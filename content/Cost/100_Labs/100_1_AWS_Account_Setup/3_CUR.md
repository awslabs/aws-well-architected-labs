---
title: "Configure Cost and Usage reports"
date: 2020-10-26T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

Cost and Usage Reports provide the most detailed information on your usage and bills. They can be configured to deliver 1 line per resource, for every hour of the day. They must be configured to enable you to access and analyze your usage and billing information.


###  Configure a Cost and Usage Report
If you configure multiple Cost and Usage Reports (CURs), then it is recommended to have 1 CUR per bucket. If you **must** have multiple CURs in a single bucket, ensure you use a different **report path prefix** so it is clear they are different reports.

1. Log in to your management account as an IAM user with the required permissions, and go to the **Billing** console:
![Images/AWSCUR1.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCUR1.png?classes=lab_picture_small)

2. Select **Cost & Usage Reports** from the left menu:
![Images/AWSCUR2.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCUR2.png?classes=lab_picture_small)

3. Click on **Create report**:
![Images/AWSCUR3.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCUR3.png?classes=lab_picture_small)

4. Enter a **Report name** (it can be any name, but we recommend including the management account id in the name), ensure you have selected **Include resource IDs** and **Data refresh settings**, then click on **Next**:
![Images/AWSCUR4.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCUR4.png?classes=lab_picture_small)

5. Click on **Configure**:
![Images/AWSCURDelivery0.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCURDelivery0.png?classes=lab_picture_small)

6. Enter a unique bucket name, and ensure the region is correct, click **Next**:
![Images/AWSCURDelivery1.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCURDelivery1.png?classes=lab_picture_small)

7. Read and verify the policy, this will allow AWS to deliver billing reports to the bucket. Click on **I have confirmed that this policy is correct**, then click **Save**:
![Images/AWSCURDelivery3.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCURDelivery3.png?classes=lab_picture_small)

8. Verify the settings:
- Ensure your bucket is a **Valid Bucket** (if not, verify the bucket policy)
- Enter a **Report path prefix** (it can be any word, but we recommend cur-<Your Management Account ID) without any '/' characters
- Ensure the **Time Granularity** is **Hourly**
- **Report Versioning** is set to **Overwrite existing report**
- Under **Enable report data integration for** select **Amazon Athena**, and click **Next**:
![Images/AWSCURDelivery4.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCURDelivery4.png?classes=lab_picture_small)

9. Review the configuration, scroll to the bottom and click on **Review and Complete**:
![Images/AWSCUR6.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCUR6.png?classes=lab_picture_small)

You have successfully configured a Cost and Usage Report to be delivered.  It may take up to 24hrs for the first report to be delivered.

{{% notice note %}}
There will be S3 Costs incurred to store the CUR, however the CUR is compressed to minimize costs.
{{% /notice %}}

### Configure the CUR Bucket for your Cost Optimization Account
We will update the CUR bucket so that the Cost Optimization linked account can access the CURs. There are two options. Option 1 allows the Cost Optimization linked account to access the CURs, but does not copy the CUR files to the account. Option 2 uses S3 Replication to create a copy of the CUR in an S3 Bucket in your Cost Optimization Account. If you are unsure what option to use we recommend option 1.

### Option 1: Configure Cost Optimization Access to the CUR Bucket
Option 1 allows the Cost Optimization linked account to access the CURs, but does not copy the CUR files to the account. If you are unsure what option to use we recommend option 1.

{{%expand "Click here to continue with the option 1" %}}

1. Go to the S3 console, select the **CUR Bucket**, select **Permissions**:
![Images/s3cur_permissions.png](/Cost/100_1_AWS_Account_Setup/Images/s3cur_permissions.png?classes=lab_picture_small)

2. Scroll down to the **Bucket Policy** section and select **Edit**
![Images/s3cur_bucketpolicy.png](/Cost/100_1_AWS_Account_Setup/Images/s3cur_bucketpolicy.png?classes=lab_picture_small)

3. Add S3 read access to the Cost Optimization account by adding the following statements under the current bucket policy. Edit **(Cost Optimization Member account ID)** and **(CUR bucket)** and update the bucket policy:

        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::(Cost Optimization Member account ID):root"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::(CUR bucket)"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::(Cost Optimization Member account ID):root"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::(CUR bucket)/*"
        }


