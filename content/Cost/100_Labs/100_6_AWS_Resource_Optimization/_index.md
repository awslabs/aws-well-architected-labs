---
title: "Level 100: Rightsizing Recommendations"
#menutitle: "Lab #3"
date: 2021-05-18T11:16:08-04:00
chapter: false
weight: 6
---
## Last Updated
June 2021

## Authors
- Arthur Basbaum, AWS Cloud Economics
- Travis Ketcherside, AWS Technical Account Manager

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com.

## Introduction
This hands-on lab will give you an overview on **Rightsizing recommendations** and how to prioritize your EC2 rightsizing efforts.

## Goals
- Enable and use Rightsizing recommendations
- Learn how to filter Rightsizing recommendations report and focus only on the less complex high saving cases

## Prerequisites
- Have at least one Amazon EC2 instance running
- Enable [Rightsizing recommendations](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/ce-rightsizing.html#rr-getting-started) at *AWS Cost Explorer > Rightsizing recommendations* (no additional cost)

## Permissions required
- A minimum of read-only access to the AWS Billing Console
- Read-only access can be granted via the AWSBillingReadOnlyAccess IAM Policy
- There may be permission error messages during the lab, as the console may require additional privilege
- These errors will not impact the lab, and we follow security best practices by implementing the minimum set of privileges required

## Costs
- There are no costs for this lab but you need to have at least 1 Amazon EC2 instance running. If you don't have any instance running please check the [AWS Free Tier page](https://aws.amazon.com/free/) for more information
- [Click here to check the costs associated with other AWS Cost Management tools](https://aws.amazon.com/aws-cost-management/pricing/)

## Steps
{{% children  /%}}

{{< prev_next_button link_next_url="./1_intro_right_sizing/" button_next_text="Start Lab" first_step="true" />}}
