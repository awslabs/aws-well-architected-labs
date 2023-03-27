---
title: "Row Level Security"
date: 2022-11-16T11:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---
## Last Updated

November 2022

## Authors
- Stephanie Gooch, Sr. Commercial Architect, AWS OPTICS
- Veaceslav Mindru, Sr. Technical Account Manager, AWS

## Introduction

Cloud Intelligence Dashboards (CID) helps you to visualize and understand AWS cost and usage data in your organization by exploring interactive dashboards. However, in order to maintain least privilege principle, customers who use CID at scale of organization often would like to provide their users access only to the data for linked accounts which they own. Using [Row Level Security](https://docs.aws.amazon.com/quicksight/latest/user/restrict-access-to-a-data-set-using-row-level-security.html) (RLS) enables you to restrict the data a user can see to just what they are allowed to. This also applicable for customers with Multiple Management (Payer) Accounts .

## Prerequisite

For this solution you must have the following:

* Access to your AWS Organizations and ability to tag resources
* An [AWS Cost and Usage Reports](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html) (CUR) or if from the multiple payers these must be replicated into a bucket, more info [here](https://wellarchitectedlabs.com/cost/100_labs/100_1_aws_account_setup/3_cur/#option-2-replicate-the-cur-bucket-to-your-cost-optimization-account-consolidate-multi-payer-curs)
* A CID deployed over this CUR data, checkout the new single deployment method [here](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/deploy_dashboards/). 
* A list of users and what level of access they require. This can be member accounts, organizational units (OU) or payers. 



## Solution 
This solution will use tags from your AWS Organization resources to create a dataset that will be used for the Row Level Security.

![Images/customizations_rls_architecture.png](/Cost/200_Cloud_Intelligence/Images/customizations_rls_architecture.png?classes=lab_picture_small)


## Step by Step Guide

### Part1: Roles

If you are deploying this in a linked account you will need a Role in you Management account to let you access your AWS Organizations Data. There are two options for this:

**Option1** If you already have the [Optimization Data Collector Lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/1_grant_permissions/#12-role-for-management-account) deployed you can use the Management role in that. 

**Option2** Else, you can deploy using the below:

{{%expand "Deployed Management Role" %}}
1.  Log into your **Management account** then click [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/Management.yaml&stackName=OptimizationManagementDataRoleStack)

2. Call the Stack **OptimizationManagementDataRoleStack**

3. In the Parameters section set **CostAccountID** as the ID of Cloud Intelligence Dashboard

4. Scroll to the bottom and click **Next**

5. Tick the acknowledge boxes and click **Create stack**.

6. You can see the role that was collected by clicking on **Resources** and clicking on the hyperlink under **Physical ID**.
![Images/Managment_CF_deployed.png](/Cost/300_Optimization_Data_Collection/Images/Managment_CF_deployed.png)

{{% /expand%}}

### Part2: Tag your AWS Organization Resources

You must tag the AWS Organization Resources with the emails of the Quicksight Users that you wish to allow access to see the resources cost data. The below will show you how to tag a resource and this can be repeated. We will be using **AWS Quicksight User Emails**, see more [here](https://docs.aws.amazon.com/quicksight/latest/user/managing-users.html). If you have a large list of accounts and want to use a script, please see the section below [Use script to tag accounts](#use-script-to-tag-accounts)  

1. Log into your **Management account** then click on the top right hand corner on your account and select **Organization**
![Images/rls_organization.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_organization.png?classes=lab_picture_small)
2. Ensure you are on the **AWS accounts** tab

![Images/rls_organization_accounts.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_organization_accounts.png?classes=lab_picture_small)
You can select different levels of access. Tag one of the following and the use will have access to all data of that resource and any child accounts below it.

* Tag an Account
* Tag an Organization Unit
* Tag the Root 

3. To tag the resource click its name an scroll down to the tag section and click **Manage tags**

![Images/rls_organization_accounts_tags.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_organization_accounts_tags.png?classes=lab_picture_small)

4. Add the Key **cudos_users** and the Value of any **emails** you wish to allow access. These are colon delimited. Once added click **Save changes**

![Images/rls_organization_accounts_cudostags.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_organization_accounts_cudostags.png?classes=lab_picture_small)

5. Repeat on all resources with relevant emails. 

## Part3: Deploy Lambda Function

Using AWS CloudFormation we will deploy the lambda function to collect these tags. 

1. Log into your account with your QuickSight Cloud Inteligence Dashboards also known as CID. Click [Launch CloudFormation template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/row-level-security/cudos_rls.yaml&stackName=CIDRowLevelSecurity) 

![Images/rls_cfn.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_cfn.png?classes=lab_picture_small)

2. Click **Next**.

3. Fill in the Parameters as seen below.

* CodeBucket - aws-well-architected-labs-{REGION-NAME} e.g. aws-well-architected-labs-ireland

{{%expand "AllowedValues S3" %}}

        - aws-well-architected-labs-ireland
        - aws-well-architected-labs        (Oregon)
        - aws-well-architected-labs-ohio
        - aws-well-architected-labs-virginia
        - aws-well-architected-labs-california
        - aws-well-architected-labs-oregon
        - aws-well-architected-labs-singapore
        - aws-well-architected-labs-frankfurt
        - aws-well-architected-labs-london
        - aws-well-architected-labs-stockholm
        - aws-well-architected-labs-ap-sydney
        - aws-well-architected-labs-mumbai
        - aws-well-architected-labs-osaka
        - aws-well-architected-labs-seoul
        - aws-well-architected-labs-tokyo
        - aws-well-architected-labs-canada
        - aws-well-architected-labs-milan
        - aws-well-architected-labs-paris
{{% /expand%}}

* CodeKey - LEAVE AS DEFAULT
* DestinationBucket - Amazon S3 Bucket in your account in the same region (this can be one from your Optimization data collector where where your CUR is stored). This bucket must have access to Amazon Quicksight
* ManagementAccountID - List of Payer IDs you wish to collect data for. Can just be one Accounts(Ex: 111222333,444555666,777888999) 
* ManagementAccountRole - The name of the IAM role that will be deployed in the management account which can retrieve AWS Organization data. KEEP THE SAME AS WHAT IS DEPLOYED INTO MANAGEMENT ACCOUNT
* RolePrefix - This prefix will be placed in front of all roles created. Note you may wish to add a dash at the end to make more readable
* Schedule - Cron job to trigger the lambda using cloudwatch event. Default is once a day 
 

![Images/rls_cfn_parameters.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_cfn_parameters.png?classes=lab_picture_small)

4. Tick the boxes and click **Create stack**.
![Images/Tick_Box.png](/Cost/300_Optimization_Data_Collection/Images/Tick_Box.png)

5. Wait until your CloudFormation has a status of **CREATE_COMPLETE**.
![Images/rls_cfn_complete.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_cfn_complete.png?classes=lab_picture_small)

## Part4: Test Lambda Function

Your lambda functions will run automatically on the schedule you chose at deployment and will be ready within an hour. However, if you would like to test your functions please see the steps below. 
Once you have deployed your modules you will be able to test your Lambda function to get your first set of data in Amazon S3. 

1. From CloudFormation Click **Resources** and find the Lambda Function and click the Physical ID

![Images/rls_cfn_resources.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_cfn_resources.png?classes=lab_picture_small)
2. To test your Lambda function open respective Lambda in AWS Console and click **Test**

3. Enter an **Event name** of **Test**, click **Create**:

![Images/Configure_Test.png](/Cost/300_Organization_Data_CUR_Connection/Images/Configure_Test.png)

4.	Click **Test**

5. The function will run, it will take a minute or two given the size of the Organizations files and processing required, then return success. Click **Details** and view the output. 

6. You can go to your bucket in S3 and there should be a file in the folder CUDOS_RLS. 
![Images/rls_s3_object.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_s3_object.png?classes=lab_picture_small)

7. Download this [qs_s3_manifest.json](/Cost/200_Cloud_Intelligence/qs_s3_manifest.json) file and replace <bucket> with the bucket you can see your data in. 

## Part5: Create RLS
We will now create the RLS Dataset in Amazon QuickSight and attach it to your datasets for CID. Please ensure the bucket you have placed the RLS file into has access to Amazon QuickSight, see [here](https://docs.aws.amazon.com/quicksight/latest/user/troubleshoot-connect-S3.html)

1. Go to Amazon QuickSight and login
2. Go to Datasets and click **New dataset**
![Images/rls_qs_datasets.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_qs_datasets.png?classes=lab_picture_small)

3. Create new Dataset by clicking **S3**
![Images/rls_qs_datasets_s3.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_qs_datasets_s3.png?classes=lab_picture_small)

4. Set Data source name as **CID RLS** and the qs_s3_manifest.json file you edited earlier into the **Upload** box
![Images/rls_qs_dataset_manifest.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_qs_dataset_manifest.png?classes=lab_picture_small)

5. Find your new dataset by searching **CID RLS** then click on it
![Images/rls_qs_rls_dataset.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_qs_rls_dataset.png?classes=lab_picture_small)

6. Click on your new dataset and select the **Refresh** tab and click **ADD NEW SCHEDULE**
![Images/rls_qs_rls_dataset_refresh.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_qs_rls_dataset_refresh.png?classes=lab_picture_small)

7. Choose Hourly and click **SAVE**
![Images/rls_qs_rls_dataset_refreshhourly.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_qs_rls_dataset_refreshhourly.png?classes=lab_picture_small)

8. Go back to Datasets and select your CID data **summary_view**. On the Summary tab find Row-level security and click **Edit**
![Images/rls_qs_summary.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_qs_summary.png?classes=lab_picture_small)

9. Click the toggle **User-based ON** then expand the **User-based rules** section and select the **CID RLS** dataset we made earlier
![Images/rls_qs_summary_addrls.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_qs_summary_addrls.png?classes=lab_picture_small)

10. Scroll down and click **Apply dataset**
![Images/rls_qs_summary_addrls_apply.png](/Cost/200_Cloud_Intelligence/Images/rls/rls_qs_summary_addrls_apply.png?classes=lab_picture_small)

11. Refresh the summary_view datasets 
12. Repeat for all other CID Datasets



### Use script to tag accounts
If you have a large number of accounts that need to be tagged then please use the guide below to do a scripted method to save time.
{{%expand "Click here to expand guide" %}}

For this you will need:
* a list of all of your accounts you wish to tag. If you do not have one, you can export your AWS Organizations using this [guide](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_export.html)
* a list of all QuickSight users email which you wish to tag this Organization with. Currently you cannot directly download this data but you can use the following cli command replacing 111122223333 with your Management account
* cli credentials for your management account or ability to create a lambda function and you will find the file in your tmp folder

``` aws quicksight list-users --namespace default --output text --aws-account-id 111122223333 > /tmp/quicksight_user.txt```

### Steps to tag
1. Download this [example file](/Cost/200_Cloud_Intelligence/templates/rls/tagger/data.csv) and this [code file](/Cost/200_Cloud_Intelligence/templates/rls/tagger/aws_org_tagger_lambda.py) and save as aws_org_tagger_lambda.py

2. In the file, remove the example line and add your list of account id's in the first column. Then add the relevant QuickSight users emails that you want to have access to the account. Remember if multiple they need tbe **separated by :**

3. Save this file.

4. You can either run the script using cli or creating a lambda function.

#### CLI
* If CLI then ensure your data.csv file and aws_org_tagger_lambda.py are in the same folder
* Run ```python3 aws_org_tagger_lambda.py```

#### Lambda
* Log into your Management account and go to Lambda
* Create new Lambda and call it **Tag-Organization** and use **Python 3.9**
* In the lambda, copy the code from the aws_org_tagger_lambda.py file
* Click on the left hand side of the Environment and click **New File**
* In the file paste your data.csv data *making sure it has the comers in it**
* Click **Deploy**
* Click on **Configuration** then **Permissions**. There will be a Role Name in blue, click on that link.
* This will take you to IAM where you **Add permissions** > **Attach policies**
* Search for **AWSOrganizationsFullAccess** and add this policy
* Go back to lambda and click to the **Test** tab then the orange **Test** button. 

Now your AWS Organization will have new or updated tags with the data from your excel sheet




{{% /expand%}}


{{% notice tip %}}
If you would like to turn off RLS you can just toggle the **User-based ON** to **OFF**
{{% /notice %}}

## See the impact

Now when you go to your Dashboard the users who had been tagged on the accounts will only see their data

