---
title: "Prerequisites"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---


### Enable Trusted Advisor Data Collection

There are 2 supported data collection methods:
1. **Trusted Advisor API with [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/) (recommended)** - provides an automated way to collect Trusted Advisor checks for all accounts in your AWS Organizations via deployment of required AWS resources from provided AWS CloudFormation templates. Supports automated data refresh.
2. **Trusted Advisor Organizational View** - provides an easy way to collect Trusted Advisor checks for all accounts in your AWS Organizations without need to provision any additional resources. Only manual data refresh is supported.


Please choose preferred data collection method and expand respective section below to proceed:

{{%expand "Trusted Advisor API with Optimization Data Collection lab (recommended)" %}}
Please follow the steps in [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/). Once [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/) completed, please proceed with next steps. 
**NOTE:** Only **Trusted Advisor Data Collection Module** is required to be deployed. Consider other modules form the lab as optional
    ------------ | -------------
{{% /expand%}}

{{%expand "Trusted Advisor Organizational View" %}}
**NOTE:** Only use this method of data collection method if you for some reasons you can't and don't plan to deploy [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/). Otherwise use recommended method with [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/)
    ------------ | -------------

#### Enable Trusted Advisor Organizational View

For the step by step guide please follow [the documentation](https://docs.aws.amazon.com/awssupport/latest/user/organizational-view.html#enable-organizational-view)

![Image](/Cost/200_Cloud_Intelligence/Images/tao/TA_org_view_enable.png?classes=lab_picture_small)

#### Create S3 bucket.

1. Create an S3 bucket with the name `costoptimizationdata{account_id}` in a [QuickSight supported AWS region](https://docs.aws.amazon.com/quicksight/latest/user/regions.html) (for example us-east-1)

2. Create new folder `optics-data-collector` and then `ta-data` within it so the whole path looks like `s3://costoptimizationdata{account_id}/optics-data-collector/ta-data/`.

{{% notice note %}}
You can use any S3 bucket name. Please save {bucket} name. It will be needed in Stage 2
{{% /notice %}}
{{% /expand%}}



### Enable QuickSight 
QuickSight is the AWS Business Intelligence tool that will allow you to not only view the Standard AWS provided insights into all of your accounts, but will also allow to produce new versions of the Dashboards we provide or create something entirely customized to you. If you are already a regular QuickSight user you can skip these steps.


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


{{< prev_next_button link_prev_url="../../" link_next_url="../2_create-upload-ta-report/" />}}
