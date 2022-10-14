---
title: "Prerequisites: Cost And Usage Report Setup"
date: 2022-05-20T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1a. </b>"
---

## Authors
- Thomas Buatois, AWS Cloud Infrastructure Architect (ProServe)
- Yuriy Prykhodko, AWS Principal Technical Account Manager
- Iakov Gan, AWS Sr. Technical Account Manager

## Contributors
- Aaron Edell, Global Head of Business and GTM - Customer Cloud Intelligence

## Cost and Usage Report (CUR)
The [Cost & Usage Report](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html) is the foundation for multiple CID Dashboards. CID requires Cost & Usage Report to be created with the following format:
- Additional report details: Include **Resource IDs**
- Time Granularity: **Hourly**
- Report Versioning: **Overwrite existing report**
- Report data integration for: **Amazon Athena**
- Compression type: **Parquet**

If you have a Cost & Usage Report that meets this criteria you can use it, if not, you can create a new CUR and request a [backfill](https://docs.aws.amazon.com/cur/latest/userguide/troubleshooting.html#backfill-data).


## CUR Deployment
Please follow one of the options bellow.
### Option 1. Deploy CUR with CFN template (Suggested)
This option supports creation of CUR in multiple usecases:
1. Deploying CUR in a single account.
2. Deploying CUR in One account (linked or management/payer) and replication to another account where you want to install CUR-based Cloud Intelligence Dashboards. This option also allows customers with multiple management (payer) accounts to deploy all the CUR-based dashboards on top of the aggregated data from multiple payers. You will need a dedicated Linked Account setup and ready to go for this step. This option will create new Cost & Usage Reports (CUR). You will need a dedicated Linked (data collection) Account setup and ready to go.
3. Deploying CUR in multiple linked account and aggregation into one. This option is useful when you do not have access to Management (payer) account and you want to have a dashboard for multiple linked accounts belonging to one Buisiness Unit. 
{{%expand "Click here to continue with Cloud Formation Deployment" %}}

We recommend that you install the Dashboards in a dedicated AWS Account that is not your management (payer) account(s). You will still create a Cost & Usage Report (CUR) in each management (payer) account which will be delivered to an S3 bucket in that account. The CloudFormation templates below will setup S3 replication to the linked account (data collection account) where you will deploy the dashboards. This works whether you have one or many management (payer) accounts.

![Images/multi-account/Architecture1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/Architecture1.png?classes=lab_picture_verysmall)

If you have __no access to your management (payer) account__, you can still use this method. Instead of creating CURs in the management (payer) account you will be creating [member CURs]([https://aws.amazon.com/about-aws/whats-new/2020/12/cost-and-usage-report-now-available-to-member-linked-accounts/]) for each linked account and replicating them to the account (data collection account) where you will be deploying the dashboards. 

Below find the steps for creating a single dedicated S3 bucket within your linked account (data collection account) where the dashboards will be deployed that will aggregate any and all CURs from other accounts.

You will be able to add or delete more source account CURs after the fact as well. 

You will be deploying the same CloudFormation(CFN) template into two different types of places (your **source accounts** and your **destination data collection account**):

1. In the **Destination** or data collection account, the CloudFormation(CFN) template will create an S3 bucket for CUR aggregation.
2. In one or more **Source Accounts**, the CFN template will create a new CUR, an S3 bucket, and a replication rule.

If your management/source (payer) account is the same as your destination account (where you want to deploy the dashboards) and you want this CFN template to create a new CUR, follow the steps for **Destination Account** only, and choose to activate local CUR in the CFN parameter.

This CFN template will create an S3 bucket with the following structure in the **Destination Account**

```html
s3://<prefix>-<destination-accountid>-shared/
	cur/<src-account1>/cid/cid/year=XXXX/month=YY/*.parquet
	cur/<src-account2>/cid/cid/year=XXXX/month=YY/*.parquet
	cur/<src-account3>/cid/cid/year=XXXX/month=YY/*.parquet
```

The Glue crawler will create the partitions source_account_id, year, and month.


### Step1. Configure Destination Account (data collection account where you will deploy your dashboards) using CloudFormation

Here we will deploy the CFN template but setting the CFN parameters for a Destination Account.

1. Login to the Destination account in the region of your choice. I can be any account inside or outside your AWS Organization.
   
2. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**.

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-managed-cost-intelligence-dashboards.s3.amazonaws.com/cfn/cur-aggregation.yaml&stackName=CID-CUR-Destination)
	
![Images/multi-account/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cf_dash_launch_2.png?classes=lab_picture_small)

4. Enter your **Destination** Account Id. 
   
**NOTE:** Please note this Account ID, we will need it later when we will deploy this same stack in your management (payer)/source accounts.

5. Disable CUR creation by entering **False** as the parameter value if you are replicating CURs from management (payer) accounts. You will only need to activate this if you are replicating CURs from linked accounts (not management payer accounts) and you want to have cost and usage data for this Destination account as well.
   
![Images/multi-account/cfn_dash_param_dst_dedicated_3.png.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_dst_dedicated_3.png?classes=lab_picture_small)

1. Enter your **Source Account(s)** IDs, using commas to separate multiple Account IDs. 
   
![Images/multi-account/cfn_dash_param_dst_dedicated_2.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_dst_dedicated_2.png?classes=lab_picture_small)

7. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page.

8.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

10. You will see the stack will start with **CREATE_IN_PROGRESS**.
**NOTE:** This step can take 5-15mins
    ------------ | -------------

11. Once complete, the stack will show **CREATE_COMPLETE**.



### Step2. Create CUR in Source Account(s) using CloudFormation

1. Login to your Source Account (can be management account or linked account if you're using [member CURs](https://aws.amazon.com/about-aws/whats-new/2020/12/cost-and-usage-report-now-available-to-member-linked-accounts/)).

2. Click the **Launch CloudFormation button** below to open the **stack template** in your CloudFormation console and select **Next**.

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-managed-cost-intelligence-dashboards.s3.amazonaws.com/cfn/cur-aggregation.yaml&stackName=CID-CUR-Replication)
	
![Images/multi-account/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cf_dash_launch_2.png?classes=lab_picture_small)

3. Enter a **Stack name** for your template such as **CID-CUR**.
![Images/multi-account/cfn_dash_dst_param.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_dst.png?classes=lab_picture_small)

4. Enter your **Desitnation** AWS Account ID as a parameter.
   
![Images/multi-account/cfn_dash_param_dst_1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_dst_1.png?classes=lab_picture_small)

5. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page.

6.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

7. You will see the stack will start with **CREATE_IN_PROGRESS** .
**NOTE:** This step can take 5-15mins
    ------------ | -------------

8.  Once complete, the stack will show **CREATE_COMPLETE**.

**NOTE:** It takes 24 hours for your first CUR to be delivered
    ------------ | -------------

9. It will take about 24 hours for your CUR to populate and replicate to your destination (data collection) account where you will deploy the dashboards. Return to this step after 24 hours. 
     
### Add or delete accounts (Optional)

This section is only available if you have already deployed the CUR replication setup using the CloudFormation template above.

1. Login to the __Destination__ Account.
   
2. Find your existing template and choose __Update__

![Images/multi-account/cfn_dash_param_10.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_10.png?classes=lab_picture_small)

3. Check __Use current template__ then choose __Next__

![Images/multi-account/cfn_dash_param_11.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_11.png?classes=lab_picture_small)

4. Update the AWS Account IDs list to modify CUR aggregation (ADD or DELETE)
    
![Images/multi-account/cfn_dash_param_dst_dedicated_2.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_dst_dedicated_2.png?classes=lab_picture_small)

5. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page

6.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

7. You will see the stack will start with **UPDATE_IN_PROGRESS** 
**NOTE:** This step can take up to 5mins
    ------------ | -------------

8.  Once complete, the stack will show **UPDATE_COMPLETE**

### Teardown of CloudFormation deployment (Optional)

**NOTE:** Deleting an account means that CUR data will not flow to your destionat (data collection) account anymore. However, historical data will be retained in destination account. To delete the CURs, go to the `${resource-prefix}-${payer-account-id}-shared` S3 Bucket and manualy delete account data.
    ------------ | -------------

1. Login to the Account you want to delete.
   
2. Find your existing template and choose __Delete__

![Images/multi-account/cfn_dash_param_12.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_12.png?classes=lab_picture_small)
{{% /expand%}}


### Option 2. Deploy CUR and CIDs into a single Management (Payer) Account
This option walks you through setting up a CUR file in the Management (payer) Account and configuring the account to have the CIDs deployed there. This option will create a new Cost & Usage Report (CUR) or reuse one you already have. 
{{%expand "Click here see steps for preparing your Cost & Usage report and Athena integraton manually" %}}

This option is okay for testing but we recommend you deploy the Cloud Intelligence Dashboards in a dedicated acount other than the management (payer) account (option 1 above). This way you can effectivly managed the access and avoid having unnecessary users in your management (payer) account. If you still want to use this option, please apply [least privileges](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#grant-least-privilege/) access to your payer account.

#### Configure CUR (skip if you already have a CUR in the correct format)
1. [Sign in](https://console.aws.amazon.com/billing/home#/) to the Billing and Cost Management console.

1. On the navigation pane, choose **Cost & Usage Reports**.

1. Choose **Create report**.

1. For **Report name**, enter a name for your report. ex: **cid**

1. Under **Additional report details**, select **Include resource IDs** to include the IDs of each individual resource in the report.
**Note:** Including resource IDs will create individual line items for each of your resources and is necessary for the Cloud Intelligence Dashboards. Based on your usage patterns, this can increase the size of your Cost and Usage Reports files significantly.
    ------------ | -------------
1. For **Data refresh settings**, select whether you want the AWS Cost and Usage Reports to refresh if AWS applies refunds, credits, or support fees to your account after finalizing your bill. When a report refreshes, a new report is uploaded to Amazon S3. It is strongly recommended that you have your CUR include this data. 

2. Choose **Next**.

3. For S3 bucket, choose **Configure**.

4. In the Configure **S3 Bucket** dialog box, do one of the following:

    + Select an existing bucket from the drop down list and choose **Next**.

    + Enter a bucket name and the Region where you want to create a new bucket and choose **Next**.

5. Review the bucket policy, and select **I have confirmed that this policy is correct** and choose **Save**.
   
6. For **Report path prefix**, enter the report path prefix that you want prepended to the name of your report. In order to make you CUR compatible with multi-account scenarions, you can choose prefix as **cur/{current_account_id}** (replacing current_account_id with the right value).
**Note:** Make sure that the report path prefix doesn't include a double slash (//) as Athena doesn't support such a table location.
    ------------ | -------------

1. For **Time granularity**, choose **Hourly**.

1. For **Report versioning**, choose **Overwrite existing report**.

1. For **Enable report data integration for**, select **Amazon Athena**.

1. Now CUR will be set to **Parquet** format, this format is **mandatory** for the workshop completion.

1. Choose **Next**.

1. After you have reviewed the settings for your report, choose **Review and Complete**.

{{% notice note %}}
It can take up to 24 hours for AWS to start delivering CURs to your Amazon S3 bucket. After delivery starts, AWS updates the AWS Cost and Usage Reports files at least once a day. You can create AWS Support ticket requesting a backfill for the last 6 months of your data.
{{% /notice %}}

### Enable your Cost & Usage Reports in Athena
The dashboards use Athena as the QuickSight data source for generating your dashboards. If you do not have your Cost & Usage Report enabled in Athena please click to expand the setup guide below. 

#### Configure Athena
##### 1. Prepare Athena
If this is the first time you will be using Athena you will need to complete a few setup steps before you are able to create the views needed. If you are already a regular Athena user you can skip these steps and move on to step 2 **Prepare CUR & Athena Integration** 

To get Athena warmed up:

1. From the services list, choose **S3**

2. Create a new S3 bucket for Athena queries to be logged to (ex: `aws-athena-query-results-cid-AccountID-Region` ). Keep the same region as the S3 bucket created for your Cost & Usage Report.

3. From the services list, choose **Athena**

4. Select **Get Started** to enable Athena and start the basic configuration

5. At the top of this screen select **Before you run your first query, you need to set up a query result location in Amazon S3.**

    ![Image of Athena Query Editor](/Cost/200_Cloud_Intelligence/Images/AthenaS3.png?classes=lab_picture_small)

6. Enter the path of the bucket created for Athena queries, it is recommended that you also select the AutoComplete option **NOTE:** The trailing “/” in the folder path is required!

7. Click the hamburger icon on the left of the main Athena page and select Workgroups. 
   
8. Select your workgroup (default is primary) and from the Actions menu select 'edit'.

9. Scroll down to the `Query results configuration` box and make sure there is a location for query results selectd. If not, choose the same S3 bucket as step 6 above. Click Save changes. 


##### 2. Prepare CUR & Athena Integration
{{% notice note %}}
Before you can deploy the CIDs, you must wait for the first Cost and Usage Report to be delivered to your Amazon S3 bucket.
{{% /notice %}}

To streamline and automate integration of your Cost and Usage Reports with Athena, AWS provides an AWS CloudFormation template with several key resources along with the reports you setup for Athena integration. The AWS CloudFormation template includes an AWS Glue crawler, an AWS Glue database, and an AWS Lambda event.

1. From the services list, choose **S3**

2. Navigate to the S3 bucket where the **Cost & Usage Report** was saved

3. Select the Object named after the **prefix** defined when your Cost & Usage Report was created (Step 11 in [Prepare Cost & Usage Report](#prepare-cost--usage-report) --> Configure Cur)

4. Select the Object named after the **Cost & Usage Report**

5. Download the **crawler-cfn.yml** file

6. Navigate to the **CloudFormation** service

7. Ensure you are in the same Region as your Cost & Usage Report S3 bucket

8. Deploy the CloudFormation template by clicking **Create stack - With new resources (standard)**

9. Select **Upload a template file**

10. Click **Choose file** and locate your `crawler-cfn.yml` file

11. Click **Next**

12. Enter a Stack Name to identify this as part of your CUDOS Dashboard setup

13. Click **Next**

14. Define Stack options including tags, permissions and rollback configurations.

15. Click **Next**

16. Enable **"I acknowledge that AWS CloudFormation might create IAM resources."** and click **Create Stack**

{{% /expand%}}



### Option 3. Deploy CUR and CIDs into dedicated Linked Account manually
Use this option if you're deploying the CUR-based Cloud Intelligence Dashboards in an account other than your management (payer) account. This option also allows customers with multiple management (payer) accounts to deploy all the CUR-based dashboards on top of the aggregated data from multiple payers. You will need a dedicated Linked Account setup and ready to go for this step. This option will create new Cost & Usage Reports (CUR). This guide will walk you through setting up the management (payer) account CUR S3 buckets to have replication enabled pointing to your linked (data collection) account manually.

{{%expand "Click here to expand step by step instructions" %}}


![Images/CUDOS_multi_payer.png](/Cost/200_Cloud_Intelligence/Images/CUDOS_multi_payer.png?classes=lab_picture_small)

#### Setup CUR in each management (payer) account
1. [Sign in](https://console.aws.amazon.com/billing/home#/) to the Billing and Cost Management console.

1. On the navigation pane, choose **Cost & Usage Reports**.

1. Choose **Create report**.

1. For **Report name**, enter a name for your report. ex: **cid**

1. Under **Additional report details**, select **Include resource IDs** to include the IDs of each individual resource in the report.
**Note:** Including resource IDs will create individual line items for each of your resources and is necessary for the Cloud Intelligence Dashboards. Based on your usage patterns, this can increase the size of your Cost and Usage Reports files significantly.
    ------------ | -------------
1. For **Data refresh settings**, select whether you want the AWS Cost and Usage Reports to refresh if AWS applies refunds, credits, or support fees to your account after finalizing your bill. When a report refreshes, a new report is uploaded to Amazon S3. It is strongly recommended that you have your CUR include this data. 

2. Choose **Next**.

3. For S3 bucket, choose **Configure**.

4. In the Configure **S3 Bucket** dialog box, do one of the following:

    + Select an existing bucket from the drop down list and choose **Next**.

    + Enter a bucket name and the Region where you want to create a new bucket and choose **Next**.

5. Review the bucket policy, and select **I have confirmed that this policy is correct** and choose **Save**.
   
6. For **Report path prefix**, enter the report path prefix that you want prepended to the name of your report. In order to make you CUR compatible with multi-account scenarions, you can choose prefix as **cur/{current_account_id}** (replacing current_account_id with the right value).
**Note:** Make sure that the report path prefix doesn't include a double slash (//) as Athena doesn't support such a table location.
    ------------ | -------------

1. For **Time granularity**, choose **Hourly**.

1. For **Report versioning**, choose **Overwrite existing report**.

1. For **Enable report data integration for**, select **Amazon Athena**.

1. Now CUR will be set to **Parquet** format, this format is **mandatory** for the workshop completion.

1. Choose **Next**.

1. After you have reviewed the settings for your report, choose **Review and Complete**.

{{% notice note %}}
It can take up to 24 hours for AWS to start delivering CURs to your Amazon S3 bucket. After delivery starts, AWS updates the AWS Cost and Usage Reports files at least once a day. You can create AWS Support ticket requesting a backfill for the last 6 months of your data.
{{% /notice %}}

#### Setup S3 CUR Bucket Replication

1. Log into and go to the console of your Linked (Data Collection) account. This is where the Cloud Intelligence Dashboards will be deployed. Your management (payer) account CURs will be replicated to this account. Note the region, and make sure everything you create is in the same region. To see available regions for QuickSight, visit [this website](https://docs.aws.amazon.com/quicksight/latest/user/regions.html). 
2. Create an S3 bucket with enabled versioning.
3. Open S3 bucket and apply following S3 bucket policy replacing respective placeholders {PayerAccountA}, {PayerAccountB} (one for each payer account) and {DataCollectionAccountBucketName}. You can add more payer accounts to the policy later if needed.

```json
{
    "Version": "2008-10-17",
    "Id": "PolicyForCombinedBucket",
    "Statement": [
        {
            "Sid": "Set permissions for objects",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "{PayerAccountA}",
                    "{PayerAccountB}"
                ]
            },
            "Action": [
                "s3:ReplicateObject",
                "s3:ReplicateDelete"
            ],
            "Resource": "arn:aws:s3:::{DataCollectionAccountBucketName}/*"
        },
        {
            "Sid": "Set permissions on bucket",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "{PayerAccountA}",
                    "{PayerAccountB}"
                ]
            },
            "Action": [
                "s3:List*",
                "s3:GetBucketVersioning",
                "s3:PutBucketVersioning"
            ],
            "Resource": "arn:aws:s3:::{DataCollectionAccountBucketName}"
        },
        {
            "Sid": "Set permissions to pass object ownership",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "{PayerAccountA}",
                    "{PayerAccountB}"
                ]
            },
            "Action": [
                "s3:ReplicateObject",
                "s3:ReplicateDelete",
                "s3:ObjectOwnerOverrideToBucketOwner",
                "s3:ReplicateTags",
                "s3:GetObjectVersionTagging",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::{DataCollectionAccountBucketName}/*"
        }
    ]
}
```

This policy supports objects encrypted with either SSE-S3 or not encrypted objects. For SSE-KMS encrypted objects additional policy statements and replication configuration will be needed: see https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-config-for-kms-objects.html

#### Set up S3 bucket replication from each Management (Payer) account to S3 bucket in Linked (Data Collection) Account

This step should be done in each management (payer) account.

1. Open S3 bucket in Management (payer) account with CUR.
2. On Properties tab under Bucket Versioning section click Edit and set bucket versioning to Enabled.
3. On Management tab under Replication rules click on Create replication rule.
4. Specify rule name.

![Images/s3_bucket_replication_1.png](/Cost/200_Cloud_Intelligence/Images/s3_bucket_replication_1.png?classes=lab_picture_small)

5. Select Specify a bucket in another account and provide Data Collection Account id and bucket name in Data Collection Account.
6. Select Change object ownership to destination bucket owner checkbox.
7. Select Create new role under IAM Role section.

![Images/s3_bucket_replication_2.png.png](/Cost/200_Cloud_Intelligence/Images/s3_bucket_replication_2.png?classes=lab_picture_small)

8. Leave rest of the settings by default and click Save.

#### Copy existing objects from CUR S3 bucket to S3 bucket in Data Collection Account

This step should be done in each management (payer) account.

Sync existing objects from CUR S3 bucket to S3 bucket in Data Collection Account.

	aws s3 sync s3://{curBucketName} s3://{DataCollectionAccountBucketName} --acl bucket-owner-full-control

After performing this step in each management (payer) account S3 bucket in Data Collection Account will contain CUR data from all payer accounts under respective prefixes.

Proceed to the next step to setup QuickSight in your linked (data collection) account.
{{% /expand%}}


## Additional Steps
These steps are not required if you will use [All-in-one CloudFormation deployment](http://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/2_deploy_dashboards/#all-in-one-cloudformation-deployment-10-min) for CID deployment on the next step.

### Configure Athena
{{%expand "Click here to expand step by step instructions" %}}

If this is the first time you will be using Athena you will need to complete a few setup steps before you are able to create the views needed. 

To get Athena warmed up:

1. From the services list, choose **S3**

1. Create a new S3 bucket for Athena queries to be logged to (ex: `aws-athena-query-results-cid-${AWS::AccountId}-${AWS::Region}` ). Keep to the same region as the S3 bucket created for your Cost & Usage Report.

1. From the services list, choose **Athena**

1. Select **Get Started** to enable Athena and start the basic configuration

1. At the top of this screen select **Before you run your first query, you need to set up a query result location in Amazon S3.**

    ![Image of Athena Query Editor](/Cost/200_Cloud_Intelligence/Images/AthenaS3.png?classes=lab_picture_small)

1. Enter the path of the bucket created for Athena queries, it is recommended that you also select the AutoComplete option **NOTE:** The trailing “/” in the folder path is required!

1. Make sure you configured s3 bucket results location for both Athena Query Editor and the 'Primary' Workgroup.

1. This s3 bucket results location must be available for QuickSight. Please note this bucket name, you will need it on the next step.

{{% /expand%}}

## Prepare Glue Crawler
If you configured the crawler already using Option 2 on this page, you can skip this step. This step is also not required if you use [All-in-one CloudFormation deployment](http://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/2_deploy_dashboards/#all-in-one-cloudformation-deployment-10-min) for CID deployment

{{%expand "Click here to expand step by step instructions" %}}

These actions should be done in Data Collection Account

1. Open AWS Glue Service in AWS Console in the same region where S3 bucket with aggregated CUR data is located and go to Crawlers section
2. Click Add Crawler
3. Specify Crawler name and click Next
4. In Specify crawler source type leave settings by default. Click Next

![Images/glue_1.png](/Cost/200_Cloud_Intelligence/Images/glue_1.png?classes=lab_picture_small)

5. In Add a data store select S3 bucket name with aggregated CUR data and add following exclusions **.zip, **.json, **.gz, **.yml, **.sql, **.csv, **/cost_and_usage_data_status/*, aws-programmatic-access-test-object. Click Next

![Images/glue_2.png](/Cost/200_Cloud_Intelligence/Images/glue_2.png?classes=lab_picture_small)

6. In Add another data store leave No by default. Click Next

7. In Choose an IAM role select Create an IAM role and provide role name. Click Next

![Images/glue_1.png](/Cost/200_Cloud_Intelligence/Images/glue_1.png?classes=lab_picture_small)

8. In Create a schedule for this crawler select Daily and specify Hour and Minute for crawler to run

9. In Configure the crawler’s output choose Glue Database in which you’d like crawler to create a table or add new one. Select Create a single schema for each S3 path checkbox. Select Add new columns only and Ignore the change and don’t update the table in the data catalog in Configuration options. Click Next 

*Please make sure Database name doesn’t include ‘-’ character*

![Images/glue_4.png](/Cost/200_Cloud_Intelligence/Images/glue_4.png?classes=lab_picture_small)

10. Crawler configuration should look as on the screenshot below. Click Finish

11. Resume deployment methodoly of choice from previous page. 
{{% /expand%}}


{{< prev_next_button link_prev_url=".." link_next_url="../1b_quicksight" />}}


