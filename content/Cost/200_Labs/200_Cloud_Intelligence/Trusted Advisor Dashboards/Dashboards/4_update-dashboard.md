---
title: Optional Steps
date: 2021-02-10T11:43:22+00:00
weight: 4
chapter: false
pre: "<b>4. </b>"
---

### Optional Step 1: Update dashboard template

1. Pull latest dashboard version from template:
    ```bash
    aws quicksight update-dashboard --aws-account-id {account} --region {region} --cli-input-json file://update-dashboard-input.json
    ```

1. Update published version of dashboard:
    ```bash
    aws quicksight list-dashboard-versions --aws-account-id {account} --region {region} --dashboard-id ta-organizational-view --query 'DashboardVersionSummaryList[-1].VersionNumber' | xargs -I {} aws quicksight update-dashboard-published-version --aws-account-id {account} --dashboard-id ta-organizational-view --version-number {}
    ```
1. Apply the latest pulled changes to the deployed dashboard with this CLI command:
    ```bash
    aws quicksight update-dashboard-published-version --region {region} --aws-account-id {account} --dashboard-id ta-organizational-view --version-number {version}
    ```
**Alternatively automation script can be used for update**

The [Cloud Intelligence Dashboards automation repo](https://github.com/aws-samples/aws-cudos-framework-deployment) is an optional way to create the Cloud Intelligence Dashboards using a collection of setup automation scripts. The supplied scripts allow you to complete the workshops in less than half the time as the standard manual setup.

Follow the [How to use steps](https://github.com/aws-samples/aws-cudos-framework-deployment#how-to-use) for installation and dashboard deployment. We recommend to use **AWS CloudShell** for automated deployment

### Optional Step 2: Add new TA Organizational view report

{{% notice tip %}}
By default Trusted Advisor (TA) refreshes checks on weekly basis. To get historical progress and trends visualized on TAO Dashboard we recommend to upload new TA Organizational View reports regularly, for example bi-weekly or monthly
{{% /notice %}}

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
    ![Image](/Cost/200_Cloud_Intelligence/Images/S3-upload-report.png?classes=lab_picture_small)![Image](/Cost/200_Cloud_Intelligence/Images/tao/S3-upload-report2.png?classes=lab_picture_small)

1. **Open** and **Refresh** ta-organizational-view dataset in QuickSight
![Image](/Cost/200_Cloud_Intelligence/Images/tao/QS_refresh_ds.png?classes=lab_picture_small)

### Optional Step 3: Switch data collection method
There are 2 supported data collection methods:
1. **Trusted Advisor Organizational View** - provides an easy way to collect Trusted Advisor checks for all accounts in your AWS Organizations without need to provision any additional resources. Only manual data refresh is supported.
2. **Trusted Advisor API via deployment of [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/)** - provides an automated way to collect Trusted Advisor checks for all accounts in your AWS Organizations via deployment of required AWS resources from provided AWS CloudFormation templates. Supports automated data refresh.

If you deployed TAO Dashboard with Trusted Advisor Organizational View as data collection method you can switch at any time to Trusted Advisor API via deployment of [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/). For that:

1.  Makes sure you've deployed [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/) as prerequisite step
2. Depending on which [deployment option](../3_deployment) you used during initial deployment of TAO Dashboard follow the steps below:
{{%expand "Automated or CloudFormation deployment" %}}
1. **Launch** [AWS CloudShell](https://console.aws.amazon.com/cloudshell/home)
2. **Clone** [repository](https://github.com/aws-samples/aws-cudos-framework-deployment) (if haven't done before) and navigate to legacy/tao folder:
    ```bash
    git clone https://github.com/aws-samples/aws-cudos-framework-deployment
    cd aws-cudos-framework-deployment/legacy/tao
    ```
3. **Run** the following script: 
    ```bash
    ./shell-script/tao.sh --action=change-source-location
     ```       
{{% notice note %}}
When asked, provide S3 URI path to ta-data folder in optimization data bucket created in the [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/). The path should be similar to s3://costoptimizationdata{account_id}/optics-data-collector/ta-data/
{{% /notice %}}
{{% /expand%}}
{{%expand "Manual deployment" %}}
1. **Change** `{s3FolderPath}` in `athena-table.json` file created in [Prepare configuration](../workshop/prepare-configs.html) step to S3 URI path to ta-data folder in optimization data bucket created in the [Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/). The path should be similar to `s3://costoptimizationdata{account_id}/optics-data-collector/ta-data/`
1. **Update** Glue table is the metadata definition with following command:
    ```bash
    aws glue update-table --region {region} --cli-input-json file://athena-table.json
    ```
1. **Open** and **Refresh** ta-organizational-view dataset in QuickSight
![Image](/Cost/200_Cloud_Intelligence/Images/tao/QS_refresh_ds.png?classes=lab_picture_small)
{{% /expand%}}


{{< prev_next_button link_prev_url="../3_deployment/"  link_next_url="https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/teardown/4_teardown/">}}