- Click here for a completed example policy

		{
			"Version": "2008-10-17",
			"Id": "123",
			"Statement": [
				{
					"Sid": "Stmt1335892150622",
					"Effect": "Allow",
					"Principal": {
						"AWS": "arn:aws:iam::386209384616:root"
					},
					"Action": [
						"s3:GetBucketAcl",
						"s3:GetBucketPolicy"
					],
					"Resource": "arn:aws:s3:::(CUR Bucket)"
				},
				{
					"Sid": "Stmt1335892526596",
					"Effect": "Allow",
					"Principal": {
						"AWS": "arn:aws:iam::386209384616:root"
					},
					"Action": "s3:PutObject",
					"Resource": "arn:aws:s3:::(CUR Bucket)/*"
				},
				{
					"Effect": "Allow",
					"Principal": {
						"AWS": "arn:aws:iam::(Cost Optimization Member Account ID):root"
					},
					"Action": "s3:ListBucket",
					"Resource": "arn:aws:s3:::(CUR Bucket)"
				},
				{
					"Effect": "Allow",
					"Principal": {
						"AWS": "arn:aws:iam::(Cost Optimization Member Account ID):root"
					},
					"Action": "s3:GetObject",
					"Resource": "arn:aws:s3:::(CUR Bucket)/*"
				}
			]
		}



4.  Scroll down to the ***Object Ownership*** section and select **Edit**
![Images/S3_ObjectOwnership1.png](/Cost/100_1_AWS_Account_Setup/Images/S3_ObjectOwnership1.png?classes=lab_picture_small)

5. Select **Bucket owner preferred**, click **Save**
![Images/S3_ObjectOwnership2.png](/Cost/100_1_AWS_Account_Setup/Images/S3_ObjectOwnership2.png?classes=lab_picture_small)

When CUR files are delivered they will now automatically have permissions allowing the bucket owner full control. Re-write of the object ACLs is no longer necessary.


