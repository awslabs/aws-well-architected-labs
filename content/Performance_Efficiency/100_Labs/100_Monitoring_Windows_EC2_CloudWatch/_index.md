---
title: "Level 100: Monitoring Windows EC2 instance with CloudWatch Dashboards"
menutitle: "Monitoring Windows EC2 with CloudWatch Dashboards"
date: 2020-11-19T11:16:08-04:00
chapter: false
weight: 3
hidden: false
description: "How to configure an Amazon CloudWatch Dashboard to get aggregated views of the health and performance of a Windows EC2 instance."
tags:
 - Windows Server
 - Windows
 - EC2
 - CloudWatch
 - CloudWatch Dashboard

---
## Authors
- Eric Pullen, Performance Efficiency Lead Well-Architected

## Introduction

This hands-on lab will guide you through creating an Amazon EC2 instance for Windows and then configuring a Amazon CloudWatch Dashboard to get aggregated views of the health and performance information for that instance. This lab should enables you to quickly get started with CloudWatch monitoring and explore account and resource-based views of metrics. You can find more best practices by reading the [Performance Efficiency Pillar of the AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/performance-efficiency-pillar/welcome.html).
The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Goals

* Monitor a Windows EC2 machine to identify CPU and memory bottlenecks

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes
* An IAM role in your AWS account

## Costs
- https://aws.amazon.com/cloudwatch/pricing/
  - You can create 3 dashboards for up to 50 metrics per month on the free tier and then it is $3.00 per dashboard per month
  - This lab creates one dashboard, so the maximum cost would be $3.00 per month if you have already consumed the free tier.
- The default lab uses a t3.large EC2 instance which will consume approximately $3.00 for every day the lab is running
- The VPC that is created for this lab will build a Nat Gateway, and will consume $5.50 per day when deployed.
- Using defaults, the total cost of the lab would be at least $8.50 per day

{{% notice note %}}
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

{{< prev_next_button link_next_url="./1_deploy_vpc/" button_next_text="Start Lab" first_step="true" />}}

## Steps:
{{ children }}
