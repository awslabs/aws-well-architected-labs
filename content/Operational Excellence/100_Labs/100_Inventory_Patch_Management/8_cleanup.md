---
title: "Removing Lab Resources"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>8. </b>"
weight: 8
---

> **Note**<br> When the lab is complete, remove the resources you created. Otherwise you will be charged for any resources that are not covered in the AWS Free Tier.

### 7.1 Remove resources created with CloudFormation
1. Navigate to the **CloudFormation** dashboard at <https://console.aws.amazon.com/cloudformation/>:
   1. Select your first stack.
   1. Choose **Actions** and choose **delete stack**.
   1. Select your second stack.
   1. Choose **Actions** and choose **delete stack**   .
1. Navigate to Systems Manager console at <https://console.aws.amazon.com/systems-manager/>:
   1. Choose **State Manager**.
   1. Select the association you created.
   1. Choose **Delete**.
1. If you created an **S3 bucket** to store detailed output, delete the bucket and associated data:
   1. Navigate to the S3 console <https://s3.console.aws.amazon.com/s3/>.
   1. Select the bucket.
   1. Choose **Delete** and provide the bucket name to confirm deletion.
1. If you created the optional **SNS Topic**, delete the SNS topic:
   1. Navigate to the SNS console <https://console.aws.amazon.com/sns/>.
   1. Select your **AdminAlert** SNS topic from the list.
   1. Choose **Actions** and select **Delete topics**.
1. If you created a **Maintenance Window**, delete the Maintenance Window:
   1. Navigate to the **Systems Manager console** at <https://console.aws.amazon.com/systems-manager/>.
   1. Choose **Maintenance Windows**.
   1. Select the maintenance window you created.
   1. Choose **Delete**.
   1. In the **Delete maintenance window** window, choose **Delete**.
1. If you do not intend to continue to use the Administrator account you created, delete the account:
   1. Navigate to the IAM console at <https://console.aws.amazon.com/iam/>.
   1. Choose **Users**.
   1. Select your user from the list.
   1. Choose **Delete user**.
   1. Select the check box next to "One or more of these users have recently accessed AWS. Deleting them could affect running systems. Check the box to confirm that you want to delete these users.".
   1. Choose **Yes, delete**.
   1. When next you navigate within the console you will be returned to the account login page.
1. If you **do** intend to continue to use the Administrator account you created, we strongly suggest you [**enable MFA**](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable.html).

Thank you for using this lab.
