---
title: "Test Restore"
date: 2021-02-21T11:16:08-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

A backup of a data source is useful only if data can be restored from it. If backups aren't tested, you might find yourself in a situation where your workload has been impacted by an event and you need to recover data from your backups, but the backups are faulty and restoring data is not possible, or exceeds your RTO. To avoid such situations, backups taken should always be tested to ensure they can be used to recover data.

In this lab, you will leverage AWS Lambda to automatically test all backups created to ensure recovery is successful, and clean up any resources that were created during the restore test process to save on cost. This will ensure you are aware of any faulty backups that might be unusable to recover data from. Automating this process with notifications enabled will ensure there is minimal operational overhead and that the Operations teams are aware of backup and restore statuses.

When testing recovery, it is important to define the criteria for successful data recovery from the restored resource. This will depend on a variety of factors such as the data source, the type of data, the margin for error, etc. Organizations and workload owners are responsible for defining this success criteria.

The EC2 Instance that was created as part of this lab is running a simple web application. For this use-case, I have determined that data recovery is successful if the application is running on the restored resource as well. If the restored resource is missing any application critical files, the healthchecks made against the restored resource will fail, indicating an issue with the backup.

### Testing Recovery

For the purpose of this lab, we will simulate the action performed by AWS Backup when creating backups of data sources by creating an on-demand backup to see if the backup is successful. Once the backup is completed, you will receive a notification stating that the backup job has completed and the lambda function will get invoked. The Lambda function will make API calls to start restoring data from the backup that was created. This will help ascertain that the backup is good. Once the restore process has been completed, you will receive another notification confirming this, and the lambda function will get invoked again to clean up new resources that were created as part of the restore. Once the cleanup has been completed, you will receive one last notification confirming cleanup.

1.  Use your administrator account to access the AWS Backup console - <https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#home>
1.  Click on **CREATE AN ON-DEMAND BACKUP** in the middle of the screen.

    ![create-on-demand-backup](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/create-on-demand-backup.png)

1.  Under **RESOURCE TYPE**, select **EC2**. Paste in the **Instance ID** obtained from the Output of the CloudFormation Stack.
1.  Under **BACKUP WINDOW**, ensure that the **CREATE BACKUP NOW** option is selected.

    ![on-demand-backup-configuration-1](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/on-demand-backup-configuration-1.png)

1.  Under **EXPIRE**, select the option **DAYS AFTER CREATION** and enter **1** for the value for this lab. This will ensure that the backup is deleted after 1 day.
1.  Under **Backup Vault**, select the **BACKUP-LAB-VAULT**.
1.  Leave the default IAM role selected.
1.  Click **CREATE ON-DEMAND BACKUP**.

    ![on-demand-backup-configuration-2](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/on-demand-backup-configuration-2.png)

1.  Click on **JOBS** from the menu on the left and select **BACKUP JOBS**. You should see a new backup job started with the status of **RUNNING**. Click on the **RESTORE JOBS** tab, there shouldn't be any restore jobs running.

    ![backup-jobs](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/backup-jobs.png)

1. Periodically refresh the console until the **STATUS** changes to **COMPLETED**. It should take about 5-10 minutes to complete.
1. After the job is completed, click on the **JOB ID** and view the **DETAILS**. You should see the **Recovery Point ARN** that was created, the **RESOURCE ID** for which the backup was created, and the **RESOURCE TYPE** for which the backup was created.

    ![backup-job-completed](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/backup-job-completed.png)

1. Monitor your email to see if you receive a **Notification** **from AWS Backup**. Compare details in the email to what you see on the AWS Console, they should match. It takes about 10 mins for the email to show up once the backup job has completed.

    ![backup-job-notification](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/backup-job-notification.png)

