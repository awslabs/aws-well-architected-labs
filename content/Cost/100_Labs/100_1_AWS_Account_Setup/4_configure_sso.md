---
title: "Enable Single Sign On (SSO)"
date: 2020-08-16T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---



You will create an AWS Organization, and join two or more accounts to the management account. An organization will allow you to centrally manage multiple AWS accounts efficiently and consistently. It is recommended to have a management account that is  used for security and administration, with access provided for limited billing tasks. A dedicated member account will be created for the Cost Optimization team or function, and another (or multiple) member account/s created to contain workload resources.

You will need organizations:CreateOrganization access, and 2 or more AWS accounts. When you join a member account to a management account, it will contain all billing information for that member account. Member accounts will no longer have any billing information, including historical billing information.  Ensure you backup or export any reports or data before joining accounts to a management account.

### Configure SSO
You will create an AWS Organization with the management account.

1. Login to the AWS console as an IAM user with the required permissions, start typing **SSO** into the **Find Services** box and click on **AWS Single Sign-On**:
![Images/home_sso.png](/Cost/100_1_AWS_Account_Setup/Images/home_sso.png)

2. Click **Enable AWS SSO**:
![Images/sso_enable.png](/Cost/100_1_AWS_Account_Setup/Images/sso_enable.png)

3. Select **Groups**:
![Images/ssodashboard_groups.png](/Cost/100_1_AWS_Account_Setup/Images/ssodashboard_groups.png)

4. Click **Create group**:
![Images/ssogroups_create.png](/Cost/100_1_AWS_Account_Setup/Images/ssogroups_create.png)

5. Enter a Group name of **Cost_Optimization** and a description, click **Create group**:
![Images/ssogroup_details.png](/Cost/100_1_AWS_Account_Setup/Images/ssogroup_details.png)

6. Click **Users**:
![Images/ssodashboard_users.png](/Cost/100_1_AWS_Account_Setup/Images/ssodashboard_users.png)

7. Click **Add user**:
![Images/ssouser_adduser.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_adduser.png)

8. Enter the following details:
 - **Username**
 - **Password** - 
 - **Email address**
 - **First name** 
 - **Last name** 
 - **Display name**
 - Configure the optional fields as required
click **Next**: 
![Images/ssouser_detail.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_detail.png)

9. Select the **Cost_Optimization** group and click **Next**:
![Images/ssouser_group.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_group.png)

10. Review user details and click **Add User**
![Images/ssouser_addusersubmit.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_addusersubmit.png)

11. The user will receive an email, with a link to **Accept invitation**, the **Portal URL** and their **Username**:
![Images/ssouser_email.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_email.png)

12. When the user goes to the portal, they will enter in a **Password** and click **Set new password**:
![Images/ssouser_login.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_login.png)

13. Enter the new SSO Username and Password click **Sign In**:
![Images/ssouser_activate.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_activate.png)

{{% notice note %}}
Users will not have permissions until you complete the rest of this step.
A management and member permission set will be created
{{% /notice %}}

14. Create the management permission set. Click on **Permission sets**, and click **Create permission set**:
![Images/ssoaccount_createpermission.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_createpermission.png)

15. Select **Custom permission set** and click **Next**:
![Images/ssouser_permission.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_permission.png)

16. Select **Inline Policy**. Use the policy below as a starting point, modify it to your requirements and paste it in the policy field,  click **Next**.

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
![Images/ssouser_inlinepolicy.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_inlinepolicy.png)

17. Enter a Permission set name of **management_CostOptimization**, enter a **Description**, set the **Session duration**, click **Next**. 
![Images/ssouser_permissionsetdetails.png](/Cost/100_1_AWS_Account_Setup/Images/permissionsetdetails.png)

18. Review and **Create** the custom permissions policy. 
![Images/ssopermissionset_create.png](/Cost/100_1_AWS_Account_Setup/Images/ssopermissionset_create.png)

19. Create the member permission set. Click on **Permission sets**, and click **Create permission set**:
![Images/ssoaccount_createpermission.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_createpermission.png)

20. Select **Custom permission set** and click **Next**:
![Images/ssouser_permission.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_permission.png)

21. Select **Inline Policy**. Use the policy below as a starting point, replace **(management CUR bucket)** and **(Cost Optimization Member Account ID)** click **Next**.

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
                "Sid": "S3ManagementCUR",
                "Effect": "Allow",
                "Action": [
                    "s3:GetObject",
                    "s3:ListBucket"
                ],
                "Resource": [
                    "arn:aws:s3:::(management CUR bucket)"
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
![Images/ssouser_inlinepolicy.png](/Cost/100_1_AWS_Account_Setup/Images/ssouser_inlinepolicy.png)

22. Enter a Permission set name of **member_CostOptimization**, enter a **Description**, set the **Session duration**, click **Next**. 
![Images/ssouser_memberpermissionsetdetails.png](/Cost/100_1_AWS_Account_Setup/Images/memberpermissionsetdetails.png)

23. Review and **Create** the custom permissions policy. 
![Images/ssopermissionset_create.png](/Cost/100_1_AWS_Account_Setup/Images/ssopermissionset_create.png)

24. Setup the Cost Optimization management account. Click **AWS accounts**, select the **management account**, click **Assign users or groups**:
![Images/ssoaccount_organizationusers.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_organizationusers.png)

25. Select **Groups**, select the **Cost_Optimization** group, click **Next**:
![Images/ssoaccount_groups.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_groups.png)

26. Select the **management_CostOptimization** Permission set, click **Next**:
![Images/ssoaccount_grouppermission.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_grouppermission.png)

27. Review and **Submit**:
![Images/ssoaccount_permissionsubmit.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_permissionsubmit.png)

28. Verify account was updated with permission set:
![Images/ssoaccount_success.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_success.png)

29. Setup the Cost Optimization member account. Click **AWS accounts**, select the **member account**, click **Assign users or groups**:
![Images/ssoaccount_memberorganizationusers.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_memberorganizationusers.png)

30. Select **Groups**, select the **Cost_Optimization** group, click **Next**:
![Images/ssoaccount_groups.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_groups.png)

31. Select the **member_CostOptimization** Permission set, click **Next**:
![Images/ssoaccount_membergroups.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_membergroups.png)

32. Review and **Submit**:
![Images/ssoaccount_memberpermissionsubmit.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_memberpermissionsubmit.png)

33. Verify account was updated with permission set:
![Images/ssoaccount_success.png](/Cost/100_1_AWS_Account_Setup/Images/ssoaccount_success.png)


{{% notice tip %}}
You have now setup your Cost Optimization users, group and their permissions.
{{% /notice %}}

{{< prev_next_button link_prev_url="../3_cur/" link_next_url="../5_account_settings/" />}}
