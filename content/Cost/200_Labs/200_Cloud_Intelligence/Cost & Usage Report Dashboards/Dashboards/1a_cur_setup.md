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

## Contributors
- Iakov Gan, AWS Sr. Technical Account Manager
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
### Option 1. Multi account deployment with CloudFormation (Suggested)
{{%expand "Click here to continue with Cloud Formation Deployment" %}}

If you have __one or several management (payer) accounts__ we recommend to install Dashboads in a dedicated AWS Account. In this case you will need to create Cost & Usage Reports to export data to S3 in each management (payer) account and then configure an S3 replication to the dedicated account. The replicaiton data volume is relatively small.

![Images/multi-account/Architecture1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/Architecture1.png?classes=lab_picture_small)

If you have just one management (payer) account, a dedicated account for dashboards is still a recommended option.

Another frequent use case is __multi linked account__ setup. When AWS Customer has a number of AWS Accounts but no access to management (payer) account. In this case it is possible to configure CUR in each account and set up a replication to one account that will be used for dashboards. Thus the replication architecture is similar to the schema with multi-payer described on the schema above. An only difference is that in this case a local CUR must be activated in the destination account.

This section provide deep dive on automated way to aggregate the Cost and Usage Report data across multiple accounts.

If you have multiple management(payer) accounts or if you just want to transfer CUR from management(payer) to a deducated account, you can follow these steps to configure CUR aggregation. Also you can add or delete account later.

The same CloudFormation template must be installed in:

1. In one or more **Source Accounts**, where CFN will activate a new CUR, an S3 bucket and a replication rule.
2. In the **Destination** or data collection account, where CFN will create an S3 bucket for CUR aggregation.

If you use just one account, CFN also can be used to create a CUR, in this case please follow guidance for **Destination Account** and choose to activate local CUR.


CFN will result to S3 bucket with following structure in the **Destination Account**

```html
s3://<prefix>-<destination-accountid>-shared/
	cur/source_account_id=<src-account1>/cid/cid/year=XXXX/month=YY/*.parquet
	cur/source_account_id=<src-account2>/cid/cid/year=XXXX/month=YY/*.parquet
	cur/source_account_id=<src-account3>/cid/cid/year=XXXX/month=YY/*.parquet
```

In this case crawler can create a reasonable partitions Strh

### Step1. Create CUR in Source Account(s) using CloudFormation

1. Login to your Source Account (can be management account or linked account depending what you what to replicate).

2. Click the **Launch CloudFormation button** below to open the **stack template** in your CloudFormation console and select **Next**.

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-managed-cost-intelligence-dashboards.s3.amazonaws.com/cfn/cur-aggregation.yaml&stackName=CID-CUR-Replication)
	
![Images/multi-account/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images//multi-account/cf_dash_launch_2.png?classes=lab_picture_small)

3. Enter a **Stack name** for your template such as **CID-CUR**.
![Images/multi-account/cfn_dash_dst_param.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_dst.png?classes=lab_picture_small)

4. Enter your **Desitnation** AWS Account Id parameter.
   
![Images/multi-account/cfn_dash_param_dst_1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_dst_1.png?classes=lab_picture_small)

5. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page.

6.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

7. You will see the stack will start in **CREATE_IN_PROGRESS** .
**NOTE:** This step can take 5-15mins
    ------------ | -------------

8.  Once complete, the stack will show **CREATE_COMPLETE**.


### Step2. Configure Destination Account using CloudFormation

At this step we will deplpoy the same CFN Template but with parameters for Destination Account.

1. Login to the Destination account in the region of your choice. I can be any account inside or outside your AWS Organization.
   
2. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**.

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-managed-cost-intelligence-dashboards.s3.amazonaws.com/cfn/cur-aggregation.yaml&stackName=CID-CUR-Destination)
	
