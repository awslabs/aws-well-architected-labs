---
title: "Level 200: EC2 Right Sizing"
#menutitle: "Lab #3"
date: 2020-12-17T11:16:08-04:00
chapter: false
weight: 6
---
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

## Steps:
{{% children  /%}}


{{< prev_next_button link_next_url="./1_intro_right_sizing/" button_next_text="Start Lab" first_step="true" />}}