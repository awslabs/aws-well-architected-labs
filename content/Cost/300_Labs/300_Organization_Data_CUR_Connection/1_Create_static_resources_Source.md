---
title: "Create Static Resources"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### Create Resource

To deploy the resource, you need for this lab you have three options. You can deploy using a AWS CloudFormation template or a Terraform module, either allows you to complete the lab in less than half the time as the standard setup. Or, you can deploy manually if you do not have access to deploy using CloudFormation or would like hands one experience going through the steps.

{{%expand "Click here to continue with the CloudFormation Advanced Setup" %}}

{{% notice note %}}
NOTE: An IAM role will be created when you create the CloudFormation stack. Please review the CloudFormation template with your security team and switch to the manual setup if required
{{% /notice %}}

### Create the Organization data collector using a CloudFormation Template Console

This section is **optional** and automates the creation of the AWS organizations data collection using a **CloudFormation template**.  You will require permissions to modify CloudFormation templates, create an IAM role, S3 Bucket, Lambda and create a Glue Crawler. **If you do not have the required permissions skip over this section to continue using the standard setup**.

1. 
* Click [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Organization_Data_CUR_Connection/main.yaml) if you are deploying to your linked account (recommended)

* Click [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Organization_Data_CUR_Connection/main_man.yaml) if you wish to deploy straight into your management account 

2. Input the stack name as  **Organization-data-collector-stack**. Then filled in the Parameters. Click **Next**.
 * **DatabaseName** - Athena Database name where you table will be created
 * **DestinationBucket** - The name you would like of the bucket that will be created in to hold org data, you will need to use a with **cost** at the start, (we have used cost-aws-lab-organisation-bucket)
 * **ManagementAccountId** - Your Management Account Id where your Optimization is held
 * **Tags** - List of tags from your Organization you would like to include separated by a comma.
![Images/Parameters.png](/Cost/300_Organization_Data_CUR_Connection/Images/Parameters.png)

3. Scroll down and click **Next**
![Images/cf_next.png](/Cost/300_Organization_Data_CUR_Connection/Images/cf_next.png)

4. Scroll down and tick the box acknowledging that this will create and IAM Role. Click **Create stack**
![Images/iam_agree_cf.png](/Cost/300_Organization_Data_CUR_Connection/Images/iam_agree_cf.png)

5. Wait for the CloudFormation to deploy, this can be seen when it has **CREATE_COMPLETE** under the stack name.
![Images/cf_deployed.png](/Cost/300_Organization_Data_CUR_Connection/Images/cf_deployed.png)

6. Repeat the above steps in your **Management account** using the [Management.yaml](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Organization_Data_CUR_Connection/Management.yaml) template to deploy an IAM Role to allow the lambda to pull data into the Cost Optimization account. If you cannot deploy a CloudFormation into your management account please see the **Create IAM Role and Policies in Management account** Step further down this page to create manually.

7. Now go back to your linked account and find your deployed CloudFormation template. Select your stack and click on **Resources** and find the lambda function **LambdaOrgData** and click on the link to take you to the lambda. 
![Images/cf_lambda.png](/Cost/300_Organization_Data_CUR_Connection/Images/cf_lambda.png)

{{% notice tip %}}
If you wish to add more tags at a later date you can either update your lambda in the console or update the CloudFormation Parameters. You can see your tags in the bonus section at the bottom of this page.
{{% /notice %}}

## Test Lambda Function
Now that you have deployed the CloudFormation, you must test your Lambda function to get your first set of data in Amazon S3. 


1. To test your lambda function click **Test**
![Images/lambda_test_cf.png](/Cost/300_Organization_Data_CUR_Connection/Images/lambda_test_cf.png) 

2. Enter an **Event name** of **Test**, click **Create**:

![Images/Configure_Test.png](/Cost/300_Organization_Data_CUR_Connection/Images/Configure_Test.png)

3.	Click **Test**

