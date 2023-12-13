#!/usr/bin/env python3
import boto3
from os import environ as os_environ
from sys import exit

QS_ACCOUNT_ID = boto3.client('sts').get_caller_identity().get('Account')
QS_REGION = os_environ['QS_REGION'] if 'QS_REGION' in os_environ else exit("Missing QS_REGION var name, please define")


def main():
    qs_client = boto3.client('quicksight', region_name=QS_REGION)
    qs_users = get_all_qs_users(QS_ACCOUNT_ID, qs_client)
    print(qs_users)


def get_all_qs_users(account_id, qs_client):
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


def lambda_handler(event, context):
    main()


if __name__ == '__main__':
    main()
