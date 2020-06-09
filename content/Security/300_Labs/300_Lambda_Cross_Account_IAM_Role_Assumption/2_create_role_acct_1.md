---
title: "Create role for Lambda in account 1"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---
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
