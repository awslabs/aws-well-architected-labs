# Level 300: Lambda Cross Account IAM Role Assumption

## Authors

- Ben Potter, Security Lead, Well-Architected

## Table of Contents

1. [Create role for Lambda in account 2](#create_role_2)
2. [Create role for Lambda in account 1](#create_role_1)
3. [Create Lambda in account 1](#create_lambda_1)
4. [Tear Down](#tear_down)

## 1. Create role for Lambda in account 2 <a name="create_role_2"></a>

1. Sign in to the AWS Management Console as an IAM user or role in your AWS account, and open the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
2. Click Roles on the left, then create role.
3. Click Another AWS account, enter the account id for account 1 (the origin), then click Next: Permissions.
4. Do not select any managed policies, click Next: Tags.
5. Click Next: Review.
6. Enter LambdaS3ListBuckets for the Role name then click Create role.
7. From the list of roles click the name of LambdaS3ListBuckets.
8. Copy the Role ARN and store for use later in this lab.
9. Click Add inline policy, then click JSON tab.
10. Replace the sample json with the following, then click Review Policy.

        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Sid": "S3ListAllMyBuckets",
                    "Effect": "Allow",
                    "Action": [
                        "s3:ListAllMyBuckets"
                    ],
                    "Resource": "*"
                }
            ]
        }

11. Name this policy LambdaS3ListBucketsPolicy, then click Create policy.

## 2. Create role for Lambda in account 1 <a name="create_role_1"></a>

1. Sign in to the AWS Management Console as an IAM user or role in your AWS account, and open the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
2. Click Roles on the left, then create role.
3. AWS service will be pre-selected, select Lambda, then click Next: Permissions.
4. Do not select any managed policies, click Next: Tags.
5. Click Next: Review.
6. Enter Lambda-Assume-Roles for the Role name then click Create role.
7. From the list of roles click the name of Lambda-Assume-Roles.
8. Copy the Role ARN and store for use later in this lab.
9. Click Add inline policy, then click JSON tab.
10. Replace the sample json with the following, replacing **account1** and **account2** with your respective account id's, us-east-1 region with the region you are using, then click Review Policy.

        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Sid": "stsassumerole",
                    "Effect": "Allow",
                    "Action": "sts:AssumeRole",
                    "Resource": "arn:aws:iam::account2:role/LambdaS3ListBuckets",
                    "Condition": {
                        "StringLike": {
                            "aws:UserAgent": "*AWS_Lambda_python*"
                        }
                    }
                },
                {
                    "Sid": "logsstreamevent",
                    "Effect": "Allow",
                    "Action": [
                        "logs:CreateLogStream",
                        "logs:PutLogEvents"
                    ],
                    "Resource": "arn:aws:logs:us-east-1:account1:log-group:/aws/lambda/Lambda-Assume-Roles*/*"
                },
                {
                    "Sid": "logsgroup",
                    "Effect": "Allow",
                    "Action": "logs:CreateLogGroup",
                    "Resource": "*"
                }
            ]
        }

11. Name this policy Lambda-Assume-Roles-Policy, then click Create policy.

***

## 3. Create Lambda in account 1 <a name="create_lambda_1"></a>

1. Open the Lambda console.
2. Click Create a function.
3. Accept the default Author from scratch.
4. Enter function name as Lambda-Assume-Roles.
5. Select Python 3.6 runtime.
6. Expand Permissions, click Use an existing role, then select the Lambda-Assume-Roles role.
7. Click Create function.
8. Replace the example function code with the following, replacing the **RoleArn** with the one from account 2 you created previously.

        import json
        import boto3
        import os
        import uuid

        def lambda_handler(event, context):
            try:
                client = boto3.client('sts')
                response = client.assume_role(RoleArn='arn:aws:iam::account2:role/LambdaS3ListBuckets',RoleSessionName="{}-s3".format(str(uuid.uuid4())[:5]))
                session = boto3.Session(aws_access_key_id=response['Credentials']['AccessKeyId'],aws_secret_access_key=response['Credentials']['SecretAccessKey'],aws_session_token=response['Credentials']['SessionToken'])

                s3 = session.client('s3')
                s3list = s3.list_buckets()
                print (s3list)
                return str(s3list['Buckets'])

            except Exception as e:
                print(e)
                raise e

9. Click Save.
10. Click Test, accept the default event template, enter event name of test, then click Create.
11. Click Test again, and in a few seconds the function output should highlight green and you can expand the detail to see the response from the S3 API.

How could the example policies be improved?

***

## 4. Tear down this lab <a name="tear_down"></a>

Remove the lambda function, then roles.

***

## References & useful resources

<https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_condition-keys.html>

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
