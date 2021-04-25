#!/usr/bin/env python3

import argparse
import boto3
from botocore.exceptions import ClientError
from botocore.client import Config
import os

def lambda_handler(event, context):
    
    # sts_connection = boto3.client('sts')
    # acct_b = sts_connection.assume_role(
    #     RoleArn="arn:aws:iam::(account id):role/OrganizationLambdaAccessRole",
    #     RoleSessionName="cross_acct_lambda"
    # )

    # ACCESS_KEY = acct_b['Credentials']['AccessKeyId']
    # SECRET_KEY = acct_b['Credentials']['SecretAccessKey']
    # SESSION_TOKEN = acct_b['Credentials']['SessionToken']

    # create service client using the assumed role credentials
    client = boto3.client(
        "organizations", region_name="us-east-1", #Using the Organizations client to get the data. This MUST be us-east-1 regardless of region you have the Lamda in
        #aws_access_key_id=ACCESS_KEY,
        #aws_secret_access_key=SECRET_KEY,
        #aws_session_token=SESSION_TOKEN,
    )


    root_id    = client.list_roots()['Roots'][0]['Id']
    ou_id_list = get_ou_ids(root_id, 'ORGANIZATIONAL_UNIT', client)
    
    with open('/tmp/ou-org.csv', 'w') as f: # Saving in the temporay folder in the lambda
        for ou in ou_id_list:
            account_data(f, ou, client)
    s3_upload('ou-org')

    with open('/tmp/acc-org.csv', 'w') as f: # Saving in the temporay folder in the lambda
        account_data(f, root_id, client)
    s3_upload('acc-org')

def account_data(f, parent, client):
    account_id_list = get_ou_ids(parent, 'ACCOUNT', client)
    for account_id in account_id_list:
        response = client.describe_account(AccountId=account_id)
        aid = response["Account"]["Id"]
        name = response["Account"]["Name"]
        time = response["Account"]["JoinedTimestamp"]
        status = response["Account"]["Status"]
        email = response["Account"]["Email"]

        line = f"{aid}, {name}, {time}, {status},{email}, None\n"
        
        f.write(line)

def s3_upload(file_name):
    bucket = os.environ["BUCKET_NAME"] #Using environment variables below the Lambda will use your S3 bucket
    try:
        s3 = boto3.client('s3', 'eu-west-1',
                        config=Config(s3={'addressing_style': 'path'}))
        s3.upload_file(
            f'/tmp/{file_name}.csv', bucket, f"organisation-data/{file_name}.csv") #uploading the file with the data to s3
        print(f"{file_name}org data in s3")
    except Exception as e:
        print(e)



def get_ou_ids(parent_id, ChildType, client):
  full_result = []
  
  paginator = client.get_paginator('list_children')
  iterator  = paginator.paginate(
    ParentId=parent_id,
    ChildType= ChildType
  )

  for page in iterator:
    for ou in page['Children']:
      # 1. Add entry
      # 2. Fetch children recursively
      print(ou['Id'])
      full_result.append(ou['Id'])
      #full_result.extend(get_ou_ids(ou['Id']))

  return full_result

lambda_handler(None, None)