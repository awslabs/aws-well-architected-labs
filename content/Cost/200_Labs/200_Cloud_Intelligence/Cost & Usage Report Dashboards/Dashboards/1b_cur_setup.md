---
title: "Cost And Usage Report Setup"
date: 2022-05-20T11:16:08-04:00
chapter: false
weight: 5
pre: "<b>4. </b>"
---

## Authors
- Thomas Buatois, AWS Cloud Infrastructure Architect (ProServe)
- Yuriy Prykhodko, AWS Principal Technical Account Manager

## Contributors
- Iakov Gan, AWS Sr. Technical Account Manager
- Aaron Edell, Global Head of Business and GTM - Customer Cloud Intelligence


## Cost and Usage Report
The [Cost & Usage Report](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html) is the foundation for these dashboards. 

## Deployment options
AWS Customers can have many AWS Accounts and even multiple Payer accounts. Cost Intelligence Dashboards are build to give a visblilty across many accounts. 

If you have __one or several management (payer) accounts__ we recommend to setup Dashboads in a dedicated AWS Account. In this case you will need to create Cost & Usage Reports to export data to S3 in each management (payer) account and then configure an S3 replication to the dedicated account. The replicaiton data volume is relatively small. Please find the automated and manual instructions bellow in the section [#Multi-Account-use-cases]({{< ref "#Multi-Account-use-cases" >}}).

If you want to set up CUR and dashboards in a __single account__ or in management (payer) account, it is also possible, but in this case make sure you apply systematically [least privileges](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#grant-least-privilege). For deployment of CUR see [Manual setup of a CUR]({{< ref "#manual-setup-of-cost-and-usage-report" >}}).

Another frequent use case is __multi linked account__ setup. When AWS customer has a set on AWS Accounts but no access to management (payer) account, then it is possible to configie CUR in each account and set up a replication to one account that will be used for dashboards.

## Cost and Usage Report Format
For dashboards you must have a Cost & Usage Report created with the following format
- Additional report details: Include **Resource IDs**
- Time Granularity: **Hourly**
- Report Versioning: **Overwrite existing report**
- Report data integration for: **Amazon Athena**
- Compression type: **Parquet**


If you do not have a Cost & Usage Report that meets this criteria you can use it, if not, you can create a new CUR and request a backfill. 


## Manual setup of Cost and Usage Report

This option is the simplest way to deploy Cost and Usage Report. In this case aggregation and dashboards will be deployed in the payer account. If you have a payer account, due to AWS Organization consolidated billing feature, the CUR of payer account contains report of all linked accounts. In this case, the deployment of CUR Aggregation is only necessary in the payer account of your organization.

However, we do not recommend this option, please consider aggregate CUR in a dedicated account. This way you can effectivly managed the access and avoid having unnecessary users in your payer account. If you still want to use this option, please apply least priviledge access to your payer account.


{{%expand "Click here see steps for preparing your Cost & Usage report and Athena integraton manually" %}}
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


## Multi-Account use cases

AWS Customers often use dashboards in a multi-payer or multi-account setup. This section will cover several typical use cases and provide deep dive on automated way to aggregate the Cost and Usage Report data across multiple accounts.

If you have multiple payer accounts or if you just want to transfer CUR from payer to a deducated account, you can follow these steps to configure CUR aggregation. Also you can [add or delete account]({{< ref "#add-or-delete-accounts-to-an-existing-multi-account-deployment" >}}) after the initial setup.

{{%expand "Click here to continue with the CloudFormation Deployment" %}}

### Enable CUR Aggregation using a CloudFormation Template

1. Login to the __**Payer Account**__  of your AWS Organization.
2. Change your console region to __N. Virginia__ - __us-east-1__. This is needed because CUR Definition resource is only available on `us-east-1` region. If you need another region, please refer to [advanced section]({{< ref "#outside-north-virginia---us-east-1-region-deployment" >}}).

![Images/multi-account/cf_dash_1_choose_region.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cf_dash_choose_region_1.png?classes=lab_picture_small)

3. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**.

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/cur-aggregation.yaml)
	
![Images/multi-account/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images//multi-account/cf_dash_launch_2.png?classes=lab_picture_small)

4. Enter a **Stack name** for your template such as **CID-SinglePayerDeployment**.
![Images/multi-account/cfn_dash_param.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param.png?classes=lab_picture_small)

5. Enter your **current** AWS Account Id parameter.
   
![Images/multi-account/cfn_dash_param_1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_1.png?classes=lab_picture_small)

6. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page.

7.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

8. You will see the stack will start in **CREATE_IN_PROGRESS** .
**NOTE:** This step can take 5-15mins
    ------------ | -------------

9.  Once complete, the stack will show **CREATE_COMPLETE**.
10. You will need to wait __24 hours__ for the first CUR delivery before starting deployment of the dashboards. Please refer to the [deploy dashboard section]({{< ref "#deploy-dashboards-via-cli" >}}) of the lab. Entreprise Support customers can reach out to their TAM and ask for a backfill of their CUR data.

{{% /expand%}}

### Option 2: (Recomended) From Payer Account(s) to a Dedicated CUR Aggregation Account 

This option is the recommanded way to deploy Cost and Usage Report (CUR) Aggregation for multiple account on a dedicated __**CUR Aggregation Account**__.

Due to AWS Organization consolidated billing feature, all billing information is consolidated inside the CUR of the __**Payer Account**__. To enable CUR aggregation on a dedicated account, we need to replicate CUR data from payer account to the CUR aggregation account. 

#### Multiple Payer Accounts

If you have __multiple payer accounts__, you can follow these steps to configure CUR replication in a dedicated aggregation account and use the [add or delete account section]({{< ref "#add-or-delete-accounts-to-an-existing-multi-account-deployment" >}}) steps to add CUR aggregation for other payer accounts.
 **NOTE:** In case of a mutliple payer setup, due to consolidated billing feature of AWS Organization, you only need to reference (and deploy replication) on the payer accounts. 
    ------------ | -------------


{{%expand "Click here to continue with the CloudFormation Deployment" %}}
### Deploy CUR Collection on CUR Aggregation Account 

1. Login to the __account you choose for CUR Aggregation__. I can be any account inside or outside your  AWS Organization.
   
2. Change your console region to __N. Virginia__ - __us-east-1__. This is needed because CUR Definition resource is only available on `us-east-1` region. If you need another region, please refer to [advanced section]({{< ref "#outside-north-virginia---us-east-1-region-deployment" >}}).

![Images/multi-account/cf_dash_1_choose_region.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cf_dash_choose_region_1.png?classes=lab_picture_small)

3. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**.

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/cur-aggregation.yaml)
	
![Images/multi-account/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images//multi-account/cf_dash_launch_2.png?classes=lab_picture_small)

4. Enter a **Stack name** for your template such as **CID-DedicatedDataCollectionAccount**
![Images/multi-account/cfn_dash_param_2.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_2.png?classes=lab_picture_small)

5. Enter your **current** AWS Account Id. 
   
![Images/multi-account/cfn_dash_param_6.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_6.png?classes=lab_picture_small)

**NOTE:** Please note this Account Id, we will need it later when we will deploy stack in replication account.

6. Enter your **Payer Account** AWS Account Id as parameter value. 
   
![Images/multi-account/cfn_dash_param_3.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_3.png?classes=lab_picture_small)

7. Disable CUR creation by entering **False**  as parameter value. 
   
![Images/multi-account/cfn_dash_param_4.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_4.png?classes=lab_picture_small)

8. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page.

9.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

10. You will see the stack will start in **CREATE_IN_PROGRESS**.
**NOTE:** This step can take 5-15mins
    ------------ | -------------

11. Once complete, the stack will show **CREATE_COMPLETE**.

### Deploy CUR Replication on Organization Payer Account 

1. Login to the __**Payer Account**__ of your AWS Organization.
2. Change your console region to __N. Virginia__ - __us-east-1__. This is needed because CUR Definition resource is only available on `us-east-1` region. If you need another region, please refer to [advanced section]({{< ref "#outside-north-virginia---us-east-1-region-deployment" >}}).

![Images/multi-account/cf_dash_1_choose_region.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cf_dash_choose_region_1.png?classes=lab_picture_small)

3. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**.

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/cur-aggregation.yaml)
	
![Images/multi-account/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images//multi-account/cf_dash_launch_2.png?classes=lab_picture_small)

4. Enter a **Stack name** for your template such as **CID-CURReplication**.
![Images/multi-account/cfn_dash_param_5.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_5.png?classes=lab_picture_small)

5. Enter your __**CUR Aggregation**__ AWS Account Id. 
![Images/multi-account/cfn_dash_param_1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_1.png?classes=lab_picture_small)

6. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page.

7.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

8. You will see the stack will start in **CREATE_IN_PROGRESS**.
**NOTE:** This step can take up to 5 mins
    ------------ | -------------

9.  Once complete, the stack will show **CREATE_COMPLETE**.
10. You will need to wait __24 hours__ for the first CUR delivery before starting deployment of the dashboards. Please refer to the [deploy dashboard section]({{< ref "#deploy-dashboards-via-cli" >}}) of the lab. Entreprise Support customers can reach out to their TAM and ask for a backfill of their CUR data.

{{% /expand%}}
 
### Option 3: From Multiple Linked Account to a Dedicated CUR Aggregation Account 

This option is a way to deploy Cost and Usage Report CUR Aggregation for __multiple linked accounts__. 

You will have to chosse one of the account to act as a __CUR Aggregation Account__ (destination) and other accounts will act as __CUR Replication Account__ (source). 

This type of deployment is particulary useful for organization with a lot of account where sub-organization or business unit are responsible for a sub-set of account and wants to enable 
CUR aggregation and vizualization only for this sub-set of accounts. 

{{%expand "Click here to continue with the CloudFormation Deployment" %}}
### Deploy CUR Aggregation

1. Login to the choosen __CUR Aggregation Account__. Remember, this account will aggregate CUR data for all accounts we will list at step 6, including itself.
   
2. Change your console region to __N. Virginia__ - __us-east-1__. This is needed because CUR Definition resource is only available on `us-east-1` region. If you need another region, please refer to [advanced section]({{< ref "#outside-north-virginia---us-east-1-region-deployment" >}}).

![Images/multi-account/cf_dash_1_choose_region.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cf_dash_choose_region_1.png?classes=lab_picture_small)

3. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**.

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/cur-aggregation.yaml)
	
![Images/multi-account/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images//multi-account/cf_dash_launch_2.png?classes=lab_picture_small)

4. Enter a **Stack name** for your template such as **CID-DedicatedDataCollectionAccount**.
![Images/multi-account/cfn_dash_param_2.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_2.png?classes=lab_picture_small)

5. Enter your **current** AWS Account Id. 
   
![Images/multi-account/cfn_dash_param_6.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_6.png?classes=lab_picture_small)

**NOTE:** Please note this Account Id, we will need it later.

6. Enter **all other accounts** AWS Account Id as parameter value seperated by a comma `,`. 

![Images/multi-account/cfn_dash_param_3.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_3.png?classes=lab_picture_small)

7. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page.

8.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

9. You will see the stack will start in **CREATE_IN_PROGRESS** 
**NOTE:** This step can take 5-15mins
    ------------ | -------------

10.  Once complete, the stack will show **CREATE_COMPLETE**

### Deploy CUR Replication on Other Accounts

For __each__ account you would like to enable cur replication, follow this steps:

**NOTE:** In case of a mutli payer setup, due to consolidated billing feature of AWS Organization, you only need to deploy this on the payer accounts. 
    ------------ | -------------

1. Login to the __**Account**__ you like to enable cur replication for.
2. Change your console region to __N. Virginia__ - __us-east-1__. This is needed because CUR Definition resource is only available on `us-east-1` region. If you need another region, please refer to [advanced section]({{< ref "#outside-north-virginia---us-east-1-region-deployment" >}}).

![Images/multi-account/cf_dash_1_choose_region.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cf_dash_choose_region_1.png?classes=lab_picture_small)

3. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**.

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/cur-aggregation.yaml)
	
![Images/multi-account/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images//multi-account/cf_dash_launch_2.png?classes=lab_picture_small)

4. Enter a **Stack name** for your template such as **CID-CURReplication**.
![Images/multi-account/cfn_dash_param_5.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_5.png?classes=lab_picture_small)

5. Enter your __CUR Aggregation Account__ AWS Account Id. 
![Images/multi-account/cfn_dash_param_1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_1.png?classes=lab_picture_small)

6. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page.

7.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

8. You will see the stack will start in **CREATE_IN_PROGRESS** 
**NOTE:** This step can take up to 5mins
    ------------ | -------------

9.  Once complete, the stack will show **CREATE_COMPLETE**
10.  You will need to wait __24 hours__ for the first CUR delivery before starting deployment of the dashboards. Please refer to the [deploy dashboard section]({{< ref "#deploy-dashboards-via-cli" >}}) of the lab. Entreprise Support customers can reach out to their TAM and ask for a backfill of their CUR data.

{{% /expand%}}
## Advanced

### Add or delete accounts to an existing multi-account deployment

{{% notice warning %}}
This section is only available if you already deploy CUR Aggregation with previous options. 
{{% /notice %}}

You may need to add or delete existing account from your CUR Aggregation. 

{{%expand "Click here to continue with the CloudFormation Deployment" %}}

1. Login to the __CUR Aggregation__ Account.
   
2. Change your region to __N. Virginia__ - __us-east-1__
   
![Images/multi-account/cf_dash_1_choose_region.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cf_dash_choose_region_1.png?classes=lab_picture_small)

3. Find your existing template and chosse __Update__

![Images/multi-account/cfn_dash_param_10.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_10.png?classes=lab_picture_small)

4. Check __Use current template__ then choose __Next__

![Images/multi-account/cfn_dash_param_11.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_11.png?classes=lab_picture_small)

5. Update AWS Account Ids list to modify CUR aggregation
    
![Images/multi-account/cfn_dash_param_1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_1.png?classes=lab_picture_small)


6. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page

7.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

8. You will see the stack will start in **UPDATE_IN_PROGRESS** 
**NOTE:** This step can take up to 5mins
    ------------ | -------------

9.  Once complete, the stack will show **UPDATE_COMPLETE**

**NOTE:** Deleting an account means that cur data will not flow to your CUR aggregation account anymore. However, historical data will be retain. To delete them, go to the `${payer-account-id}-cur-centralizer-shared` S3 Bucket and manualy delete account data. 
    ------------ | -------------
### On Deletion

1. Login to the Account you want to delete.
   
2. Change your region to __N. Virginia__ - __us-east-1__
   
![Images/multi-account/cf_dash_1_choose_region.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cf_dash_choose_region_1.png?classes=lab_picture_small)

3. Find your existing template and chosse __Delete__

![Images/multi-account/cfn_dash_param_12.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_12.png?classes=lab_picture_small)


### On Addition

1. Login to the __**Account**__ you like to enable cur collection for
2. Change your region to __N. Virginia__ - __us-east-1__

![Images/multi-account/cf_dash_1_choose_region.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cf_dash_choose_region_1.png?classes=lab_picture_small)

3. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/cur-aggregation.yaml)
	
![Images/multi-account/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images//multi-account/cf_dash_launch_2.png?classes=lab_picture_small)

4. Enter a **Stack name** for your template such as **CID-CURReplication**
![Images/multi-account/cfn_dash_param_5.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_5.png?classes=lab_picture_small)

1. Enter your __**CUR Aggregation**__ AWS Account Id . 
![Images/multi-account/cfn_dash_param_1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_1.png?classes=lab_picture_small)

6. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page

7.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

8. You will see the stack will start in **CREATE_IN_PROGRESS** 
**NOTE:** This step can take up to 5mins
    ------------ | -------------

9.  Once complete, the stack will show **CREATE_COMPLETE**

{{% /expand%}}

### Outside North Virginia - `us-east-1` region deployment

You may want to deploy resources in an other region than `us-east-1`, for security or governance reasons.

{{% notice tip %}}
AWS CloudFormation deploy resources regionaly, this means that if we need to deploy resources in multiple region we need to deploy multiple CloudFormation templates. This is our case here, collection resources are available in many different region but CUR definition `AWS::CUR::ReportDefinition` however is only available in `us-east-1`.
{{% /notice %}}


The following step shows how to deploy CUR Aggregation resources on the region of your choosing. Lets say here `eu-west-1`


{{%expand "Click here to continue with the CloudFormation Deployment" %}}
### Enable CUR Aggregation

1. Login to the __**Payer Account**__  of your AWS Organization
2. Change your region to __Europe (Ireland) - eu-west-1__

![Images/multi-account/cf_dash_choose_region_2.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cf_dash_choose_region_2.png?classes=lab_picture_small)

3. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/cur-aggregation.yaml)
	
![Images/multi-account/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images//multi-account/cf_dash_launch_2.png?classes=lab_picture_small)

4. Enter a **Stack name** for your template such as **CID-SinglePayerDeployment**
![Images/multi-account/cfn_dash_param.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param.png?classes=lab_picture_small)

5. Enter your **current** AWS Account Id parameter
   
![Images/multi-account/cfn_dash_param_1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_1.png?classes=lab_picture_small)

6. Change the bucket region to your __current region__, here `eu-west-1`

![Images/multi-account/cfn_dash_param_7.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_7.png?classes=lab_picture_small)

7. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page

8.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

9. You will see the stack will start in **CREATE_IN_PROGRESS** 
**NOTE:** This step can take 5-15mins
    ------------ | -------------
10.  Once complete, the stack will show **CREATE_COMPLETE**
 
### Enable Cost and Usage report on `us-east-1`

1. Login to the __**Payer Account**__ of your AWS Organization
2. Change your region to __N. Virginia__ - __us-east-1__

![Images/multi-account/cf_dash_1_choose_region.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cf_dash_choose_region_1.png?classes=lab_picture_small)

3. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/cur-aggregation.yaml)
	
![Images/multi-account/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images//multi-account/cf_dash_launch_2.png?classes=lab_picture_small)

4. Enter a **Stack name** for your template such as **CID-CURDefinition**
![Images/multi-account/cfn_dash_param_8.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_8.png?classes=lab_picture_small)

5. Enter your __current__ AWS Account Id . 
![Images/multi-account/cfn_dash_param_1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_1.png?classes=lab_picture_small)

6. Change the bucket region to region of the CUR aggregation deployment, here `eu-west-1`

![Images/multi-account/cfn_dash_param_9.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_9.png?classes=lab_picture_small)

7. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page

8.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

9. You will see the stack will start in **CREATE_IN_PROGRESS** 
**NOTE:** This step can take up to 5 mins
    ------------ | -------------
10.  Once complete, the stack will show **CREATE_COMPLETE**
{{% /expand%}}
### Manual deployment

This scenario allows customers with multiple payer (management) accounts to deploy all the CUR dashboards on top of the aggregated data from multiple payers. To fulfill prerequisites customers should set up or have setup a new Governance Account. The payer account CUR S3 buckets will have S3 replication enabled, and will replicate to a new S3 bucket in your separate Governance account.
{{%expand "Click here to expand step by step instructions" %}}

![Images/CUDOS_multi_payer.png](/Cost/200_Cloud_Intelligence/Images/CUDOS_multi_payer.png?classes=lab_picture_small)

**NOTE: These steps assume you've already setup the CUR to be delivered in each payer (management) account.**

#### Setup S3 CUR Bucket Replication

1. Create or go to the console of your Governance account. This is where the Cloud Intelligence Dashboards will be deployed. Your payer account CURs will be replicated to this account. Note the region, and make sure everything you create is in the same region. To see available regions for QuickSight, visit [this website](https://docs.aws.amazon.com/quicksight/latest/user/regions.html). 
2. Create an S3 bucket with enabled versioning.
3. Open S3 bucket and apply following S3 bucket policy with replacing respective placeholders {PayerAccountA}, {PayerAccountB} (one for each payer account) and {GovernanceAccountBucketName}. You can add more payer accounts to the policy later if needed.

```json
{
"Version": "2008-10-17",
"Id": "PolicyForCombinedBucket",
"Statement": [
	{
		"Sid": "Set permissions for objects",
		"Effect": "Allow",
		"Principal": {
    		"AWS": ["{PayerAccountA}","{PayerAccountB}"]
		},
		"Action": [
    		"s3:ReplicateObject",
    		"s3:ReplicateDelete"
		],
		"Resource": "arn:aws:s3:::{GovernanceAccountBucketName}/*"
	},
	{
		"Sid": "Set permissions on bucket",
		"Effect": "Allow",
		"Principal": {
		    "AWS": ["{PayerAccountA}","{PayerAccountB}"]
		},
		"Action": [
 		   "s3:List*",
 		   "s3:GetBucketVersioning",
 		   "s3:PutBucketVersioning"
		],
		"Resource": "arn:aws:s3:::{GovernanceAccountBucketName}"
	},
	{
		"Sid": "Set permissions to pass object ownership",
		"Effect": "Allow",
		"Principal": {
		    "AWS": ["{PayerAccountA}","{PayerAccountB}"]
		},
		"Action": [
    		"s3:ReplicateObject",
    		"s3:ReplicateDelete",
    		"s3:ObjectOwnerOverrideToBucketOwner",
    		"s3:ReplicateTags",
    		"s3:GetObjectVersionTagging",
    		"s3:PutObject"
		],
		"Resource": "arn:aws:s3:::{GovernanceAccountBucketName}/*"
	}
]
}
```

This policy supports objects encrypted with either SSE-S3 or not encrypted objects. For SSE-KMS encrypted objects additional policy statements and replication configuration will be needed: see https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-config-for-kms-objects.html

#### Set up S3 bucket replication from each Payer (Management) account to S3 bucket in Governance account

This step should be done in each payer (management) account.

1. Open S3 bucket in Payer account with CUR.
2. On Properties tab under Bucket Versioning section click Edit and set bucket versioning to Enabled.
3. On Management tab under Replication rules click on Create replication rule.
4. Specify rule name.

![Images/s3_bucket_replication_1.png](/Cost/200_Cloud_Intelligence/Images/s3_bucket_replication_1.png?classes=lab_picture_small)

5. Select Specify a bucket in another account and provide Governance account id and bucket name in Governance account.
6. Select Change object ownership to destination bucket owner checkbox.
7. Select Create new role under IAM Role section.

![Images/s3_bucket_replication_2.png.png](/Cost/200_Cloud_Intelligence/Images/s3_bucket_replication_2.png?classes=lab_picture_small)

8. Leave rest of the settings by default and click Save.

#### Copy existing objects from CUR S3 bucket to S3 bucket in Governance account

This step should be done in each payer (management) account.

Sync existing objects from CUR S3 bucket to S3 bucket in Governance account.

	aws s3 sync s3://{curBucketName} s3://{GovernanceAccountBucketName} --acl bucket-owner-full-control

After performing this step in each payer (management) account S3 bucket in Governance account will contain CUR data from all payer accounts under respective prefixes.

#### Prepare Glue Crawler 

These actions should be done in Governance account

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



{{< prev_next_button link_prev_url="../1a_prerequistes" link_next_url="../1c_quicksight" />}}


