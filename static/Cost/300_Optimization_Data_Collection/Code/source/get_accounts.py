import boto3
import logging
import os
import json

def sqs_message(account_data, QueueUrl):
    #posts message to que
    client = boto3.client('sqs')
    (account_id,account_name,payer_id) = account_data
    message = {
        "account_id": account_id,
        "account_name": account_name, 
        "payer_id": payer_id
        
    }
    response = client.send_message(
        QueueUrl=QueueUrl,
        MessageBody=json.dumps(message)
    )
    return response


def org_accounts(role_name, payer_id):
    account_ids = []
    ROLE_ARN = f"arn:aws:iam::{payer_id}:role/{role_name}"
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
        "organizations", region_name="us-east-1", #Using the Organization client to get the data. This MUST be us-east-1 regardless of region you have the lamda in
        aws_access_key_id=ACCESS_KEY,
        aws_secret_access_key=SECRET_KEY,
        aws_session_token=SESSION_TOKEN,
    )
    paginator = client.get_paginator("list_accounts") #Paginator for a large list of accounts
    response_iterator = paginator.paginate()

    for account in response_iterator:
        for ids in account['Accounts']:
            account_ids.append(ids)
    logging.info("AWS Org data Gathered")
    return account_ids


def lambda_handler(event, context):
    role_name = os.environ['ROLE']
    MANAGEMENT_ACCOUNT_IDS = os.environ['MANAGEMENT_ACCOUNT_IDS']
    for payer_id in [r.strip() for r in MANAGEMENT_ACCOUNT_IDS.split(',')]:
        account_info = org_accounts(role_name, payer_id)
        
        for account in account_info:
            if  account['Status'] == 'ACTIVE':
                try:
                    account_id = account['Id']
                    account_name = account['Name']
                    payer_id = payer_id #check format of show this sends to que, need to have in sqs for data output
                    account_data = (account_id, account_name, payer_id)
                    for que in os.environ.get("SQS_URL").split(","):
                        print(que)
                        sqs_message(account_data, que)
                        logging.info(f"SQS message sent for {account_id}:{account_name} to TA")

                except Exception as e:
                    pass
                    logging.warning("%s" % e)
            else:
                logging.info(f"account {account['Id']} is not active")