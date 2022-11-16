---
title: "Row Level Security"
date: 2022-11-16T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>4. </b>"
---
## Last Updated

November 2022

## Introduction

CID allows everyone in your organization to understand your cost data by exploring interactive dashboards that you manage. However, having all data available for all users can be too overwhelming and mean it is more difficult to find the data they care about. Using [Row Level Security](https://docs.aws.amazon.com/quicksight/latest/user/restrict-access-to-a-data-set-using-row-level-security.html) (RLS) enables you to restrict the data a user can see to just what they are allowed to. This works for Multiple Payers.

## PrerRequisite

For this solution you must have the following:

* Access to your AWS Organizations and ability to tag resources
* An AWS Cost and Usage Reports (https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html) (CUR) or if from the multiple payers these must be replicated into a bucket, more info here (https://wellarchitectedlabs.com/cost/100_labs/100_1_aws_account_setup/3_cur/#option-2-replicate-the-cur-bucket-to-your-cost-optimization-account-consolidate-multi-payer-curs)
* A CID deployed over this CUR data, checkout the new single deployment method here (https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/deploy_dashboards/)
* A list of users and what level of access they require. This can be member accounts, organizational units (OU) or payers. 


## Solution 
This solution will use tags from your AWS Organization resources to create a dataset that will be used for the Row Level Security.

![Images/customizations_rls_architecture.png](/Cost/200_Cloud_Intelligence/Images/customizations_rls_architecture.png?classes=lab_picture_small)


## Step by Step Guide

### Roles

If you are deploying this in a linked account you will need a Role in you Management account to let you access your AWS Organizations Data. There are two options for this:

**Option1** If you already have the [Optimization Data Collector Lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/1_grant_permissions/#12-role-for-management-account) deployed you can use the Management role in that. 
**Option2** Else, you can deploy using the below:

1.  Log into your **Management account** then click [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/Management.yaml&stackName=OptimizationManagementDataRoleStack)

2. Call the Stack **OptimizationManagementDataRoleStack**

3. In the Parameters section set **CostAccountID** as the ID of Cloud ntelligence Dashboard

4. Scroll to the bottom and click **Next**

5. Tick the acknowledge boxes and click **Create stack**.

6. You can see the role that was collected by clicking on **Resources** and clicking on the hyperlink under **Physical ID**.
![Images/Managment_CF_deployed.png](/Cost/300_Optimization_Data_Collection/Images/Managment_CF_deployed.png)

### Tag your AWS Organization Resources

You must tag the AWS Organization Resources with the emails of the Quicksight Users that you wish to see the resources cost data. The below will show you how to tag a resource and this can be repeated. 

1. Log into your **Management account** then click on the top right hand corner on your account and select **Organization**
2. Ensure you are on the **AWS accounts**

You can select different levels of access. Tag one of the following and the use will have access to all data of that resource and any child accounts below it.

* Tag an Account
* Tag an Organization Unit
* Tag the Root 

3. To tag the resource click its name an scroll down to the tag section and click **Manage tags**

4. Add the Key **cudos_users** and the Value of any **emails** you wish to allow access. These are **colon delimited**. Once added click **Save changes**

5. Repeat on all resources with relevant emails. 

## Deploy Lambda Function

Using AWS CloudFormation we will deploy the lambda function to collect these tags. 

1. Log into your account with CID. Click [Launch CloudFormation template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/200_200_Cloud_Intelligence/cudos_rls.yaml&stackName=CIDRowLevelSecurity) 

2. Fill in the Parameters as seen below.

* CodeBucket - LEAVE AS DEFAULT
* CodeKey - LEAVE AS DEFAULT
* DestinationBucket - Amazon S3 Bucket in your account in the same region (this can be one from your Optimization data collector where where your CUR is stored)
* ManagementAccountID - List of Payer IDs you wish to collect data for. Can just be one Accounts(Ex: 111222333,444555666,777888999) 
* ManagementAccountRole - The name of the IAM role that will be deployed in the management account which can retrieve AWS Organization data. KEEP THE SAME AS WHAT IS DEPLOYED INTO MANAGEMENT ACCOUNT
* RolePrefix - This prefix will be placed in front of all roles created. Note you may wish to add a dash at the end to make more readable
* Schedule - Cron job to trigger the lambda using cloudwatch event. Default is once a day 

