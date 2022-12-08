---
title: "TAO Dashboard Deployment"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Deployment Options
There are 2 options to deploy the TAO Dashboard. If you are unsure what option to select, we recommend using the Manual deployment

### Option 1: CloudFormation Deployment
This section is optional way to deploy TAO Dashboard using a **CloudFormation template**. You will require permissions to modify CloudFormation templates and create an IAM role. **If you do not have the required permissions use Automation Scripts Deployment**. 

{{%expand "Click here to continue with the CloudFormation Deployment" %}}

**NOTE:** An IAM role will be created when you create the CloudFormation stack.
    ------------ | -------------

### Create TAO Dashboard using a CloudFormation Template

1. Login in your Cost Optimization account

2. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/tao.cfn.yml)
	
![Images/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_2.png?classes=lab_picture_small)

3. Enter a **Stack name** for your template such as **TAO-Dashboard-QuickSight**
![Images/cf_dash_3.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_3.png?classes=lab_picture_small)

4. Review **Information** parameter to confirm prerequisites before specifying the other parameters
![Images/cf_dash_4.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_4.png?classes=lab_picture_small)

5. Update your **S3 Bucket Path to the TA Reports** with the S3 path where your **Trusted Advisor reports** are stored. Path should look like ``s3://{bucketname}/reports`` or ``s3://costoptimizationdata{account_id}/trusted-advisor/trusted-advisor-data/`` depending on data collection method used in [Create and Upload Trusted Advisor Report](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/dashboards/2_create-upload-ta-report/) step before.
![Images/cf_dash_5.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_5.png?classes=lab_picture_small)


6. Update your **Athena Database Name** with the name of the CUR Athena Database where you want to deploy table for TA reports. Leave **default** if you are not sure which database name provide:
![Images/cf_dash_6.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_6.png?classes=lab_picture_small)

7. Update **QuickSight Username** parameter with your **QuickSight username** 
![Images/cf_dash_7.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_7.png?classes=lab_picture_small)
To validate your QuickSight username complete the tasks below:
	- Open a new tab or window and navigate to the **QuickSight** console
	- Find your username in the top right navigation bar
![Images/cf_dash_7_2.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_7_2.png?classes=lab_picture_small)
	- Add the identified username to the CloudFormation parameter
	
8. Update **Quicksight Identity Region** parameter with your **QuickSight region** 
![Images/cf_dash_8.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_8.png?classes=lab_picture_small)

	- **Optional** add a **Suffix** if you want to create multiple instances of the same account. 
    - **Optional** specify a **Preferred Refresh Schedule** for QuickSight dataset refresh. Leave empty if no automated refresh is needed.
9. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page

10. Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_10.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

11. You will see the stack will start in **CREATE_IN_PROGRESS** 
![Images/cf_dash_10.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_10.png?classes=lab_picture_small)

**NOTE:** This step can take 5-15mins
    ------------ | -------------

12. Once complete, the stack will show **CREATE_COMPLETE**
![Images/cf_dash_11.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_11.png?classes=lab_picture_small)

13. Navigate to **Dashboards** page in your QuickSight console, click on **Trusted Advisor Organizational View** dashboard to open it
![Images/cf_dash_12.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_12.png?classes=lab_picture_small)
{{% /expand%}}

### Option 2: Automation Scripts Deployment
The [Cloud Intelligence Dashboards automation repo](https://github.com/aws-samples/aws-cudos-framework-deployment) is an optional way to create the Cloud Intelligence Dashboards using a collection of setup automation scripts. The supplied scripts allow you to complete the workshops in less than half the time as the standard manual setup.

{{%expand "Click here to continue with the Automation Scripts Deployment" %}}

#### Step 1: Prepare Athena
If this is the first time you will be using Athena you will need to complete a few setup steps before you are able to create the views needed. If you are already a regular Athena user you can skip these steps and move on to the [Enable Quicksight](https://www.wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/dashboards/1_prerequistes/#enable-quicksight) section below.

To get Athena warmed up:

1. From the services list, choose **S3**

1. Create a new S3 bucket for Athena queries to be logged to. Keep to the same region as the S3 bucket created for your Trusted Advisor Organizational View reports.

1. From the services list, choose **Athena**

1. Select **Get Started** to enable Athena and start the basic configuration
    ![Image of Athena Query Editor](/Cost/200_Cloud_Intelligence/Images/Athena-GetStarted.png?classes=lab_picture_small)

1. At the top of this screen select **Before you run your first query, you need to set up a query result location in Amazon S3.**

    ![Image of Athena Query Editor](/Cost/200_Cloud_Intelligence/Images/Athena-S3.png?classes=lab_picture_small)

1. Enter the path of the bucket created for Athena queries, it is recommended that you also select the AutoComplete option **NOTE:** The trailing “/” in the folder path is required!

**NOTE:** Configuration **MUST** be performed at the Athena workgroup level. 
    ------------ | -------------
#### Step 2: Deploy Dashboard
Follow the [How to use steps](https://github.com/aws-samples/aws-cudos-framework-deployment#how-to-use) for installation and dashboard deployment. We recommend to use **AWS CloudShell** for automated deployment
{{% /expand%}}

### Saving and Sharing your Dashboard in QuickSight 
Now that you have your dashboard created you will need want to share your dashboard with users or customize your own version of this dashboard
	- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)

{{< prev_next_button link_prev_url="../2_create-upload-ta-report" link_next_url="../4_update-dashboard" />}}