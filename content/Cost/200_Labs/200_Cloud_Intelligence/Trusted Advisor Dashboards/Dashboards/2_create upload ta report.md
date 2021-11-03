---
title: "Create & Upload Trusted Advisor Report"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---


### Stage 1 - Create and upload Trusted Advisor Organizational View report

{{% notice note %}}
At the moment TA Organizational View supports only manual report generation. Periodic refresh is required for the latest trends.
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
    ![Image](/Cost/200_Cloud_Intelligence/Images/S3-upload-report.png?classes=lab_picture_small)

{{% notice note %}}
You can upload as many folders with reports as you need. Dashboard will use all uploaded data to show trends over time
{{% /notice %}}

{{< prev_next_button link_prev_url="../1_prerequistes" link_next_url="../3_auto_deployment/" />}}
