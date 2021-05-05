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

### Create the Cost Intelligence Dashboard using a CloudFormation Template

1. Login via SSO in your Cost Optimization account

2. Click the **Launch CloudFormation button** below to open the **stack template** and add in the needed variables in your CloudFormation console and select **Next**

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https%3A%2F%2Fee-assets-prod-us-east-1.s3.amazonaws.com%2Fmodules%2F8cf0b70c5c7a489ebe4e957c2f32bb67%2Fv2%2FQuickSightCurReportAutomation.yml)
	
![Images/cf_dash_2.png](/Cost/200_Enterprise_Dashboards/Images/cf_dash_2.png)

## Test Lamda Funtion
If you deployed through cloudformation then please test your lambda function now. 

1.	Scroll to the **function code**  and click **Deploy**. Then Click **Test**.

![Images/Deploy_Function.png](/Cost/300_Organization_Data_CUR_Connection/Images/Deploy_Function.png)

1.	Enter an **Event name** of **Test**, click **Create**:

![Images/Configure_Test.png](/Cost/300_Organization_Data_CUR_Connection/Images/Configure_Test.png)

2.	Click **Test**

3.	The function will run, it will take a minute or two given the size of the Organizations files and processing required, then return success. Click **Details** and verify there is headroom in the configured resources and duration to allow any increases in Organizations file size over time:

![Images/Lambda_Success.png](/Cost/300_Organization_Data_CUR_Connection/Images/Lambda_Success.png)

4.	Go to your S3 bucket and into the organisation-data folder and you should see a file of non-zero size is in it:

![Images/Org_in_S3.png](/Cost/300_Organization_Data_CUR_Connection/Images/Org_in_S3.png)


{{% notice note %}}
NOTE: You have successfully completed all CloudFormation specific steps. All remaining setup and future customizations will follow the same process as the manual steps.
{{% /notice %}}

{{% /expand%}}


{{% notice tip %}}
If you wish to add more tags at a later date you must repeat Step 4 from the lambda section, adding the tags to the list of Environment variables and replacing the Athena table with the tags appended. 
{{% /notice %}}


{{< prev_next_button link_prev_url="../5_join_cost_intelligence_dashboard/" link_next_url="../7_teardown/" />}}


