---
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 999
hidden: FASLSE
---

Users will require the following access to complete this lab. Edit the policy below before implementation, replace **(Account ID)** with the required account ID from the account they will work in. Ensure you remove this policy after the lab is completed.

{{% notice warning %}}
This Policy is only required to complete this lab. It must be removed from the users and delted once the lab is complete.
{{% /notice %}}

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "iam:ListPolicies",
                    "iam:GetPolicyVersion",
                    "iam:CreateGroup",
                    "iam:GetPolicy",
                    "iam:DeletePolicy",
                    "iam:DetachGroupPolicy",
                    "iam:ListGroupPolicies",
                    "iam:AttachUserPolicy",
                    "iam:CreateUser",
                    "iam:GetGroup",
                    "iam:CreatePolicy",
                    "iam:CreateLoginProfile",
                    "iam:AddUserToGroup",
                    "iam:ListPolicyVersions",
                    "iam:AttachGroupPolicy",
                    "iam:ListUsers",
                    "iam:ListAttachedGroupPolicies",
                    "iam:ListGroups",
                    "iam:GetGroupPolicy",
                    "iam:CreatePolicyVersion",
                    "iam:DeletePolicyVersion",
                    "iam:GetLoginProfile",
                    "iam:GetAccountPasswordPolicy",
                    "iam:DeleteLoginProfile"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": "iam:*",
                "Resource": "arn:aws:iam::(Account ID):user/TestUser1"
            },
            {
                "Effect": "Allow",
                "Action": "iam:*",
                "Resource": "arn:aws:iam::(Account ID):group/costtest"
            },
            {
                "Effect": "Allow",
                "Action": "iam:*",
                "Resource": [
                    "arn:aws:iam::(Account ID):policy/RegionRestrict",
                    "arn:aws:iam::(Account ID):policy/EC2EBS_Restrict",
                    "arn:aws:iam::(Account ID):policy/EC2_FamilyRestrict"
                ]
            },
            {
                "Effect": "Allow",
                "Action": "ec2:DeleteSecurityGroup",
                "Resource": "arn:aws:ec2:*:*:security-group/*"
            },
            {
                "Effect": "Allow",
                "Action": "ec2:DeleteVolume",
                "Resource": "arn:aws:ec2:*:*:volume/*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "ec2:ModifyVolume",
                    "ec2:ModifyVolumeAttribute",
                    "ec2:DescribeVolumeStatus",
                    "ec2:DescribeVolumes",
                    "ec2:DescribeVolumesModifications",
                    "ec2:DescribeVolumeAttribute",
                    "ec2:DescribeAvailabilityZones"
                ],
                "Resource": "*"
            }
        ]
    }


