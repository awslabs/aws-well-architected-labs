#!/usr/bin/env python3

import boto3
from botocore.exceptions import ClientError
from botocore.client import Config
import os
import json
import datetime

def myconverter(o):
    if isinstance(o, datetime.datetime):
        return o.__str__()

def list_accounts():
    bucket = os.environ["BUCKET_NAME"] #Using enviroment varibles below the lambda will use your S3 bucket
    tags_check = os.environ["TAGS"]

    sts_connection = boto3.client('sts')
    acct_b = sts_connection.assume_role(
        RoleArn="arn:aws:iam::(account id):role/OrganizationLambdaAccessRole",
        RoleSessionName="cross_acct_lambda"
    )
        
    ACCESS_KEY = acct_b['Credentials']['AccessKeyId']
    SECRET_KEY = acct_b['Credentials']['SecretAccessKey']
    SESSION_TOKEN = acct_b['Credentials']['SessionToken']

    # create service client using the assumed role credentials
    client = boto3.client(
        "organizations", region_name="us-east-1", #Using the Organization client to get the data. This MUST be us-east-1 regardless of region you have the lamda in
        aws_access_key_id=ACCESS_KEY,
        aws_secret_access_key=SECRET_KEY,
        aws_session_token=SESSION_TOKEN,
    )
    paginator = client.get_paginator("list_accounts") #Paginator for a large list of accounts
    response_iterator = paginator.paginate()
    with open('/tmp/org.json', 'w') as f: # Saving in the temporay folder in the lambda

        for response in response_iterator: # extracts the needed info
            for account in response["Accounts"]:
                aid = account["Id"]                
                if tags_check != '':
                    tags_list = client.list_tags_for_resource(ResourceId=aid) #gets the lists of tags for this account
                    
                    for tag in os.environ.get("TAGS").split(","): #looking at tags in the enviroment variables split by a space
                        for org_tag in tags_list['Tags']:
                            if tag == org_tag['Key']: #if the tag found on the account is the same as the current one in the environent varibles, add it to the data
                                value = org_tag['Value']
                                kv = {tag : value}
                                account.update(kv)
                        
                data = json.dumps(account, default = myconverter) #converts datetime to be able to placed in json

                f.write(data)
                f.write('\n')
    print("respose gathered")

    try:
        s3 = boto3.client('s3', 'eu-west-1',
                        config=Config(s3={'addressing_style': 'path'}))
        s3.upload_file(
            '/tmp/org.json', bucket, "organisation-data/org.json") #uploading the file with the data to s3
        print("org data in s3")
    except Exception as e:
        print(e)

def lambda_handler(event, context):
    list_accounts()
