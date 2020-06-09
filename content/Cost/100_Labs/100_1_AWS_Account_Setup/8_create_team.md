---
title: "Create a cost optimization team"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>8. </b>"
weight: 8
---

We are going to create a cost optimization team in a dedicated member account. Within your organization there needs to be a team of people that are performing Cloud Financial Management. This exercise will create the users and the group, then assign access to services they will typically need. This team will then be able to manage the organizations cost and usage, and start to implement optimization mechanisms.

We will create two policies, one policy will allow access to cost optimization services in the master account, the other will provice access to perform cost optimization activities in the member account.

{{% notice warning %}}
You **MUST** work with your security team/specialist to ensure you create the policies inline with least privileges for your organization.
{{% /notice %}}

### Master Account Policy
1. Log into the console as an IAM user with the required permissions

2. Log in and go to the **IAM** Service page:
![Images/AWSIAM1.png](/Cost/100_1_AWS_Account_Setup/Images/AWSIAM1.png)

3. Click on **Policies**:
![Images/IAM_Policies.png](/Cost/100_1_AWS_Account_Setup/Images/IAM_Policies.png)

4. Click **Create policy**:
![Images/IAMPolicy_Create.png](/Cost/100_1_AWS_Account_Setup/Images/IAMPolicy_Create.png)

5. Click **JSON**, edit the following policy - replacing **(master account ID)** with the account ID of your master account, click **Review policy**:

        {
            "Version": "2012-10-17",
            "Statement": {
                "Effect": "Allow",
                "Action": "sts:AssumeRole",
                "Resource": "arn:aws:iam::(Master AccountID):role/CostOptimization*"
            }
        }

![Images/IAMPolicy_Review.png](/Cost/100_1_AWS_Account_Setup/Images/IAMPolicy_Review.png)

{{%expand "Alternatively you can add a condition if you only want some of your team to access the master account, use the following policy" %}}
        {
            "Version": "2012-10-17",
            "Statement": [
            {
                "Effect": "Allow",
                "Action": "sts:AssumeRole",
                "Resource": "arn:aws:iam::(Master AccountID):role/CostOptimization",
                "Condition": {
                    "ArnEquals": {
                        "aws:PrincipalArn": "arn:aws:iam::(Member AccountID):user/(username)"
                    }
                }
            }
        ]
    }
{{% /expand%}}

6. Enter a policy name of **Master_CostOptimization** and a description of **Access Cost Optimization services in the master account**, click **Create policy**:
![Images/IAMPolicy_finish.png](/Cost/100_1_AWS_Account_Setup/Images/IAMPolicy_finish.png)


### Cost Optimization Policies
We will now create a policy for the team to access services in the member account to perform Cost Optimization. The team will have full access to billing management serivces, access to add and remove users from the Cost Optimization group, and read access to the CUR file in the master account. This will be suitable for the 100 level labs.

1. Click  **Create Policy**:
![Images/AWSIAM3.png](/Cost/100_1_AWS_Account_Setup/Images/AWSIAM3.png)

2. Select the **JSON** tab:
![Images/AWSIAM4.png](/Cost/100_1_AWS_Account_Setup/Images/AWSIAM4.png)

3. **Edit** the policy below, replacing **(Master CUR bucket)** and **(This Account ID)** with what you previously configured. Then Copy & paste the following policy into the field, click **Review policy**:

{{% notice warning %}}
You MUST work with your security team/specialist to ensure you create the policies inline with least privileges for your organization.
{{% /notice %}}

{{%expand "IAM Policy" %}}
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
                        "wellarchitected:*"
                    ],
                    "Resource": "*"
                },
                {
                    "Sid": "GroupAdmin",
                    "Effect": "Allow",
                    "Action": [
                        "iam:ListGroups",
                        "iam:ListUsers"
                    ],
                    "Resource": "*"
                },
                {
                    "Sid": "GroupAdmin2",
                    "Effect": "Allow",
                    "Action": [
                        "iam:AddUserToGroup",
                        "iam:RemoveUserFromGroup",
                        "iam:GetGroup"
                    ],
                    "Resource": "arn:aws:iam::(This Account ID):group/CostOptimization"
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
                }
            ]
        }
{{% /expand%}}
![Images/IAMPolicy_pastereview.png](/Cost/100_1_AWS_Account_Setup/Images/IAMPolicy_pastereview.png)

