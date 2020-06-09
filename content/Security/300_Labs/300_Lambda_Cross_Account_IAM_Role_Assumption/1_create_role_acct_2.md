---
title: "Create role for Lambda in account 2"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
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
