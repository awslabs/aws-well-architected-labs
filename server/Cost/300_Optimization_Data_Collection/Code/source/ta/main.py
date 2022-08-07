import boto3
import logging
from datetime import date, datetime
import os
import json
from botocore.exceptions import ClientError
from botocore.client import Config

# Data code to import
import ta

def lambda_handler(event, context):
    # Read from accounts collector?
    # Use same setup as mult ecs
    # pass in account id 
    DestinationPrefix = os.environ["PREFIX"]
    try:
        for record in event['Records']:
            body = json.loads(record["body"])
            account_id = body["account_id"]
            account_name = body["account_name"]
            if DestinationPrefix == 'ta':
                ta.main(account_id,account_name)
            else:
                print(f"These aren't the datapoints you're looking for: {DestinationPrefix}")
            print(f"{DestinationPrefix} respose gathered")
            upload_to_s3(DestinationPrefix, account_id)
            start_crawler()
    except Exception as e:
        print(e)
        logging.warning(f"{e}" )

def upload_to_s3(DestinationPrefix, account_id):


    fileSize = os.path.getsize("/tmp/data.json")
    if fileSize == 0:  
        print(f"No data in file for {DestinationPrefix}")
    else:
        d = datetime.now()
        month = d.strftime("%m")
        year = d.strftime("%Y")
        date_formatted = d.strftime("%d%m%Y-%H%M%S")

        # Using environment variables below the lambda will use your S3 bucket
        bucket = os.environ["BUCKET_NAME"]  
        today = date.today()
        year = today.year
        month = today.month
        try:
            s3 = boto3.client("s3", config=Config(s3={"addressing_style": "path"}))
            s3.upload_file(
                "/tmp/data.json",
                bucket,
                f"optics-data-collector/{DestinationPrefix}-data/year={year}/month={month}/{DestinationPrefix}-{account_id}-{date_formatted}.json",
            )  # uploading the file with the data to s3
            print(f"Data {account_id} in s3 - {bucket}/optics-data-collector/{DestinationPrefix}-data/year={year}/month={month}")
        except Exception as e:
            print(e)


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


def start_crawler():
    glue_client = boto3.client("glue")
    try:
        glue_client.start_crawler(Name=os.environ["CRAWLER_NAME"])
    except Exception as e:
        # Send some context about this error to Lambda Logs
        logging.warning("%s" % e)