---
title: "Deploy the Infrastructure"
menutitle: "Deploy Infrastructure"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

For many organizations, the data that they possess is one of the most valuable assets they have. Backing up data frequently is of vital importance for the long lasting success of any organization. However, a backup of data is only valuable if data can be recovered/restored from the backup. In the cloud, backing up data and testing the restore is easier compared to on-premises datacenters. Automating this process with appropriate notification systems will ensure that an organization's data is backed up frequently, the backups are tested to ensure expected recovery, and the appropriate people are notified in case of failures.

![architecture](/Reliability/200_Testing_Backup_and_Restore_of_Data/Images/architecture.jpeg)

You will use AWS CloudFormation to provision some resources needed for this lab. As part of this lab, the CloudFormation stack that you provision will create an EBS Volume, an SNS Topic, and a Lambda Function. **This lab will only work in us-east-1.**

### 1.1 Log into the AWS console {#awslogin}

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

{{%expand "Click here for instructions to access your assigned AWS account:" %}} {{% common/Workshop_AWS_Account %}} {{% /expand%}}

**If you are using your own AWS account**:
{{%expand "Click here for instructions to use your own AWS account:" %}}
* Sign in to the AWS Management Console as an IAM user who has PowerUserAccess or AdministratorAccess permissions, to ensure successful execution of this lab.
{{% /expand%}}

### 1.2 Deploy the infrastructure using AWS CloudFormation

Click [here](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/quickcreate?templateUrl=https%3A%2F%2Fc3pio.s3.amazonaws.com%2Fbackup-lab%2Fbackup-lab.yaml&stackName=WA-BACKUP-LAB) to deploy the stack.

Under **PARAMETERS**, specify an email address that you have access to for **NotificationEmail.**

Check the box **I acknowledge that AWS CloudFormation might create IAM resources.**

Click **CREATE** / **CREATE STACK.**

**MANUAL STEPS**

1.  Use your administrator account to access the CloudFormation console - <https://console.aws.amazon.com/cloudformation/>.
1.  Click on **CREATE STACK**.
1.  Under **PREREQUISITE - PREPARE TEMPLATE**, select the option **TEMPLATE IS READY**.
1.  Under **SPECIFY TEMPLATE**, select the option **AMAZON S3 URL**, enter the link - https://c3pio.s3.amazonaws.com/backup-lab/backup-lab.yaml and click **NEXT**.
1.  Enter a **STACK NAME** such as **WA**-**BACKUP-LAB**.
1.  For **NotificationEmail,** specify an email address that you have access to.
1.  Leave default values for the rest of the fields and click **NEXT**.
1.  No changes are needed on the **CONFIGURE STACK OPTIONS** page, click **NEXT**.
1.  Review the details of the stack, scroll down to **CAPABILITIES,** and check the box next to **I acknowledge that AWS CloudFormation might create IAM resources.**
1. Click **CREATE STACK**.

**Note:** Once stack creation starts, monitor the email address you entered. You should receive an email from SNS with the subject **AWS Notification - Subscription Confirmation.** Click on the link **Confirm subscription** to confirm the subscription of your email to the SNS Topic.

The stack takes about 3 minutes to create all the resources. Periodically refresh the page until you see that the **STACK STATUS** is in **CREATE_COMPLETE**. Once the stack is in **CREATE_COMPLETE**, visit the **OUTPUTS** section for the stack and note down the **KEY** and **VALUE** for each of the outputs. This information will be used later in the lab.