1.  The SNS Topic that was created as part of the CloudFormation stack has been configured as a trigger for the Lambda function. When AWS Backup publishes a new message when a backup or restore job is completed, the Lambda function gets invoked.
1.  Let's take a look at the relevant section of the Lambda function code to understand what will happen once the backup job is completed and a notification has been received. You can view the full Lambda function code [here](/Reliability/200_Testing_Backup_and_Restore_of_Data/Code/lambda_function.py).

    The Lambda function first obtains the [recovery point restore metadata](https://docs.aws.amazon.com/aws-backup/latest/devguide/restore-metadata.html) for the recovery point that was created when the on-demand backup job was initiated.

    ```
    metadata = backup.get_recovery_point_restore_metadata(
              BackupVaultName=backup_vault_name,
              RecoveryPointArn=recovery_point_arn
          )
    ```

    Once the recovery point restore metadata has been retrieved, the function will then use this to make an API call to AWS Backup to start a restore job.

    ```
    restore_request = backup.start_restore_job(
                  RecoveryPointArn=recovery_point_arn,
                  IamRoleArn=iam_role_arn,
                  Metadata=metadata['RestoreMetadata']
          )
    ```

1. Go back to **JOBS** and switch to the **RESTORE JOBS** tab. You should see a **RESTORE JOB** running. The lambda function that was created as part of this lab has requested a restore job from AWS Backup. This is to ensure data recovery from the backup is successful.

    ![restore-jobs](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/restore-jobs.png)

1. Periodically refresh the console until the **STATUS** changes to **COMPLETED**. It should take about 5-10 minutes to complete.
1. After the job is completed, click on the **JOB ID** and view the **DETAILS**. You should see the **Recovery Point** **ARN** from which the restore was tested, the **RESOURCE ID** of the newly created EC2 Instance, and the **RESOURCE TYPE** for which the restore was created.

    ![restore-jobs-completed](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/restore-jobs-completed.png)

1. Note down the **RESOURCE ID** of the newly created EC2 Instance and verify that it exists from the EC2 Console - <https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Instances:sort=instanceState>. Note down the public IP of the new EC2 Instance.
1. Monitor your email to see if you have received a **Notification from AWS Backup** confirming the restore job was successful. Compare details in the email to what you see on the AWS Console, they should match. It takes about 10 mins for the email to show up once the restore job has completed.

    ![restore-job-notification](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/restore-job-notification.png)

1. While waiting for the notification, let's take a look at the relevant sections of the Lambda function code to see what happens when a restore job is completed. You can view the full Lambda function code [here](/Reliability/200_Testing_Backup_and_Restore_of_Data/Code/lambda_function.py).

    After receiving confirmation from AWS Backup that the restore job has completed successfully, the Lambda function will verify data recovery. To do this, an API call is made to retrieve the public IP address of the new EC2 Instance. It makes an HTTP GET request to the new EC2 Instance to check if the application is running. If a valid response (200 in this case) is received, it is ascertained that data recovery was successful as per the recovery success criteria that was established earlier in this section. The Lambda function will then make an API call to EC2 to terminate the new EC2 Instance to save on cost. You can manually verify this as well by visiting the following URL:

    `http://<PUBLIC_IP_OF_THE_NEW_INSTANCE>/`

    ```
    instance_details = ec2.describe_instances(
                          InstanceIds=[
                              instance_id
                          ]
                      )
    public_ip = instance_details['Reservations'][0]['Instances'][0]['PublicIpAddress']

    http = urllib3.PoolManager()
    url = public_ip
    resp = http.request('GET', url)
    print(resp.status)

    if resp.status == 200:
        print('Valid response received. Data recovery validated. Proceeding with deletion.')
        print('Deleting: ' + instance_id)
        delete_request = ec2.terminate_instances(
                    InstanceIds=[
                        instance_id
                    ]
                )
    else:
        print('Invalid response. Data recovery is questionable.')
    ```

1. Monitor your email to see if you have received a **Restore Test Status** notification confirming the deletion of the newly created resource. Check the EC2 Console to verify that the new EC2 Instance has been terminated. - <https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Volumes:sort=size>
1. Use your administrator account to access the AWS CloudWatch console - <https://console.aws.amazon.com/cloudwatch/home?region=us-east-1>
1. Click on **LOGS** from the menu on the left side.
1. For filter, paste the following string after replacing the value for the name of the CloudFormation stack that was created as part of this lab.

   `/aws/lambda/RestoreTestFunction-<YOUR CLOUDFORMATION STACK NAME>`

1.  Click on the **LOG STREAM** and view the output of the Lambda function's execution to understand the different steps performed by the function to automate this process.

### Review of Best Practices Implemented

**Identify all data that needs to be backed up and perform backups or reproduce the data from sources:** Back up important data using Amazon S3, Amazon EBS snapshots, or third-party software. Alternatively, if the data can be reproduced from sources to meet RPO, you may not require a backup.

**Perform data backup automatically or reproduce the data from sources automatically:** Automate backups or the reproduction from sources using AWS features (for example, snapshots of Amazon RDS and Amazon EBS, versions on Amazon S3, etc.), AWS Marketplace solutions, or third-party solutions.

**Perform periodic recovery of the data to verify backup integrity and processes:** Validate that your backup process implementation meets Recovery Time Objective and Recovery Point Objective through a recovery test.

{{< prev_next_button link_prev_url="../3_enable_notifications" link_next_url="../5_cleanup/" />}}
