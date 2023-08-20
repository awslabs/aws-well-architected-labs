---
title: "Alternative Deployment Methods"
date: 2022-05-20T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3 </b>"
---

## Alternative Methods for Deploying the CUR-based Cloud Intelligence Dashboards
If you are unable to deploy using the CloudFormation automation steps earlier in this lab, here are two alternative methods. Pre-requisites are included in each step. 

### Option 1: Deploy CIDs with Command Line Tool
{{%expand "Click here to continue with command line tool deployment" %}}

This option walks you through setting up a CUR file in the Management (payer) Account and configuring the prerequisites to have the CIDs deployed there. This option will create a new Cost & Usage Report (CUR) or reuse one you already have. 

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

In this step, we will be using an AWS provided CloudFormation template that automated integrating your CUR with Athena. The AWS CloudFormation template includes an AWS Glue crawler, an AWS Glue database, and an AWS Lambda event.

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

### Enable QuickSight
QuickSight is the AWS Business Intelligence tool that will allow you to not only view the Standard AWS provided insights into all of your accounts, but will also allow to produce new versions of the Dashboards we provide or create something entirely customized to you. 

**If you are already a regular QuickSight user** you will need to make sure you have an enterprise license and add permissions for QuickSight to read your CUR bucket. You can accomplish this by going to the persona icon in the upper right hand corner of QuickSight, clicking Manage Quicksight, clicking on Security and Permissions, clicking on managing QuickSight access to AWS Service, selecting S3, then selecting the CUR bucket from the list of S3 buckets. If you are new to QuickSight, complete the steps below.

1. Log into your AWS Account and search for **QuickSight** in the list of Services

