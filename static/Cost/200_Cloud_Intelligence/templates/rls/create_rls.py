#!/usr/bin/env python3
"""
This script generates CSV:

    |qs user id |account_id|payer_account_id|
"""

import os
import csv
import json
from collections import defaultdict
import boto3

OWNER_TAG = os.environ.get('CID_OWNER_TAG', 'cid_users')
BUCKET_NAME = os.environ['BUCKET_NAME']
TMP_RLS_FILE = os.environ.get('TMP_RLS_FILE', '/tmp/cid_rls.csv')
RLS_HEADER = ['UserName', 'account_id', 'payer_account_id']
QS_ACCOUNT_ID = boto3.client('sts').get_caller_identity().get('Account')
QS_REGION = os.environ['QS_REGION']
MANAGEMENT_ACCOUNT_IDS = os.environ.get('MANAGEMENT_ACCOUNT_IDS', QS_ACCOUNT_ID)
MANAGEMENT_ROLE_NAME = os.environ['MANAGEMENTROLENAME']
CID_FULL_ACCESS_USERS = os.environ.get('CID_FULL_ACCESS_USERS', "")

def recursive_defaultdict():
    return defaultdict(recursive_defaultdict)

def assume_management(payer_id, region):
    credentials = boto3.client('sts').assume_role(
        RoleArn=f"arn:aws:iam::{payer_id}:role/{MANAGEMENT_ROLE_NAME}",
        RoleSessionName="cross_acct_lambda"
    )['Credentials']
    return boto3.client(
        "organizations", region_name=region,
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken'],
    )


def get_tags(account_list, org_client):
    for index, account in enumerate(account_list):
        account_tags = org_client.list_tags_for_resource(ResourceId=account["Id"])['Tags']
        account_tags = {'AccountTags': account_tags}
        account.update(account_tags)
        account_list[index] = account
    return account_list


def update_tag_data(account, users, ou_tag_data, separator=":"):
    """ Default separator """
    for user in users.split(separator):
        user = user.strip()
        ou_tag_data[user]['account_id'] = ou_tag_data[user].get('account_id', []) + [account]
    return ou_tag_data


def get_ou_children(ou, org_client):
    for ou in org_client.get_paginator('list_organizational_units_for_parent').paginate(ParentId=ou).search('OrganizationalUnits'):
        yield ou['Id']

def get_ou_accounts(org_client, ou, accounts_list=None, process_ou_children=True):
    if accounts_list is None:
        accounts_list = []
    for account in org_client.get_paginator('list_accounts_for_parent').paginate(ParentId=ou).search("Accounts[?Status=='ACTIVE']"):
        accounts_list.append(account)
    if process_ou_children:
        for ou in get_ou_children(ou, org_client):
            get_ou_accounts(org_client, ou, accounts_list)
    return accounts_list

# def get_cid_users(account_list):
#     cid_users = []
#     for account in account_list:
#         for tag in account['AccountTags']:
#             if tag['Key'] == 'cid_users':
#                 cid_users.append((account['Id'], tag['Value']))
#     return cid_users

# def dict_list_to_csv(dict):
#     for key in dict:
#         dict[key] = ','.join(dict[key])
#     return dict


def upload_to_s3(file, s3_file):
    try:
        s3 = boto3.client('s3', QS_REGION)
        s3.upload_file(file, BUCKET_NAME, f"cid_rls/{s3_file}")
        print(f"{s3_file} data in s3")
    except Exception as e:
        print(e)


def main():
    qs_rls = {} # Key=QS User, value: dict (full access / account / payer id)
    ou_tag_data = recursive_defaultdict() # Key: email 
    qs_users = {qs_user['UserName']: qs_user['Email'] for qs_user in get_qs_users()}
    cid_full_access_users = CID_FULL_ACCESS_USERS.split(',')
    print(f"qs_users: {qs_users}")
    print(f"cid_full_access_users: {cid_full_access_users}")

    for payer_data in [r.strip() for r in MANAGEMENT_ACCOUNT_IDS.split(',')]:
        if ':' in payer_data:
            payer_id = payer_data.split(':')[0]
            identity_region = payer_data.split(':')[1]
        else:
            payer_id = payer_data
            identity_region = QS_REGION
        print("processing payer: {}".format(payer_id))

        org_client = assume_management(payer_id, identity_region)
        root_ou = org_client.list_roots()['Roots'][0]['Id']
        ou_tag_data = process_ou(org_client, root_ou, ou_tag_data, root_ou)
        ou_tag_data = process_root_ou(org_client, payer_id, root_ou, ou_tag_data)  # -> will recreate root process
        qs_email_user_map = recursive_defaultdict()

        for user_name, email in qs_users.items():
            qs_email_user_map[email] = qs_email_user_map.get(email, []) + [user_name]

        # process all tags from all OU
        for email in ou_tag_data:
            print("###################### USER_EMAIL:{}#######################".format(email))
            for qs_user in qs_email_user_map.get(email, []):
                if email in cid_full_access_users:
                    qs_rls[qs_user] = {'full_access': True}
                else:
                    qs_rls[qs_user] = ou_tag_data[email]
    print(f"QS EMAIL USER MAPPING: {json.dumps(qs_email_user_map)}")
    print(f"QS RLS DATA: {json.dumps(qs_rls)}")
    rls_s3_filename = "cid_rls.csv"
    write_csv(qs_rls, rls_s3_filename)


