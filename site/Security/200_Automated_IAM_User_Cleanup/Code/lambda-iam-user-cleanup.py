import json
import boto3
import datetime
import os

minAgeKeysToReport = int(os.environ['MinAgeKeysToReport'])
minAgeKeysToDisable = int(os.environ['MinAgeKeysToDisable'])
minAgeKeysToDelete = int(os.environ['MinAgeKeysToDelete'])
minAgeUnusedUsersToReport = int(os.environ['MinAgeUnusedUsersToReport'])
minAgeUnusedUsersToDisable = int(os.environ['MinAgeUnusedUsersToDisable'])
minAgeUnusedUsersToDelete = int(os.environ['MinAgeUnusedUsersToDelete'])

def lambda_handler(event, context):
    client = boto3.client('iam')
    
    today = datetime.datetime.now()
    
    report = ''
    
    # Iterate over all the users
    userResponse = client.list_users()
    for u in userResponse['Users']:
        # Work out when the user was last used
        passwordLastUsed = u['PasswordLastUsed'] if 'PasswordLastUsed' in u else u['CreateDate']
        daysSinceUsed = (today - passwordLastUsed.replace(tzinfo=None)).days
        deleted = False
        # If the feature is enabled (>0) and the days since used > delete setting
        if (minAgeUnusedUsersToDelete > 0 and daysSinceUsed >= minAgeUnusedUsersToDelete):
            # Delete the user
            client.delete_user(UserName=u['UserName'])
            report += 'User {0} has not logged in since {1} and has been deleted\n'.format(
                u['UserName'],
                passwordLastUsed)
            deleted = True
        # else, if the features is enabled and the days since used > disable setting
        elif (minAgeUnusedUsersToDelete > 0 and daysSinceUsed >= minAgeUnusedUsersToDelete):
            # Force a password reset
            client.update_login_profile(
                UserName=u['UserName'],
                PasswordResetRequired=True)
            report += 'User {0} has not logged in since {1} and has been disabled\n'.format(
                u['UserName'],
                passwordLastUsed)
        # else, if the days since used > report setting
        elif (daysSinceUsed >= minAgeUnusedUsersToReport):
            # add the user to the report
            report += 'User {0} has not logged in since {1} and needs cleanup\n'.format(
                u['UserName'],
                passwordLastUsed)
        
        # If we haven't deleted the user
        if not deleted:
            # Get their access keys
            keysResponse = client.list_access_keys(
                UserName=u['UserName'])
            # For each of their keys
            for k in keysResponse['AccessKeyMetadata']:
                # Get when the key was last used
                lastUsedResponse = client.get_access_key_last_used(AccessKeyId=k['AccessKeyId'])
                keyLastUsed = lastUsedResponse['AccessKeyLastUsed']['LastUsedDate'] if 'LastUsedDate' in lastUsedResponse['AccessKeyLastUsed'] else k['CreateDate']
                daysSinceUsed = (today - keyLastUsed.replace(tzinfo=None)).days
                # If the feature is enabled (>0) and the days since used > delete setting
                if (minAgeKeysToDelete > 0 and daysSinceUsed >= minAgeKeysToDelete):
                    # Delete the key
                    client.delete_user(UserName=u['UserName'])
                    response = client.delete_access_key(
                        UserName=u['UserName'],
                        AccessKeyId=k['AccessKeyId']
                    )
                    report += 'User {0} has not used access key {1} in since {2} and has been deleted\n'.format(
                        u['UserName'],
                        k['AccessKeyId'],
                        keyLastUsed)
                # else, if the features is enabled and the days since used > disable setting
                elif (minAgeKeysToDisable > 0 and daysSinceUsed >= minAgeKeysToDisable):
                    # Force a password reset
                    response = client.update_access_key(
                        UserName=u['UserName'],
                        AccessKeyId=k['AccessKeyId'],
                        Status='Inactive'
                    )
                    report += 'User {0} has not used access key {1} in since {2} and has been disabled\n'.format(
                        u['UserName'],
                        k['AccessKeyId'],
                        keyLastUsed)
                # else, if the days since used > report setting
                elif (daysSinceUsed >= minAgeKeysToReport):
                    # add the user to the report
                    report += 'User {0} has not used access key {1} in since {2} and needs cleanup\n'.format(
                        u['UserName'],
                        k['AccessKeyId'],
                        keyLastUsed)
        
    if not report:
        report = 'IAM user cleanup successfully ran. No outstanding users found.'
    else:
        report = 'IAM user cleanup successfully ran.\n\n' + report
    
    snsClient = boto3.client('sns')
    snsClient.publish(
        TopicArn=os.environ['TopicTarget'],
        Subject='IAM user cleanup from ' +  context.invoked_function_arn.split(":")[4],
        Message=report
    )