2. You will be asked to **sign up** before you will be able to use it

    ![QuickSight Sign up Workflow Image](https://wellarchitectedlabs.com/Cost/200_Cloud_Intelligence/Images/QS-signup.png?classes=lab_picture_small)

3. After pressing the **Sign up** button you will be presented with 2 options, please ensure you select the **Enterprise Edition** during this step

4. Select **continue** and you will need to fill in a series of options in order to finish creating your account. 

    + Ensure you select the region that is most appropriate based on where your S3 Bucket is located containing your Cost & Usage Report file.

        ![Select Region and Amazon S3 Discovery](/Cost/200_Cloud_Intelligence/Images/QS-s3.png?classes=lab_picture_small)
    
    + Enable the Amazon S3 option and select the bucket where your **Cost & Usage Report** is stored, as well as your **Athena** query bucket

        ![Image of s3 buckets that are linked to the QuickSight account. Enable bucket and give Athena Write permission to it.](/Cost/200_Cloud_Intelligence/Images/QS-bucket.png?classes=lab_picture_small)

5. Click **Finish** and wait for the congratulations screen to display

6. Click **Go to Amazon QuickSight**
![](/Cost/200_Cloud_Intelligence/Images/Congrats-QS.png?classes=lab_picture_small)
1. Click on the persona icon on the top right and select manage QuickSight. 
2. Click on the SPICE Capacity option. Purchase enough SPICE capacity so that the total is roughly 40GB. If you get SPICE capacity errors later, you can come back here to purchase more. If you've purchased too much you can also release it after you've deployed the dashboards. 

### Deploy Dashboards
If you run into an error, please [visit our FAQ](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/faq/) to see if we can provide a quick answer. 

1. Open up a terminal application with permissions to run API requests against your AWS account. We recommend [CloudShell](https://console.aws.amazon.com/cloudshell).

2. We will be following the steps outlined in the [Cloud Intelligence Dashboards automation GitHub repo.](https://github.com/aws-samples/aws-cudos-framework-deployment/) For more information on the CLI tool, please visit the repo. 

3. In your Terminal type the following and hit return. This will make sure you have the latest pip package installed.

```bash
python3 -m ensurepip --upgrade
```

4. In your Terminal type the following and hit return. This will download and install the CID CLI tool.

```bash
pip3 install --upgrade cid-cmd
```

5. In your Terminal, type the following and hit return. You are now starting the process of deploying the dashboards. 

```bash
cid-cmd deploy
```

6. Select the CUDOS dashboard first. 

    ![cmd1](/Cost/200_Cloud_Intelligence/Images/cmd1.png?classes=lab_picture_verysmall)

7. The CLI may prompt you to select a QuickSight data source (use the data source you used for any previous CID delpoyments), an Athena workgroup (select primary if unsure), or an Athena database (select the one created by your Glue crawler for your CUR).

8. You will also be prompted to select the method you would like to use to get account names into the Cloud Intelligence Dashboards. It is recommended you choose "Retreive AWS Organizations account" if you use AWS Organizations. This will pull your account names as they are today. To setup automation to add new account names after deployment, follow [this lab.](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/) If you don't have AWS Organizations or you get an error when you select this option, select Dummy Account Mapping instead. For help on other ways of adding your account names, visit [this page dedicated to account mapping.](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/0_view0/)

9. Once complete, you should see a message with a link to your newly deployed dashboard.

    ![cmd2](/Cost/200_Cloud_Intelligence/Images/cmd1.png?classes=lab_picture_verysmall)

10. Run cid-cmd deploy again and select the Cloud Intelligence Dashboards. Once that is completed, run it one more time and select the KPI dashboard. Note that the KPI dashboard will use more SPICE capacity than the CID and CUDOS dashboards so please make sure you've [purchased enough](https://docs.aws.amazon.com/quicksight/latest/user/managing-spice-capacity.html). 

11.	Visit QuickSight and go to Datasets. Select the **summary_view** dataset

    ![qs_select_summary](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_summary.png?classes=lab_picture_small)

12.	Click **Schedule refresh**

    ![qs_schedule_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_schedule_refresh.png?classes=lab_picture_small)

13.	Click **Create**

    ![qs_create_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_create_refresh.png?classes=lab_picture_small)

14.	Enter a daily schedule, in the appropriate time zone and click **Create**

    ![qs_daily_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_daily_refresh.png?classes=lab_picture_small)

15.	Click **Cancel** to exit

    ![qs_cancel_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_cancel_refresh.png?classes=lab_picture_small)

16.	Click **x** to exit

    ![qs_exit_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_exit_refresh.png?classes=lab_picture_small)

17.	Repeat these steps with all other SPICE datasets (including the KPI datasets). No refresh is required for customer_all.

18. [Share or edit your dashboard.](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight/) 

{{% /expand%}}



### Option 2: Manual Deployment
{{%expand "Click here to expand step by step instructions" %}}

Use this option if you're deploying the CUR-based Cloud Intelligence Dashboards into your management (payer) account or a separate linked account. This option also allows customers with multiple management (payer) accounts to deploy all the CUR-based dashboards on top of the aggregated data from multiple payers. You will need a dedicated Linked Account setup and ready to go if you want to deploy the CIDs into a linked account other than your management (payer) account. This guide will walk you through creating a new Cost & Usage Reports (CUR), and if you're deploying into a linked account; setting up the management (payer) account CUR S3 buckets to have replication enabled pointing to your linked (data collection) account. 

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

#### Setup S3 CUR Bucket Replication (skip if you're deploying the dashboards into your management payer account)

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

#### Copy existing objects from CUR S3 bucket to S3 bucket in Linked (Data Collection) Account

This step should be done in each management (payer) account.

Sync existing objects from CUR S3 bucket to S3 bucket in Data Collection Account.

	aws s3 sync s3://{curBucketName} s3://{DataCollectionAccountBucketName} --acl bucket-owner-full-control

After performing this step in each management (payer) account S3 bucket in Data Collection Account will contain CUR data from all payer accounts under respective prefixes.

### Configure Athena

If this is the first time you will be using Athena you will need to complete a few setup steps before you are able to create the views needed. 

To get Athena warmed up:

1. From the services list, choose **S3**

2. Create a new S3 bucket for Athena queries to be logged to (ex: `aws-athena-query-results-cid-${AWS::AccountId}-${AWS::Region}` ). Keep to the same region as the S3 bucket created for your Cost & Usage Report.

3. From the services list, choose **Athena**

4. Select **Get Started** to enable Athena and start the basic configuration

5. At the top of this screen select **Before you run your first query, you need to set up a query result location in Amazon S3.**

    ![Image of Athena Query Editor](/Cost/200_Cloud_Intelligence/Images/AthenaS3.png?classes=lab_picture_small)

6. Enter the path of the bucket created for Athena queries, it is recommended that you also select the AutoComplete option **NOTE:** The trailing “/” in the folder path is required!

7. Make sure you configured s3 bucket results location for both Athena Query Editor and the 'Primary' Workgroup.

8. This s3 bucket results location must be available for QuickSight. Please note this bucket name, you will need it on the next step.

## Prepare Glue Crawler

These actions should be done in the account where you are deploying the dashboards, either the Management (payer) Account or a Linked (data collection) Account. 

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

10.  Click Finish. Select the crawler and from the action menu choose 'run crawler'. 

### Setup QuickSight 
QuickSight is the AWS Business Intelligence tool that will allow you to not only view the Standard AWS provided insights into all of your accounts, but will also allow to produce new versions of the Dashboards we provide or create something entirely customized to you. 

**If you are already a regular QuickSight user** you will need to make sure you have an enterprise license and add permissions for QuickSight to read your CUR bucket. You can accomplish this by going to the persona icon in the upper right hand corner of QuickSight, clicking Manage Quicksight, clicking on Security and Permissions, clicking on managing QuickSight access to AWS Service, selecting S3, then selecting the CUR bucket from the list of S3 buckets. If you are new to QuickSight, complete the steps below.

1. Log into your AWS Account and search for **QuickSight** in the list of Services

2. You will be asked to **sign up** before you will be able to use it

    ![QuickSight Sign up Workflow Image](https://wellarchitectedlabs.com/Cost/200_Cloud_Intelligence/Images/QS-signup.png?classes=lab_picture_small)

3. After pressing the **Sign up** button you will be presented with 2 options, please ensure you select the **Enterprise Edition** during this step

4. Select **continue** and you will need to fill in a series of options in order to finish creating your account. 

    + Ensure you select the region that is most appropriate based on where your S3 Bucket is located containing your Cost & Usage Report file.

        ![Select Region and Amazon S3 Discovery](/Cost/200_Cloud_Intelligence/Images/QS-s3.png?classes=lab_picture_small)
    
    + Enable the Amazon S3 option and select the bucket where your **Cost & Usage Report** is stored, as well as your **Athena** query bucket

        ![Image of s3 buckets that are linked to the QuickSight account. Enable bucket and give Athena Write permission to it.](/Cost/200_Cloud_Intelligence/Images/QS-bucket.png?classes=lab_picture_small)

5. Click **Finish** and wait for the congratulations screen to display

6. Click **Go to Amazon QuickSight**
![](/Cost/200_Cloud_Intelligence/Images/Congrats-QS.png?classes=lab_picture_small)
1. Click on the persona icon on the top right and select manage QuickSight. 
2. Click on the SPICE Capacity option. Purchase enough SPICE capacity so that the total is roughly 40GB. If you get SPICE capacity errors later, you can come back here to purchase more. If you've purchased too much you can also release it after you've deployed the dashboards. 

This option is the manual deployment and will walk you through all steps required to create this dashboard without any automation. We recommend this option users new to Athena and QuickSight.

You will require AWS CLI environment. We recommend using CloudShell in your account, but you also can [install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) on your working environment.

### Create Athena Views

The data source for the dashboard will be an Athena view of your existing Cost and Usage Report (CUR). The default dashboard assumes you have both Savings Plans and Reserved Instances, if not you will need to create the alternate views.

1. Login via SSO in your Cost Optimization account, go into the **Athena** console:

2. Modify and run the following queries to confirm if you have Savings Plans, and Reserved Instances in your usage. If no lines are returned, you have no Savings Plans or Reserved Instances. Replace (database).(tablename) and run the following:

    Savings Plans:

        select * from (database).(tablename)
        where savings_plan_savings_plan_a_r_n not like ''
        limit 10

    Reserved Instances:

        select * from (database).(tablename)
        where reservation_reservation_a_r_n not like ''
        limit 10
		

**NOTE:** Unless you already have Savings Plans and Reserved Instances both already adopted as your savings options, **recreate Athena Views** corresponding with your savings profile whenever you onboard a new savings option (like Savings Plans or Reserved Instances) **for the first time**.
    ------------ | -------------

3. Create the **account_map  view** by modifying the following code, and executing it in Athena:
	- [View0 - account_map](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/0_view0/)

4. Create the **Summary view** by modifying the following code, and executing it in Athena:
	- [View1 - Summary View](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/1_view1/)
	

5. Create the **EC2_Running_Cost view** by modifying the following code, and executing it in Athena:
	- [View2 - EC2_Running_Cost](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/2_view2/)

6. Create the **Compute savings plan eligible spend view** by modifying the following code, and executing it in Athena:
	- [View3 - compute savings plan eligible spend](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/3_view3/)	

7. Create the **s3 view** by modifying the following code, and executing it in Athena:
	- [View4 - s3](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/4_view4/)	

8. Create the **RI SP Mapping view** by modifying the following code, and executing it in Athena:
	- [View5 - RI SP Mapping](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/5_view5/)

**NOTE:** The Athena Views are updated to reflect any additions in the cost and usage report. If you created your dashboard prior to June 1, 2021 you will want to update to the latest views.
    ------------ | -------------



### Create QuickSight Data Sets
#### Create Datasets

1. Go to the **QuickSight** service homepage inside your account. Be sure to select the correct region from the top right user menu or you will not see your expected tables

    ![qs_region](/Cost/200_Cloud_Intelligence/Images/cur/qs_region.png?classes=lab_picture_small)

1.	From the left hand menu, choose **Datasets**

    ![qs_dataset_sidebar](/Cost/200_Cloud_Intelligence/Images/cur/qs_dataset_sidebar.png?classes=lab_picture_small)
	
1.	Click **New dataset** displayed in the top right corner

    ![qs_dataset](/Cost/200_Cloud_Intelligence/Images/cur/qs_dataset.png?classes=lab_picture_small)

1.	Choose **Athena** as your Data Source

    ![qs_datasource](/Cost/200_Cloud_Intelligence/Images/cur/qs_datasource.png?classes=lab_picture_small)

1.	Enter a data source name of **Cost_Dashboard** and click **Create data source**

    ![qs_create_datasource](/Cost/200_Cloud_Intelligence/Images/cur/qs_create_datasource.png?classes=lab_picture_small)

1.	Select the database which holds the views you created (reference Athena if you’re unsure which one to select), and the **summary_view** table, then click **Edit/Preview data**

    ![qs_select_datasource](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_datasource.png?classes=lab_picture_small)

1.	Select **SPICE** to change your Query mode

    ![qs_dataset_summary](/Cost/200_Cloud_Intelligence/Images/cur/qs_dataset_summary.png?classes=lab_picture_small)
	
1.	Click **Add Data**

    ![qs_add_data](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_data.png?classes=lab_picture_small)
	
1.  Select **Data source**	
  
  ![qs_add_data_source](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_data_source.png?classes=lab_picture_small)
	
10. Choose your **Cost_Dashboard** view and click **Select**

    ![qs_select_data_source_add](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_data_source_add.png?classes=lab_picture_small)

1.  Select the **database** which holds the CUR views you created

   ![qs_select_database_add](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_database_add.png?classes=lab_picture_small)
	
12.  Choose your **account_map** view and click **Select** 
	![qs_add_account_map](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_account_map.png?classes=lab_picture_small)

13.	Click the two circles to open the **Join conﬁguration**, then select **Left** to change your join type

    ![qs_join_account_map_left](/Cost/200_Cloud_Intelligence/Images/cur/qs_join_account_map_left.png?classes=lab_picture_small)
	
1.	Configure the join clause to **linked_account_id = account_id**, then click **Apply**

    ![qs_join_account_map](/Cost/200_Cloud_Intelligence/Images/cur/qs_join_account_map.png?classes=lab_picture_small)
	
1.	Select **Save**

    ![qs_save_summary](/Cost/200_Cloud_Intelligence/Images/cur/qs_save_summary.png?classes=lab_picture_small)

1.	Select the **summary_view** dataset

    ![qs_select_summary](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_summary.png?classes=lab_picture_small)

1.	Click **Schedule refresh**

    ![qs_schedule_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_schedule_refresh.png?classes=lab_picture_small)

1.	Click **Create**

    ![qs_create_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_create_refresh.png?classes=lab_picture_small)

1.	Enter a daily schedule, in the appropriate time zone and click **Create**

    ![qs_daily_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_daily_refresh.png?classes=lab_picture_small)

1.	Click **Cancel** to exit

    ![qs_cancel_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_cancel_refresh.png?classes=lab_picture_small)

1.	Click **x** to exit

    ![qs_exit_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_exit_refresh.png?classes=lab_picture_small)

1.	Repeat **steps 3-21**, creating data sets with the remaining Athena views. You will reuse your existing **Cost_Dashboard** data source, and select the following views as the table:

 - s3_view
 - ec2_running_cost
 - compute_savings_plan_eligible_spend


	**NOTE:** Make sure to reuse the existing Athena data source by scrolling to the bottom of the Data source create/select page when creating a new Dataset instead of creating a new data source  
		------------ | -------------
			![qs_data_source_scroll](/Cost/200_Cloud_Intelligence/Images/cur/qs_data_source_scroll.png?classes=lab_picture_small)

	When this step is complete, your Datasets tab should have **4 new SPICE Datasets**
	
23.	Select the **summary_view** dataset

    ![qs_select_summary](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_summary.png?classes=lab_picture_small)

1.	Click **Edit Data Set**

    ![qs_edit_dataset](/Cost/200_Cloud_Intelligence/Images/cur/qs_edit_dataset.png?classes=lab_picture_small)

1.	Click **Add Data**

    ![qs_add_data_2](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_data_2.png?classes=lab_picture_small)

1. Select **Data source**	
    ![qs_add_data_source](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_data_source.png?classes=lab_picture_small)
	
1.	Choose your **Cost_Dashboard** view and click **Select**

    ![qs_select_data_source_add](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_data_source_add.png?classes=lab_picture_small)

1.  Select the **database** which holds the CUR views you created

   ![qs_select_database_add](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_database_add.png?classes=lab_picture_small)	
	
29.	Choose your **ri_sp_mapping view** and click **Select**

    ![qs_add_ri_sp](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_ri_sp.png?classes=lab_picture_small)

1.	Click the two circles to open the **Join conﬁguration**, then select **Left** to change your join type

    ![qs_ri_sp_left](/Cost/200_Cloud_Intelligence/Images/cur/qs_ri_sp_left.png?classes=lab_picture_small)

1.	Click **Add a new join clause** twice so you have 3 join clauses to configure in total. Configure the 3 join clauses as below, then click **Apply**
    * **ri_sp_arn = ri_sp_arn_mapping**
	* **payer_account_id = payer_account_id_mapping**
    * **billing_period = billing_period_mapping**

    ![qs_ri_sp_join](/Cost/200_Cloud_Intelligence/Images/cur/qs_ri_sp_join.png?classes=lab_picture_small)
	
1.	Click **Save**

    ![qs_ri_sp_save](/Cost/200_Cloud_Intelligence/Images/cur/qs_ri_sp_save.png?classes=lab_picture_small)


**NOTE:** This completes the QuickSight Data Preparation section. Next up is the Import process to generate the QuickSight Dashboard.
    ------------ | -------------

### Deploy Cost Intelligence Dashboard
We will now use the CLI to create the dashboard from the Cost Intelligence Dashboard template.

1. Edit and Run `list-users` and make a note of your **User ARN**:
```
aws quicksight list-users --aws-account-id <Account_ID> --namespace default --region <Region>
```

2. Edit and Run `list-data-sets` and make a note of the **Name** and **Arn** for the **5 Datasets ARNs**:
```
aws quicksight list-data-sets --aws-account-id <Account_ID> --region <Region>
```

3. Create an **cid_import.json** file using the below sample
```
{
    "AwsAccountId": "<Account_ID>",
    "DashboardId": "cost_intelligence_dashboard",
    "Name": "Cost Intelligence Dashboard",
    "Permissions": [
         {
                "Principal": "<User ARN>",
        "Actions": [
                     "quicksight:DescribeDashboard",
                     "quicksight:ListDashboardVersions",
                     "quicksight:UpdateDashboardPermissions",
                     "quicksight:QueryDashboard",
                     "quicksight:UpdateDashboard",
                     "quicksight:DeleteDashboard",
                     "quicksight:DescribeDashboardPermissions",
                     "quicksight:UpdateDashboardPublishedVersion"
            ]
        }
    ],
"DashboardPublishOptions": {
"AdHocFilteringOption": {
"AvailabilityStatus": "DISABLED"
}
},
    "SourceEntity": {
        "SourceTemplate": {
            "DataSetReferences": [
                {
                    "DataSetPlaceholder": "summary_view",
                    "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"

                },
                                         {
                    "DataSetPlaceholder": "ec2_running_cost",
                    "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                },
                                         {
                     "DataSetPlaceholder": "compute_savings_plan_eligible_spend",
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                 },
                                         {
                     "DataSetPlaceholder": "s3_view",
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                 }
             ],
                     "Arn": "arn:aws:quicksight:us-east-1:223485597511:template/Cost_Intelligence_Dashboard"
         }
     },
     "VersionDescription": "1"
}
```

4. Update the **cid_import.json** to match your details by replacing the following placeholders:

    Placeholder | Replace with
    ------------ | -------------
    \<Account_ID> | AWS Account ID where the dashboard will be deployed
    \<Region> | [Region Code](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) where the dashboard will be deployed (Example eu-west-1)
    \<User ARN> | ARN of your user
    \<DataSetId> | Replace with Dataset ID's from the data sets you created in the Preparing Quicksight section **NOTE:** There are 4 unique Dataset IDs

5. Run the import
```
aws quicksight create-dashboard --cli-input-json file://cid_import.json --region <Region> --dashboard-id cost_intelligence_dashboard
```

6. Check the status of your deployment
```
aws quicksight describe-dashboard --dashboard-id cost_intelligence_dashboard --region <Region> --aws-account-id <Account_ID>
```

If you encounter no errors, open **QuickSight** from the AWS Console, and navigate to **Dashboards**. You should now see **Cost Intelligence Dashboard** available. This dashboard can be shared with other users, but is otherwise ready for viewing and customizing.

If something goes wrong in the dashboard creation step, correct the issue then delete the failed deployment before re-deploying

```
aws quicksight delete-dashboard --dashboard-id cost_intelligence_dashboard --region <Region> --aws-account-id <Account_ID>
```

**NOTE:** You have successfully created the Cost Intelligence Dashboard. For a detailed description of the dashboard read the [FAQ](/Cost/200_Cloud_Intelligence/Cost_Intelligence_Dashboard_ReadMe.pdf)
    ------------ | -------------


### Deploy CUDOS

1. Create the **customer_all view** by modifying the following code, and executing it in Athena:
	- [View6 - customer_all](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/6_view6/)	


**NOTE:** The Athena Views are updated to reflect any additions in the cost and usage report. If you created your dashboard prior to June 1, 2021 you will want to update to the latest views.
    ------------ | -------------


### Create QuickSight Data Sets
#### Create Datasets

1.  Go to QuickSight and then datasets. 

1.	Click **New dataset** displayed in the top right corner of QuickSight

    ![qs_dataset](/Cost/200_Cloud_Intelligence/Images/cur/qs_dataset.png?classes=lab_picture_small)

1.	Select your existing **Cost_Dashboard** as your Data Source
   
   ![qs_datasource_dup](/Cost/200_Cloud_Intelligence/Images/cur/qs_datasource_dup.png?classes=lab_picture_small)
   
29.	Select **Create dataset**

   ![qs_create_customer_all](/Cost/200_Cloud_Intelligence/Images/cur/qs_create_customer_all.png?classes=lab_picture_small)

30.	Select the database which holds your **customer_all** view and select that view then click **Edit/Preview data**

   ![qs_customer_all_view](/Cost/200_Cloud_Intelligence/Images/cur/qs_customer_all_view.png?classes=lab_picture_small)

31.	Keep the Query mode as **Direct query**

    ![qs_direct_query](/Cost/200_Cloud_Intelligence/Images/cur/qs_direct_query.png?classes=lab_picture_small)

32.	Click **Add data**, select the **Cost Dashboard** data source, and select **account_map**. Edit the join clauses with a left join type as such;
    **line_item_usage_account_id** = **account_id**

    ![qs_customer_all_map](/Cost/200_Cloud_Intelligence/Images/cur/qs_customer_all_map.png?classes=lab_picture_small)

33. Click Save & Publish. 

**NOTE:** This completes the QuickSight Data Preparation section. Next up is the Import process to generate the QuickSight Dashboard.
    ------------ | -------------

### Import Dashboard Template
We will now use the CLI to create the dashboard from the CUDOS Dashboard template.

1. Edit and Run `list-users` and make a note of your **User ARN**:
```
aws quicksight list-users --aws-account-id <Account_ID> --namespace default --region <Region>
```

2. Edit and Run `list-data-sets` and make a note of the **Name** and **Arn** for the **5 Datasets ARNs**:
```
aws quicksight list-data-sets --aws-account-id <Account_ID> --region <Region>
```

3. Create an **import.json** file using the below sample
```
{
    "AwsAccountId": "<Account_ID>",
    "DashboardId": "cudos",
    "Name": "CUDOS",
    "Permissions": [
         {
                "Principal": "<User ARN>",
        "Actions": [
                     "quicksight:DescribeDashboard",
                     "quicksight:ListDashboardVersions",
                     "quicksight:UpdateDashboardPermissions",
                     "quicksight:QueryDashboard",
                     "quicksight:UpdateDashboard",
                     "quicksight:DeleteDashboard",
                     "quicksight:DescribeDashboardPermissions",
                     "quicksight:UpdateDashboardPublishedVersion"
            ]
        }
    ],
"DashboardPublishOptions": {
"AdHocFilteringOption": {
"AvailabilityStatus": "DISABLED"
}
},
    "SourceEntity": {
        "SourceTemplate": {
            "DataSetReferences": [
                {
                    "DataSetPlaceholder": "summary_view",
                    "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                },
                                         {
                    "DataSetPlaceholder": "ec2_running_cost",
                    "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                },
                                         {
                     "DataSetPlaceholder": "compute_savings_plan_eligible_spend",
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                 },
                                         {
                     "DataSetPlaceholder": "s3_view",
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                 },
                              {
                 "DataSetPlaceholder": "customer_all",
                 "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"
             }
             ],
                     "Arn": "arn:aws:quicksight:us-east-1:223485597511:template/cudos_dashboard_v3"
         }
     },
     "VersionDescription": "1"
}
```

4. Update the **import.json** to match your details by replacing the following placeholders:

    Placeholder | Replace with
    ------------ | -------------
    \<Account_ID> | AWS Account ID where the dashboard will be deployed
    \<Region> | [Region Code](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) where the dashboard will be deployed (Example eu-west-1)
    \<User ARN> | ARN of your user
    \<DataSetId> | Replace with Dataset ID's from the data sets you created in the Preparing Quicksight section **NOTE:** There are 5 unique Dataset IDs

5. Run the import
```
aws quicksight create-dashboard --cli-input-json file://import.json --region <Region> --dashboard-id cudos
```

6. Check the status of your deployment
```
aws quicksight describe-dashboard --dashboard-id cudos --region <Region> --aws-account-id <Account_ID>
```

If you encounter no errors, open **QuickSight** from the AWS Console, and navigate to **Dashboards**. You should now see **CUDOS** available. This dashboard can be shared with other users, but is otherwise ready for viewing and customizing.

If something goes wrong in the dashboard creation step, correct the issue then delete the failed deployment before re-deploying

```
aws quicksight delete-dashboard --dashboard-id cudos --region <Region> --aws-account-id <Account_ID>
```

### Deploy the KPI Dashboard

**NOTE:** This dashboard uses the account_map and summary_view as shown in the CID/CUDOS dashboards. If you have not created these dashboards, you will need to create one or both of the dashboards prior to creating the KPI Dashboard 
    ------------ | -------------

The data source for the dashboard will be an Athena view of your existing Cost and Usage Report (CUR). The default dashboard assumes you have both Savings Plans and Reserved Instances. If you do not have both, follow the instructions within each view below to adjust the query accordingly. 

1. Login via SSO in your Cost Optimization account, go into the **Athena** console:


2. Create the **KPI Instance Mapping view** by modifying the following code, and executing it in Athena:
	- [KPI Instance Mapping](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/kpi_instance_mapping_view/)

3. Create the **KPI Instance All view** by modifying the following code, and executing it in Athena:
	- [KPI Instance All](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/kpi_instance_all_view/)

4. Create the **KPI S3 Storage All view** by modifying the following code, and executing it in Athena:
	- [KPI S3 Storage All](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/kpi_s3_storage_all_view/)	

5. Create the **KPI EBS Storage All view** by modifying the following code, and executing it in Athena:
	- [KPI EBS Storage All](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/kpi_ebs_storage_all_view/)

6. Create the **KPI EBS Snap view** by modifying the following code, and executing it in Athena:
	- [KPI EBS Snap](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/kpi_ebs_snap_view/)	

7. Create the **KPI Tracker view** by modifying the following code, and executing it in Athena:
	- [KPI Tracker](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/kpi_tracker_view/)	



**NOTE:** The Athena Views are updated to reflect any additions in the cost and usage report. If you created your dashboard prior to January 18, 2022 you will want to update to the latest views above.
    ------------ | -------------



### Create QuickSight Data Sets

#### Create Datasets

1. Go to the **QuickSight** service homepage inside your account. Be sure to select the correct region from the top right user menu or you will not see your expected tables

    ![qs_region](/Cost/200_Cloud_Intelligence/Images/cur/qs_region.png?classes=lab_picture_small)

2.	From the left hand menu, choose **Datasets**

    ![qs_dataset_sidebar](/Cost/200_Cloud_Intelligence/Images/cur/qs_dataset_sidebar.png?classes=lab_picture_small)
	
3.	Click **New dataset** displayed in the top right corner

    ![qs_dataset](/Cost/200_Cloud_Intelligence/Images/cur/qs_dataset.png?classes=lab_picture_small)
	
    
4.	Select your existing **data source** you created for your CID and/or CUDOS dashboard 

**NOTE:** Your existing data sources are at the bottom of the page 
    ------------ | -------------
	
![qs_data_source_scroll](/Cost/200_Cloud_Intelligence/Images/cur/qs_data_source_scroll.png?classes=lab_picture_small)


5.	Select the database which holds the views you created (reference Athena if you’re unsure which one to select), and select the **kpi_tracker** view then click **Edit/Preview data**

    ![qs_select_datasource](/Cost/200_Cloud_Intelligence/Images/kpi/qs_select_kpi_datasource.png?classes=lab_picture_small)

6.	Select **SPICE** to change your Query mode

    ![qs_dataset_summary](/Cost/200_Cloud_Intelligence/Images/kpi/qs_dataset_kpi.png?classes=lab_picture_small)
	
7.	Select **Save & Publish**

    ![qs_save_summary](/Cost/200_Cloud_Intelligence/Images/kpi/qs_save_kpi.png?classes=lab_picture_small)

8.	Select **Cancel**

    ![qs_save_summary](/Cost/200_Cloud_Intelligence/Images/kpi/qs_cancel_kpi.png?classes=lab_picture_small)	

9.	Select the **kpi_tracker** dataset

    ![qs_select_summary](/Cost/200_Cloud_Intelligence/Images/kpi/qs_select_kpi.png?classes=lab_picture_small)

10.	Click **Schedule refresh**

    ![qs_schedule_refresh](/Cost/200_Cloud_Intelligence/Images/kpi/qs_schedule_refresh.png?classes=lab_picture_small)

11.	Click **Create**

    ![qs_create_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_create_refresh.png?classes=lab_picture_small)

12.	Enter a daily schedule, in the appropriate time zone and click **Create**

    ![qs_daily_refresh](/Cost/200_Cloud_Intelligence/Images/kpi/qs_daily_refresh.png?classes=lab_picture_small)

13.	Click **Cancel** to exit

    ![qs_cancel_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_cancel_refresh.png?classes=lab_picture_small)

14.	Click **x** to exit

    ![qs_exit_refresh](/Cost/200_Cloud_Intelligence/Images/kpi/qs_exit_refresh.png?classes=lab_picture_small)

15.	Repeat **steps 3-14**, creating data sets with the remaining Athena views. You will reuse your existing **Cost_Dashboard** data source, and select the following views as the table:

 - kpi_instance_all
 - kpi_s3_storage_all
 - kpi_ebs_storage_all
 - kpi_ebs_snap_view


	**NOTE:** Make sure to reuse the existing Athena data source by scrolling to the bottom of the Data source create/select page when creating a new Dataset instead of creating a new data source  
		------------ | -------------
			![qs_data_source_scroll](/Cost/200_Cloud_Intelligence/Images/cur/qs_data_source_scroll.png?classes=lab_picture_small)

	When this step is complete, your Datasets tab should have **5 new SPICE Datasets** as well as your **existing summary_view dataset** and any existing datasets 
	

**NOTE:** This completes the QuickSight Data Preparation section. Next up is the Import process to generate the QuickSight Dashboard.
    ------------ | -------------

### Import Dashboard Template
We will now use the AWS CLI to create the dashboard from the KPI Dashboard template.

1. Edit and Run `list-users` and make a note of your **User ARN**:
```
aws quicksight list-users --aws-account-id <Account_ID> --namespace default --region <Region>
```

2. Edit and Run `list-data-sets` and make a note of the **Name** and **Arn** for the **5 Datasets ARNs**:
```
aws quicksight list-data-sets --aws-account-id <Account_ID> --region <Region>
```

3. Create an **kpi_import.json** file using the below sample
```
{
    "AwsAccountId": "<Account_ID>",
    "DashboardId": "kpi_dashboard",
    "Name": "KPI Dashboard",
    "Permissions": [
         {
                "Principal": "<User ARN>",
        "Actions": [
                     "quicksight:DescribeDashboard",
                     "quicksight:ListDashboardVersions",
                     "quicksight:UpdateDashboardPermissions",
                     "quicksight:QueryDashboard",
                     "quicksight:UpdateDashboard",
                     "quicksight:DeleteDashboard",
                     "quicksight:DescribeDashboardPermissions",
                     "quicksight:UpdateDashboardPublishedVersion"
            ]
        }
    ],
"DashboardPublishOptions": {
"AdHocFilteringOption": {
"AvailabilityStatus": "DISABLED"
}
},
    "SourceEntity": {
        "SourceTemplate": {
            "DataSetReferences": [
                {
                     "DataSetPlaceholder": "kpi_tracker", 
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"
                 },
                {
                    "DataSetPlaceholder": "summary_view", 
                    "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"
                 },
                 {
                     "DataSetPlaceholder": "kpi_instance_all", 
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"
                 },
                 {
                     "DataSetPlaceholder": "kpi_s3_storage_all", 
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"
                 },				 
                 {
                     "DataSetPlaceholder": "kpi_ebs_storage_all", 
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"
                 },
                 {
                     "DataSetPlaceholder": "kpi_ebs_snap", 
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"
                 }				 						 			 				 
             ],
                     "Arn": "arn:aws:quicksight:us-east-1:223485597511:template/kpi_dashboard"
         }
     },
     "VersionDescription": "1"
}
```

4. Update the **kpi_import.json** to match your details by replacing the following placeholders:

    Placeholder | Replace with
    ------------ | -------------
    \<Account_ID> | AWS Account ID where the dashboard will be deployed
    \<Region> | [Region Code](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) where the dashboard will be deployed (Example eu-west-1)
    \<User ARN> | ARN of your user
    \<DataSetId> | Replace with Dataset ID's from the data sets you created in the Preparing Quicksight section **NOTE:** There are 6 unique Dataset IDs

5. Run the import
```
aws quicksight create-dashboard --cli-input-json file://kpi_import.json --region <Region> --dashboard-id kpi_dashboard
```

6. Check the status of your deployment
```
aws quicksight describe-dashboard --dashboard-id kpi_dashboard --region <Region> --aws-account-id <Account_ID>
```

If you encounter no errors, open **QuickSight** from the AWS Console, and navigate to **Dashboards**. You should now see **KPI Dashboard** available. This dashboard can be shared with other users, but is otherwise ready for viewing and customizing.

If something goes wrong in the dashboard creation step, correct the issue then delete the failed deployment before re-deploying

```
aws quicksight delete-dashboard --dashboard-id kpi_dashboard --region <Region> --aws-account-id <Account_ID>
```
{{% /expand%}}


---

{{< prev_next_button link_prev_url="../post_deployment_steps" link_next_url="../3_additional_dashboards" />}}


