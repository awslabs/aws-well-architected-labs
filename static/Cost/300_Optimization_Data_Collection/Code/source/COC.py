import boto3
import json
from datetime import date, timedelta, datetime
import json
import os
import logging
from botocore.client import Config

def get_ec2_instance_recommendations(accountid, client):
    try:
        response = client.get_ec2_instance_recommendations(

            accountIds=[
                accountid,
            ]
        )
        
        data  = response['instanceRecommendations']
        
        return data
    except Exception as e:
                pass
                logging.warning(f"{e} - {accountid}")


def get_auto_scaling_group_recommendations(accountid, client):
    try:
        response = client.get_auto_scaling_group_recommendations(

            accountIds=[
                accountid,
            ]
        )
        data  = response['autoScalingGroupRecommendations']
        
        return data
    except Exception as e:
                pass
                logging.warning(f"{e} - {accountid}")

def get_lambda_function_recommendations(accountid, client):
    try:
        response = client.get_lambda_function_recommendations(

            accountIds=[
                accountid,
            ]
        )
        data  = response['lambdaFunctionRecommendations']
        
        return data
    except Exception as e:
                pass
                logging.warning(f"{e} - {accountid}")


def get_ebs_volume_recommendations(accountid, client):
    try:
        response = client.get_ebs_volume_recommendations(

            accountIds=[
                accountid,
            ]
        )
        data  = response['volumeRecommendations']
        
        return data
    except Exception as e:
                pass
                logging.warning(f"{e} - {accountid}")


def write_file(file_name, data):
    with open('/tmp/%s.json' %file_name, 'w') as outfile:
     
        for item in data:
            if item is None or len(item) == 0:
                pass
            try:
                for instanceArn in item:
                    del instanceArn['lastRefreshTimestamp']
                    json.dump(instanceArn, outfile)
                    outfile.write('\n')
            except Exception as e:
                pass
                logging.warning("%s" % e)


def s3_upload(recommendations, Region, account_id):

    d = datetime.now()
    month = d.strftime("%m")
    year = d.strftime("%Y")
    dt_string = d.strftime("%d%m%Y-%H%M%S")

    today = date.today()
    year = today.year
    month = today.month
    try:
        S3BucketName = os.environ["BUCKET_NAME"]
        s3 = boto3.client('s3', Region,
                            config=Config(s3={'addressing_style': 'path'}))
        s3.upload_file(f'/tmp/{recommendations}_recommendations.json', S3BucketName, f"Compute_Optimizer/Compute_Optimizer_{recommendations}/year={year}/month={month}/{recommendations}_recommendations_{account_id}-{dt_string}.json")
        print(f"{recommendations} data in s3 {S3BucketName}")
    except Exception as e:
        # Send some context about this error to Lambda Logs
        logging.warning("%s" % e)

def start_crawler(Crawler_Name):
    glue_client = boto3.client("glue")
    try:
        glue_client.start_crawler(Name=Crawler_Name)
        print(f"{Crawler_Name} has been started")
    except Exception as e:
        # Send some context about this error to Lambda Logs
        logging.warning("%s" % e)

def lambda_handler(event, context):
    ec2_reccomendations = []
    auto_scaling_group_recommendations= []
    lambda_function_recommendations = []
    ebs_volume_recommendations = []
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

    # create service client using the assumed role credentials
    client = boto3.client(
            "compute-optimizer", region_name=Region,
            aws_access_key_id=ACCESS_KEY,
            aws_secret_access_key=SECRET_KEY,
            aws_session_token=SESSION_TOKEN,
    )
    try:
        for record in event['Records']:
        
            account_id = record["body"]
            
            print(account_id)
            data = get_ec2_instance_recommendations(account_id, client)
            ec2_reccomendations.append(data)
            
            auto_data = get_auto_scaling_group_recommendations(account_id, client)
            auto_scaling_group_recommendations.append(auto_data)

            lambda_data = get_lambda_function_recommendations(account_id, client)
            lambda_function_recommendations.append(lambda_data)
            
            ebs_data = get_ebs_volume_recommendations(account_id, client)
            ebs_volume_recommendations.append(ebs_data)

            write_file('ec2_instance_recommendations' ,ec2_reccomendations)
            write_file('auto_scale_recommendations' ,auto_scaling_group_recommendations)
            write_file('lambda_recommendations' ,lambda_function_recommendations)
            write_file('ebs_volume_recommendations' ,ebs_volume_recommendations)

            s3_upload('ec2_instance', Region, account_id)
            s3_upload('auto_scale', Region, account_id)
            s3_upload('lambda', Region, account_id)
            s3_upload('ebs_volume', Region, account_id)

            start_crawler(os.environ["EC2Crawler"])
            start_crawler(os.environ["AUTOCrawler"])
            start_crawler(os.environ["EBSCrawler"])
            start_crawler(os.environ["LambdaCrawler"])


    except Exception as e:
        # Send some context about this error to Lambda Logs
        logging.warning("%s" % e)
