---
title: "Configure Cost and Usage reports"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

Cost and Usage Reports provide the most detailed information on your usage and bills. They can be configured to deliver 1 line per resource, for every hour of the day. They must be configured to enable you to access and analyze your usage and billing information.


###  Configure a Cost and Usage Report
If you configure multiple Cost and Usage Reports (CURs), then it is recommended to have 1 CUR per bucket. If you **must** have multiple CURs in a single bucket, ensure you use a different **report path prefix** so it is clear they are different reports.

1. Log in to your Master account as an IAM user with the required permissions, and go to the **Billing** console:
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

3. Add S3 read access to the Cost Optimization account by adding the following statements under the current bucket policy. Edit **(sub account ID)** and **(CUR bucket)** and update the bucket policy:

        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::(sub account ID):root"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::(CUR bucket)"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::(sub account ID):root"
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
                    "AWS": "arn:aws:iam::(Sub Account ID):root"
                },
                "Action": "s3:ListBucket",
                "Resource": "arn:aws:s3:::(CUR Bucket)"
            },
            {
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::(Sub Account ID):root"
                },
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::(CUR Bucket)/*"
            }
        ]
    }

{{% /expand%}}





### Configure re-write of the S3 object ACLs
We will setup a Lambda function to re-write the ACLs on newly delivered CUR files. This is required to allow sub accounts to read the CUR files, as they are delivered with bucket owner (master account) access only.

1. Go to the IAM Dashboard

2. Click on **Policies**, click **Create policy**:
![Images/IAMPolicy_Createpolicy.png](/Cost/100_1_AWS_Account_Setup/Images/IAMPolicy_Createpolicy.png)

3. Click on **JSON**, edit the following policy - replacing **(bucket name)** with your CUR bucket, Click **Review policy**:

       {
           "Version": "2012-10-17",
           "Statement": [
               {
                   "Effect": "Allow",
                   "Action": [
                       "s3:PutObjectVersionAcl",
                       "s3:PutObjectAcl"
                   ],
                   "Resource": "arn:aws:s3:::(bucket name)/*"
               }
           ]
       }

![Images/splitsharecur1.png](/Cost/100_1_AWS_Account_Setup/Images/splitsharecur1.png)

4. Enter a name of **Lambda_S3Linked_PutACL**, enter a **Description** and click **Create policy**:
![Images/IAM_PolicyCreate.png](/Cost/100_1_AWS_Account_Setup/Images/IAM_PolicyCreate.png)

5. Click **Roles**, click **Create role**:
![Images/IAMRole_Create.png](/Cost/100_1_AWS_Account_Setup/Images/IAMRole_Create.png)

6. Click **Lambda** as the use case, click **Next: Permissions**:
![Images/IAM_LambdaPermissions.png](/Cost/100_1_AWS_Account_Setup/Images/IAM_LambdaPermissions.png)

7. Search for the **Lambda_S3Linked_PutACL** policy, select it and click **Next: Tags**:
![Images/IAM_PolicyTags.png](/Cost/100_1_AWS_Account_Setup/Images/IAM_PolicyTags.png)

8. Click **Next: Review**

9. Enter a Role name of **Lambda_Put_Linked_S3ACL**, a description and click **Create role**:
![Images/IAM_RoleCreate.png](/Cost/100_1_AWS_Account_Setup/Images/IAM_RoleCreate.png)

10. Go to the Lambda Service dashboard, click **Create function**:
![Images/Lambda_home.png](/Cost/100_1_AWS_Account_Setup/Images/Lambda_home.png)

11. Select **Author from scratch**, enter a function name of **S3LinkedPutACL**, a runtime of **Node.js 12.x**, Execution role **Use an existing role** and select the **Lambda_Put_Linked_S3ACL** role, click **Create function**:
![Images/Lambda_functionscratch.png](/Cost/100_1_AWS_Account_Setup/Images/Lambda_functionscratch.png)

12. Paste in the following Lambda code, replace the following strings with the values of your accounts:
 
 - **Master Account Name**: The owner account name - the account email without the @companyname, they will get FULL_CONTROL permissions
 - **Master Canonical ID**: The owner canonical ID, to get the Canonical ID, refer to: https://docs.aws.amazon.com/general/latest/gr/acct-identifiers.html
 - **Linked Account Name**: The cost optimization account name - the account email without the @companyname, they will get READ permissions 
 - **Linked Account Canonical ID**: The cost optimization account canonical ID


{{%expand "Click here for the Lambda Code" %}}

    const AWS = require('aws-sdk');
    const util = require('util');

    // Main Loop
    exports.handler = function(event, context, callback) {
    
        // If its an object delete, do nothing
        if (event.RequestType === 'Delete') {
        }
        else // Its an object put
        {
            // Get the source bucket from the S3 event
            var srcBucket = event.Records[0].s3.bucket.name;
        
            // Object key may have spaces or unicode non-ASCII characters, decode it
            var srcKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, " "));  

            // Gets the top level folder, which is the key for the permissions array        
            var folderID = srcKey.split("/")[0];

            // Define the object permissions, using the permissions array
            var params =
            {
                Bucket: srcBucket,
                Key: srcKey,
                AccessControlPolicy:
                {
                    'Owner':
                    {
                        'DisplayName': 'aws-billpresentation+artifact-storage',
                        'ID': '72b999b38bdff6b040374efc3086ba5a0a87c0c07e1eda14fe56fadb2b4a6ef0'
                    },
                    'Grants': 
                    [
                        {
                            'Grantee': 
                            {
                                'Type': 'CanonicalUser',
                                'DisplayName': '(master account name)',
                                'ID': '(master canonical id)'
                            },
                            'Permission': 'FULL_CONTROL'
                        },
                        {
                            'Grantee': {
                                'Type': 'CanonicalUser',
                                'DisplayName': '(linked account name)',
                                'ID': '(linked canonical id)'
                                },
                            'Permission': 'READ'
                        },
                    ]
                }
            };

            // get reference to S3 client 
            var s3 = new AWS.S3();

            // Put the ACL on the object
            s3.putObjectAcl(params, function(err, data) {
                if (err) console.log(err, err.stack); // an error occurred
                else     console.log(data);           // successful response
            });
        }
    };

{{% /expand%}}

13. Click **Save**:
![Images/Lambda_functionsave.png](/Cost/100_1_AWS_Account_Setup/Images/Lambda_functionsave.png)

14. Go to the **S3 service dashboard**, select your **CUR** bucket, click **Properties**:
![Images/s3cur_bucketproperties.png](/Cost/100_1_AWS_Account_Setup/Images/s3cur_bucketproperties.png)

15. Select **Events**, click **Add notification**:
![Images/s3cur_event.png](/Cost/100_1_AWS_Account_Setup/Images/s3cur_event.png)

16. Enter a name of **S3PutACL**, select **All object create events**, Send to **Lambda Function**, Lambda function **S3LinkedPutACL**, click **Save**:
![Images/s3_event.png](/Cost/100_1_AWS_Account_Setup/Images/s3_event.png)

17. You will need to wait until the next CUR file is delivered by AWS (at most 24 hours). Navigate to the latest CUR file and check the permissions, it will have the original owner (AWS), your master account with full permissions (as per original), and your linked Cost Optimization account as read permissions:
![Images/s3_newCUR.png](/Cost/100_1_AWS_Account_Setup/Images/s3_newCUR.png)


### Update existing CURs
If there are existing CURs from other reports that need permissions to be updated, you can use the following CLI - which will copy the objects over themselves and update the permissions as it copies.

    aws s3 cp --recursive s3://(CUR bucket) s3://(CUR bucket) --grants read=id=(sub account canonical ID) full=id=(master account canonical ID) --storage-class STANDARD


{{% notice tip %}}
Congratulations - you will now have CURs delivered and accessible by your Cost Optimization account.
{{% /notice %}}
