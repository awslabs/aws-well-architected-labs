import json
import boto3
import base64
import urllib3

backup = boto3.client('backup')

def lambda_handler(event, context):
    print('Incoming Event:' + json.dumps(event))

    try:
        if event['Records'][0]['Sns']['Subject'] == 'Restore Test Status':
            print('No action required, deletion of new resource confirmed.')
            return
    except Exception as e:
            print(str(e))
            return

    job_type = event['Records'][0]['Sns']['Message'].split('.')[-1].split(' ')[1]

    try:
        if 'failed' in event['Records'][0]['Sns']['Message']:
            print('Something has failed. Please review the job in the AWS Backup console.')
            return 'Job ID:' + event['Records'][0]['Sns']['Message'].split('.')[-1].split(':')[1].strip()
        elif job_type == 'Backup':
            backup_job_id = event['Records'][0]['Sns']['Message'].split('.')[-1].split(':')[1].strip()
            backup_info = backup.describe_backup_job(
                            BackupJobId=backup_job_id
                        )
            #get backup job details
            recovery_point_arn = backup_info['RecoveryPointArn']
            iam_role_arn = backup_info['IamRoleArn']
            backup_vault_name = backup_info['BackupVaultName']
            resource_type = backup_info['ResourceType']

            metadata = backup.get_recovery_point_restore_metadata(
                BackupVaultName=backup_vault_name,
                RecoveryPointArn=recovery_point_arn
            )

            #determine resource type that was backed up and get corresponding metadata
            if resource_type == 'DynamoDB':
                metadata['RestoreMetadata']['targetTableName'] = metadata['RestoreMetadata']['originalTableName'] + '-restore-test'
            elif resource_type == 'EBS':
                ec2 = boto3.client('ec2')
                region = event['Records'][0]['Sns']['TopicArn'].split(':')[3]
                volumeid = event['Records'][0]['Sns']['Message'].split('.')[2].split('/')[1]

                metadata['RestoreMetadata']['availabilityZone'] = ec2.describe_volumes(
                VolumeIds=[
                    volumeid
                ]
                )['Volumes'][0]['AvailabilityZone']
            elif resource_type == 'RDS':
                metadata['RestoreMetadata']['DBInstanceIdentifier'] = event['Records'][0]['Sns']['Message'].split('.')[2].split(':')[7] + '-restore-test'
            elif resource_type == 'EFS':
                metadata['RestoreMetadata']['PerformanceMode'] = 'generalPurpose'
                metadata['RestoreMetadata']['newFileSystem'] = 'true'
                metadata['RestoreMetadata']['Encrypted'] = 'false'
                metadata['RestoreMetadata']['CreationToken'] = metadata['RestoreMetadata']['file-system-id'] + '-restore-test'
            elif resource_type == 'EC2':
                metadata['RestoreMetadata']['CpuOptions'] = '{}'
                metadata['RestoreMetadata']['NetworkInterfaces'] = '[]'

            #API call to start the restore job
            print('Starting the restore job')
            restore_request = backup.start_restore_job(
                    RecoveryPointArn=recovery_point_arn,
                    IamRoleArn=iam_role_arn,
                    Metadata=metadata['RestoreMetadata']
            )

            print(json.dumps(restore_request))

            return
        elif job_type == 'Restore':
            restore_job_id = event['Records'][0]['Sns']['Message'].split('.')[-1].split(':')[1].strip()
            topic_arn = event['Records'][0]['Sns']['TopicArn']
            restore_info = backup.describe_restore_job(
                            RestoreJobId=restore_job_id
                        )
            resource_type = restore_info['CreatedResourceArn'].split(':')[2]

            print('Restore from the backup was successful. Deleting the newly created resource.')

            #determine resource type that was restored and delete it to save cost
            if resource_type == 'dynamodb':
                dynamo = boto3.client('dynamodb')
                table_name = restore_info['CreatedResourceArn'].split(':')[5].split('/')[1]

                # Include recovery validation checks for DynamoDB here

                print('Deleting: ' + table_name)
                delete_request = dynamo.delete_table(
                                    TableName=table_name
                                )
            elif resource_type == 'ec2':
                ec2 = boto3.client('ec2')
                ec2_resource_type = restore_info['CreatedResourceArn'].split(':')[5].split('/')[0]
                if ec2_resource_type == 'volume':
                    volume_id = restore_info['CreatedResourceArn'].split(':')[5].split('/')[1]

                    # Include recovery validation checks for EBS here

                    print('Deleting: ' + volume_id)
                    delete_request = ec2.delete_volume(
                                VolumeId=volume_id
                            )
                elif ec2_resource_type == 'instance':
                    instance_id = restore_info['CreatedResourceArn'].split(':')[5].split('/')[1]
                    print('Validating data recovery before deletion.')

                    #validating data recovery
                    instance_details = ec2.describe_instances(
                                InstanceIds=[
                                    instance_id
                                ]
                            )
                    public_ip = instance_details['Reservations'][0]['Instances'][0]['PublicIpAddress']

                    http = urllib3.PoolManager()
                    url = public_ip
                    try:
                        resp = http.request('GET', url)
                        print("Received response:")
                        print(resp.status)

                        if resp.status == 200:
                            print('Valid response received. Data recovery validated. Proceeding with deletion.')
                            print('Deleting: ' + instance_id)
                            delete_request = ec2.terminate_instances(
                                        InstanceIds=[
                                            instance_id
                                        ]
                                    )
                            message = 'Restore from ' + restore_info['RecoveryPointArn'] + ' was successful. Data recovery validation succeeded with HTTP ' + str(resp.status) + ' returned by the application. ' + 'The newly created resource ' + restore_info['CreatedResourceArn'] + ' has been cleaned up.'
                        else:
                            print('Invalid response. Validation FAILED.')
                            message = 'Invalid response received: HTTP ' + str(resp.status) + '. Data Validation FAILED. New resource ' + restore_info['CreatedResourceArn'] + ' has NOT been cleaned up.'
                    except Exception as e:
                        print(str(e))
                        message = 'Error connecting to the application: ' + str(e)
            elif resource_type == 'rds':
                rds = boto3.client('rds')
                database_identifier = restore_info['CreatedResourceArn'].split(':')[6]

                # Include recovery validation checks for RDS here

                print('Deleting: ' + database_identifier)
                delete_request = rds.delete_db_instance(
                            DBInstanceIdentifier=database_identifier,
                            SkipFinalSnapshot=True
                        )
            elif resource_type == 'elasticfilesystem':
                efs = boto3.client('efs')
                elastic_file_system = restore_info['CreatedResourceArn'].split(':')[5].split('/')[1]

                # Include recovery validation checks for EFS here

                print('Deleting: ' + elastic_file_system)
                delete_request = efs.delete_file_system(
                            FileSystemId=elastic_file_system
                        )

            sns = boto3.client('sns')

            print('Sending final confirmation')
            #send a final notification
            notify = sns.publish(
                TopicArn=topic_arn,
                Message=message,
                Subject='Restore Test Status'
            )

            print(json.dumps(notify))

            return
    except Exception as e:
        print(str(e))
        return
