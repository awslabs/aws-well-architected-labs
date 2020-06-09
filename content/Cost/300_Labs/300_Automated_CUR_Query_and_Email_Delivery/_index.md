---
title: "Level 300: Automated Athena CUR Query and E-mail Delivery"
#menutitle: "Lab #1"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 1
hidden: false
---
## Authors
- Na Zhang, Sr. Technical Account Manager, AWS

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
This hands-on lab will guide you through deploying an automatic CUR query & E-mail delivery solution using Athena, Lambda, SES and CloudWatch. The Lambda function is triggered by a CloudWatch event, it then runs saved queries in Athena against your CUR file. The queries are grouped into a single report file (xlsx format), and sends report via SES. This solution provides automated reporting to your organization, to both consumers of cloud and financial teams.

![Images/architecture.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/architecture.png)

## Goals
- Provide automated financial reports across your organization

## Prerequisites
- CUR is enabled and delivered into S3, with Athena integration. Recommend to complete [200_4_Cost_and_Usage_Analysis]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}})
- If your account is in the SES sandbox(default), verify your email addresses in SES to assure you can send or receive emails via verified mail addresses: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-email-addresses.html


## Permissions required
- Create IAM policies and roles
- Write and read to/from S3 Buckets
- Create and modify Lambda functions
- Create, save and execute Athena queries
- Verify e-mail address, send mail in SES


## Costs
- Variable, dependent on the amount of data scanned and report frequency
- Approximately <$5 a month for small to medium accounts


## Time to complete
- The lab should take approximately 15 minutes to complete


## Steps:
{{% children  %}}
