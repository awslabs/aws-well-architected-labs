import boto3
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
           
            account_id = record["body"]
            
            print(account_id)
            list_region = lits_regions()
            with open(
                    "/tmp/data.json", "w"
                ) as f:  # Saving in the temporay folder in the lambda
                for region in list_region:
                    client = assume_role(account_id, "ecs", region)
                    
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
                                            "service": service.get("serviceName"),
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
    except Exception as e:
        print(e)
        logging.warning(f"{e}" )
        


def assume_role(account_id, service, region):
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
        client = boto3.client(
            service,
            aws_access_key_id=credentials['AccessKeyId'],
            aws_secret_access_key=credentials['SecretAccessKey'],
            aws_session_token=credentials['SessionToken'],
            region_name = region
        )
        return client

    except ClientError as e:
        logging.warning(f"Unexpected error Account {account_id}: {e}")
        return None

def lits_regions():
    from boto3.session import Session

    s = Session()
    ecs_regions = s.get_available_regions('ecs')
    return ecs_regions