4.	The function will run, it will take a minute or two given the size of the Organizations files and processing required, then return success. Click **Details** and verify there is headroom in the configured resources and duration to allow any increases in Organizations file size over time:

![Images/Lambda_Success.png](/Cost/300_Organization_Data_CUR_Connection/Images/Lambda_Success.png)

5.	Go to your S3 bucket and into the organisation-data folder and you should see a file of non-zero size:

![Images/Org_in_S3.png](/Cost/300_Organization_Data_CUR_Connection/Images/Org_in_S3.png)

6. Go to the **Glue** Service page:
![Images/home_glue.png](/Cost/200_Pricing_Model_Analysis/Images/home_glue.png)

7. Now that you have deployed your CloudFomation, jump to step 11 on **Create Glue Crawler** on Utilize Organization Data Source [page]({{< ref "/Cost/300_Labs/300_Organization_Data_CUR_Connection/3_Utilize_Organization_Data_Source" >}}) to run your Glue crawler which will create your Athena table. 

{{% notice note %}}
NOTE: You have successfully completed all CloudFormation specific steps. All remaining setup and future customizations will follow the same process as the manual steps.
{{% /notice %}}

{{% /expand%}}

{{%expand "Click here to continue with the Terraform Advanced Setup" %}}
### Create the Organization data collector using Terraform