4. Enter a **Name** of **CostOptimization**, add a **Description** of **Cost Optimization services**, click **Create policy**:
![Images/IAMPolicy_namereview.png](/Cost/100_1_AWS_Account_Setup/Images/IAMPolicy_namereview.png)

5. We will create another policy to allow advanced Cost Optimization, this allows the team to administer Athena, Glue, QuickSight within this account, and full access to S3 buckets with a specific name (starting with **cost**). This will be suitable for the 200 level labs. Use the process above to create the policy **Advanced_CostOptimization**, use the following policy below and replace **(bucket prefix)**:

{{% notice warning %}}
You MUST work with your security team/specialist to ensure you create the policies inline with least privileges for your organization.
{{% /notice %}}


{{%expand "IAM Policy" %}}
	{
	    "Version": "2012-10-17",
	    "Statement": [
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
	                "arn:aws:iam::(This Account ID):role/service-role/AWSGlueServiceRole-Cost*",
	                "arn:aws:iam::(This Account ID):policy/service-role/AWSGlueServiceRole-Cost*"
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

You have successfully created the cost optimization teams policies.

### Create the Cost Optimization Group

This group will be used for all people performing Cost Optimization duties.

1. While in the IAM console, select **Groups** from the left menu:
![Images/AWSIAM7.png](/Cost/100_1_AWS_Account_Setup/Images/AWSIAM7.png)

2. Click on **Create New Group**:
![Images/AWSIAM8.png](/Cost/100_1_AWS_Account_Setup/Images/AWSIAM8.png)

3. Enter a **Group Name** of **Cost Optimization** and click **Next Step**:
![Images/AWSIAM9.png](/Cost/100_1_AWS_Account_Setup/Images/AWSIAM9.png)

4. Click **Policy Type** and select **Customer Managed**:
![Images/AWSIAM10.png](/Cost/100_1_AWS_Account_Setup/Images/AWSIAM10.png)

5. Enter **CostOpt** in the search field, select the **CostOptimization**, **Master_CostOptimization**, and **Advanced_CostOptimization** policies (created previously), click **Next Step**:
![Images/iamgroup_policynextstep.png](/Cost/100_1_AWS_Account_Setup/Images/iamgroup_policynextstep.png)

6. Review the details and click **Create Group**:
![Images/iamgroup_reviewcreate.png](/Cost/100_1_AWS_Account_Setup/Images/iamgroup_reviewcreate.png)

You have now successfully created the cost optimization group, and attached the required policies.


### Create an IAM User
We will create a user and join them to the group above.

1. In the IAM console, select **Users** from the left menu:
![Images/AWSIAM15.png](/Cost/100_1_AWS_Account_Setup/Images/AWSIAM15.png)

2. Click **Add user**:
![Images/AWSIAM16.png](/Cost/100_1_AWS_Account_Setup/Images/AWSIAM16.png)

3. Enter a **User name**, select **AWS Management Console access**, choose **Custom Password**, type a suitable password, deselect **Require password reset**, and click **Next: Permissions**:
![Images/AWSIAM17.png](/Cost/100_1_AWS_Account_Setup/Images/AWSIAM17.png)

4. Select the **CostOptimization** group (created previously), and click **Next: Tags**:
![Images/AWSIAM18.png](/Cost/100_1_AWS_Account_Setup/Images/AWSIAM18.png)

5. Click **Next Review**:
![Images/AWSIAM19.png](/Cost/100_1_AWS_Account_Setup/Images/AWSIAM19.png)

6. Click **Create user**:
![Images/AWSIAM20.png](/Cost/100_1_AWS_Account_Setup/Images/AWSIAM20.png)


You have successfully created a user, placed them in the cost optimization group and have applied policies.
You can continue to expand this group by adding additional users from your organization.
