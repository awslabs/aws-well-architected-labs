---
title: "Bonus Infrastructure as Code"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 6
pre: "<b>6. </b>"
---


### Bonus Infrastructure as Code

### Optional: Advanced Setup using a CloudFormation Template
This section is **optional** and automates the creation of the AWS organizations data collection using a **CloudFormation template**. The CloudFormation template allows you to complete the lab in less than half the time as the standard setup. You will require permissions to modify CloudFormation templates, create an IAM role, create an S3 Bucket, and create an Glue Grawler. **If you do not have the required permissions skip over this section to continue using the standard setup**. 

You will still need to create your IAM role in your Managment account **after** you have deployed the below. This can be see in the create IAM Role and Policies in Management account [step.]({{< ref "/Cost/300_Labs/300_Organization_Data_CUR_Connection/1_Create_static_resources_Source" >}})

{{%expand "Click here to continue with the CloudFormation Advanced Setup" %}}

{{% notice note %}}
NOTE: An IAM role will be created when you create the CloudFormation stack. Please review the CloudFormation template with your security team and switch to the manual setup if required
{{% /notice %}}

### Create the Organization data collector using a CloudFormation Template Console


Deploy through Console 

1. Click the **Download CloudFormation** by clicking [here](/Cost/300_Organization_Data_CUR_Connection/Code/main.yaml)
  * You can right-click then choose **Save link as**; or you can right click and copy the link to use with `wget`


2. Login via SSO in your Cost Optimization account and search for **Cloud Formation**
![Images/cloudformation.png](/Cost/300_Organization_Data_CUR_Connection/Images/cloudformation.png)

3. On the right side of the screen select **Create stack** and choose **With new resources (standard)**
![Images/create_stack.png](/Cost/300_Organization_Data_CUR_Connection/Images/create_stack.png)

4. Choose **Template is ready** and **Upload a template file** and upload the main.yaml file you downloaded from above. Click **Next**.
![Images/upload_template.png](/Cost/300_Organization_Data_CUR_Connection/Images/upload_template.png)

5. Input the stack name as  **Organization-data-collector-stack** parameter Parameters. Once filled click **Next**.
 * **DatabaseName** - Athena Database name where you table will be created
 * **DestinationBucket** - Unique bucket name that is created to hold org data, you will need to use a  with **cost** at the start, (we have used cost-aws-lab-organisation-bucket)
 * **ManagementAccountId** - Your Management Account Id where your Optimization is held
 * **RoleARN** - ARN of the IAM role deployed in the management accounts which can retrieve AWS Org information e.g.arn:aws:iam::123456789:role/OrganizationLambdaAccessRole
 * **Tags** - List of tags from your Organisation you would like to include separated by a comma.
![Images/Parameters.png](/Cost/300_Organization_Data_CUR_Connection/Images/Parameters.png)

6. Scroll down and click **Next**
![Images/cf_next.png](/Cost/300_Organization_Data_CUR_Connection/Images/cf_next.png)

7. Scroll down and tick the box acknowledgeing that this will create and IAM Role. Click **Create stack**
![Images/iam_agree_cf.png](/Cost/300_Organization_Data_CUR_Connection/Images/iam_agree_cf.png)

8. Wait for the Cloudformation to deploy, this can be seen when it has **CREATE_COMPLETE** under the stack name.
![Images/cf_deployed.png](/Cost/300_Organization_Data_CUR_Connection/Images/cf_deployed.png)

9. Select your stack and click on **Resources** and find the lambda function **LambdaOrgData** and click on the link to take you too the lambda. 
![Images/cf_lambda.png](/Cost/300_Organization_Data_CUR_Connection/Images/cf_lambda.png)


### Create the Organization data collector using a CloudFormation Template CLI

1. Deploy through CLI download [parameter.json](/Cost/300_Organization_Data_CUR_Connection/Code/parameter.json) update them with your parameter.

2. Run the following in your terminal, esuring that you have access to the member account you wish to deploy in. 
``` aws cloudformation create-stack --stack-name Organization-data-collector-stack --template-body file://main.yaml --capabilities CAPABILITY_NAMED_IAM --parameters file://parameter.json```


## Test Lamda Funtion
Now you have deployed the cloudformation then you can test your lambda to get your first set of data in Amazon S3. 


1. To test your lambda function click **Test**
![Images/lambda_test_cf.png](/Cost/300_Organization_Data_CUR_Connection/Images/lambda_test_cf.png) 

2. Enter an **Event name** of **Test**, click **Create**:

![Images/Configure_Test.png](/Cost/300_Organization_Data_CUR_Connection/Images/Configure_Test.png)

3.	Click **Test**

4.	The function will run, it will take a minute or two given the size of the Organizations files and processing required, then return success. Click **Details** and verify there is headroom in the configured resources and duration to allow any increases in Organizations file size over time:

![Images/Lambda_Success.png](/Cost/300_Organization_Data_CUR_Connection/Images/Lambda_Success.png)

5.	Go to your S3 bucket and into the organisation-data folder and you should see a file of non-zero size is in it:

![Images/Org_in_S3.png](/Cost/300_Organization_Data_CUR_Connection/Images/Org_in_S3.png)

6. Now you have deployed your cloudfomation jump to step 11 on **Create Glue Crawler** on Utilize Organization Data Source [page]({{< ref "/Cost/300_Labs/300_Organization_Data_CUR_Connection/3_Utilize_Organization_Data_Source" >}}) to run your crawler to create your athena table. 

{{% notice note %}}
NOTE: You have successfully completed all CloudFormation specific steps. All remaining setup and future customizations will follow the same process as the manual steps.
{{% /notice %}}

{{% /expand%}}


{{% notice tip %}}
If you wish to add more tags at a later date you must repeat Step 4 from the lambda section, adding the tags to the list of Environment variables and replacing the Athena table with the tags appended. 
{{% /notice %}}


{{< prev_next_button link_prev_url="../5_join_cost_intelligence_dashboard/" link_next_url="../7_teardown/" />}}


