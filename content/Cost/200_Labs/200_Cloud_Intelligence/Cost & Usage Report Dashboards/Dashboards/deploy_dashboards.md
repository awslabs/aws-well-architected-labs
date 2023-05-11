---
title: "Deploy Dashboards"
date: 2022-10-10T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1 </b>"
---

## Authors
- Yuriy Prykhodko, AWS Principal Technical Account Manager
- Iakov Gan, AWS Sr. Technical Account Manager
- Thomas Buatois, AWS Cloud Infrastructure Architect (ProServe)

## Contributors
- Aaron Edell, Global Head of Business and GTM - Customer Cloud Intelligence
---


## Setup
We recommend deployment of **CUDOS**, **KPI** and **Cost Intelligence Dashboard** in a dedicated account, other than your Management (Payer) Account. This Lab provides a Cloud Formation template to move data from your Management Account to a dedicated one. You can use it deploy the dashboards on top of multiple Management (Payer) Accounts or multiple linked accounts.

If you do not want to use CloudFormation to setup your dashboards, you have an option of [using our command line tool](../alternative_deployments).


{{< rawhtml >}}
<iframe width="560" height="315" src="https://www.youtube.com/embed/uAiYmJu99zU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
{{< /rawhtml >}}


## Architecture

![Images/arch5.png](/Cost/200_Cloud_Intelligence/Images/arch5.png?classes=lab_picture_small)
The Cost and Usage report (CUR) is generated in one or multiple Management (Payer) accounts. S3 replication copies CUR files from **Source** (**Management Account**) to the **Destination** (**Data Collection Account**).

This architecture supports aggregation of CURs from multiple **Sources** to one **Data Collection Account**. This is useful if you want have visibility across multiple Management (Payer) Accounts.

Also the same aggregation can be used when you do not have access to the Management (Payer) account and you need visibility across multiple Linked Accounts that belong to a single Business Unit.

## Deployment overview

![Images/arch6.png](/Cost/200_Cloud_Intelligence/Images/arch6.png?classes=lab_picture_verysmall)

There are 3 major steps in the Deployment:
* #1. Deploy a bucket for aggregated CUR in the **Data Collection Account**
* #2. Deploy CUR, bucket and a replication policy in **Source** Accounts (can be one or many Sources).
* #3. Deploy Cloud Intelligence Dashboards (CID) Stack in **Data Collection Account**

If your Management(payer) / Source  account is the same as your Destination account (where you want to deploy the dashboards) you can follow the steps for **Destination Account** only, and choose to activate Local CUR in the CFN parameter.

## CUR Bucket Structure
Each indivudal CUR has a prefix `cur/<account>` so the aggregated CUR has the following structure:

```html
s3://<prefix>-<destination-accountid>-shared/
	cur/<src-account1>/cid/cid/year=XXXX/month=YY/*.parquet
	cur/<src-account2>/cid/cid/year=XXXX/month=YY/*.parquet
	cur/<src-account3>/cid/cid/year=XXXX/month=YY/*.parquet
```
This structure allows easily aggregate multiple CURs and allow a Glue crawler manage partitions: source_account_id, year, and month.

