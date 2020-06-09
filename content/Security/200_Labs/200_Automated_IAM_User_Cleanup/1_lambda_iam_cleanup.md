---
title: "Deploying IAM Lambda Cleanup with AWS SAM"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

1. Download these two templates (or by cloning this repository):
    * [cloudformation-iam-user-cleanup.yaml](/Security/200_Automated_IAM_User_Cleanup/Code/cloudformation-iam-user-cleanup.yaml)
    * [lambda-iam-user-cleanup.py](/Security/200_Automated_IAM_User_Cleanup/Code/lambda-iam-user-cleanup.py)

2. Create an Amazon S3 bucket if you don't already have one, it needs to be in the same AWS region being deployed into.

3. Now that you have the S3 bucket created and the files downloaded to your machine. You can start to create your deployment package on the command line with AWS SAM.
   Make sure you are working in the folder where where you have downloaded the files to.

   Run the following command to prepare your deployment package:


4. Once you have finished preparing the package you can deploy the CloudFormation with AWS SAM:

    NOTE: The template file to use here is the output file from the previous command:

     `aws cloudformation deploy --template-file output-template.yaml  --stack-name IAM-User-Cleanup --capabilities CAPABILITY_IAM --parameter-overrides NotificationEmail=<replace_with_your_email_address>`

5. Once you have completed the deployment of your AWS Lambda function, test the function by going to the AWS Lambda function in your AWS account and create a dummy event by selecting test.

    If your test runs successfully you should receive an email from:

    *AWS Notifications <no-reply@sns.amazonaws.com>*

    with the subject line of: *IAM user cleanup from <account_ID>*

    and the body of the email will have a status report from the findings. E.g. IAM Users and AWS Access Keys which require a cleanup

    *IAM user cleanup successfully ran.*

    *User John Doe has not logged in since 2018-04-19 08:36:18+00:00 and needs cleanup*

    *User John Doe has not used access key AKIAIOSFODNN7EXAMPLE in since 2018-04-22 21:32:  00+00:00 and needs cleanup*

    *User John Doe has not used access key AKIAIOSFODNN7EXAMPLE in since 2018-04-22 20:08:00+00:00 and needs cleanup*

