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
            s3(DestinationPrefix)
            #start_crawler()
    except Exception as e:
        print(e)
        logging.warning(f"{e}" )

def s3(DestinationPrefix):
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
            f"optics-data-collector/{DestinationPrefix}-data/year={year}/month={month}/{DestinationPrefix}.json",
        )  # uploading the file with the data to s3
        print(f"Data in s3 - optics-data-collector/{DestinationPrefix}-data/year={year}/month={month}")
    except Exception as e:
        print(e)


def start_crawler():
    glue_client = boto3.client("glue")
    os.environ["ROLE_ARN"]
    try:
        glue_client.start_crawler(Name=os.environ["CRAWLER_NAME"])
    except Exception as e:
        # Send some context about this error to Lambda Logs
        logging.warning("%s" % e)