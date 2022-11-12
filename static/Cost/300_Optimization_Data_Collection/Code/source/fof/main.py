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

prefix = os.environ['PREFIX']
bucket = os.environ["BUCKET_NAME"]

def lambda_handler(event, context):
    # pass in account id

    sub_modules = {
        'ami':      [ami.main,      os.environ.get("AMICrawler")],
        'ebs':      [ebs.main,      os.environ.get("EBSCrawler")],
        'snapshot': [snapshot.main, os.environ.get("SnapshotCrawler")],
    }

    for record in event.get('Records', []):
        try:
            body = json.loads(record["body"])
            account_id = body["account_id"]
            payer_id = body["payer_id"]
            print(account_id)
            for name, (func, crawler) in sub_modules.keys():
                try:
                    func(account_id)
                    print(f"{name} response gathered")
                    upload_to_s3(name, account_id, payer_id)
                    start_crawler(crawler)
                except:
                    logging.warning(f"{name}: {type(e)} - {e}" )
        except Exception as e:
            logging.warning(f"{name}: {type(e)} - {e}" )

def upload_to_s3(name, account_id, payer_id):
    local_file = "/tmp/data.json"
    if os.path.getsize(local_file) == 0:  
        print(f"No data in file for {name}")
        return
    d = datetime.now()
    month = d.strftime("%m")
    year = d.strftime("%Y")
    dt_string = d.strftime("%d%m%Y-%H%M%S")
    try:
        key =  f"{prefix}/{prefix}-{name}-data/payer_id={payer_id}/year={year}/month={month}/{prefix}-{account_id}-{dt_string}.json",
        s3 = boto3.client("s3", config=Config(s3={"addressing_style": "path"}))
        s3.upload_file(local_file, bucket, key)
        print(f"Data {account_id} in s3 - {bucket}/{key}")
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


def start_crawler(crawler):
    glue_client = boto3.client("glue")
    try:
        glue_client.start_crawler(Name=crawler)
    except Exception as e:
        # Send some context about this error to Lambda Logs
        logging.warning("%s" % e)