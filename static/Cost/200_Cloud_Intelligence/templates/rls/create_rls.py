#!/usr/bin/env python3
import boto3
import csv
from os import environ as os_environ
from sys import exit
from botocore.client import Config

OWNER_TAG = os_environ['CID_OWNER_TAG'] if 'CID_OWNER_TAG' in os_environ else 'cid_users'
BUCKET_NAME = os_environ['BUCKET_NAME'] if 'BUCKET_NAME' in os_environ else exit(
    "Missing bucket for uploading CSV. Please define bucket as ENV VAR BUCKET_NAME")
TMP_RLS_FILE = os_environ['TMP_RLS_FILE'] if 'TMP_RLS_FILE' in os_environ else '/tmp/cid_rls.csv'
RLS_HEADER = ['UserName', 'account_id', 'payer_account_id']
QS_ACCOUNT_ID = boto3.client('sts').get_caller_identity().get('Account')
QS_REGION = os_environ['QS_REGION'] if 'QS_REGION' in os_environ else exit("Missing QS_REGION var name, please define")
MANAGEMENT_ACCOUNT_IDS = os_environ['MANAGEMENT_ACCOUNT_IDS'] if 'MANAGEMENT_ACCOUNT_IDS' in os_environ else QS_ACCOUNT_ID
MANAGEMENTROLENAME = os_environ['MANAGEMENTROLENAME'] if 'MANAGEMENTROLENAME' in os_environ else exit(
    "Missing MANAGEMENT ROLE NAME. Please define bucket as ENV VAR MANAGEMENTROLENAME")
CID_FULL_ACCESS_USERS = os_environ['CID_FULL_ACCESS_USERS'] if 'CID_FULL_ACCESS_USERS' in os_environ else ""


def assume_management(payer_id, region):
    role_name = os_environ["MANAGEMENTROLENAME"]
    management_role_arn = f"arn:aws:iam::{payer_id}:role/{role_name}"
    sts_connection = boto3.client('sts')
    acct_b = sts_connection.assume_role(
        RoleArn=management_role_arn,
        RoleSessionName="cross_acct_lambda"
    )
    ACCESS_KEY = acct_b['Credentials']['AccessKeyId']
    SECRET_KEY = acct_b['Credentials']['SecretAccessKey']
    SESSION_TOKEN = acct_b['Credentials']['SessionToken']
    client = boto3.client(
        "organizations", region_name=region,
        aws_access_key_id=ACCESS_KEY, aws_secret_access_key=SECRET_KEY, aws_session_token=SESSION_TOKEN
    )
    return client


def get_tags(account_list, org_client):
    for index, account in enumerate(account_list):
        account_tags = org_client.list_tags_for_resource(ResourceId=account["Id"])['Tags']
        account_tags = {'AccountTags': account_tags}
        account.update(account_tags)
        account_list[index] = account
    return account_list


def update_tag_data(account, users, ou_tag_data, separator=":"):
    """ Default separator """
    users = users.split(separator)
    for user in users:
        user = user.strip()
        if user in ou_tag_data:
            if account not in ou_tag_data[user]:
                ou_tag_data[user]['account_id'].append(account)
        else:
            ou_tag_data.update({user: {'account_id': [account]}})
    return ou_tag_data


def get_ou_children(ou, org_client):
    NextToken = True
    ous_list = []
    while NextToken:
        if type(NextToken) is str:
            list_ous_result = org_client.list_organizational_units_for_parent(ParentId=ou, MaxResults=20, NextToken=NextToken)
        else:
            list_ous_result = org_client.list_organizational_units_for_parent(ParentId=ou, MaxResults=20)
        if 'NextToken' in list_ous_result:
            NextToken = list_ous_result['NextToken']
        else:
            NextToken = False
            ous = list_ous_result['OrganizationalUnits']
            for ou in ous:
                ous_list.append(ou['Id'])
    return ous_list


def get_ou_accounts(org_client, ou, accounts_list=None, process_ou_children=True):
    NextToken = True
    if accounts_list is None:
        accounts_list = []
    while NextToken:
        if type(NextToken) is str:
            list_accounts_result = org_client.list_accounts_for_parent(ParentId=ou, MaxResults=20, NextToken=NextToken)
        else:
            list_accounts_result = org_client.list_accounts_for_parent(ParentId=ou, MaxResults=20)
        if 'NextToken' in list_accounts_result:
            NextToken = list_accounts_result['NextToken']
        else:
            NextToken = False
        accounts = list_accounts_result['Accounts']
        for account in accounts:
            if account['Status'] == 'ACTIVE':
                accounts_list.append(account)
    if process_ou_children:
        for ou in get_ou_children(ou, org_client):
            get_ou_accounts(org_client, ou, accounts_list)
    return accounts_list


def get_cid_users(account_list):
    cid_users = []
    for account in account_list:
        for index, key in enumerate(account['AccountTags']):
            if key['Key'] == 'cid_users':
                cid_users.append((account['Id'], account['AccountTags'][index]['Value']))
    return cid_users


def dict_list_to_csv(dict):
    for key in dict:
        dict[key] = ','.join(dict[key])
    return dict


