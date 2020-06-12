---
title: "Test Restore"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

A backup of a data source is useful only if data can be restored from it. If backups aren't tested, you might find yourself in a situation where your workload has been impacted by an event and you need to recover data from your backups, but the backups are faulty and restoring data is no longer feasible, or exceeds your RTO. To avoid such situations, backups taken should always be tested to ensure they can be used to recover data.

In this lab, you will leverage AWS Lambda to automatically test all backups created to ensure recovery is successful, and clean up any resources that were created during the restore test process to save on cost. This will ensure you are aware of any faulty backups that might be unusable to recover data from. Automating this process with notifications enabled will ensure there is minimal operational overhead and that the Operations teams are aware of backup and restore statuses.

### Testing Recovery

For the purpose of this lab, we will simulate the action performed by AWS Backup when creating backups of data sources by creating an on-demand backup to see if the backup is successful. Once the backup is completed, you will receive a notification stating that the backup job has completed and the lambda function will get invoked. The Lambda function will make API calls to start restoring data from the backup that was created. This will help ascertain that the backup is good. Once the restore process has been completed, you will receive another notification confirming this, and the lambda function will get invoked again to clean up new resources that were created as part of the restore. Once the cleanup has been completed, you will receive one last notification confirming cleanup.

1.  Use your administrator account to access the AWS Backup console - <https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#home>
1.  Click on **CREATE AN ON-DEMAND BACKUP** in the middle of the screen.

    ![create-on-demand-backup](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/create-on-demand-backup.png)

1.  Under **RESOURCE TYPE**, select **EBS**. Paste in the **Volume ID** obtained from the Output of the CloudFormation Stack.
1.  Under **BACKUP WINDOW**, ensure that the **CREATE BACKUP NOW** option is selected.

    ![on-demand-backup-configuration-1](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/on-demand-backup-configuration-1.png)

1.  Under **EXPIRE**, select the option **DAYS AFTER CREATION** and enter **1** for the value for this lab. This will ensure that the backup is deleted after 1 day.
1.  Under **Backup Vault**, select the **BACKUP-LAB-VAULT**.
1.  Leave the default IAM role selected.
1.  Click **CREATE ON-DEMAND BACKUP**.

    ![on-demand-backup-configuration-2](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/on-demand-backup-configuration-2.png)

1.  Click on **JOBS** from the menu on the left and select **BACKUP JOBS**. You should see a new backup job started with the status of **RUNNING**. Click on the **RESTORE JOBS** tab, there shouldn't be any restore jobs running.

    ![backup-jobs](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/backup-jobs.png)

1. Periodically refresh the console until the **STATUS** changes to **COMPLETED**. It should take about 5-10 minutes to complete. While waiting for the job to finish and the notification to go out, you can review the lambda function code [here](Code/lambda_function.py) to understand what the lambda function is doing.
1. After the job is completed, click on the **JOB ID** and view the **DETAILS**. You should see the **Recovery Point ARN** that was created, the **RESOURCE ID** for which the backup was created, and the **RESOURCE TYPE** for which the backup was created.

    ![backup-job-completed](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/backup-job-completed.png)

1. Monitor your email to see if you receive a **Notification** **from AWS Backup**. Compare details in the email to what you see on the AWS Console, they should match. It takes about 10 mins for the email to show up once the backup job has completed.

    ![backup-job-notification](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/backup-job-notification.png)

1. Go back to **JOBS** and switch to the **RESTORE JOBS** tab. You should see a **RESTORE JOB** running. The lambda function that was created as part of this lab has requested a restore job to ensure that the backup can be used to recover from.

    ![restore-jobs](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/restore-jobs.png)

1. Periodically refresh the console until the **STATUS** changes to **COMPLETED**. It should take about 5-10 minutes to complete.
1. After the job is completed, click on the **JOB ID** and view the **DETAILS**. You should see the **Recovery Point** **ARN** from which the restore was tested, the **RESOURCE ID** of the newly created EBS Volume, and the **RESOURCE TYPE** for which the restore was created.

    ![restore-jobs-completed](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/restore-jobs-completed.png)

1. Note down the **RESOURCE ID** of the newly created EBS Volume and verify that it exists from the EC2 Console - <https://console.aws.amazon.com/ec2/home?region=us-east-1#Volumes:sort=size>
1. Monitor your email to see if you have received a **Notification from AWS Backup** confirming the restore job was successful. Compare details in the email to what you see on the AWS Console, they should match. It takes about 10 mins for the email to show up once the restore job has completed.

    ![restore-job-notification](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/restore-job-notification.png)

1. Once it is established that the restore was successful, it is time to delete the new resource that was created to prevent unnecessary spend. This process is also automated using AWS Lambda.
1. Monitor your email to see if you have received a **Restore Test Status** notification confirming the deletion of the newly created resource. Check the EC2 Console to verify that the new EBS Volume has been deleted - <https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#Volumes:sort=size>
1. Use your administrator account to access the AWS CloudWatch console - <https://console.aws.amazon.com/cloudwatch/home?region=us-east-1>
1. Click on **LOGS** from the menu on the left side.
1. For filter, paste the following string.

   `/aws/lambda/RestoreTestFunction`

1.  Click on the **LOG STREAM** and view the output of the Lambda function's execution.

### Review of Best Practices Implemented

**Identify all data that needs to be backed up and perform backups or reproduce the data from sources:** Back up important data using Amazon S3, Amazon EBS snapshots, or third-party software. Alternatively, if the data can be reproduced from sources to meet RPO, you may not require a backup.

**Perform data backup automatically or reproduce the data from sources automatically:** Automate backups or the reproduction from sources using AWS features (for example, snapshots of Amazon RDS and Amazon EBS, versions on Amazon S3, etc.), AWS Marketplace solutions, or third-party solutions.

**Perform periodic recovery of the data to verify backup integrity and processes:** Validate that your backup process implementation meets Recovery Time Objective and Recovery Point Objective through a recovery test.
