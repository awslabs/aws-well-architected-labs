---
title: "Enable Single Sign On (SSO)"
date: 2020-08-16T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---



You will create an AWS Organization, and join two or more accounts to the master account. An organization will allow you to centrally manage multiple AWS accounts efficiently and consistently. It is recommended to have a master account that is  used for security and administration, with access provided for limited billing tasks. A dedicated member account will be created for the Cost Optimization team or function, and another (or multiple) member account/s created to contain workload resources.

You will need organizations:CreateOrganization access, and 2 or more AWS accounts. When you join a member account to a master account, it will contain all billing information for that member account. Member accounts will no longer have any billing information, including historical billing information.  Ensure you backup or export any reports or data before joining accounts to a master account.

### Configure SSO
You will create an AWS Organization with the master account.

1. Login to the AWS console as an IAM user with the required permissions, start typing **SSO** into the **Find Services** box and click on **AWS Single Sign-On**:
![Images/home_sso.png](/Cost/100_1_AWS_Account_Setup/Images/home_sso.png)

2. Click **Enable AWS SSO**:
![Images/sso_enable.png](/Cost/100_1_AWS_Account_Setup/Images/sso_enable.png)

3. Select **Groups**:
![Images/ssodashboard_groups.png](/Cost/100_1_AWS_Account_Setup/Images/ssodashboard_groups.png)

4. Click **Create group**:
![Images/ssogroups_create.png](/Cost/100_1_AWS_Account_Setup/Images/ssogroups_create.png)

5. Enter a Group name of **Cost_Optimization** and a description, click **Create**:
![Images/ssogroup_details.png](/Cost/100_1_AWS_Account_Setup/Images/ssogroup_details.png)

6. Click **Users**:
![Images/ssodashboard_users.png](/Cost/100_1_AWS_Account_Setup/Images/ssodashboard_users.png)

7. Click **Add user**:
![Images/ssouser_adduser.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_adduser.png)

8. Enter the following details:
 - **Username**
 - **Password**
 - **Email address**
 - **First name** 
 - **Last name** 
 - **Display name**
 - Configure the optional fields as required
click **Next: Groups**: 
![Images/ssouser_detail.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_detail.png)

9. Select the **Cost_Optimization** group and click **Add user**:
![Images/ssouser_group.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_group.png)

10. The user will receive an email, with a link to **Accept invitation**, the **Portal URL** and their **Username**:
![Images/ssouser_email.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_email.png)

11. When the user goes to the portal, they will enter in a **Password** and click **Update user**:
![Images/ssouser_login.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_login.png)

12. The user will then Click **Continue**:
![Images/ssouser_activate.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_activate.png)

{{% notice note %}}
Users will not have permissions until you complete the rest of this step.
{{% /notice %}}

13. Click on **AWS accounts**, select **Permission sets**, and click **Create permission set**:
![Images/ssoaccount_createpermission.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_createpermission.png)

14. Select **Create a custom permission set**, enter a name of **Master_CostOptimization**, enter a **Description**, set the **Session duration**, select **Create a custom permissions policy**. Use the policy below as a starting point, modify it to your requirements and paste it in the policy field,  click **Create**.

{{% notice warning %}}
You **MUST** work with your security team/specialist to ensure you create the policies inline with least privileges for your organization.
{{% /notice %}}

{{%expand "Click here for Custom permissions policy" %}}
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "budgets:*",
                    "ce:*",
                    "aws-portal:*Usage",
                    "aws-portal:*PaymentMethods",
                    "aws-portal:*Billing",
                    "cur:DescribeReportDefinitions",
                    "cur:PutReportDefinition",
                    "cur:DeleteReportDefinition",
                    "cur:ModifyReportDefinition",
                    "pricing:DescribeServices",
                    "wellarchitected:*",
                    "savingsplans:*"
                ],
                "Resource": "*"
            }
        ]
    }
{{% /expand%}}

![Images/ssopermissionset_create.png](/Cost/100_1_AWS_Account_Setup/Images/ssopermissionset_create.png)

15. Click **Create permission set**

16. Select **Create a custom permission set**, enter a name of **Member_CostOptimization**, enter a **Description**, set the **Session duration**, select **Create a custom permissions policy**. Use the policy below as a starting point, modify it to your requirements, replace **(Master CUR bucket)** and **(Cost Optimization Member Account ID)** and paste it in the policy field,  click **Create**.

{{% notice warning %}}
You **MUST** work with your security team/specialist to ensure you create the policies inline with least privileges for your organization.
{{% /notice %}}

{{%expand "Click here for Custom permissions policy" %}}
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "CostServices",
                "Effect": "Allow",
                "Action": [
                    "ce:*",
                    "budgets:*",
                    "aws-portal:*Usage",
                    "aws-portal:*PaymentMethods",
                    "aws-portal:*Billing",
                    "pricing:DescribeServices",
                    "wellarchitected:*",
                    "savingsplans:*"
                ],
                "Resource": "*"
            },
            {
                "Sid": "S3MasterCUR",
                "Effect": "Allow",
                "Action": [
                    "s3:GetObject",
                    "s3:ListBucket"
                ],
                "Resource": [
                    "arn:aws:s3:::(Master CUR bucket)"
                ]
            },
        {
            "Sid": "AthenaGlueAndServiceReadAccess",
            "Effect": "Allow",
            "Action": [
                "athena:*",
                "glue:*",
                "iam:ListRoles",
                "iam:ListPolicies",
                "s3:GetBucketLocation",
                "s3:ListAllMyBuckets"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "QuickSightAccess",
            "Effect": "Allow",
            "Action": [
                "quicksight:CreateUser",
                "quicksight:Subscribe"
            ],
            "Resource": "*"
        },
        {
            "Sid": "IAMAccessForGlue",
            "Effect": "Allow",
            "Action": "iam:*",
            "Resource": [
                "arn:aws:iam::(Cost Optimization Member Account ID):role/service-role/AWSGlueServiceRole-Cost*",
                "arn:aws:iam::(Cost Optimization Member Account ID):policy/service-role/AWSGlueServiceRole-Cost*"
            ]
        },
        {
            "Sid": "S3AccessForAthena",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:ListMultipartUploadParts",
                "s3:AbortMultipartUpload",
                "s3:CreateBucket",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::aws-athena-query-results-*"
            ]
        },
        {
            "Sid": "FullS3AccessForBucketsWithSpecificPrefix",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::cost*"
            ]
        }
    ]
    }
{{% /expand%}}

![Images/ssopermissionset_create.png](/Cost/100_1_AWS_Account_Setup/Images/ssopermissionset_create.png)

17. Click **AWS organization**, select the **Master account**, click **Assign users**:
![Images/ssoaccount_organizationusers.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_organizationusers.png)

18. Select **Groups**, select the **Cost_Optimization** group, click **Next: Permission sets**:
![Images/ssoaccount_groups.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_groups.png)

19. Select the **Master_CostOptimization** Permission set, click **Finish**:
![Images/ssoaccount_grouppermission.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_grouppermission.png)

20. Click **Proceed to AWS accounts**:
![Images/ssoaccount_success.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_success.png)

21. setup the Cost Optimization member account, select the **Memeber account**, click **Assign users**

22. Select **Groups**, select the **Cost_Optimization** group, click **Next: Permission sets**:
![Images/ssoaccount_groups.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_groups.png)

23. Select the **Member_CostOptimization** Permission set, click **Finish**

24. Click **Proceed to AWS accounts**


{{% notice tip %}}
You have now setup your Cost Optimization users, group and their permissions.
{{% /notice %}}







