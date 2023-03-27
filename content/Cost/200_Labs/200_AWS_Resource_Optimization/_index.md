---
title: "Level 200: Rightsizing with Compute Optimizer"
#menutitle: "Lab #3"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 7
---
## Last Updated
October 2021

## Authors
- Jeff Kassel, AWS Technical Account Manager
- Arthur Basbaum, AWS Cloud Economics
- Travis Ketcherside, AWS Technical Account Manager

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
 This hands-on lab will guide you through the steps to install the CloudWatch agent to collect memory utilization (% GB consumption) and analyze how that new datapoint can help during rightsizing exercises with the AWS Compute Optimizer.

## Goals
- Install and collect memory statistics through a custom metric using Amazon CloudWatch
- Use AWS Compute Optimizer to gain insights into rightsizing recommendations on AWS

## Prerequisites
- Completion of [Level 100: Rightsizing Recommendations](https://wellarchitectedlabs.com/cost/100_labs/100_aws_resource_optimization/)
- Enable [AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/getting-started/) at no additional cost. After AWS Compute Optimizer is enabled it may take up to 12 hours to fully analyze the AWS resources in your account.

## Costs
Use of AWS Compute Optimizer is free, but costs associated with CloudWatch and EC2 will be accrued once free tier usage is consumed. Please visit the [CloudWatch](https://aws.amazon.com/cloudwatch/pricing/) and [EC2](https://aws.amazon.com/ec2/pricing/) pricing pages for additional details. 

## Permissions required
- IAM permissions for [read-only access](https://docs.aws.amazon.com/compute-optimizer/latest/ug/security-iam.html#standalone-account-access) for AWS Compute Optimizer
- NOTE: There may be permission error messages during the lab, as the console may require additional privileges. These errors will not impact the lab, and we follow security best practices by implementing the minimum set of privileges required.

## Steps:
{{% children  /%}}


{{< prev_next_button link_next_url="./1_cloudwatch_intro/" button_next_text="Start Lab" first_step="true" />}}
