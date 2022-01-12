import boto3
import json
from datetime import date, timedelta, datetime
import json
import os
import logging
from botocore.client import Config
S3BucketName = os.environ["BUCKET_NAME"]

def get_ec2_instance_recommendations(client, year, month):
    try:
        response = client.export_ec2_instance_recommendations(
            includeMemberAccounts=True,
            s3DestinationConfig={
                'bucket': S3BucketName,
                'keyPrefix': f'Compute_Optimizer/Compute_Optimizer_ec2_instance/year={year}/month={month}'
                }
        )
        print('EC2 instances export queued. JobId: ' + response['jobId'])
        
    except Exception as e:
                pass
                logging.warning(f"{e} - EC2")


def get_auto_scaling_group_recommendations(client, year, month):
    try:
        response = client.export_auto_scaling_group_recommendations(
            includeMemberAccounts=True,
            s3DestinationConfig={
                'bucket': S3BucketName,
                'keyPrefix': f'Compute_Optimizer/Compute_Optimizer_auto_scale/year={year}/month={month}'
                }
        )
        print('ASG instances export queued. JobId: ' + response['jobId'])
        
    except Exception as e:
                pass
                logging.warning(f"{e} - ASGs")

def get_lambda_function_recommendations(client, year, month):
    try:
        response = client.export_lambda_function_recommendations(
            includeMemberAccounts=True,
            s3DestinationConfig={
                'bucket': S3BucketName,
                'keyPrefix': f'Compute_Optimizer/Compute_Optimizer_lambda/year={year}/month={month}'
                }
        )
        print('Lambda export queued. JobId: ' + response['jobId'])
    except Exception as e:
                pass
                logging.warning(f"{e} - Lambda")

def get_ebs_volume_recommendations(client, year, month):
    try:
        response = client.export_ebs_volume_recommendations(

            includeMemberAccounts=True,
            s3DestinationConfig={
                'bucket': S3BucketName,
                'keyPrefix': f'Compute_Optimizer/Compute_Optimizer_ebs_volume/year={year}/month={month}'
                }
        )
        print('EBS export queued. JobId: ' + response['jobId'])
    except Exception as e:
                pass
                logging.warning(f"{e} - EBS")

def lambda_handler(event, context):

    d = datetime.now()
    month = d.strftime("%m")
    year = d.strftime("%Y")
    dt_string = d.strftime("%d%m%Y-%H%M%S")

    today = date.today()
    year = today.year
    month = today.month

    Region = os.environ["REGION"]
    #client = boto3.client('compute-optimizer', region_name=Region)

    ROLE_ARN = os.environ['ROLE_ARN']

    sts_connection = boto3.client('sts')
    acct_b = sts_connection.assume_role(
            RoleArn=ROLE_ARN,
            RoleSessionName="cross_acct_lambda"
    )
                
    ACCESS_KEY = acct_b['Credentials']['AccessKeyId']
    SECRET_KEY = acct_b['Credentials']['SecretAccessKey']
    SESSION_TOKEN = acct_b['Credentials']['SessionToken']

    # # create service client using the assumed role credentials
    client = boto3.client(
             "compute-optimizer", region_name=Region,
            aws_access_key_id=ACCESS_KEY,
            aws_secret_access_key=SECRET_KEY,
            aws_session_token=SESSION_TOKEN,
    )
    try:

        get_ec2_instance_recommendations(client, year, month)
                
        get_auto_scaling_group_recommendations(client, year, month)
        get_lambda_function_recommendations(client, year, month)
                
        get_ebs_volume_recommendations(client, year, month)
               
    except Exception as e:
        # Send some context about this error to Lambda Logs
        logging.warning("%s" % e)
