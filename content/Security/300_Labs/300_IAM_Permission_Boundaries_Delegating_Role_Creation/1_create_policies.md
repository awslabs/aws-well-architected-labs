---
title: "Create IAM policies"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### 1.1 Create policy for permission boundary

This policy will be used for the permission boundary when the developer role creates their own user role with their delegated permissions. In this lab using AWS IAM we are only going to allow the us-east-1 (North Virginia) and us-west-1 (North California) regions, optionally you can change these to your favourite regions and add / remove as many as you need. The only service actions we are going to allow in these regions are AWS EC2 and AWS Lambda, note that these services require additional supporting actions if you were to re-use this policy after this lab, depending on your requirements.

1. Sign in to the AWS Management Console as an IAM user with MFA enabled that can assume roles in your AWS account, and open the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
If you need to enable MFA follow the [IAM User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html). You will need to log out and back in again with MFA so your session has MFA active.
2. In the navigation pane, click **Policies** and then click **Create policy**.

![Images/iam-role-policy-1.png](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-policy-create-1.png)

3. On the Create policy page click the **JSON** tab.

![Images/iam-role-policy-2.png](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-policy-create-2.png)

4. Replace the example start of the policy that is already in the editor with the policy below.
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "EC2RestrictRegion",
            "Effect": "Allow",
            "Action": "ec2:*",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": [
                        "us-east-1",
                        "us-west-1"
                    ]
                }
            }
        },
        {
            "Sid": "LambdaRestrictRegion",
            "Effect": "Allow",
            "Action": "lambda:*",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": [
                        "us-east-1",
                        "us-west-1"
                    ]
                }
            }
        }
    ]
}
```
5. Click **Review policy**.
6. Enter the name of *restrict-region-boundary* and any description to help you identify the policy, verify the summary and then click **Create policy**.

![Images/iam-role-policy-3.png](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-policy-create-3.png)

### 1.2 Create developer IAM restricted policy

This policy will be attached to the developer role, and will allow the developer to create policies and roles with a name prefix of *app1*, and only if the permission boundary *restrict-region-boundary* is attached. You will need to change the account id placeholders of *123456789012* to your account number in 5 places. You can find your account id by navigating to [https://console.aws.amazon.com/billing/home?#/account](https://console.aws.amazon.com/billing/home?#/account) in the console. Naming prefixes are useful when you have different teams or in this case different applications running in the same AWS account. They can be used to keep your resources looking tidy, and also in IAM policy as the resource as we are doing here.

1. Create a managed policy using the JSON policy below and name of *createrole-restrict-region-boundary*.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CreatePolicy",
            "Effect": "Allow",
            "Action": [
                "iam:CreatePolicy",
                "iam:CreatePolicyVersion",
                "iam:DeletePolicyVersion"
            ],
            "Resource": "arn:aws:iam::123456789012:policy/app1*"
        },
        {
            "Sid": "CreateRole",
            "Effect": "Allow",
            "Action": [
                "iam:CreateRole"
            ],
            "Resource": "arn:aws:iam::123456789012:role/app1*",
            "Condition": {
                "StringEquals": {
                    "iam:PermissionsBoundary": "arn:aws:iam::123456789012:policy/restrict-region-boundary"
                }
            }
        },
        {
            "Sid": "AttachDetachRolePolicy",
            "Effect": "Allow",
            "Action": [
                "iam:DetachRolePolicy",
                "iam:AttachRolePolicy"
            ],
            "Resource": "arn:aws:iam::123456789012:role/app1*",
            "Condition": {
                "ArnEquals": {
                    "iam:PolicyARN": [
                        "arn:aws:iam::123456789012:policy/*",
                        "arn:aws:iam::aws:policy/*"
                    ]
                }
            }
        }      
    ]
}
```

### 1.3 Create developer IAM console access policy

This policy allows list and read type IAM service actions so you can see what you have created using the console. Note that it is not a requirement if you simply wanted to create the role and policy, or if you were using the Command Line Interface (CLI) or CloudFormation.

1. Create a managed policy using the JSON policy below and name of *iam-restricted-list-read*.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Get",
            "Effect": "Allow",
            "Action": [
                "iam:ListPolicies",
                "iam:GetRole",
                "iam:GetPolicyVersion",
                "iam:ListRoleTags",
                "iam:GetPolicy",
                "iam:ListPolicyVersions",
                "iam:ListAttachedRolePolicies",
                "iam:ListRoles",
                "iam:ListRolePolicies",
                "iam:GetRolePolicy"
            ],
            "Resource": "*"
        }
    ]
}
```
