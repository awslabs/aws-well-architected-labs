import boto3
from boto3.session import Session
import logging
from datetime import date
import json
import os
from botocore.exceptions import ClientError
from botocore.client import Config


def lambda_handler(event, context):
    bucket = os.environ[
        "BUCKET_NAME"
    ]  # Using enviroment varibles below the lambda will use your S3 bucket
    DestinationPrefix = os.environ["PREFIX"]
    try:
        for record in event['Records']:
           
            body = json.loads(record["body"])
            account_id = body["account_id"]
            
            print(account_id)
            list_region = lits_regions()
            with open(
                    "/tmp/data.json", "w"
                ) as f:  # Saving in the temporay folder in the lambda
                session = assume_session(account_id)
                for region in list_region:
                    client = session.client("ecs",region_name = region)
                    
                    paginator = client.get_paginator(
                        "list_clusters"
                    )  # Paginator for a large list of accounts
                    response_iterator = paginator.paginate()

                    try:
                        for response in response_iterator:  # extracts the needed info
                            for cluster in response["clusterArns"]:
                                listservices = client.list_services(
                                    cluster=cluster.split("/")[1], maxResults=100
                                )
                                for i in listservices["serviceArns"]:
                                    # print (i)
                                
                                    services = client.describe_services(
                                        cluster=cluster.split("/")[1],
                                        services=[
                                            i.split("/")[2],
                                        ],
                                        include=[
                                            "TAGS",
                                        ],
                                    )
                                    for service in services["services"]:
                                        data = {
                                            "cluster": cluster.split("/")[1],
                                            "services": service.get("serviceName"),
                                            "servicesARN": i, #.split("/")[2]
                                            "tags": service.get("tags"),
                                            "account_id":account_id

                                        }
                                        print(data)

                                        jsondata = json.dumps(
                                            data
                                        )  # converts datetime to be able to placed in json

                                        f.write(jsondata)
                                        f.write("\n")
                    except Exception as e:
                        print(e)
                        pass
                
            print("respose gathered")

            fileSize = os.path.getsize("/tmp/data.json")
            if fileSize == 0:  
                print(f"No data in file for {DestinationPrefix}")
            else:
                today = date.today()
                year = today.year
                month = today.month
                
                client = boto3.client("s3")
                client.upload_file(
                    "/tmp/data.json",
                    bucket,
                    f"{DestinationPrefix}-data/year={year}/month={month}/{DestinationPrefix}-{account_id}.json",
                )  # uploading the file with the data to s3
                print(f"Data in s3 - {DestinationPrefix}-data/year={year}/month={month}")
                start_crawler()
    except Exception as e:
        print(e)
        logging.warning(f"{e}" )
        


def assume_session(account_id):
    role_name = os.environ['ROLENAME']
    role_arn = f"arn:aws:iam::{account_id}:role/{role_name}" #OrganizationAccountAccessRole
    sts_client = boto3.client('sts')
    
    try:
        #region = sts_client.meta.region_name
        assumedRoleObject = sts_client.assume_role(
            RoleArn=role_arn,
            RoleSessionName="AssumeRoleRoot"
            )
        
        credentials = assumedRoleObject['Credentials']
        session = Session(
            aws_access_key_id=credentials['AccessKeyId'],
            aws_secret_access_key=credentials['SecretAccessKey'],
            aws_session_token=credentials['SessionToken']
        )
        return session

    except ClientError as e:
        logging.warning(f"Unexpected error Account {account_id}: {e}")
        return None

def lits_regions():
    s = Session()
    ecs_regions = s.get_available_regions('ecs')
    return ecs_regions

def start_crawler():
    glue_client = boto3.client("glue")
    try:
        glue_client.start_crawler(Name=os.environ["CRAWLER_NAME"])
        print("Crawler Started")
    except Exception as e:
        # Send some context about this error to Lambda Logs
        logging.warning("%s" % e)