There is an AWS [Github Repo](https://github.com/awslabs/well-architected-lab300-aws-organization-data-terraform-module) which has a module to deploy all the resources needed in this lab. Please deploy using the instructions in the github repo then return to the step below.

{{% notice tip %}}
If you wish to add more tags at a later date you can either update your lambda in the console or update the CloudFormation Parameters. You can see your tags in the bonus section at the bottom of this page.
{{% /notice %}}

## Test Lambda Function
Now you have deployed the Terraform then you can test your lambda to get your first set of data in Amazon S3. 


1. Go to the **Lambda** service page :

![Images/Lambda.png](/Cost/300_Organization_Data_CUR_Connection/Images/Lambda.png)


2. Search for your new function called **Lambda_Org_Data** and click on it. To test your lambda function click **Test**
![Images/lambda_test_cf.png](/Cost/300_Organization_Data_CUR_Connection/Images/lambda_test_cf.png) 

3. Enter an **Event name** of **Test**, click **Create**:

![Images/Configure_Test.png](/Cost/300_Organization_Data_CUR_Connection/Images/Configure_Test.png)

4.	Click **Test**

5.	The function will run, it will take a minute or two given the size of the Organizations files and processing required, then return success. Click **Details** and verify there is headroom in the configured resources and duration to allow any increases in Organizations file size over time:

![Images/Lambda_Success.png](/Cost/300_Organization_Data_CUR_Connection/Images/Lambda_Success.png)

6.	Go to your S3 bucket and into the organisation-data folder and you should see a file of non-zero size is in it:

![Images/Org_in_S3.png](/Cost/300_Organization_Data_CUR_Connection/Images/Org_in_S3.png)

7. Go to the **Glue** Service page:
![Images/home_glue.png](/Cost/200_Pricing_Model_Analysis/Images/home_glue.png)

8. Now you have deployed your Terraform jump to step 11 on **Create Glue Crawler** on Utilize Organization Data Source [page]({{< ref "/Cost/300_Labs/300_Organization_Data_CUR_Connection/3_Utilize_Organization_Data_Source" >}}) to run your crawler to create your athena table. 

{{% notice note %}}
NOTE: You have successfully completed all Terraform specific steps. All remaining setup and future customizations will follow the same process as the manual steps.
{{% /notice %}}

{{% /expand%}}


{{%expand "Click here to continue with Creating Resources Manually" %}}
### Create the Organization data collector manually

### Create Amazon S3 Bucket and Folders
We’ll create an S3 bucket to store the organizations data to be combined with your cost and usage report. This will hold your organisation data so we can connect it to Athena.

1. Login via SSO to your Cost Optimization account, go into the **S3** console:

![Images/home_s3-dashboard.png](/Cost/300_Organization_Data_CUR_Connection/Images/home_s3-dashboard.png)

2. Click **Create bucket** and create a bucket. You will need to use a unique bucket name with **cost** at the start, (we have used cost-aws-lab-organisation-bucket). Make a note of this as we will be using it later.



### Create IAM Role and Policies
We’ll create an IAM role and policy for the AWS Lambda function to access the organizations data & write it to S3. This role will be used to get the list of accounts in the Organization and the meta data attached to them such as name and email. This is then placed in our S3 bucket.

1.	Go to the **IAM Console**

2.	Select **Policies** and **Create policy**

![Images/create_policy.png](/Cost/300_Organization_Data_CUR_Connection/Images/create_policy.png)

3.	On the **JSON** tab the following policy and replace **(bucket name)** with your bucket name from before and replace **(account id)** with your **Management Account id** which manages your Organization. Enter the following policy, click **Review policy**:

        {
            "Version":"2012-10-17",
            "Statement":[
                {
                    "Sid":"S3Org",
                    "Effect":"Allow",
                    "Action":[
                        "s3:PutObject",
                        "s3:DeleteObjectVersion",
                        "s3:DeleteObject"
                    ],
                    "Resource":"arn:aws:s3:::(bucket name)/*"
                },
                {
                    "Sid":"OrgData",
                    "Effect":"Allow",
                    "Action":[
                        "organizations:ListAccountsForParent",
                        "organizations:ListRoots",
                        "organizations:ListCreateAccountStatus",
                        "organizations:ListAccounts",
                        "organizations:ListTagsForResource",
                        "organizations:DescribeOrganization",
                        "organizations:DescribeOrganizationalUnit",
                        "organizations:DescribeAccount",
                        "organizations:ListParents",
                        "organizations:ListOrganizationalUnitsForParent",
                        "organizations:ListChildren"
                    ],
                    "Resource":"*"
                },
                {
                    "Sid":"Logs",
                    "Effect": "Allow",
                    "Action": [
                        "logs:CreateLogGroup",
                        "logs:CreateLogStream",
                        "logs:PutLogEvents",
                        "logs:DescribeLogStreams"
                    ],
                    "Resource": "arn:aws:logs:*:*:*"
                },
                {
                    "Sid": "assume",
                    "Effect": "Allow",
                    "Action": "sts:AssumeRole",
                    "Resource": "arn:aws:iam::(account id):role/OrganizationLambdaAccessRole"
                }
            ]
        }

4.	Fill in the following
* **Policy Name** LambdaOrgPolicy
* **Description** Access to S3 for Lambda function to collect organization data
* Click **Create policy**

![Images/LambdaOrgPolicy.png](/Cost/300_Organization_Data_CUR_Connection/Images/LambdaOrgPolicy.png)

5.	Select **Roles**, click **Create role**

![Images/createrole.png](/Cost/300_Organization_Data_CUR_Connection/Images/createrole.png)

6.	Select **Lambda**, click **Next: Permissions**:

![Images/permissons.png](/Cost/300_Organization_Data_CUR_Connection/Images/permissons.png)

7.	Type lambda into the search and select the **LambdaOrgPolicy** policy, click **Next: Tags**

![Images/add_permission.png](/Cost/300_Organization_Data_CUR_Connection/Images/add_permission.png)

8.	Click **Next: Review**

9.	**Role name** LambdaOrgRole, click Create role:

![Images/create_role.png](/Cost/300_Organization_Data_CUR_Connection/Images/create_role.png)


### Create IAM Role and Policies in Management account
As we need to pull the data from the **Management account** we need to allow our role to do this. 

1. Log into your **Management account**

2. Go to the **IAM Console**

3. Select **Policies** and **Create policy**. Copy steps 2 - 4 from above to create the below policy called **ListOrganizations**.

![Images/create_policy.png](/Cost/300_Organization_Data_CUR_Connection/Images/create_policy.png)

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "OrgData",
                "Effect": "Allow",
                "Action": [
                    "organizations:ListAccountsForParent",
                    "organizations:ListRoots",
                    "organizations:ListCreateAccountStatus",
                    "organizations:ListAccounts",
                    "organizations:ListTagsForResource",
                    "organizations:DescribeOrganization",
                    "organizations:DescribeOrganizationalUnit",
                    "organizations:DescribeAccount",
                    "organizations:ListParents",
                    "organizations:ListOrganizationalUnitsForParent",
                    "organizations:ListChildren"
                ],
                "Resource": "*"
            }
        ]
    }


