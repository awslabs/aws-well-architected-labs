---
title: "Create role for Lambda in account 1"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---
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
