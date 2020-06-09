---
title: "Create an IAM policy and role for Lambda function"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

This step is used to create an IAM policy and a role that allows Lambda function to perform Athena CUR query and deliver processed CUR report via SES.

1.  Log into **IAM console**, click on **Policies** and click on **Create Policy**:
![Images/iam_policy01.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/iam_policy01.png)

2. Click on the **JSON** tab, **modify** the following policy, replacing the **your-cur-query-results-bucket** string.  Make sure you add "*" at the end of the bucket name so the whole bucket is writable:


        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Sid": "VisualEditor0",
                    "Effect": "Allow",
                    "Action": [
                        "s3:PutObject"
                    ],
                    "Resource": [
                        "arn:aws:s3:::your-cur-query-results-bucket*"
                    ]
                },
                {
                    "Sid": "VisualEditor1",
                    "Effect": "Allow",
                    "Action": [
                        "athena:List*",
                        "athena:*QueryExecution",
                        "athena:Get*",
                        "athena:BatchGet*",
                        "glue:Get*",
                        "glue:BatchGet*",
                        "s3:Get*",
                        "s3:List*",
                        "SES:SendRawEmail",
                        "SES:SendEmail",
                        "logs:CreateLogStream",
                        "logs:CreateLogGroup",
                        "logs:PutLogEvents"
                    ],
                    "Resource": "*"
                }
            ]
        }


3. Copy the policy to JSON edit frame, ensure the **bucket name** has been changed, click **Review policy**:
![Images/iam_json_edit.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/iam_json_edit.png)

4. Configure the name **Lambda_Auto_CUR_Delivery_Access**, and click **Create policy**.
![Images/policy_name.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/policy_name.png)

5. Click on **Roles**, click **Create Role**:
![Images/create_role01.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/create_role01.png)

6. Choose **Lambda** as the service that will use this role, click **Next Permissions**:
![Images/create_role.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/create_role.png)

7. At **Attach permissions policies** page, search and choose **Lambda_Auto_CUR_Delivery_Access** policy created in the previous step. Click **Next:Tags**, click **Next:Review**.
![Images/attach_policy.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/attach_policy.png)

8. At **Review** page, configure a name **Lambda_Auto_CUR_Delivery_Role**, click **Create role**. This role will be used for lambda function execution.
![Images/lambda_role_name.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/lambda_role_name.png) 
