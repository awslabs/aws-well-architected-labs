---
title: Optional Steps
date: 2021-02-10T11:43:22+00:00
weight: 4
chapter: false
pre: "<b>4. </b>"
---

### Add new TA Organizational view report

{{% notice tip %}}
By default Trusted Advisor (TA) refreshes checks on weekly basis. We recommend to use [Automated Data Collection Method](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/) to get historical progress and trends visualized on TAO Dashboard. However if you decided to use manual data collection you need to upload new TA Organizational View reports regularly, for example bi-weekly or monthly
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


{{< prev_next_button link_prev_url="../3_deployment/"  link_next_url="https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/teardown/4_teardown/">}}