4.	Select **Roles**, click **Create role**

![Images/createrole.png](/Cost/300_Organization_Data_CUR_Connection/Images/createrole.png)

5. Choose **Another AWS account**,  and enter your sub account id which is where we started the lab, **Next: Permissions** 

![Images/iam_another_account.png](/Cost/300_Organization_Data_CUR_Connection/Images/iam_another_account.png)

6. Search for Organizations and select the **ListOrganizations** policy you just made. Click **Next: Tags** then click **Next: Review**

7. **Role name** OrganizationLambdaAccessRole, click **Create role**:

![Images/Org_Lambda_Role.png](/Cost/300_Organization_Data_CUR_Connection/Images/Org_Lambda_Role.png)

8. Search for your new role in the roles page and click on the role name. Click on **Trusted relationships** tab then **Edit trusted relationship**
![Images/Trusted_Relationship.png](/Cost/300_Organization_Data_CUR_Connection/Images/Trusted_Relationship.png)

9. On the **JSON** tab the replace the current json with the following policy and replace **(sub account id)** with your sub account id from before, click **Update Trust policy**:

        {
            "Version": "2012-10-17",
            "Statement": [
                {
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::(sub account id):role/LambdaOrgRole"
                },
                "Action": "sts:AssumeRole"
                }
            ]
        }


{{% notice tip %}}
Now you have completed this section you have setup the resources that will enable you to collect your Organizations data. We will use these resources in the next section when creating our Lambda function. Please return to the sub account you created your S3 bucket in.
{{% /notice %}}

{{% /expand%}}


{{% notice note %}}
Now you have completed this section there is a bonus part where you can check the Tags on your AWS Accounts. These can be used in the lambda if you wish. 
{{% /notice %}}

{{%expand "Click here to see the Bonus Check AWS Organizations Tags" %}}

### Bonus Check AWS Organizations Tags
In the next step we will be setting up a lambda to pull the data from your AWS Organization. If you wish to pull your tags from this data too then follow these steps to see your tags. 

If you can use the [AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/organizations/list-tags-for-resource.html) then you can run the below command in your terminal where you have access to your management account to see an individual accounts tags:

    aws organizations list-tags-for-resource --resource-id (account id)

#### Bonus Check AWS Organizations Tags from Console

1.	From your Amazon console on the top right of your screen click on the drop down and chose **My Organization**.

![Images/myorg.png](/Cost/300_Organization_Data_CUR_Connection/Images/myorg.png)

2.	Open **AWS accounts** and you will see your Organization and your Organization structure. This holds your Organizational Units and your Accounts. Click on an account name that you wish to see the tags for. 

![Images/aws_accounts.png](/Cost/300_Organization_Data_CUR_Connection/Images/aws_accounts.png)

3.	At the bottom of the page, you will see the **Tags** section. Make a note the Tags Keys in the left-hand box which you wish to collect to use with the CUR in the next step. Note, these are **case sensitive** so we recommend copy and pasting them. 

![Images/account_tags.png](/Cost/300_Organization_Data_CUR_Connection/Images/account_tags.png)
{{% /expand%}}



{{< prev_next_button link_prev_url="../" link_next_url="../2_create_automation_resources_source/" />}}