![Images/multi-account/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images//multi-account/cf_dash_launch_2.png?classes=lab_picture_small)

4. Enter your **Destination** Account Id. 
   
![Images/multi-account/cfn_dash_param_dst_dedicated_1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_dst_dedicated_1.png?classes=lab_picture_small)

**NOTE:** Please note this Account Id, we will need it later when we will deploy stack in replication account.

5. Disable CUR creation by entering **False** as parameter value if you are replicating CURs of management (payer) accounts. You will only need to activate this if you are replicating CURs from linked accounts and you want to have data for the Destination account as well.
   
![Images/multi-account/cfn_dash_param_dst_dedicated_3.png.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_dst_dedicated_3.png?classes=lab_picture_small)

6. Enter your **Source Account(s)** Id's as a comma separated values. 
   
![Images/multi-account/cfn_dash_param_dst_dedicated_2.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_dst_dedicated_2.png?classes=lab_picture_small)

7. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page.

8.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

10. You will see the stack will start in **CREATE_IN_PROGRESS**.
**NOTE:** This step can take 5-15mins
    ------------ | -------------

11. Once complete, the stack will show **CREATE_COMPLETE**.


### Create CUR in Source Account using CloudFormation
{{%expand "Click here to continue" %}}

1. Login to the Source Account (can be management account or linked account depending what you what to replicate).

2. Click the **Launch CloudFormation button** below to open the **stack template** in your CloudFormation console and select **Next**.

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/cur-aggregation.yaml&stackName=CID-CUR-Source)
	
