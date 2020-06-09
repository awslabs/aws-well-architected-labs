---
title: "Getting Started"
menutitle: "Getting Started"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### 1.1 Install the AWS CLI

Although instructions in this lab are written for both AWS Management console and AWS CLI, its best to install the AWS CLI on the machine you will be using as you can modify the example commands to run different scenarios easily and across multiple AWS accounts.

* [Install the AWS CLI on macOS](https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html)
* [Install the AWS CLI on Linux](https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html)
* [Install the AWS CLI on Windows](https://docs.aws.amazon.com/cli/latest/userguide/install-windows.html)

You will also need jq to parse json from the CLI:
* [Install jq ](https://stedolan.github.io/jq/download/)

A best practice is to enforce the use of MFA, so if you misplace your AWS Management console password and/or access/secret key, there is nothing anyone can do without your MFA credentials. You can follow the instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html) to configure AWS CLI to assume a role with MFA enforced.

### 1.2 Amazon CloudWatch Logs

[Amazon CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html) can be used to monitor, store, and access your log files from Amazon Elastic Compute Cloud (Amazon EC2) instances, AWS CloudTrail, Amazon Route 53, Amazon VPC Flow Logs, and other sources. It is a [best practice](https://wa.aws.amazon.com/wat.question.SEC_4.en.html) to enable logging and analyze centrally, and develop investigation proceses. Using the AWS CLI and developing runbooks for investigation into different events can be significantly faster than using the console. If your logs are stored in Amazon S3 instead, you can use [Amazon Athena](https://docs.aws.amazon.com/athena/latest/ug/what-is.html) to directly analyze data.

To list the Amazon CloudWatch Logs Groups you have configured in each region, you can describe them. Note you must specify the region, if you need to query multiple regions you must run the command for each. You must use the region ID such as *us-east-1* instead of the region name of *US East (N. Virginia)* that you see in the console. You can obtain a list of the regions by viewing them in the [AWS Regions and Endpoints](https://docs.aws.amazon.com/general/latest/gr/rande.html) or using the CLI command: `aws ec2 describe-regions`.
To list the log groups you have in a region, replace the example us-east-1 with your region:
`aws logs describe-log-groups --region us-east-1`
The default output is json, and it will give you all details. If you want to list only the names in a table:
`aws logs describe-log-groups --output table --query 'logGroups[*].logGroupName' --region us-east-1`
