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
![Images/AWSCUR1.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCUR1.png)

2. Select **Cost & Usage Reports** from the left menu:
![Images/AWSCUR2.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCUR2.png)

3. Click on **Create report**:
![Images/AWSCUR3.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCUR3.png)

4. Enter a **Report name** (it can be any name), ensure you have selected **Include resource IDs** and **Data refresh settings**, then click on **Next**:
![Images/AWSCUR4.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCUR4.png)

5. Click on **Configure**:
![Images/AWSCURDelivery0.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCURDelivery0.png)

6. Enter a unique bucket name, and ensure the region is correct, click **Next**:
![Images/AWSCURDelivery1.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCURDelivery1.png)

7. Read and verify the policy, this will allow AWS to deliver billing reports to the bucket. Click on **I have confirmed that this policy is correct**, then click **Save**:
![Images/AWSCURDelivery3.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCURDelivery3.png)

8. Verify the settings:
- Ensure your bucket is a **Valid Bucket** (if not, verify the bucket policy)
- Enter a **Report path prefix** (it can be any word) without any '/' characters
- Ensure the **Time Granularity** is **Hourly**
- **Report Versioning** is set to **Overwrite existing report**
- Under **Enable report data integration for** select **Amazon Athena**, and click **Next**:
![Images/AWSCURDelivery4.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCURDelivery4.png)

9. Review the configuration, scroll to the bottom and click on **Review and Complete**:
![Images/AWSCUR6.png](/Cost/100_1_AWS_Account_Setup/Images/AWSCUR6.png)

You have successfully configured a Cost and Usage Report to be delivered.  It may take up to 24hrs for the first report to be delivered.

{{% notice note %}}
There will be S3 Costs incurred to store the CUR, however the CUR is compressed to minimize costs.
{{% /notice %}}


### Configure the CUR Bucket
We will update the CUR bucket so that the Cost Optimization linked account can access the CURs.

1. Go to the S3 console, select the **CUR Bucket**, select **Permissions**:
![Images/s3cur_permissions.png](/Cost/100_1_AWS_Account_Setup/Images/s3cur_permissions.png)

2. Select **Bucket Policy**:
![Images/s3cur_bucketpolicy.png](/Cost/100_1_AWS_Account_Setup/Images/s3cur_bucketpolicy.png)

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


{{%expand "Click here for a completed example policy" %}}
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

{{% /expand%}}


4. Allow bucket owner object ownership for the CUR files. Cick on **Object Ownership**
![Images/S3_ObjectOwnership.png](/Cost/100_1_AWS_Account_Setup/Images/S3_ObjectOwnership.png)

5. Click **Edit**
![Images/S3_ObjectOwnership1.png](/Cost/100_1_AWS_Account_Setup/Images/S3_ObjectOwnership1.png)

6. Select **Bucket owner preferred**, click **Save**
![Images/S3_ObjectOwnership2.png](/Cost/100_1_AWS_Account_Setup/Images/S3_ObjectOwnership2.png)

When CUR files are delivered they will now automatically have permissions allowing the bucket owner full control. Re-write of the object ACLs is no longer necessary.


### Update existing CURs
If there are existing CURs from other reports that need permissions to be updated, you can use the following CLI - which will copy the objects over themselves and update the permissions as it copies. You can use this [link](https://docs.aws.amazon.com/AmazonS3/latest/userguide/finding-canonical-user-id.html) to find you canonical ID's.

    aws s3 cp --recursive s3://(CUR bucket) s3://(CUR bucket) --grants read=id=(sub account canonical ID) full=id=(management account canonical ID) --storage-class STANDARD


{{% notice tip %}}
Congratulations - you will now have CURs delivered and accessible by your Cost Optimization account.
{{% /notice %}}

{{< prev_next_button link_prev_url="../2_account_structure/" link_next_url="../4_configure_sso/" />}}