### Update existing CURs
If there are existing CURs from other reports that need permissions to be updated, you can use the following CLI - which will copy the objects over themselves and update the permissions as it copies. You can use this [link](https://docs.aws.amazon.com/AmazonS3/latest/userguide/finding-canonical-user-id.html) to find you canonical ID's.

    aws s3 cp --recursive s3://(CUR bucket) s3://(CUR bucket) --grants read=id=(sub account canonical ID) full=id=(management account canonical ID) --storage-class STANDARD


**NOTE:** Congratulations - you will now have CURs delivered and accessible by your Cost Optimization account.
    ------------ | -------------

{{% /expand%}}

### Option 2: Replicate the CUR Bucket to your Cost Optimization account (Consolidate Multi-Payer CURs) 
Option 2 uses S3 Replication to create a copy of the CUR in an S3 Bucket in your Cost Optimization Account. If you have multiple Management Accounts (multi-Payer) or wish you create a single CUR source for groupings of your member account CUR(s) we recommend this option.

{{%expand "Click here to continue with the option 2" %}}

### Create your Cost Optimization account CUR Bucket
We will now create a bucket in your Cost Optimization account that will hold the replicated CUR(s)

1. Log into you Cost Optimization Account and navigate to Amazon S3
1. Select **Create bucket**
![Images/S3_bucket.png](/Cost/100_1_AWS_Account_Setup/Images/s3_createbucket.png?classes=lab_picture_small)
1. Add an S3 **Bucket name** select your **preferred region** and **Enable** Bucket versioning
![Create S3 bucket](/Cost/100_1_AWS_Account_Setup/Images/S3_enable_versioning.png?classes=lab_picture_small)
1. Select your **new S3 Bucket**, select **Permissions**:
![Images/s3cur_permissions2.png](/Cost/100_1_AWS_Account_Setup/Images/s3cur_permissions2.png?classes=lab_picture_small)

1. Scroll down to the **Bucket Policy** section and select **Edit**
![Images/s3cur_bucketpolicy2.png](/Cost/100_1_AWS_Account_Setup/Images/s3cur_bucketpolicy2.png?classes=lab_picture_small)
1. Edit, apply and save the following S3 bucket policy replacing respective placeholders **(ManagementAccountA)**, **(ManagementAccountB)** and **(Cost Optimization Account CUR BucketName)**. You can add more management accounts to the policy if needed. If using only one Management account you will remove **,"(ManagementAccountB)"**

		{
		"Version": "2008-10-17",
		"Id": "PolicyForCombinedBucket",
		"Statement": [
			{
				"Sid": "Set permissions for objects",
				"Effect": "Allow",
				"Principal": {
					"AWS": ["(ManagementAccountA)","(ManagementAccountB)"]
				},
				"Action": [
					"s3:ReplicateObject",
					"s3:ReplicateDelete"
				],
				"Resource": "arn:aws:s3:::(Cost Optimization Account CUR BucketName)/*"
			},
			{
				"Sid": "Set permissions on bucket",
				"Effect": "Allow",
				"Principal": {
					"AWS": ["(ManagementAccountA)","(ManagementAccountB)"]
				},
				"Action": [
					"s3:List*",
					"s3:GetBucketVersioning",
					"s3:PutBucketVersioning"
				],
				"Resource": "arn:aws:s3:::(Cost Optimization Account CUR BucketName)"
			},
			{
				"Sid": "Set permissions to pass object ownership",
				"Effect": "Allow",
				"Principal": {
					"AWS": ["(ManagementAccountA)","(ManagementAccountB)"]
				},
				"Action": [
					"s3:ReplicateObject",
					"s3:ReplicateDelete",
					"s3:ObjectOwnerOverrideToBucketOwner",
					"s3:ReplicateTags",
					"s3:GetObjectVersionTagging",
					"s3:PutObject"
				],
				"Resource": "arn:aws:s3:::(Cost Optimization Account CUR BucketName)/*"
			}
		]
		}

**NOTE:** This policy supports objects encrypted with either SSE-S3 or not encrypted objects. For SSE-KMS encrypted objects additional policy statements and replication configuration will be needed: see https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-config-for-kms-objects.html
    ------------ | -------------

### Configure Bucket Replication for your Cost Optimization account CUR Bucket
1. Log into your Management Account and navigate to Amazon S3
1. Select the **CUR Bucket**, then select **Properties**:
![Images/s3cur_properties.png](/Cost/100_1_AWS_Account_Setup/Images/s3cur_properties.png?classes=lab_picture_small)
1. Scroll down to the Bucket Versioning section click **Edit** 
![Images/s3cur_versioning1.png](/Cost/100_1_AWS_Account_Setup/Images/s3cur_versioning1.png?classes=lab_picture_small)
1. Set Bucket versioning to **Enabled**
![Images/s3cur_versioning2.png](/Cost/100_1_AWS_Account_Setup/Images/s3cur_versioning2.png?classes=lab_picture_small)
1. Select the **Management** tab, then click on **Create replication rule** under **Replication rules**/
![Images/s3cur_replication.png](/Cost/100_1_AWS_Account_Setup/Images/s3cur_replication.png?classes=lab_picture_small)
1. Create your replication rule by updating the **following fields** then click **Save**
	- Add a **Replication rule name** of **CUR-Bucket-Replication**
	- Select **Specify a bucket in another account** under Destination
	- Add your Cost Optimization Account ID
	- Add your Cost Optimization S3 CUR Bucket name
	- Select **Change object ownership to destination bucket owner**
	- Select **Create new role** under the IAM role section
	- Leave rest of the settings as default
![Images/s3cur_replication1.png](/Cost/100_1_AWS_Account_Setup/Images/s3cur_replication1.png?classes=lab_picture_small)


**NOTE:** If you have a multi-Management (multi-Payer) structure or are using multiple member CURs, repeat the replication process in **each** Management or member CUR account
    ------------ | -------------


### Update existing CURs - Optional
If you would like to sync historical objects in your CUR S3 bucket to your Cost Optimization account S3 bucket, you can use the following CLI:

	aws s3 sync s3://<Management_Account_CUR_Bucket_Name> s3://<Cost_Optimization_Account_CUR_Bucket_Name> --acl bucket-owner-full-control

**NOTE:** Congratulations - you will now have CURs delivered and accessible by your Cost Optimization account.
    ------------ | -------------

[Visit the Well-Architected Level 200: Cost and Usage Analysis lab to learn how to analyze your CUR in Athena and create a single Athena CUR table for multi-Management (multi-Payer) or multiple member CURs]({{< ref "/Cost/200_Labs/200_4_cost_and_usage_analysis" >}})

{{% /expand%}}

{{< prev_next_button link_prev_url="../2_account_structure/" link_next_url="../4_configure_sso/" />}}

