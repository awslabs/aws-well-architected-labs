---
title: "Level 100: EC2 Right Sizing"
#menutitle: "Lab #3"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 6
---
## Authors
- Arthur Basbaum, AWS Cloud Economics

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
 This hands-on lab will give you an overview on **Amazon CloudWatch** and **AWS Resource Optimization** and how to prioritize your EC2 Right Sizing efforts.

## Goals
- Learn how to check metrics like CPU, Network and Disk usage on Amazon CloudWatch
- Enable and use the AWS Resource Optimization and get EC2 Right Sizing recommendations
- Learn how to filter AWS Resource Optimization report and focus only on the less complex high saving cases

## Prerequisites
- Root user access to the master account
- Enable AWS Resource Optimization at *AWS Cost Explorer > Recommendations* no additional cost.

## Permissions required
- Log in as the Cost Optimization team, created in [AWS Account Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}})
- NOTE: There may be permission error messages during the lab, as the console may require additional privileges. These errors will not impact the lab, and we follow security best practices by implementing the minimum set of privileges required.

## Steps:
{{% children  %}}

