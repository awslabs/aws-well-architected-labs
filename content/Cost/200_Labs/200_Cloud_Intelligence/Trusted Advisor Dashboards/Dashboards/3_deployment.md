---
title: "TAO Dashboard Deployment"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Deployment Options
There are 2 options to deploy the TAO Dashboard. If you are unsure what option to select, we recommend using the CloudFormation

### Option 1: CloudFormation Deployment
If you already have CUDOS, Cost Intellegence Dashboard or KPI Dashboard installed via CloudFormation as described [here](/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/deploy_dashboards/), you can update the Stack (default name Cloud-Intelligence-Dashboards) by setting **Deploy TAO Dashboard** to "yes" and updating the path of Data Collection S3 bucket (if different from default).

{{%expand "Click here to continue with the CloudFormation Deployment" %}}

**NOTE:** An IAM role will be created when you create the CloudFormation stack.
    ------------ | -------------

1. Login into your Linked (Data Collection) Account where you would like to deploy dashboard

2. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?&templateURL=https://aws-managed-cost-intelligence-dashboards.s3.amazonaws.com/cfn/cid-cfn.yml&stackName=Cloud-Intelligence-Dashboards&param_DeployTAODashboard=yes)
	
3. Enter a **Stack name** for your template such as **Cloud-Intelligence-Dashboards**
4. Review **Common Parameters** and confirm prerequisites before specifying the other parameters. You must answer 'yes' to both prerequisites questions.
5. Copy and paste your **QuicksightUserName** into the parameter text box.
To find your QuickSight username:
	- Open a new tab or window and navigate to the **QuickSight** console
	- Find your username in the top right navigation bar
![Images/cf_dash_qs_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_qs_2.png?classes=lab_picture_small)

1. Update your **Path to Optimization Data Collection S3 bucket** if needed. 

2. Check that **Deploy TAO Dashboard** is set to yes.

3.  Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.

4.  You will see the stack will start in **CREATE_IN_PROGRESS** 
   **NOTE:** This step can take 5mins
    ------------ | -------------

1. Once complete, the stack will show **CREATE_COMPLETE**

11. Navigate back to CloudFormation and to the **Output of the Stack** tab and check dashboard URLS. Click on a URL to open the dashboards.
   **NOTE:** This Output Section will be available once the Stack is Completed
    ------------ | -------------

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
1. Open up a terminal application with permissions to run API requests against your AWS account. We recommend [CloudShell](https://console.aws.amazon.com/cloudshell).

2. We will be following the steps outlined in the [Cloud Intelligence Dashboards automation GitHub repo.](https://github.com/aws-samples/aws-cudos-framework-deployment/) For more information on the CLI tool, please visit the repo. 

3. In your Terminal type the following and hit return. This will make sure you have the latest pip package installed.
`python3 -m ensurepip --upgrade`

4. In your Terminal type the following and hit return. This will download and install the CID CLI tool.
`pip3 install --upgrade cid-cmd`

5. In your Terminal, type the following and hit return. You are now starting the process of deploying the dashboards. 
`cid-cmd deploy`

    Or you can provide all parameters in the command line. Please make sure the S3 path is the one where you have Trusted Advisor data collected.

```bash
cid-cmd -vv deploy \
  --dashboard-id ta-organizational-view \
  --athena-database optimization_data \
  --view-ta-organizational-view-reports-s3FolderPath \
  's3://costoptimizationdata{account_id}/trusted-advisor/trusted-advisor-data'
```

6. Select the Trusted Advisor Organizational View dashboard and proceed with deployment. 

{{% /expand%}}

{{< prev_next_button link_prev_url="../2_create-upload-ta-report" link_next_url="../4_update-dashboard" />}}