![Images/multi-account/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images//multi-account/cf_dash_launch_2.png?classes=lab_picture_small)

3. Enter a **Stack name** for your template such as **CID-CUR**.
![Images/multi-account/cfn_dash_dst_param.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_dst.png?classes=lab_picture_small)

4. Enter your **Desitnation** AWS Account Id parameter.
   
![Images/multi-account/cfn_dash_param_dst_1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_dst_1.png?classes=lab_picture_small)

5. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page.

6.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

7. You will see the stack will start in **CREATE_IN_PROGRESS** .
**NOTE:** This step can take 5-15mins
    ------------ | -------------

8.  Once complete, the stack will show **CREATE_COMPLETE**.
   
{{% /expand%}}


### Step3. Add or delete accounts (Optional)

This section is only available if you already deployed CUR Replication with CloudFormation.


1. Login to the __Destination__ Account.
   
2. Find your existing template and chosse __Update__

![Images/multi-account/cfn_dash_param_10.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_10.png?classes=lab_picture_small)

3. Check __Use current template__ then choose __Next__

![Images/multi-account/cfn_dash_param_11.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_11.png?classes=lab_picture_small)

4. Update AWS Account Ids list to modify CUR aggregation (ADD or DELETE)
    
![Images/multi-account/cfn_dash_param_dst_dedicated_2.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_dst_dedicated_2.png?classes=lab_picture_small)

5. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page

6.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

7. You will see the stack will start in **UPDATE_IN_PROGRESS** 
**NOTE:** This step can take up to 5mins
    ------------ | -------------

8.  Once complete, the stack will show **UPDATE_COMPLETE**

### Teardown of CloudFormation deployment (Optional)

**NOTE:** Deleting an account means that cur data will not flow to your CUR aggregation account anymore. However, historical data will be retain. To delete them, go to the `${resource-prefix}-${payer-account-id}-shared` S3 Bucket and manualy delete account data.
    ------------ | -------------

1. Login to the Account you want to delete.
   
2. Find your existing template and chosse __Delete__

![Images/multi-account/cfn_dash_param_12.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_12.png?classes=lab_picture_small)
{{% /expand%}}


### Option 2. Single account deployment
{{%expand "Click here see steps for preparing your Cost & Usage report and Athena integraton manually" %}}

If you want to set up CUR and dashboards in a __single account__ or in a __management (payer) account__ directly, it is possible, but in this case you need to make sure you apply [least privileges](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#grant-least-privilege/) systematically.

You can set up CUR in billing console and configure Athena integration from a CloudFormation template [provided with your CUR](https://docs.aws.amazon.com/cur/latest/userguide/use-athena-cf.html) (in the same S3 bucket as your CUR).

You can also use it for dashboards directly, however, we do not recommend this option. Please consider replicating CUR to a dedicated account. This way you can effectivly managed the access and avoid having unnecessary users in your payer account. If you still want to use this option, please apply least priviledge access to your payer account.

#### Configure CUR
1. [Sign in](https://console.aws.amazon.com/billing/home#/) to the Billing and Cost Management console.

1. On the navigation pane, choose **Cost & Usage Reports**.

1. Choose **Create report**.

1. For **Report name**, enter a name for your report. ex: **cid**

1. Under **Additional report details**, select **Include resource IDs** to include the IDs of each individual resource in the report.
**Note:** Including resource IDs will create individual line items for each of your resources. This can increase the size of your Cost and Usage Reports files significantly, based on your AWS usage.
    ------------ | -------------
1. For **Data refresh settings**, select whether you want the AWS Cost and Usage Reports to refresh if AWS applies refunds, credits, or support fees to your account after finalizing your bill. When a report refreshes, a new report is uploaded to Amazon S3.

1. Choose **Next**.

1. For S3 bucket, choose **Configure**.

1. In the Configure **S3 Bucket** dialog box, do one of the following:

    + Select an existing bucket from the drop down list and choose **Next**.

    + Enter a bucket name and the Region where you want to create a new bucket and choose **Next**.

1. Review the bucket policy, and select **I have confirmed that this policy is correct** and choose **Save**.
1. For **Report path prefix**, enter the report path prefix that you want prepended to the name of your report. In order to make you CUR compatible with multi-account scenarions, you can choose prefix as **cur/source_account_id={current_account_id}** (replacing current_account_id with the right value).
**Note:** Make sure that report path prefix doesn't include a double slash (//) as Athena doesn't support such table location.
    ------------ | -------------

1. For **Time granularity**, choose **Hourly**.

1. For **Report versioning**, choose **Overwrite existing report**.

1. For **Enable report data integration for**, select **Amazon Athena**.

1. Now CUR will be set to **Parquet** format, this format is **mandatory** for the workshop completion.

1. Choose **Next**.

1. After you have reviewed the settings for your report, choose **Review and Complete**.

{{% notice note %}}
It can take up to 24 hours for AWS to start delivering reports to your Amazon S3 bucket. After delivery starts, AWS updates the AWS Cost and Usage Reports files at least once a day. You can create AWS Support ticket requesting a backfill for the last 6 months of your data.
{{% /notice %}}


### Enable your Cost & Usage Reports in Athena
The dashboards use Athena as the QuickSight data source for generating your dashboards. If you do not have your Cost & Usage Report enabled in Athena please click to expand the setup guide below. 

#### Configure Athena
##### 1. Prepare Athena
If this is the first time you will be using Athena you will need to complete a few setup steps before you are able to create the views needed. If you are already a regular Athena user you can skip these steps and move on to step 2 **Prepare CUR & Athena Integration** 

To get Athena warmed up:

1. From the services list, choose **S3**

1. Create a new S3 bucket for Athena queries to be logged to (ex: `aws-athena-query-results-cid-${AWS::AccountId}-${AWS::Region}` ). Keep to the same region as the S3 bucket created for your Cost & Usage Report.

1. From the services list, choose **Athena**

1. Select **Get Started** to enable Athena and start the basic configuration

1. At the top of this screen select **Before you run your first query, you need to set up a query result location in Amazon S3.**

    ![Image of Athena Query Editor](/Cost/200_Cloud_Intelligence/Images/AthenaS3.png?classes=lab_picture_small)

1. Enter the path of the bucket created for Athena queries, it is recommended that you also select the AutoComplete option **NOTE:** The trailing “/” in the folder path is required!

1. Make sure you configured s3 bucket results location for both Athena Query Editor and the 'Primary' Workgroup.

##### 2. Prepare CUR & Athena Integration
{{% notice note %}}
Before you can use the AWS CloudFormation template to automate an Athena integration, you must wait for the first Cost and Usage Report to be delivered to your Amazon S3 bucket.
{{% /notice %}}

To streamline and automate integration of your Cost and Usage Reports with Athena, AWS provides an AWS CloudFormation template with several key resources along with the reports you setup for Athena integration. The AWS CloudFormation template includes an AWS Glue crawler, an AWS Glue database, and an AWS Lambda event.

If you are not deploying the CIDs in your payer acacount, or wish to deploy them on top of multiple payer accounts, please follow [these instructions](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/faq/) in lieu of the below. Come back for the QuickSight prerequisites.

1. From the services list, choose **S3**

1. Navigate to the S3 bucket where the **Cost & Usage Report** was saved

1. Select the Object named after the **prefix** defined when your Cost & Usage Report was created (Step 11 in [Prepare Cost & Usage Report](#prepare-cost--usage-report) --> Configure Cur)

1. Select the Object named after the **Cost & Usage Report**

1. Download the **crawler-cfn.yml** file

1. Navigate to the **CloudFormation** service

1. Ensure you are in the same Region as your Cost & Usage Report S3 bucket

1. Deploy the CloudFormation template by clicking **Create stack - With new resources (standard)**

1. Select **Upload a template file**

1. Click **Choose file** and locate your `crawler-cfn.yml` file

1. Click **Next**

1. Enter a Stack Name to identify this as part of your CUDOS Dashboard setup

1. Click **Next**

1. Define Stack options including tags, permissions and rollback configurations.

1. Click **Next**

1. Enable **"I acknowledge that AWS CloudFormation might create IAM resources."** and click **Create Stack**

{{% /expand%}}



### Option3. Multi account deployment with manual configuration

{{%expand "Click here to expand step by step instructions" %}}
This scenario allows customers with multiple management (payer) accounts to deploy all the CUR dashboards on top of the aggregated data from multiple payers. To fulfill prerequisites customers should set up or have setup a new Data Collection Account. The payer account CUR S3 buckets will have S3 replication enabled, and will replicate to a new S3 bucket in your separate Data Collection account.

![Images/CUDOS_multi_payer.png](/Cost/200_Cloud_Intelligence/Images/CUDOS_multi_payer.png?classes=lab_picture_small)

**NOTE: These steps assume you've already setup the CUR to be delivered in each management (payer) account.**

#### Setup S3 CUR Bucket Replication

1. Create or go to the console of your Data Collection account. This is where the Cloud Intelligence Dashboards will be deployed. Your payer account CURs will be replicated to this account. Note the region, and make sure everything you create is in the same region. To see available regions for QuickSight, visit [this website](https://docs.aws.amazon.com/quicksight/latest/user/regions.html). 
2. Create an S3 bucket with enabled versioning.
3. Open S3 bucket and apply following S3 bucket policy with replacing respective placeholders {PayerAccountA}, {PayerAccountB} (one for each payer account) and {DataCollectionAccountBucketName}. You can add more payer accounts to the policy later if needed.

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

#### Set up S3 bucket replication from each Management (Payer) account to S3 bucket in Data Collection Account

This step should be done in each management (payer) account.

1. Open S3 bucket in Payer account with CUR.
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
{{% /expand%}}


## Configure Athena
You will need to do this in Data Collection Account, and only if you choose Manual or Automated multi-account option of CUR Deployment. The latest version of CID CloudFormation does not require this step.

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
You will need to do this in Data Collection Account, and only if you choose Manual or Automated multi-account option of CUR Deployment. The latest version of CID CloudFormation does not require this step.

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