def upload_to_s3(file, s3_file):
    try:
        s3 = boto3.client('s3', os_environ["QS_REGION"], config=Config(s3={'addressing_style': 'path'}))
        s3.upload_file(file, BUCKET_NAME, f"cid_rls/{s3_file}")
        print(f"{s3_file} data in s3")

    except Exception as e:
        print(e)


def main(separator=":"):
    qs_rls = {}
    ou_tag_data = {}
    qs_client = boto3.client('quicksight', region_name=QS_REGION)
    qs_users = get_qs_users(QS_ACCOUNT_ID, qs_client)
    qs_users = {qs_user['UserName']: qs_user['Email'] for qs_user in qs_users}
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
        qs_email_user_map = {}
        for key, value in qs_users.items():
            if value not in qs_email_user_map:
                qs_email_user_map[value] = [key]
            else:
                qs_email_user_map[value].append(key)
        # process all tags from alll OU
        for user in ou_tag_data:
            print("###################### USER_EMAIL:{}#######################".format(user))
            if user in qs_email_user_map:
                if user not in cid_full_access_users:
                    for qs_user in qs_email_user_map[user]:
                        qs_rls[qs_user] = ou_tag_data[user]
                else:
                    qs_rls[user] = {'full_access': True}
    print("QS EMAIL USER MAPPING: {}".format(qs_email_user_map))
    print("QS RLS DATA: {}".format(qs_rls))
    rls_s3_filename = "cid_rls.csv"
    write_csv(qs_rls, rls_s3_filename)


def get_qs_users(account_id, qs_client):
    print("Fetching QS users, Getting first page, NextToken: 0")
    qs_users_result = (qs_client.list_users(AwsAccountId=account_id, MaxResults=100, Namespace='default'))
    qs_users = qs_users_result['UserList']

    while 'NextToken' in qs_users_result:
        NextToken = qs_users_result['NextToken']
        qs_users_result = (qs_client.list_users(AwsAccountId=account_id, MaxResults=100, Namespace='default', NextToken=NextToken))
        qs_users.extend(qs_users_result['UserList'])
        print("Fetching QS users, getting Next Page, NextToken: {}".format(NextToken.split('/')[0]))

    for qs_users_index, qs_user in enumerate(qs_users):
        qs_user = {'UserName': qs_user['UserName'], 'Email': qs_user['Email']}
        qs_users[qs_users_index] = qs_user

    return qs_users


def process_account(account_id, ou_tag_data, ou, org_client):
    print(f"DEBUG: proessing account level tags, processing account_id: {account_id}")
    tags = org_client.list_tags_for_resource(ResourceId=account_id)['Tags']
    for tag in tags:
        if tag['Key'] == 'cid_users':
            cid_users_tag_value = tag['Value']
            print(f"DEBUG: processing child account: {account_id} for ou: {ou}")
            ou_tag_data = update_tag_data(account_id, cid_users_tag_value, ou_tag_data)
    return ou_tag_data


def process_root_ou(org_client, payer_id, root_ou, ou_tag_data):
    "PROCESS OU MUST BE PROCESSED LAST"
    tags = org_client.list_tags_for_resource(ResourceId=root_ou)['Tags']
    for tag in tags:
        if tag['Key'] == 'cid_users':
            cid_users_tag_value = tag['Value']
            for user in cid_users_tag_value.split(':'):
                if user in ou_tag_data:
                    if 'payer_id' in ou_tag_data[user]:
                        if payer_id not in ou_tag_data[user]['payer_id']:
                            ou_tag_data[user]['payer_id'].append(payer_id)
                    else:
                        ou_tag_data[user]['payer_id'] = [payer_id]
                else:
                    ou_tag_data.udpate({user: {'payer_id': [payer_id]}})
    return ou_tag_data


def process_ou(org_client, ou, ou_tag_data, root_ou):
    print("DEBUG: processing ou {}".format(ou))
    tags = org_client.list_tags_for_resource(ResourceId=ou)['Tags']
    for tag in tags:
        if tag['Key'] == 'cid_users':
            cid_users_tag_value = tag['Value']
            """ Do not process all children if this is root ou, this is done bellow in separate cycle. """
            process_ou_children = bool(ou != root_ou)
            for account in get_ou_accounts(org_client, ou, process_ou_children=process_ou_children):
                account_id = account['Id']
                print(f"DEBUG: processing inherit tag: {cid_users_tag_value} for ou: {ou} account_id: {account_id}")
                ou_tag_data = update_tag_data(account_id, cid_users_tag_value, ou_tag_data)

    children_ou = get_ou_children(ou, org_client)
    if len(children_ou) > 0:
        for child_ou in children_ou:
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
                wrt.writerow({'UserName': user,
                              'account_id': "",
                              'payer_account_id': ",".join(qs_rls[user]['payer_id'])})
            elif qs_rls[user].get('full_access'):
                wrt.writerow({'UserName': user,
                              'account_id': "",
                              'payer_account_id': ""})
            else:
                wrt.writerow({'UserName': user,
                              'account_id': ",".join(qs_rls[user]['account_id']),
                              'payer_account_id': ""})

            """  WRITE TO CSV HERE THE ALL ACCESS USERS
                wrt.writerow({'UserName': user,
                              'account_id': "",
                              'payer_account_id': ""}) """

    upload_to_s3(TMP_RLS_FILE, rls_s3_filename)


def lambda_handler(event, context):
    main()


if __name__ == '__main__':
    main()