def get_qs_users(account_id, qs_client):
    qs_client = boto3.client('quicksight', region_name=QS_REGION)
    account_id = boto3.client('sts').get_caller_identity().get('Account')
    yield from qs_client.get_paginator('list_users').paginate(AwsAccountId=account_id, Namespace='default').search('UserList')

def process_account(account_id, ou_tag_data, ou, org_client):
    print(f"DEBUG: processing account level tags, processing account_id: {account_id}")
    for tag in org_client.get_paginator('list_tags_for_resource').paginate(ResourceId=account_id).search('Tags'):
        if tag['Key'] == 'cid_users':
            cid_users_tag_value = tag['Value']
            print(f"DEBUG: processing child account: {account_id} for ou: {ou}")
            ou_tag_data = update_tag_data(account_id, cid_users_tag_value, ou_tag_data)
    return ou_tag_data


def process_root_ou(org_client, payer_id, root_ou, ou_tag_data):
    "PROCESS OU MUST BE PROCESSED LAST"
    for tag in org_client.get_paginator('list_tags_for_resource').paginate(ResourceId=root_ou).search('Tags'):
        if tag['Key'] == 'cid_users':
            for user in tag['Value'].split(':'):
                ou_tag_data[user]['payer_id'] = ou_tag_data[user].get('payer_id', []) + [payer_id]
    return ou_tag_data


def process_ou(org_client, ou, ou_tag_data, root_ou):
    print("DEBUG: processing ou {}".format(ou))
    for tag in org_client.get_paginator('list_tags_for_resource').paginate(ResourceId=ou).search('Tags'):
        if tag['Key'] == 'cid_users':
            cid_users_tag_value = tag['Value']
            """ Do not process all children if this is root ou, this is done bellow in separate cycle. """
            process_ou_children = bool(ou != root_ou)
            for account in get_ou_accounts(org_client, ou, process_ou_children=process_ou_children):
                account_id = account['Id']
                print(f"DEBUG: processing inherit tag: {cid_users_tag_value} for ou: {ou} account_id: {account_id}")
                ou_tag_data = update_tag_data(account_id, cid_users_tag_value, ou_tag_data)

    for child_ou in get_ou_children(ou, org_client):
        print(f"DEBUG: processing child ou: {child_ou}")
        ou_tag_data = process_ou(org_client, child_ou, ou_tag_data, root_ou)

    ou_accounts = get_ou_accounts(org_client, ou, process_ou_children=False)  # Do not process children, only accounts at OU level.
    ou_accounts_ids = [ou_account['Id'] for ou_account in ou_accounts]
    print(f"DEBUG: Getting accounts in  OU: {ou} ########################### ou_accounts:{ou_accounts_ids}")
    for account in ou_accounts:
        account_id = account['Id']
        print(f"DEBUG: Processing OU level accounts for ou: {ou}, account: {account_id}")
        ou_tag_data = process_account(account_id, ou_tag_data, ou, org_client)
    return ou_tag_data


def write_csv(qs_rls, rls_s3_filename):
    with open(TMP_RLS_FILE, 'w', newline='') as cid_rls_csv_file:
        wrt = csv.DictWriter(cid_rls_csv_file, fieldnames=RLS_HEADER)
        wrt.writeheader()
        for user in qs_rls:
            """ we will write empty account_id, if payer_id is present, cause the user should see all accounts under one payer
                and we will write empty payer_id if payer_id is absent """
            if 'payer_id' in qs_rls[user]:
                wrt.writerow({
                    'UserName': user,
                    'account_id': "",
                    'payer_account_id': ",".join(qs_rls[user]['payer_id'])
                })
            elif qs_rls[user].get('full_access'):
                wrt.writerow({
                    'UserName': user,
                    'account_id': "",
                    'payer_account_id': ""
                })
            else:
                wrt.writerow({
                    'UserName': user,
                    'account_id': ",".join(qs_rls[user]['account_id']),
                    'payer_account_id': ""
                })

    upload_to_s3(TMP_RLS_FILE, rls_s3_filename)


def lambda_handler(event, context):
    main()


if __name__ == '__main__':
    main()

#### TEST UPDATE ####
