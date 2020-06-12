---
title: "Enable Notifications"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

In the cloud, setting up notifications to be aware of events within your workload is easily achieved. AWS Backup leverages AWS SNS to send notifications related to backup activities that are occurring. This will allow visibility into backup job statuses, restore job statuses, or any failures that may have occurred, allowing your Operations teams to respond appropriately.

1.  Open a terminal where you have access to the AWS CLI. Ensure that the CLI is up to date and that you have AWS Administrator Permissions to run AWS CLI commands. <https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html>
1.  Edit the following AWS CLI command and include the **ARN** of the **SNS TOPIC** that you created. Replace **<YOUR SNS TOPIC ARN>** with the **ARN** of the **SNS TOPIC** obtained from the outputs section of the CloudFormation Stack. **Note that the backup vault name is case sensitive.**

    `aws backup put-backup-vault-notifications --region us-east-1 --backup-vault-name BACKUP-LAB-VAULT --backup-vault-events BACKUP_JOB_COMPLETED RESTORE_JOB_COMPLETED --sns-topic-arn <YOUR SNS TOPIC ARN>`

1.  Once edited, run the above command, it will enable notifications with messages published to the **SNS TOPIC** every time a backup or restore job is completed. This will ensure the Operations team is aware of any failures with backing up or restoring data.
1.  You can verify that notifications have been enabled by running the following command. The output will include a section called **SNSTopicArn** followed by the ARN of the SNS Topic that was created as part of the lab.

    `aws backup get-backup-vault-notifications --backup-vault-name BACKUP-LAB-VAULT --region us-east-1`

    ![add-notification](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/add-notification.png)

You have now successfully enabled notifications for the backup vault BACKUP-LAB-VAULT, ensuring that the Operations team is aware of all backup and restore activities involving this vault, and any failures associated with those activities.
