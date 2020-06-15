---
title: "Setup Amazon QuickSight"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

This will setup Amazon QuickSight, so that users in the Cost Optimization Account can create analysis' and dashboards.

###  Setup QuickSight for the first time

1. Log into the console in the **Cost Optimization account** as an IAM user with the required permissions, go to the **Amazon QuickSight** console:
![Images/AWSQuicksight1.png](/Cost/100_1_AWS_Account_Setup/Images/AWSQuicksight1.png)

2. If you havent used QuickSight before click on **Sign up for QuickSight**, otherwise skip this step and proceed to **Setup QuickSight IAM Policy** below:
![Images/AWSQuicksight2.png](/Cost/100_1_AWS_Account_Setup/Images/AWSQuicksight2.png)

3. Select the **Standard** edition, and click **Continue**:
![Images/AWSQuicksight3.png](/Cost/100_1_AWS_Account_Setup/Images/AWSQuicksight3.png)

4. Select the **region** which should be the same as your CUR file source, Enter your **QuickSight account name**, **Notification email address**, select **Amazon Athena** and click **Choose S3 buckets**:
![Images/AWSQuicksight4.png](/Cost/100_1_AWS_Account_Setup/Images/AWSQuicksight4.png)

5. Select **S3 Buckets You Can Access Across AWS**, under **Use a different bucket** enter the **CUR bucket name**, click **Add S3 bucket** and click **Finish**:
![Images/AWSQuicksights3.png](/Cost/100_1_AWS_Account_Setup/Images/AWSQuicksights3.png)

6. Click **Finish**:
![Images/AWSQuicksight80.png](/Cost/100_1_AWS_Account_Setup/Images/AWSQuicksight80.png)

### Setup QuickSight IAM Policy

1. Go to the **IAM Dashboard**

2. Click **Policies** and search for the **AWSQuickSightS3Policy**, click on the **AWSQuickSightS3Policy** policy:
![Images/IAMPolicy_editQS.png](/Cost/100_1_AWS_Account_Setup/Images/IAMPolicy_editQS.png)

3. Click **Edit policy**, 
![Images/IAMPolicy_editpolicy.png](/Cost/100_1_AWS_Account_Setup/Images/IAMPolicy_editpolicy.png)

4. We will add the s3 resource **arn:aws:s3:::cost\*** below the existing s3 bucket. This will allow QuickSight to access any S3 bucket starting with **cost**, so Cost Optimization users can easily create new datasets without requiring additional QuickSight privileges. Click **Review policy**:
![Images/IAMPolicy_editreview.png](/Cost/100_1_AWS_Account_Setup/Images/IAMPolicy_editreview.png)

5. Click **Save changes**:
![Images/IAMPolicy_save.png](/Cost/100_1_AWS_Account_Setup/Images/IAMPolicy_save.png)

{{% notice tip %}}
Congratulations - QuickSight is now setup for your users. The Cost Optimization team can self manage QuickSight, and access to data sets in S3 with the correct bucket name.
{{% /notice %}}
