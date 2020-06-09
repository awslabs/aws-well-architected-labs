import json
import boto3
import datetime
import time
import os

minAgeKeysToReport = int(os.environ['MinAgeKeysToReport'])
minAgeKeysToDisable = int(os.environ['MinAgeKeysToDisable'])
minAgeKeysToDelete = int(os.environ['MinAgeKeysToDelete'])
minAgeUnusedUsersToReport = int(os.environ['MinAgeUnusedUsersToReport'])
minAgeUnusedUsersToDisable = int(os.environ['MinAgeUnusedUsersToDisable'])
minAgeUnusedUsersToDelete = int(os.environ['MinAgeUnusedUsersToDelete'])
minAgeRolesToReport = int(os.environ['MinAgeRolesToReport'])
minAgeRolesToDisable = int(os.environ['MinAgeRolesToDisable'])
minAgeRolesToDelete = int(os.environ['MinAgeRolesToDelete'])

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
        
    # Iterate over all the roles
    rolesResponse = client.list_roles(MaxItems=1000)
    for r in [r for r in rolesResponse['Roles'] if '/aws-service-role/' not in r['Path'] and '/service-role/' not in r['Path']]:
        # We need to create a job to generate the last access report
        jobId = client.generate_service_last_accessed_details(Arn=r['Arn'])['JobId']
        
        roleAccessDetails = client.get_service_last_accessed_details(JobId=jobId)
        jobAttempt = 0
        while roleAccessDetails['JobStatus'] == 'IN_PROGRESS':
            time.sleep(jobAttempt*2) 
            jobAttempt = jobAttempt + 1
            roleAccessDetails = client.get_service_last_accessed_details(JobId=jobId)
        if roleAccessDetails['JobStatus'] == 'FAILED':
            report += 'Unable to retrive last access report for role {0}. No action taken.\n'.format(
                    r['Arn'])
        else:
            lastAccessedDates = [a['LastAuthenticated'] for a in roleAccessDetails['ServicesLastAccessed'] if 'LastAuthenticated' in a]
            if not lastAccessedDates:
                report += 'Role {0} has no access history. No action taken.\n'.format(
                        r['Arn'])
            else:
                roleLastUsed = min(lastAccessedDates)
                daysSinceUsed = (today - roleLastUsed.replace(tzinfo=None)).days
                # If the feature is enabled (>0) and the days since used > delete setting
                if (minAgeRolesToDelete > 0 and daysSinceUsed >= minAgeRolesToDelete):
                    # Delete the user
                    client.delete_role(RoleName=r['RoleName'])
                    report += 'Role {0} has not been used since {1} and has been deleted\n'.format(
                        r['Arn'],
                        roleLastUsed)
                # else, if the features is enabled and the days since used > disable setting
                elif (minAgeRolesToDelete > 0 and daysSinceUsed >= minAgeRolesToDelete):
                    # Force a password reset
                    client.attach_role_policy(
                        PolicyArn='arn:aws:iam::aws:policy/AWSDenyAll',
                        RoleName=r['RoleName'],
                    )
                    report += 'Role {0} has not been used since {1} and has been disabled\n'.format(
                        r['Arn'],
                        roleLastUsed)
                # else, if the days since used > report setting
                elif (daysSinceUsed >= minAgeRolesToReport):
                    # add the user to the report
                    print(r)
                    report += 'Role {0} has not been used since {1} and needs cleanup\n'.format(
                        r['Arn'],
                        roleLastUsed)
    
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