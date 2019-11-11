# Level 200: Automated IAM User Cleanup: Lab Guide

## Authors

- Pierre Liddle, Principal Security Architect
- Byron Pogson, Solutions Architect

## Table of Contents

1. [Architecture Overview](#overview)
2. [Deploying IAM Lambda Cleanup with AWS SAM](#Lambda_IAM_Cleanup)

## 1. Architecture Overview <a name="overview"></a>

The AWS Lambda function is triggered by a regular scheduled event in Amazon CloudWatch Events.
Once the Lambda function runs to check the status of the AWS IAM Users and associated IAM Access Keys the results are sent the designated email contact via Amazon SNS. A check is also performed for unused roles.
The logs from the AWS Lambda function are captured in Amazon CloudWatch Logs for review and trouble shooting purposes.

![architecture](architecture.png)

## 2. Deploying IAM Lambda Cleanup with AWS SAM <a name="Lambda_IAM_Cleanup"></a>

1. Download the latest version of the templates from the GitHub [code](https://github.com/awslabs/aws-well-architected-labs/tree/master/Security/200_Automated_IAM_User_Cleanup/Code) folder as raw objects, or by cloning this repository.

2. Create an Amazon S3 bucket if you don't already have one, it needs to be in the same AWS region being deployed into.

3. Now that you have the S3 bucket created and the files downloaded to your machine. You can start to create your deployment package on the command line with AWS SAM.
   Make sure you are working in the folder where where you have downloaded the files to.

   Run the following command to prepare your deployment package:

     `aws cloudformation package --template-file cloudformation-iam-user-cleanup.yml  --output-template-file output-template.yaml --s3-bucket <bucket>`

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

## References & useful resources

[AWS Identity and Access Management User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
[IAM Best Practices and Use Cases](https://docs.aws.amazon.com/IAM/latest/UserGuide/IAMBestPracticesAndUseCases.html)
[AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-reference.html#serverless-sam-cli)
[AWS Serverless Application Model (SAM)](https://aws.amazon.com/serverless/sam/)

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


