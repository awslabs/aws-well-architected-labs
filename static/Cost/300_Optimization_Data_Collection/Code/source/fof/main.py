import boto3
import logging
from datetime import date
import json
import os
from botocore.exceptions import ClientError
from botocore.client import Config

# Data code to import
import ami
import ebs
import snapshot
import ta
import ecs

def lambda_handler(event, context):
    # Read from accounts collector?
    # Use same seyup as mult ecs
    # pass in account id 
    DestinationPrefix = os.environ["PREFIX"]
    #import pdb; pdb.set_trace()
    event = {'Records': [{'messageId': 'e215b689-4371-40c2-bc7a-0cd31cce8c67', 'receiptHandle': 'AQEByvl3jN2S5KzNXbjpXwjMxAFSvw+d0Vc1T/brraRWdEEclN+okuUkLEC+1eb0mgOm8b5hStjJggINVDRAODZ7UBjk0dvUTX+dLSzYKfV8GaZSleuBdQir95hmN1ezPn0dhKq37wGoGGCnLpRnMv8og3+VRo65QYzq1mlkIAFyNwpoGlF9i32LBm19cWXtc5oRLx0Pu9o/XYj9KSahhDb4XT7KbvbJDfT8aNob7uiNOALc3m6FrasEIh7+JslM59sk73WSeH6U2yDHaM70+wAdA6JEr3o5cdotrhAF0AXGU427tD3+y6pJWintS5WUhgEgq10oLr39Qds4e4Wccie1nFgvHFEND7eM+Fd4U7NXx/YVXvKqtdnxK9Q9eB1tz9BjT+657YlDu8g8980mm9N3obAm1qgcXoOS+Y7dVsupjyf6GSBbtW0T102rIWEa/+DssSg0YySDddY9WTfgRKAGMg==', 'body': '423143053313', 'attributes': {'ApproximateReceiveCount': '1', 'SentTimestamp': '1616003474625', 'SenderId': 'AROAWFBKKTAAYIWZSN3QL:AWS-Orgonisation-Account-Collector', 'ApproximateFirstReceiveTimestamp': '1616003474626'}, 'messageAttributes': {}, 'md5OfBody': '1cbed631eae73238e43fd9a1da801a83', 'eventSource': 'aws:sqs', 'eventSourceARN': 'arn:aws:sqs:eu-west-1:423143053313:ecschargeback-AccountCollector-1HBMDERAH5NBV-TaskQueue-1A093SRHNYT3N', 'awsRegion': 'eu-west-1'}]}
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
            elif DestinationPrefix == 'ecs':
                ecs.main(account_id)
            else:
                print(f"These aren't the datapoints you're looking for: {DestinationPrefix}")
            print(f"{DestinationPrefix} respose gathered")
            s3(DestinationPrefix, account_id)
            start_crawler()
    except Exception as e:
        print(e)
        logging.warning(f"{e}" )

def s3(DestinationPrefix, account_id):
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
            f"optics-data-collector/{DestinationPrefix}-data/year={year}/month={month}/{DestinationPrefix}-{account_id}.json",
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
    os.environ["ROLE_ARN"]
    try:
        glue_client.start_crawler(Name=os.environ["CRAWLER_NAME"])
    except Exception as e:
        # Send some context about this error to Lambda Logs
        logging.warning("%s" % e)