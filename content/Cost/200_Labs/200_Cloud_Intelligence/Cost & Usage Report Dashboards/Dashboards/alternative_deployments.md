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
QuickSight is the AWS Business Intelligence tool that will allow you to not only view the Standard AWS provided insights into all of your accounts, but will also allow to produce new versions of the Dashboards we provide or create something entirely customized to you. If you are already a regular QuickSight user you can skip these steps and move on to the next step. If not, complete the steps below.

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

Use this option if you're deploying the CUR-based Cloud Intelligence Dashboards in an account other than your management (payer) account. This option also allows customers with multiple management (payer) accounts to deploy all the CUR-based dashboards on top of the aggregated data from multiple payers. You will need a dedicated Linked Account setup and ready to go for this step. This option will create new Cost & Usage Reports (CUR). This guide will walk you through setting up the management (payer) account CUR S3 buckets to have replication enabled pointing to your linked (data collection) account manually.

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
If you configured the crawler already using Option 2 on this page, you can skip this step. This step is also not required if you use [All-in-one CloudFormation deployment](http://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/2_deploy_dashboards/#all-in-one-cloudformation-deployment-10-min) for CID deployment


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

QuickSight is the AWS Business Intelligence tool that will allow you to not only view the Standard AWS provided insights into all of your accounts, but will also allow to produce new versions of the Dashboards we provide or create something entirely customized to you. If you are already a regular QuickSight user you can skip these steps and move on to the next step. If not, complete the steps below.

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

{{% /expand%}}


{{< prev_next_button link_prev_url="../post_deployment_steps" link_next_url="../3_additional_dashboards" />}}


