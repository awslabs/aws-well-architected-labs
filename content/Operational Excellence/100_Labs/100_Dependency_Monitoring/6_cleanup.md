---
title: "Tear down this lab"
date: 2020-09-15T11:16:09-04:00
chapter: false
weight: 6
pre: "<b>6. </b>"
---

The following instructions will remove the resources that you have created in this lab.

#### Cleaning up Amazon CloudWatch Resources

1. Go to the Amazon CloudWatch console at <https://console.aws.amazon.com/cloudwatch> and click on **Alarms**
1. Search for the alarm `WA-Lab-Dependency-Alarm` and click on it
1. Click on **Delete** on the top right hand corner
1. Click **Delete**

#### Cleaning up AWS Systems Manager OpsCenter Resources

1. Go to the AWS Systems Manager console at <https://console.aws.amazon.com/systems-manager> and click on **OpsCenter**
1. Click on the **OpsItems** tab, search by **Title**, select **contains**, and enter the value as `S3 Data Writes`
1. Click on the OpsItem that has been created with the title **S3 Data Writes failing**
1. Click on **Set status** on the top right hand corner, and select **Resolved**

#### Cleaning up the CloudFormation Stack

1.  Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation> and click on the `Dependency-Monitoring-Lab`
1.  Click on **Delete** and then **Delete stack**

Thank you for using this lab.
