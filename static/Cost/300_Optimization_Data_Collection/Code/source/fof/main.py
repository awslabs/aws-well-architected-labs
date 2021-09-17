import boto3
import logging
from datetime import date, datetime
import json
import os
from botocore.exceptions import ClientError
from botocore.client import Config

# Data code to import
import ami
import ebs
import snapshot
import ta

def lambda_handler(event, context):
    # Read from accounts collector?
    # Use same seyup as mult ecs
    # pass in account id 
    DestinationPrefix = os.environ["PREFIX"]
    #import pdb; pdb.set_trace()
    try:
        for record in event['Records']:
            account_id = record["body"]
            print(account_id)
            if DestinationPrefix == 'ami':
                ami.main(account_id)
            elif DestinationPrefix == 'ebs':
                ebs.main(account_id)
            elif DestinationPrefix == 'snapshot':
                snapshot.main(account_id)
            elif DestinationPrefix == 'ta':
                ta.main(account_id)
            else:
                print(f"These aren't the datapoints you're looking for: {DestinationPrefix}")
            print(f"{DestinationPrefix} respose gathered")
            s3(DestinationPrefix, account_id)
            start_crawler()
    except Exception as e:
        print(e)
        logging.warning(f"{e}" )

def s3(DestinationPrefix, account_id):

    d = datetime.now()
    month = d.strftime("%m")
    year = d.strftime("%Y")
    dt_string = d.strftime("%d%m%Y-%H%M%S")

    bucket = os.environ[
        "BUCKET_NAME"
    ]  # Using enviroment varibles below the lambda will use your S3 bucket
    today = date.today()
    year = today.year
    month = today.month
    try:
        s3 = boto3.client("s3", config=Config(s3={"addressing_style": "path"}))
        s3.upload_file(
            "/tmp/data.json",
            bucket,
            f"optics-data-collector/{DestinationPrefix}-data/year={year}/month={month}/{DestinationPrefix}-{account_id}-{dt_string}.json",
        )  # uploading the file with the data to s3
        print(f"Data {account_id} in s3 - {bucket}/optics-data-collector/{DestinationPrefix}-data/year={year}/month={month}")
    except Exception as e:
        print(e)


def assume_role(account_id, service, region):
    role_name = os.environ['ROLENAME']
    role_arn = f"arn:aws:iam::{account_id}:role/{role_name}" #OrganizationAccountAccessRole
    sts_client = boto3.client('sts')
    
    try:
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