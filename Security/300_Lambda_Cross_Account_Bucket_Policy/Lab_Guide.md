# Level 300: Lambda Cross Account Using Bucket Policy

## Authors

* Seth Eliot, Resiliency Lead, Well-Architected, AWS

## Table of Contents

1. [Identify (or create) S3 bucket in account 2](#create_bucket_1)
1. [Create role for Lambda in account 1](#create_role_1)
1. [Create bucket policy for the S3 bucket in account 2](#create_bucket_policy)
1. [Create Lambda in account 1](#create_lambda_1)
1. [Tear Down](#tear_down)

This lab is best runusing two AWS accounts

* Identify the AWS account number for account 1 (no dashes)
* Identify the AWS account number for account 2 (no dashes)

If you only have one AWS account, then use the same AWS account number for both **account1** and **account2**

## 1. Identify (or create) S3 bucket in account 2 <a name="create_bucket_1"></a>

1. In account 2 sign in to the S3 Management Console as an IAM user or role in your AWS account, and open the S3 console at <https://console.aws.amazon.com/s3>
1. Choose an S3 bucket that contains some objects. You will enable the ability to list the objects in this bucket from the other account.
   * If you would rather create a new bucket to use, [follow these directions](Documentation/CreateNewS3Bucket.md)
   * Record the **bucketname**

## 2. Create role for Lambda in account 1 <a name="create_role_1"></a>

1. In account 1 sign in to the AWS Management Console as an IAM user or role in your AWS account, and open the IAM console at <https://console.aws.amazon.com/iam/>
1. Click Roles on the left, then create role
1. AWS service will be pre-selected, select **Lambda**, then click **Next: Permissions**
1. Do not select any managed policies, click **Next: Tags**
1. Click **Next: Review**
1. Enter _Lambda-List-S3-Role_ for the Role name then click Create role
1. From the list of roles click the name of **Lambda-List-S3-Role**
1. Click **Add inline policy**, then click **JSON** tab
1. Replace the sample json with the following
    * Replace **account1** with the AWS Account number (no dashes) of account 1
    * Replace **bucketname** with the S3 bucket name from account 2
    * Then click **Review Policy**

          {
              "Version": "2012-10-17",
              "Statement": [
                  {
                      "Sid": "S3ListBucket",
                      "Effect": "Allow",
                      "Action": [
                          "s3:ListBucket"
                      ],
                      "Resource": "arn:aws:s3:::bucketname"
                  },
                  {
                      "Sid": "logsstreamevent",
                      "Effect": "Allow",
                      "Action": [
                          "logs:CreateLogStream",
                          "logs:PutLogEvents"
                      ],
                      "Resource": "arn:aws:logs:us-east-1:account1:log-group:/aws/lambda/Lambda-List-S3*/*"
                  },
                  {
                      "Sid": "logsgroup",
                      "Effect": "Allow",
                      "Action": "logs:CreateLogGroup",
                      "Resource": "*"
                  }
              ]
          }

1. Name this policy _Lambda-List-S3-Policy_, then click Create policy

## 3. Create bucket policy for the S3 bucket in account 2 <a name="create_bucket_policy"></a>

1. In account 2 sign in to the S3 Management Console as an IAM user or role in your AWS account, and open the S3 console at <https://console.aws.amazon.com/s3>
1. Click on the name of the bucket you will use for this workshop
1. Go to the **Permissions tab**
1. Click **Bucket Policy**
1. Enter the following JSON policy
     1. Replace **account1** with the AWS Account number (no dashes) of account 1
     1. Replace **bucketname** with the S3 bucket name from account 2
     1. Note: This policy uses least privilege. Only resources using the IAM role from account 1 will have access

            {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Sid": "Stmt1565731301209",
                        "Action": [
                            "s3:ListBucket"
                        ],
                        "Effect": "Allow",
                        "Resource": "arn:aws:s3:::bucketname",
                        "Principal": {
                            "AWS":"arn:aws:iam::account1:role/Lambda-List-S3-Role"
                        },
                        "Condition": {
                            "StringLike": {
                                "aws:UserAgent": "*AWS_Lambda_python*"
                            }
                        }
                    }
                ]
            }

1. Click **Save**

## 4. Create Lambda in account 1 <a name="create_lambda_1"></a>

1. Open the Lambda console <https://console.aws.amazon.com/lambda>
1. Click **Create a function**
1. Accept the default **Author from scratch**
1. Enter function name as _Lambda-List-S3_
1. Select **Python 3.7 **runtime
1. Expand Permissions, click **Use an existing role**, then select the **Lambda-List-S3-Role**
1. Click **Create function**
1. Replace the example function code with the following
    * Replace **bucketname** with the S3 bucket name from account 2

          import json
          import boto3
          import os
          import uuid
          
          def lambda_handler(event, context):
              try:
                  
                  # Create an S3 client
                  s3 = boto3.client('s3')
          
                  # Call S3 to list current buckets
                  objlist = s3.list_objects(
                                  Bucket='bucketname',
                                  MaxKeys = 10) 
                  
                  print (objlist['Contents'])
                  return str(objlist['Contents'])
          
          
              except Exception as e:
                  print(e)
                  raise e

1. Click **Save**.
1. Click **Test**, accept the default event template, enter an event name for the test, then click **Create**
1. Click **Test** again, and in a few seconds the function output should highlight green and you can expand the detail to see the response from the S3 API

***

## 5. Tear down this lab <a name="tear_down"></a>

* Remove the lambda function, then roles
* If you created a new S3 bucket, then you may remove it

***

## References & useful resources

* <https://docs.aws.amazon.com/AmazonS3/latest/dev/using-iam-policies.html>
* <https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_identity-vs-resource.html>

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
