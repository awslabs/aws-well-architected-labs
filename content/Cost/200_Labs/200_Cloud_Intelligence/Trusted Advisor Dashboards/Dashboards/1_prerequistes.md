---
title: "Prerequisites"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---


### (Required for automated Installation with cid-cmd tool) Python 3.9+
For automatic installation you will require Python 3.9+ and PIP installed.

### Enable Trusted Advisor Data Collection
There are 2 supported data collection methods:
1. **Trusted Advisor Organizational View** - provides an easy way to collect Trusted Advisor checks for all accounts in your AWS Organizations without need to provision any additional resources. Only manual data refresh is supported.
2. **Trusted Advisor API via deployment of [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/)** - provides an automated way to collect Trusted Advisor checks for all accounts in your AWS Organizations via deployment of required AWS resources from provided AWS CloudFormation templates. Supports automated data refresh.

Please choose preferred data collection method and expand respective section below to proceed:

{{%expand "Trusted Advisor Organizational View" %}}

### Enable Trusted Advisor Organizational View

For the step by step guide please follow [the documentation](https://docs.aws.amazon.com/awssupport/latest/user/organizational-view.html#enable-organizational-view)

![Image](/Cost/200_Cloud_Intelligence/Images/tao/TA_org_view_enable.png?classes=lab_picture_small)

### Create S3 bucket.

1. Create an S3 bucket in a [QuickSight supported AWS region](https://docs.aws.amazon.com/quicksight/latest/user/regions.html) (for example us-east-1)

2. Create new folder named `reports` in the created S3 bucket.
    ![Image](/Cost/200_Cloud_Intelligence/Images/tao/S3-upload-report.png?classes=lab_picture_small)

{{% notice note %}}
You can use any S3 bucket name. Please save {bucket} name. It will be needed in Stage 2
{{% /notice %}}
{{% /expand%}}
{{%expand "Trusted Advisor API via deployment of Optimization Data Collection lab" %}}
Please follow the steps in [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/). Once [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/) completed, please proceed with next steps. 
**NOTE:** Only **Trusted Advisor Data Collection Module** is required to be deployed. Consider other modules form the lab as optional
    ------------ | -------------
{{% /expand%}}
### Prepare Athena
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

{{% notice note %}}
Configuration **MUST** be performed at the Athena workgroup level. 
{{% /notice %}}

### Enable QuickSight 
QuickSight is the AWS Business Intelligence tool that will allow you to not only view the Standard AWS provided insights into all of your accounts, but will also allow to produce new versions of the Dashboards we provide or create something entirely customized to you. You will require QuickSight Enterprise Edition. If you are already a regular QuickSight user you can skip these steps and move on to the next step. If not, complete the steps below.

{{%expand "Click here - to setup QuickSight" %}}
1. Log into your AWS Account and search for **QuickSight** in the list of Services

1. You will be asked to **sign up** before you will be able to use it

    ![QuickSight Sign up Workflow Image](/Cost/200_Cloud_Intelligence/Images/QS-signup.png?classes=lab_picture_small)

1. After pressing the **Sign up** button you will be presented with 2 options, please ensure you select the **Enterprise Edition** during this step

1. Select **continue** and you will need to fill in a series of options in order to finish creating your account. 

    + Ensure you select the region that is most appropriate based on where your S3 Bucket is located containing your TA report files.

        ![Select Region and Amazon S3 Discovery](/Cost/200_Cloud_Intelligence/Images/QS-s3.png?classes=lab_picture_small)
    
    + Enable the Amazon S3 option and select the bucket where your Trusted Advisor Organizational View reports are located

        ![Image of s3 buckets that are linked to the QuickSight account. Enable bucket and give Athena Write permission to it.](/Cost/200_Cloud_Intelligence/Images/QS-s3-bucket.png?classes=lab_picture_small)

1. Click **Finish** & wait for the congratulations screen to display

1. Click **Go to Amazon QuickSight**

    ![Image](/Cost/200_Cloud_Intelligence/Images/QS-Congrats.png?classes=lab_picture_small)

1. Check you have **Amazon QuickSight Enterprise Edition**

    ![Image](/Cost/200_Cloud_Intelligence/Images/QS-enterprise.png?classes=lab_picture_small)

{{% /expand%}}

{{< prev_next_button link_prev_url="../../" link_next_url="../2_create-upload-ta-report/" />}}
