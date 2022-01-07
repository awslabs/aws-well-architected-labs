---
title: "Create & Upload Trusted Advisor Report"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---


### Create and upload Trusted Advisor Organizational View report
There are 2 supported data collection methods:
1. **Trusted Advisor Organizational View** - provides an easy way to collect Trusted Advisor checks for all accounts in your AWS Organizations without need to provision any additional resources. Only manual data refresh is supported.
2. **Trusted Advisor API via deployment of [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/)** - provides an automated way to collect Trusted Advisor checks for all accounts in your AWS Organizations via deployment of required AWS resources from provided AWS CloudFormation templates. Supports automated data refresh.

Please expand data collection method which you used in prerequisites step to proceed with workshop:
{{%expand "Trusted Advisor Organizational View" %}}


**NOTE:** At the moment TA Organizational View supports only manual report generation. Periodic refresh is required for the latest trends
    ------------ | -------------

1. **Create** Organizational View report

    For the step by step guide please follow [the documentation](https://docs.aws.amazon.com/awssupport/latest/user/organizational-view.html#create-organizational-view-reports)

    ![Image](/Cost/200_Cloud_Intelligence/Images/TA_org_view_create_report.png?classes=lab_picture_small)

    + Please choose **JSON** format for report
    + You can select either all accounts and Trusted Advisor checks or filter by particular checks or Organizational Unit (OU). There is no limitation from dashboard deployment point of view

{{% notice note %}}
You can select certain accounts but please ensure you maintain consistency in following reports for periodic refreshes to avoid data mismatch. 
{{% /notice %}}

1. **Download** Organizational View report

    ![Image](/Cost/200_Cloud_Intelligence/Images/TA_org_view_download_report.png?classes=lab_picture_small)

    + For step by step guide please follow [the documentation](https://docs.aws.amazon.com/awssupport/latest/user/organizational-view.html#download-organizational-view-reports)

1. **Unzip** downloaded report

1. **Upload** downloaded report to the `reports` folder in the S3 bucket

    Make sure you upload **unzipped** folder to S3 bucket
    ![Image](/Cost/200_Cloud_Intelligence/Images/tao/S3-upload-report.png?classes=lab_picture_small)![Image](/Cost/200_Cloud_Intelligence/Images/tao/S3-upload-report2.png?classes=lab_picture_small)

**NOTE:** You can upload as many folders with reports as you need. Dashboard will use all uploaded data to show trends over time
    ------------ | -------------
{{% /expand%}}
{{%expand "Trusted Advisor API via deployment of Optimization Data Collection lab" %}}
Please makes sure you've deployed [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/) as prerequisite step. Once [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/) completed, please proceed with next steps. During next steps please provide S3 URI path to `ta-data` folder in optimization data bucket created in the lab. The path should be similar to `s3://costoptimizationdata{account_id}/optics-data-collector/ta-data/`

**NOTE:** Only **Trusted Advisor Data Collection Module** is required to be deployed. Consider other modules form the lab as optional
    ------------ | -------------
{{% /expand%}}
{{< prev_next_button link_prev_url="../1_prerequistes" link_next_url="../3_deployment/" />}}
