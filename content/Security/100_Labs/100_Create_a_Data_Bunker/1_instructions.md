---
title: "Creating data bunker account in console"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### 1. (Highly recommended) Create a logging account from the organizations master account

Best practice is to have a separate logging account for your data bunker. This account should only be accessible by folks in your security group with a read only role. How you create this account will depend on your organization's policies, the instructions below are guidance on how to do this. If you do not currently have a landing zone setup see the quest [Quick Steps to Security Success](../quest_100_Quick_Steps_to_Security_Success/README.md) for a more in-depth discussion.

1. Login to the master account of your AWS Organization
2. If you do not have an account within your organization to store security logs. Navigate to AWS Organizations and select **Create Account**. Include a cross account access role and note it's name (default is OrganizationAccountAccessRole) - we will modify this later to remove unnecessary access
3. (Optional) If your role does not have permission to assume any role you will also have to add an IAM policy. The AWS administrator policy has this by default, otherwise follow the steps in the [AWS Organizations Documentation](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html#orgs_manage_accounts_access-cross-account-role) to grant permissions to access the role
4. Consider applying best practices as a baseline such as [lock away your AWS account root user access keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#lock-away-credentials) and [using multi-factor authentication](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html)
5. Navigate to **Settings** and take a note of your Organization ID

### 2. Create the bucket for CloudTrail logs

1. Switch roles into the logging account for your organization 
1. Navigate to S3
1. Press **Create Bucket**
1. Enter a *name* for your bucket, make note of it and click **Next**
1. Under configuration options *enable versioning* and *enable object lock*. This will prevent our logs from being deleted. Press **Next**
1. Do not modify any permissions - press **Next**
1. Press **Create Bucket**
1. Press the bucket we just create and navigate to the **Properties** tab
1. (Strongly recommended unless tearing down immediately) Under **Object Lock**, *enable compliance mode* and set a *retention period*. The length of the retention period will depend on your organizational requirements. If you are enabling this just for baseline security start with 31 days to keep one month of logs. **Note:** You will be unable to delete files within this window or the bucket if objects still exist in it
1. Under the **Permissions** tab, replace the Bucket Policy with the following, replacing [bucket] and [organization id]. Press **Save**

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::[bucket]"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::[bucket]/AWSLogs/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::[bucket]/AWSLogs/[organization id]/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
```

11. (Optional) Next we will add a life cycle policy to clean up old logs. Navigate to **Management**
1. (Optional) Add a life cycle rule named *Delete old logs*, press **Next**
1. (Optional) Add a transition rule for both the current and previous versions to move to Glacier after 32 days. Press **Next**
1. (Optional) Select the current and previous versions and set them to delete after *365* days

### 3. (Highly recommended) Ensure cross account access is read-only

These instructions outline how to modify the cross account access created in step 1 is read-only. As with step 1, this will depend on how your organization's policies. The key is that our security team are not able to modify data in our data bunker. Human access should only be in a break-glass emergency situation.

**Note:** Following these steps will prevent *OrganizationAccountAccessRole* from making further changes to this account. Ensure other services such as Amazon Guard Duty and AWS Security Hub are configured before proceeding. If further changes are needed you will have to reset the root credentials for the security account.

1. Navigate to **IAM** and select **Roles**
2. Select the organizations account access role for your organization: Note: the default is *OrganizationAccountAccessRole*
3. Press **Attach Policy** and attach the AWS managed *ReadOnlyAccess* Policy
4. Navigate back to the *OrganizationAccountAccessRole* and press the **X** to remove the *AdministratorAccess* policy

### 4. Turn on CloudTrail from the root account

1. Switch back to the root account
1. Navigate to **CloudTrail**
1. Select **Trails** from the menu on the left
1. Press **Create Trail**
1. Enter a name for the trail such as *OrganizationTrail*
1. Select *Yes* next to *Apply trail to my organization*
1. Under *Storage location*, select *No* for *Create new S3 bucket* and enter the *bucket name* of the bucket created in step 2

### Verification

1. Switch back to the Security account
2. Navigate to the S3 bucket previously created
3. (Optional) You can start to [explore the logs using CloudTrail](https://docs.aws.amazon.com/athena/latest/ug/cloudtrail-logs.html)

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2019-2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

[https://aws.amazon.com/apache2.0/](https://aws.amazon.com/apache2.0/)

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
