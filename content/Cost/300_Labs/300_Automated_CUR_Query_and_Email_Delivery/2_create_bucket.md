---
title: "Create S3 Bucket"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

The first step is to create an S3 bucket which will hold the lambda code and also used for storage of the reports. **NOTE**: the bucket must be in the same region as the Lambda function, it is advised to use a single region for all resources within this lab.

This bucket will store the reports and Athena CUR query results. These will **not** be deleted, to enable historical reporting, so delete these periodically if you do not require them.

1. Login via SSO, go to the **s3 dashboard** and create an S3 bucket in the required region:
![Images/s3_setup01.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/s3_setup01.png)
