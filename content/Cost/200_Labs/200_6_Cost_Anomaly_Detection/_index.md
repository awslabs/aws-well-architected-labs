---
title: "Level 200 - Cost Anomaly Detection"
## menutitle: "Lab #1"
date: 2023-03-13T11:16:09-04:00
chapter: false
weight: 1
hidden: false
---

## Authors
* **Bilal Shuja**, Technical Account Manager.
* **Jerry Chen**, Well-Architected Geo Solutions Architect.

## Contributors
* **Ben Mergen**, Sr Cost Lead SA WA.

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Well-Architected Best Practices

This lab helps you to exercise the following Well-Architected Best Practices in your operation change process:

* [COST01-BP03](https://docs.aws.amazon.com/wellarchitected/latest/framework/cost_cloud_financial_management_budget_forecast.html) - **Establish cloud budgets and forecasts**
* [COST01-BP05](https://docs.aws.amazon.com/wellarchitected/2022-03-31/framework/cost_cloud_financial_management_usage_report.html) - **Report and notify on cost optimization**


## Introduction

 Reduce cost surprises and enhance control without slowing innovation with [AWS Cost Anomaly Detection](https://aws.amazon.com/aws-cost-management/aws-cost-anomaly-detection/). This hands-on lab will guide you through the steps to setup AWS Cost Anomaly Detection in your AWS account. AWS Cost Anomaly Detection is a monitoring feature that leverages advanced Machine Learning technologies to identify anomalous spend. Based on selected spend segments, Cost Anomaly Detection automatically determines patterns each day by adjusting for organic growth and seasonal trends. It triggers an alert when spend seems abnormal based on your normal resource usage pattern. This lab will walk you through the steps to analyze these alerts and investigate root cause. 

## Goals: 

* Setting up anomaly detection by creating monitors and alert subscription.
* Analyzing unusual spend detected by Cost Anomaly Detection and investigating the root cause


## Prerequisites:

* [AWS Account Setup]({{< ref "100_1_AWS_Account_Setup" >}}) has been completed

{{% notice note %}}
Cost Anomaly Detection require at least 10 days of historical service usage data before anomalies can be detected for that service. Make sure to use an account that has active resources for the past 10 days.
{{% /notice %}}

As an alternative an existing AWS account can be used to run this workshop.

{{% notice note %}}
It is strongly advised not to use production account for the purpose of this lab, use a test or sandbox account to understand the functionalities and capabilities of the service and then replicate the relevant configurations to the production accounts.
{{% /notice %}}

* AWS Cost Anomaly Detection is a feature within Cost Explorer. To access AWS Cost Anomaly Detection, Cost Explorer must be enabled. For instructions on how to enable Cost Explorer using the console, see [Enabling Cost Explorer](https://docs.aws.amazon.com/cost-management/latest/userguide/ce-enable.html).

For a multi-account AWS environment, Cost Anomaly Detection needs to be set up in the management account in order to analyze cost across whole AWS organisation and alert on anomalies for each linked account.

* An [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) or an [IAM role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) in your AWS account with full access to [AWS Cost Explorer](https://aws.amazon.com/aws-cost-management/aws-cost-explorer/) and [Amazon Simple Notification Service(SNS)](https://aws.amazon.com/sns/).

{{% notice note %}}
These permissions will allow the IAM user or the role to view your AWS account spend.
{{% /notice %}}

## Costs

AWS Cost Anomaly Detection service is free to use. The only applicable charges are SNS topic subscriptions which will be charged at the SNS rates. Customers that opt for email alerts have no associated costs.

{{< prev_next_button link_next_url="./1_cad_intro/" button_next_text="Start Lab" first_step="true" />}}

Steps:
{{% children  /%}}
