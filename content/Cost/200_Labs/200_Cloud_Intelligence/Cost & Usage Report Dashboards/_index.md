---
title: "Cost & Usage Report Dashboards"
#menutitle: "Lab #2"
date: 2020-09-07T11:16:08-04:00
chapter: false
weight: 1
hidden: false
pre: "<b> </b>"
---
## Last Updated

July 2021


## Feedback

If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: cloud-intelligence-dashboards@amazon.com

## Introduction

The dashboards in this section use data exclusively from the [AWS Cost and Usage Report.](https://aws.amazon.com/aws-cost-management/aws-cost-and-usage-reporting/) 

{{% notice note %}}
For explanations on each field and visual found in the **Cost Intelligence Dashboard** (as well as some FAQs) download and read the [CID User Guide](/Cost/200_Enterprise_Dashboards/Cost_Intelligence_Dashboard_ReadMe.pdf)
{{% /notice %}}

The AWS Cost & Usage Report (CUR) contains the most comprehensive set of AWS cost and usage data available, including additional metadata about AWS services, pricing, Reserved Instances, and Savings Plans. The CUR itemizes usage at the account or Organization level by product code, usage type and operation. These costs can be further organized by enabling Cost Allocation tags and Cost Categories. The AWS Cost & Usage Report is available at an hourly, daily, or monthly level of granularity.

![Images/CIDframework.png](/Cost/200_Cloud_Intelligence/Images/CIDframework.png?classes=lab_picture_small)

{{% notice note %}}
 These dashboards and their content: (a) are for informational purposes only, (b) represents current AWS product offerings and practices, which are subject to change without notice, and (c) does not create any commitments or assurances from AWS and its affiliates, suppliers or licensors. AWS content, products or services are provided “as is” without warranties, representations, or conditions of any kind, whether express or implied. The responsibilities and liabilities of AWS to its customers are controlled by AWS agreements, and this document is not part of, nor does it modify, any agreement between AWS and its customers. We recommend validating your data by comparing the aggregate un-grouped Payer and Linked Account spend for a prior month. Customers are responsible for making their own independent assessment of these dashboards and their content.
{{% /notice %}} 

## Goals

- Create the Cost Intelligence dashboard
- Create the CUDOS dashboard
- Create Additional Dashboards
	- Data Transfer Dashboard
	- Trends Dashboard 

- Distribute your dashboards in your organization


## Permissions

- Permission to access Amazon Athena, AWS Glue, the Amazon S3 bucket where the CUR lives, and Amazon QuickSight via both the console and the Command Line Tool. 
- Permissions for CloudFormation is helpful but not required. 

{{% notice note %}}
Detailed permissions are shared in the next step
{{% /notice %}}

## Costs

- A QuickSight Enterprise license starts at $18 per month. 
- Incremental costs associated with AWS Glue, Amazon Athena, and Amazon S3. 
- Estimated total cost for all Dashboards together in a large AWS deployment is $54 per month. 

## Time to complete

Approximately 45-60 minutes to onboard all CUR dashboards in this section manually. If using the optional automation steps, setup should take approximately 15-30 minutes to complete.

## Steps:

{{% children  /%}}

{{% notice note %}}
Additional Dashboards include the **Data Transfer Dashboard** and **Trends Dashboard** 
{{% /notice %}} 

{{< prev_next_button link_next_url="../cost-usage-report-dashboards/dashboards/1_prerequistes/" button_next_text="Start Lab" first_step="true" />}}