---
title: "Create bucket policy for the S3 bucket in account 2"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

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
