---
title: "Prerequisites"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---


### (Required for automated Installation with cid-cmd tool) Python 3.9+
For automatic installation you will require Python 3.9+ and PIP installed.


### Prepare Cost & Usage Report
The Cost & Usage Report is the foundation for these dashboards. You must have a Cost & Usage Report created with the following format
- Additional report details: Include **Resource IDs**
- Time Granularity: **Hourly**
- Report Versioning: **Overwrite existing report**
- Report data integration for: **Amazon Athena**
- Compression type: **Parquet** 


If you do not have a Cost & Usage Report that meets this criteria follow the *steps for preparing your Cost & Usage report* setup guide below. 

{{% notice note %}}
It can take up to 24 hours for AWS to start delivering reports to your Amazon S3 bucket. After delivery starts, AWS updates the AWS Cost and Usage Reports files at least once a day.
{{% /notice %}}

{{%expand "Click here see steps for preparing your Cost & Usage report" %}}
#### Configure CUR
1. [Sign in](https://console.aws.amazon.com/billing/home#/) to the Billing and Cost Management console.

1. On the navigation pane, choose **Cost & Usage Reports**.

1. Choose **Create report**.

1. For **Report name**, enter a name for your report.

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

1. For **Report path prefix**, enter the report path prefix that you want prepended to the name of your report.

1. For **Time granularity**, choose **Hourly**.

1. For **Report versioning**, choose **Overwrite existing report**.

1. For **Enable report data integration for**, select **Amazon Athena**.

1. Now CUR will be set to **Parquet** format, this format is **mandatory** for the workshop completion.

1. Choose **Next**.

1. After you have reviewed the settings for your report, choose **Review and Complete**.

{{% /expand%}}

{{% notice note %}}
The Cloud Intelligence Dashboards support Multi-Payer Cost and Usage Report (CUR) reporting. **After using the steps below to setup a CUR in each payer account, visit [this section](/cost/200_labs/200_cloud_intelligence/faq/) of the lab on combining multiple CURs for the Cloud Intelligence Dashboards before returning here**
{{% /notice %}}


### Enable your Cost & Usage Reports in Athena
The dashboards use Athena as the QuickSight data source for generating your dashboards. If you do not have your Cost & Usage Report enabled in Athena please click to expand the setup guide below. 

{{%expand "Click here - to follow the steps for setting up Athena for the first time" %}}
#### Configure Athena
##### 1. Prepare Athena
If this is the first time you will be using Athena you will need to complete a few setup steps before you are able to create the views needed. If you are already a regular Athena user you can skip these steps and move on to step 2 **Prepare CUR & Athena Integration** 

To get Athena warmed up:

1. From the services list, choose **S3**

1. Create a new S3 bucket for Athena queries to be logged to. Keep to the same region as the S3 bucket created for your Cost & Usage Report (ex: athena-query-result-REGION-ACCOUTID ).

1. From the services list, choose **Athena**

1. Select **Get Started** to enable Athena and start the basic configuration

1. You need to set up a query result location both in Ahena editor AND your primary workgroup. 

If it is your first time in Athena, then at the top of this screen select **Before you run your first query, you need to set up a query result location in Amazon S3**

    ![Image of Athena Query Editor](/Cost/200_Cloud_Intelligence/Images/AthenaS3.png?classes=lab_picture_small)

Enter the path of the bucket created for Athena queries, it is recommended that you also select the AutoComplete option **NOTE:** The trailing “/” in the folder path is required!

1. Also set a location bucket in the workgroup (default workgroup name is primary). Navigate to Athena workgroups, choose "primary", then click "Edit" button. Set the location bucket and save settings. It can be the same bucket as for the Query Editor.


##### 2. Prepare CUR & Athena Integration
{{% notice note %}}
Before you can use the AWS CloudFormation template to automate an Athena integration, you must wait for the first Cost and Usage Report to be delivered to your Amazon S3 bucket.
{{% /notice %}}

To streamline and automate integration of your Cost and Usage Reports with Athena, AWS provides an AWS CloudFormation template with several key resources along with the reports you setup for Athena integration. The AWS CloudFormation template includes an AWS Glue crawler, an AWS Glue database, and an AWS Lambda event.

1. From the services list, choose **S3**

1. Navigate to the S3 bucket where the **Cost & Usage Report** was saved

1. Select the Object named after the **prefix** defined when your Cost & Usage Report was created (Step 11 in [Prepare Cost & Usage Report](prepare-cur.html))

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


### Enable QuickSight 
QuickSight is the AWS Business Intelligence tool that will allow you to not only view the Standard AWS provided insights into all of your accounts, but will also allow to produce new versions of the Dashboards we provide or create something entirely customized to you. You will require QuickSight Enterprise Edition. If you are already a regular QuickSight user you can skip these steps and move on to the next step. If not, complete the steps below.

{{%expand "Click here - to setup QuickSight" %}}
#### Enable QuickSight:

1. Log into your AWS Account and search for **QuickSight** in the list of Services

1. You will be asked to **sign up** before you will be able to use it

    ![QuickSight Sign up Workflow Image](https://wellarchitectedlabs.com/Cost/200_Cloud_Intelligence/Images/QS-signup.png?classes=lab_picture_small)

1. After pressing the **Sign up** button you will be presented with 2 options, please ensure you select the **Enterprise Edition** during this step

1. Select **continue** and you will need to fill in a series of options in order to finish creating your account. 

    + Ensure you select the region that is most appropriate based on where your S3 Bucket is located containing your Cost & Usage Report file.

        ![Select Region and Amazon S3 Discovery](/Cost/200_Cloud_Intelligence/Images/QS-s3.png?classes=lab_picture_small)
    
    + Enable the Amazon S3 option and select the bucket where your **Cost & Usage Report** is stored, as well as your **Athena** query bucket

        ![Image of s3 buckets that are linked to the QuickSight account. Enable bucket and give Athena Write permission to it.](/Cost/200_Cloud_Intelligence/Images/QS-bucket.png?classes=lab_picture_small)

1. Click **Finish** and wait for the congratulations screen to display

1. Click **Go to Amazon QuickSight**

![](/Cost/200_Cloud_Intelligence/Images/Congrats-QS.png?classes=lab_picture_small)
{{% /expand%}}



{{< prev_next_button link_prev_url="./cost-usage-report-dashboards/" link_next_url="../2a_cost_intelligence_dashboard" />}}
