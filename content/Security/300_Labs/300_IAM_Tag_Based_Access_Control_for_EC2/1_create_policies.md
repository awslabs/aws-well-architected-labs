---
title: "Create IAM policies"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

The policies are split into five different functions for demonstration purposes, you may like to modify and combine them to use after this lab to your exact requirements. In addition to enforcing tags, a region restriction only allow regions us-east-1 (North Virginia) and us-west-1 (North California).

### 1.1 Create policy named *ec2-list-read*

This policy allows read only permissions with a region condition. The only service actions we are going to allow are EC2, note that you typically require additional supporting actions such as Elastic Load Balancing if you were to re-use this policy after this lab, depending on your requirements.

1. Sign in to the AWS Management Console as an IAM user with MFA enabled that can assume roles in your AWS account, and open the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
If you need to enable MFA follow the [IAM User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html). You will need to log out and back in again with MFA so your session has MFA active.
2. In the navigation pane, click **Policies** and then click **Create policy**.

![Images/iam-role-policy-1.png](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/iam-policy-create-1.png)

3. On the Create policy page click the **JSON** tab.

![Images/iam-role-policy-2.png](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/iam-policy-create-2.png)

4. Replace the example start of the policy that is already in the editor with the policy below.
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ec2listread",
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:Get*"
            ],
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
6. Enter the name of *ec2-list-read* and any description to help you identify the policy, verify the summary and then click **Create policy**.

![Images/iam-role-policy-3.png](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/iam-policy-create-3.png)

### 1.2 Create policy named *ec2-create-tags*

This policy allows the creation of tags for EC2, with a condition of the action being [RunInstances](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_RunInstances.html), which is launching an instance.

1. Create a managed policy using the JSON policy below and name of *ec2-create-tags*.
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ec2createtags",
            "Effect": "Allow",
            "Action": "ec2:CreateTags",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ec2:CreateAction": "RunInstances"
                }
            }
        }
    ]
}
```

### 1.3 Create policy named *ec2-create-tags-existing*

This policy allows creation (and overwriting) of EC2 tags only if the resources are already tagged **Team / Alpha**.

1. Create a managed policy using the JSON policy below and name of *ec2-create-tags-existing*.
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ec2createtagsexisting",
            "Effect": "Allow",
            "Action": "ec2:CreateTags",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ec2:ResourceTag/Team": "Alpha"
                },
                "ForAllValues:StringEquals": {
                    "aws:TagKeys": [
                        "Team",
                        "Name"
                    ]
                },
                "StringEqualsIfExists": {
                    "aws:RequestTag/Team": "Alpha"
                }
            }
        }
    ]
}
```

### 1.4 Create policy named *ec2-run-instances*

This first section of this policy allows instances to be launched, only if the conditions of region and specific tag keys are matched. The second section allows other resources to be created at instance launch time with region condition.

1. Create a managed policy using the JSON policy below and name of *ec2-run-instances*.
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ec2runinstances",
            "Effect": "Allow",
            "Action": "ec2:RunInstances",
            "Resource": "arn:aws:ec2:*:*:instance/*",
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": [
                        "us-east-1",
                        "us-west-1"
                    ],
                    "aws:RequestTag/Team": "Alpha"
                },
                "ForAllValues:StringEquals": {
                    "aws:TagKeys": [
                        "Name",
                        "Team"
                    ]
                }
            }
        },
        {
            "Sid": "ec2runinstancesother",
            "Effect": "Allow",
            "Action": "ec2:RunInstances",
            "Resource": [
                "arn:aws:ec2:*:*:subnet/*",
                "arn:aws:ec2:*:*:key-pair/*",
                "arn:aws:ec2:*::snapshot/*",
                "arn:aws:ec2:*:*:launch-template/*",
                "arn:aws:ec2:*:*:volume/*",
                "arn:aws:ec2:*:*:security-group/*",
                "arn:aws:ec2:*:*:placement-group/*",
                "arn:aws:ec2:*:*:network-interface/*",
                "arn:aws:ec2:*::image/*"
            ],
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

### 1.5 Create policy named *ec2-manage-instances*

This policy allows reboot, terminate, start and stop of instances, with a condition of the key **Team** is **Alpha** and region.

1. Create a managed policy using the JSON policy below and name of *ec2-manage-instances*.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ec2manageinstances",
            "Effect": "Allow",
            "Action": [
                "ec2:RebootInstances",
                "ec2:TerminateInstances",
                "ec2:StartInstances",
                "ec2:StopInstances"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ec2:ResourceTag/Team": "Alpha",
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
