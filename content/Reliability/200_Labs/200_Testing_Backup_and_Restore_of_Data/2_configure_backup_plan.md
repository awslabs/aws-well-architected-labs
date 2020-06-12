---
title: "Create Backup Plan"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

A well thought out backup strategy is key to an organization's success and is determined by a variety of factors. The biggest factors influencing a backup strategy is the Recovery Time Objective (RTO) and Recovery Point Objective (RPO) set for the workload. RTO and RPO are determined based on the criticality of the workload to the business, the SLAs that have been agreed upon, and the cost associated with achieving the RTO and RPO. RTO and RPO should be specific to each workload and not set for the entire organization/infrastructure.

In this lab, you will create a backup strategy by leveraging AWS Backup, a fully managed backup service that can automatically backup data from EBS Volumes, RDS Databases, DynamoDB Tables, EFS File Systems, EC2 Instances, and Storage Gateways.

1.  Sign in to the AWS Backup console - <https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#backupplan>.
1.  Choose **CREATE BACKUP PLAN**.

    ![create-backup-plan-1](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/create-backup-plan-1.png)

1.  Select the option to **BUILD A NEW PLAN**.
1.  Specify a **Backup plan name** such as **BACKUP-LAB**.

    ![build-new-backup-plan](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/build-new-backup-plan.png)

1.  Under **BACKUP RULE CONFIGURATION**, enter a **RULE NAME** such as **BACKUP-LAB-RULE**.
1.  To set a **SCHEDULE** for the backup, you can specify the **FREQUENCY** at which backups are taken. You can enter frequency as every 12 hours, Daily, Weekly, or Monthly. Alternatively, you can specify a custom **CRON EXPRESSION** for your backup frequency. For this exercise, select the **FREQUENCY** as **DAILY.**
1.  Once frequency has been established, you will need to specify a backup window - a period of time during which data is being backed up from your data sources. Keep in mind that creating backups could cause you data sources to be temporarily unavailable depending on the underlying configuration of those resources. It is best to create backups during scheduled downtimes/maintenance windows when user impact is minimal. For this exercise, select **Use backup window defaults - *recommended.*** The default backup window is set to start at 5 AM UTC time and last 8 hours. If you need to schedule backups at a different time, you can customize the backup window.

    ![backup-rule-configuration](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/backup-rule-configuration.png)

1.  You can set lifecycle policies for your backups to transition them to cold storage or to expire them after a period of time to reduce costs and operational overhead. This is currently supported for backups of EFS only. For this exercise, set the values for **Transition to cold storage** and **Expire** both to **NEVER.**
1.  Under **BACKUP VAULT**, click on **CREATE NEW BACKUP VAULT**. It is recommended to use different Backup Vaults for different workloads.

    ![create-backup-vault](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/create-backup-vault.png)

1. On the pop-up screen, specify a **BACKUP VAULT NAME** such as **BACKUP-LAB-VAULT.**
1. You can choose to encrypt your backups for additional security by specifying a KMS key. You can choose the default key created and managed by AWS Backup or specify your own custom key. For this exercise, select the default key **(default) aws/backup**.
1. Click **CREATE BACKUP VAULT**.

    ![backup-vault-configuration](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/backup-vault-configuration.png)

1. Additionally, you can choose to have your backups automatically copied to a different AWS Region.
1. You can add tags to your recovery points to help identify them.
1. Click **CREATE PLAN**.

    ![create-backup-plan-2](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/create-backup-plan-2.png)

Once the backup plan and the backup rule has been created, you can specify resources to back up. You can select individual resources to be backed up, or specify a tag (key-value) associated with the resource. AWS Backup will execute backup jobs on all resources that match the tags specified.

1.  Click on **BACKUP PLANS** from the menu on the left side of the screen.
1.  Select the backup plan **BACKUP-LAB** that you just created.

    ![select-backup-plan](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/select-backup-plan.png)

1.  Scroll down to the section titled **RESOURCE ASSIGNMENTS** and click on **ASSIGN RESOURCES**.

    ![resource-assignments](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/resource-assignments.png)

1.  Specify a **RESOURCE ASSIGNMENT NAME** such as **BACKUP-RESOURCES** to help identify the resources that are being backed up.
1.  Leave the **DEFAULT ROLE** selected for **IAM ROLE**. If a role does not already exist, the AWS Backup service will create one with the necessary permissions.
1.  Under **ASSIGN RESOURCES**, you can specify resources to be backed up individually by specifying the **RESOURCE TYPE** and **RESOURCE ID**, or select **TAGS** and enter the **TAG KEY** and the **TAG VALUE**. For this lab, select **TAGS** as the value for **ASSIGN BY**, and enter **workload** as the **KEY** and **myapp** as the **VALUE**. This tag and value was created by the CloudFormation stack. **Remember that tags are case sensitive and ensure that the values you enter are all in lower case.**
1.  Click on **ASSIGN RESOURCES**.

    ![assign-resources](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/assign-resources.png)

You have successfully created a backup plan for your data sources, and all supported resources with the tags **WORKLOAD-MYAPP** will be backed up automatically, at the frequency specified. In case of a disaster, these backups can be used to recover data to ensure business continuity. Since the entire process is automated, it will save considerable operational overhead for your Operations teams.
