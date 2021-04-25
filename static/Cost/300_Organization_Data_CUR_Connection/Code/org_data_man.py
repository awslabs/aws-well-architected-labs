#!/usr/bin/env python3
    
import argparse
import boto3
from botocore.exceptions import ClientError
from botocore.client import Config
import os

def list_accounts():
    bucket = os.environ["BUCKET_NAME"] #Using environment variables below the Lambda will use your S3 bucket


    # create service client using the assumed role credentials
    client = boto3.client(
        "organizations", region_name="us-east-1" #Using the Organizations client to get the data. This MUST be us-east-1 regardless of region you have the Lamda in
    )


    paginator = client.get_paginator("list_accounts") #Paginator for a large list of accounts
    response_iterator = paginator.paginate()
    with open('/tmp/org.csv', 'w') as f: # Saving in the temporay folder in the lambda

        for response in response_iterator: # extracts the needed info
            for account in response["Accounts"]:
                aid = account["Id"]
                name = account["Name"]
                time = account["JoinedTimestamp"]
                status = account["Status"]
                line = "%s, %s, %s, %s\n" % (aid, name, time, status)
                f.write(line)
    print("respose gathered")

    try:
        s3 = boto3.client('s3', '(Region)',
                        config=Config(s3={'addressing_style': 'path'}))
        s3.upload_file(
            '/tmp/org.csv', bucket, "organisation-data/org.csv") #uploading the file with the data to s3
        print("org data in s3")
    except Exception as e:
        print(e)

def lambda_handler(event, context):
    list_accounts()