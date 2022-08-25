---
title: "Multi-Account Setup"
date: 2022-05-20T11:16:08-04:00
chapter: false
weight: 5
pre: "<b>4. </b>"
---

## Authors
- Thomas Buatois, AWS Cloud Infrastructure Architect (ProServe)

## Contributors 
- Iakov Gan, AWS Sr. Technical Account Manager
- Yuriy Prykhodko, AWS Sr. Technical Account Manager
- Aaron Edell, Global Head of Business and GTM - Customer Cloud Intelligence

## Prerequisites

- [Install or Update the AWS CLI]({{< ref "1_prerequistes/#install-or-update-the-aws-cli" >}})
- [Enable QuickSight]({{< ref "1_prerequistes/#enable-quicksight" >}})

## Multi-Account use cases 

In addition to a simple setup that we covered in the previous chapters of this lab, some customer can require a more complex solution to use a dashboard in a multi-payer or multi-account setup. This chapter will cover several typical use cases and provide deep dive on automated way to aggregate the Cost and Usage Report data across multiple accounts. 

There are several options to deploy the Cost Intelligence Dashboard (CID) in a multi-account setup.

For each deployment scenario there will be two main section: 
#### 1. Deployment of the CUR Aggregation stack across multiple accounts

Typicaly there are __CUR Aggregation account__ (destination) where all the CUR information will be consolidated and __CUR Replication account__ (source) from where CUR orginated data will be replicated to the CUR Aggregation account. 

In this section of the lab, creation of resources needed for CUR Aggregation will be automated with **CloudFormation templates**. However, if you are not confortable with CloudFormation you can see [manual deployment steps]({{< ref "#manual-deployment" >}}) 

#### 2. Deployment of the Dashboards

{{% notice warning %}}
It can take up to __24 hours__ for AWS to start delivering reports to your Amazon S3 bucket. After delivery starts, AWS updates the AWS Cost and Usage Reports files at least once a day.
__You will need to wait for CUR files delivery before following this steps.__
{{% /notice %}}

After deployment of CUR Aggregation you can deploy Dashboards using __CID command line tool__ or with __CloudFormation__ according the per dashboard deployment documentation. 

## Deployment
### Option 1: From Payer Account

This option is the simplest way to deploy Cost and Usage Report Aggregation for multi account on the __*Payer Account*__ of an AWS Organization. In this case aggregation and dashboards will be deployed in the payer account. 

Due to AWS Organization consolidated billing feature, the CUR of payer account contains report of linked accounts. In this case, the deployment of CUR Aggregation is __only__  necessary in the payer account of your organization. 

However, we do not recommend this option, please consider aggregate CUR in a dedicated account (option 2). This way you can effectivly managed the access and avoid having unnecessary users in your payer account. If you still want to use this option, please apply least priviledge access to your payer account.

#### Multiple Payer Accounts

If you have __multiple payer accounts__, you can follow these steps to configure CUR aggregation for this payer account and use the [add or delete account section]({{< ref "#add-or-delete-accounts-to-an-existing-multi-account-deployment" >}}) steps to add CUR aggregation for other payer accounts.

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
## Deploy Dashboards via CLI

{{% notice warning %}}
It can take up to __24 hours__ for AWS to start delivering reports to your Amazon S3 bucket. After delivery starts, AWS updates the AWS Cost and Usage Reports files at least once a day.
__You will need to wait for CUR files delivery before following this steps.__
{{% /notice %}}

The CID command line tool is way to deploy Dasboards.

1. Navigate to the [Cloud Intelligence Dashboards automation repo]("https://github.com/aws-samples/aws-cudos-framework-deployment#how-to-use") and follow the instructions to install the command line tool..

2. Run the `deploy` command with specific named resources. If you change the default value ResourcePrefix template, please update command accordingly.

```bash
cid-cmd deploy \
  --athena-database centralized-cur-db \
  --athena-workgroup centralized-cur-wk
```

You can re launch this tool with the same parameters to add, update or delete dashboards.

1. Once complete, visit the [account mapping page](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/0_view0/) and follow the steps there to get your account names into the dashboard. 

### Saving and Sharing your Dashboard in QuickSight

Now that you have your dashboard created you can share your dashboard with users or customize your own version of this dashboard
	
- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)	

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