Using existing CUR is possible in a limited number of cases. See [FAQ](/cost/200_labs/200_cloud_intelligence/faq/#can-i-use-exising-cost-and-usage-report-cur-instead-of-the-one-created-by-cid).

## Deployment

### Step 1. (IN DATA COLLECTION ACCOUNT) Create Destination For CUR Aggregation

Here we will deploy the CFN template but setting the CFN parameters for a Destination Account.

1. Login to the Destination account in the region of your choice. It can be any account inside or outside your AWS Organization.
   
2. Click the **Launch Stack button** below to open the **pre-populated stack template** in your CloudFormation console.


[![LaunchStack](/images/LaunchStack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?&templateURL=https://aws-managed-cost-intelligence-dashboards.s3.amazonaws.com/cfn/cur-aggregation.yaml&stackName=CID-CUR-Destination&param_CreateCUR=False&param_DestinationAccountId=REPLACE%20WITH%20THE%20CURRENT%20ACCOUNT%20ID&param_SourceAccountIds=PUT%20HERE%20PAYER%20ACCOUNT%20ID)

3. Enter your **Destination** Account Id (Current Account). 

   **NOTE:** Please note this Account ID, we will need it later when we will deploy this same stack in your management (payer)/source accounts.
    ------------ | -------------

![Images/multi-account/advanced-step1.png](/Cost/200_Cloud_Intelligence/Images/multi-account/advanced-step1.png?classes=lab_picture_small)


4. Disable CUR creation by entering **False** as the parameter value if you are replicating CURs from management (payer) accounts. You will only need to activate this if you are replicating CURs from linked accounts (not management payer accounts) and you want to have cost and usage data for this Destination account as well.
   
5. Enter your **Source Account(s)** IDs, using commas to separate multiple Account IDs. 
   
6.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources**, and click **Create stack**.

7. You will see the stack will start with **CREATE_IN_PROGRESS**.

   **NOTE:** This step can take 5-15mins
    ------------ | -------------

8. Once complete, the stack will show **CREATE_COMPLETE**.

You will be able to add or delete Source Account CURs later by updating this stack and adding or deleting Management (Payer) Account ID in a comma separated list of Source Accounts.


### Step 2. (IN PAYER / SOURCE ACCOUNT) Create CUR and Replication

{{%expand "Click here if you are installing dashboards in Management / Payer Account." %}}

**WARNING**: Please note that it is typically recommended to install dashboards in a dedicated Data Collection Account in order to keep the number of users in Payer to a minimum. However, if you do decide to proceed with installing dashboards in a Payer Account, we recommend taking steps to mitigate any associated risks. This could include limiting access to a smaller team or implementing better access control measures.
    ------------ | -------------

You need to update the stack created on **Step 1** with parameters:
* CreateCUR = True
* and also set your SourceAccountID (the same as destinaton).

Then go directly to the **[Step 3](#step-3-in-data-collection-account-deploy-dashboards)**.
------------ | -------------

{{% /expand%}}


1. Login to your Source Account (can be management account or linked account if you're using [member CURs](https://aws.amazon.com/about-aws/whats-new/2020/12/cost-and-usage-report-now-available-to-member-linked-accounts/)).

2. Click the **Launch Stack button** below to open the **stack template** in your CloudFormation console.

	[![LaunchStack](/images/LaunchStack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?&templateURL=https://aws-managed-cost-intelligence-dashboards.s3.amazonaws.com/cfn/cur-aggregation.yaml&stackName=CID-CUR-Replication&param_CreateCUR=True&param_DestinationAccountId=REPLACE%20WITH%20DATA%20COLLECTION%20ACCOUNT%20ID&param_SourceAccountIds=)


3. Enter a **Stack name** for your template such as **CID-CUR-Replication**.

4. Enter your **Destination** AWS Account ID as a parameter (Your Data Collection Account, where you will deploy dashboards).

![Images/multi-account/advanced-step2.png](/Cost/200_Cloud_Intelligence/Images/multi-account/advanced-step2.png?classes=lab_picture_small)

6.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.

7. You will see the stack will start with **CREATE_IN_PROGRESS** .
   **NOTE:** This step can take 5-15mins
    ------------ | -------------

8.  Once complete, the stack will show **CREATE_COMPLETE**.


9. It will take about 24 hours for your CUR to populate and replicate to your destination (data collection) account where you will deploy the dashboards. You can continue, but the dashboards will be empty. Or you can return to the next steps after 24 hours. We also recommend creating a Support Case in Service=`Billing` and Category=`Invoices and Reporting`, requesting a backfill of your CUR (name=`cid`) with 12 months of data. Case must be created from your Source Account (Management/Payer account).

## Step 3. (IN DATA COLLECTION ACCOUNT) Deploy Dashboards

### 3.1 Enable QuickSight Enterprise

QuickSight is the AWS Business Intelligence tool that will allow you to not only view the Standard AWS provided insights into all of your accounts, but will also allow to produce new versions of the Dashboards we provide or create something entirely customized to you. If you are already a regular QuickSight user you can skip these steps and move on to the next step. If not, complete the steps below.

1. Log into your Destination Linked Account and search for **QuickSight** in the list of Services

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

### 3.2 Deploy Dashboards using CloudFormation
In this option we use guide you through using a CloudFormation template that will deploy **all needed resources**. You will cut and paste some parameters (An S3 path to CUR data, A QuickSight user that will be the owner of the QuickSight assets, and which dashboards you want to deploy) into the template and click run. 

All other resources are created automatically: Athena Workgroup and bucket, Glue table, Crawler, QS dataset, and finally the dashboards. The template uses a custom resource (a Lambda with [this CLI tool](https://github.com/aws-samples/aws-cudos-framework-deployment/)) to create, delete, or update assets. 

1. Login into your Linked (Data Collection) Account

2. Click the **Launch Stack button** below to open the **pre-populated stack template** in your CloudFormation.

	[![LaunchStack](/images/LaunchStack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?templateURL=https://aws-managed-cost-intelligence-dashboards.s3.amazonaws.com/cfn/cid-cfn.yml&stackName=Cloud-Intelligence-Dashboards&param_DeployCUDOSDashboard=yes&param_DeployKPIDashboard=yes&param_DeployCostIntelligenceDashboard=yes)

3. Enter a **Stack name** for your template such as **Cloud-Intelligence-Dashboards**
4. Review **Common Parameters** and confirm prerequisites before specifying the other parameters. You must answer 'yes' to both prerequisites questions.
5. Copy and paste your **QuicksightUserName** into the parameter text box.

To find your QuickSight username:
	- Open a new tab or window and navigate to the **QuickSight** console
	- Find your username in the top right navigation bar
![Images/cf_dash_qs_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_qs_2.png?classes=lab_picture_small)

1. Update your **CURBucketPath** if needed.
   1. (Default) If you used the CFN Template in the CUR setup process above then **CURBucketPath** needs to be the s3 path to the folder in your CUR bucket where account IDs are. For example `s3://cid-1234567890123-shared/cur/`
   2. If you did *not* use the CFN automated CUR setup process above and have just one CUR you setup manually then **CURBucketPath** needs to be the s3 path to the folder in your CUR bucket where the year folders are. For example `s3://cid-1234567890123-shared/prefix/name/name/` (double check this path, you must see /year=xxxx partitions in there).

   Please note that **CURBucketPath** parameter currently cannot be updated once the stack is created. If you need to change it you can delete and re-create the stack.

2. Select the Dashboards you want to install. We recommend deploying all three: Cost Intelligence Dashboard, CUDOS, and the KPI Dashboard.

3.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.

4.  You will see the stack will start in **CREATE_IN_PROGRESS**
   **NOTE:** This step can take 5mins
    ------------ | -------------

1. Once complete, the stack will show **CREATE_COMPLETE**

2. While this is working, head back to QuickSight and click on manage Quicksight from the person icon on the top right.

![quicksightpermissionss3_1](/Cost/200_Cloud_Intelligence/Images/quicksightpermissionss3_1.png?classes=lab_picture_small)

10. Select Security and permissions. Under QuickSight access to AWS services click manage. Select Athena, S3, and in S3 select both your CUR bucket **and** Query results bucket (Ex: will be something like `aws-athena-query-results-cid-1234567890123-us-east-1`). If you do not see this bucket, please check if it is created by the CloudFormation stack.

![quicksightpermissionss3_2](/Cost/200_Cloud_Intelligence/Images/quicksightpermissionss3_2.png?classes=lab_picture_small)

11. Navigate back to CloudFormation and to the **Output of the Stack** tab and check dashboard URLS. Click on a URL to open the dashboards.
   **NOTE:** This Output Section will be available once the Stack is Completed
    ------------ | -------------


If you see no data in QuickSight Dahsboards after 24 hours, plase check the following:
 1) Double check that QuickSight has permissions to read from your CUR bucket.
 2) In QuickSight, go to Datasets and click on Summary View. Check for errors (if you see a status `Failed`, you can click it to see more info).
 3) Check if CUR data has arrived to the S3 bucket. If you just created CUR you will need to wait 24 hours before the first data arrives. We also recommend creating a Support Case in Service=`Billing` and Category=`Invoices and Reporting`, requesting a backfill of your CUR (name=cid) with 12 months of data. Case must be created from the same account as CUR (Typically Management/Payer account).
 4) The QuickSight datasets refresh once per day at midnight, if your first CUR was delivered after midnight, you may need to click manual refresh on each dataset to see data in the dashboard. This will auto-resolve after midnight the next night.



Any issue? Visit our [FAQ](../../../faq/#troubleshooting).

If you can see data in your dashboards, you can continue to the [post deployment steps](../post_deployment_steps) for adding Account Names.


---


{{< prev_next_button link_prev_url="../.." link_next_url="../post_deployment_steps" />}}