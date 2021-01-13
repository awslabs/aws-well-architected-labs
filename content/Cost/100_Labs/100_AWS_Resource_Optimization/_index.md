---
title: "Level 100: EC2 Right Sizing"
#menutitle: "Lab #3"
date: 2021-01-13T11:16:08-04:00
chapter: false
weight: 6
---
## Last Updated
December 2020

## Authors
- Arthur Basbaum, AWS Cloud Economics
- Travis Ketcherside, Technical Account Manager 

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
 This hands-on lab will give you an overview on **Amazon CloudWatch** and **AWS Resource Optimization** and how to prioritize your EC2 Right Sizing efforts.

## Goals
- Learn how to check metrics like CPU, Network and Disk usage on Amazon CloudWatch
- Enable and use the AWS Resource Optimization and get EC2 Right Sizing recommendations
- Learn how to filter AWS Resource Optimization report and focus only on the less complex high saving cases

## Prerequisites
- Have at least one Amazon EC2 instance running
- Enable AWS Resource Optimization at *AWS Cost Explorer > Recommendations* no additional cost.

## Permissions required
- Log in as the Cost Optimization team, created in [AWS Account Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup/4_configure_sso.html" >}})
- NOTE: There may be permission error messages during the lab, as the console may require additional privileges. These errors will not impact the lab, and we follow security best practices by implementing the minimum set of privileges required.

## Costs
- https://aws.amazon.com/aws-cost-management/pricing/
- There are no costs for this lab but you need to have at least 1 Amazon EC2 instance running. If you don't have any instance running please check the [AWS Free Tier page](https://aws.amazon.com/free/) for more information.

## Time to complete
- The lab should take approximately 30 minutes to complete

## Steps:
{{% children  /%}}

{{< prev_next_button link_next_url="./1_intro_right_sizing/" button_next_text="Start Lab" first_step="true" />}}