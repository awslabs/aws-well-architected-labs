---
title: "Level 200: EC2 Right Sizing"
#menutitle: "Lab #3"
date: 2021-01-13T11:16:08-04:00
chapter: false
weight: 6
---
## Last Updated
December 2020

## Authors
- Jeff Kassel, AWS Technical Account Manager
- Arthur Basbaum, AWS Cloud Economics
- Travis Ketcherside, AWS Technical Account Manager

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
This hands-on lab will guide you through the steps to install the CloudWatch agent to collect memory utilization (% GB consumption) and use AWS Compute Optimizer to right-size EC2 Instances, EBS volumes, and auto-scaling groups.

## Goals
- Learn how to attach IAM roles to an EC2 instance for CloudWatch custom metric collection
- Learn how to install and collect memory data through a custom metric at Amazon CloudWatch
- Use AWS Compute Optimizer to gain insights into EC2 right-sizing

## Prerequisites
- Root user access to the management account
- Completion of [Level 100: EC2 Right Sizing](https://wellarchitectedlabs.com/cost/100_labs/100_aws_resource_optimization/)
- Enable [AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/getting-started/) at no additional cost.

## Permissions required
- Root user access to the management account
- NOTE: There may be permission error messages during the lab, as the console may require additional privileges. These errors will not impact the lab, and we follow security best practices by implementing the minimum set of privileges required.

## Costs
- https://aws.amazon.com/aws-cost-management/pricing/
- There are no costs for this lab but you need to have at least 1 Amazon EC2 instance running. If you don't have any instance running please check the [AWS Free Tier page](https://aws.amazon.com/free/) for more information.

## Time to complete
- The lab should take approximately 35 minutes to complete

## Steps:
{{% children  /%}}


{{< prev_next_button link_next_url="./1_intro_right_sizing/" button_next_text="Start Lab" first_step="true" />}}