---
title: "CUDOS, KPI and Cost Intelligence Dashboard"
#menutitle: "Lab #2"
date: 2022-10-10T11:16:08-04:00
chapter: false
weight: 1
hidden: false
pre: "<b> </b>"
---
## Last Updated

April 2023


## Feedback

If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: cloud-intelligence-dashboards@amazon.com

[Ask your questions](https://repost.aws/tags/TANKNkVH-tSUa2jYNx4F159g/cloud-intelligence-dashboards) on re:Post and get answers from our team, other AWS experts, and other customers using the dashboards. 

[Subscribe to our YouTube channel](https://www.youtube.com/channel/UCl0O3ASMCwA_gw0QIKzoU3Q/) to see guides, tutorials, and walkthroughs on all things Cloud Intelligence Dashboards. 

## Introduction

The dashboards in this section use data exclusively from the [AWS Cost and Usage Report.](https://aws.amazon.com/aws-cost-management/aws-cost-and-usage-reporting/) 

The AWS Cost & Usage Report (CUR) contains the most comprehensive set of AWS cost and usage data available, including additional metadata about AWS services, pricing, Reserved Instances, and Savings Plans. The CUR itemizes usage at the account or Organization level by product code, usage type and operation. These costs can be further organized by enabling Cost Allocation tags and Cost Categories.


![Images/CIDframework.png](/Cost/200_Cloud_Intelligence/Images/arch5.png?classes=lab_picture_small)


## Goals

- Create the Cost Intelligence dashboard
- Create the CUDOS dashboard
- Create the KPI dashboard
- Create Additional Dashboards
	- Data Transfer Dashboard
	- Trends Dashboard
- Distribute your dashboards in your organization


## Permissions

- Access to Management Account for creation of CUR, S3 bucket and S3 replication rules. If you do not have access to Management / Payer Account, you can install the same lab across multiple linked account consolidating CUR in one of them.
- In the Data Colection Account you will need permission to access Amazon Athena, AWS Glue, Amazon S3, and Amazon QuickSight via both the console and the Command Line Tool.
- Permissions for CloudFormation or access to the environment via CLI are required.
- For CLI deployment you can download and apply to your IAM Role this set of [minimal permissions](https://github.com/aws-samples/aws-cudos-framework-deployment/blob/main/assets/minimal_permissions.json)


## Costs

See [FAQ#pricing](/cost/200_labs/200_cloud_intelligence/faq/#pricing)

## Time to complete

If using automation steps, setup should take approximately 15-30 minutes to complete. Please note that the first data refresh of Cost and Usage Report may take 24h.

## Steps:

{{% children  /%}}

---

{{< prev_next_button link_next_url="../cost-usage-report-dashboards/dashboards/deploy_dashboards/" button_next_text="Start Lab" first_step="true" />}}
