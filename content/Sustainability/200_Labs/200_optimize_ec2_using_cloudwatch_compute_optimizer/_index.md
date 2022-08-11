---
title: "Level 200: Optimize Hardware Patterns using AWS Compute Optimizer and Observe Sustainability kpis using Amazon CloudWatch"
menutitle: "Optimize Hardware Patterns using AWS Compute Optimizer and Amazon CloudWatch"
date: 2020-11-18T09:00:08-04:00
chapter: false
weight: 1
hidden: false
---
## Author

- **Neha Garg**, Enterprise Solutions Architect.
- **Jang Whan Han**, Well-Architected Geo Solutions Architect.

## Contributor
- **Stephen Salim**, Well-Architected Geo Solutions Architect.
- **Sam Mokhtari**, Sr Sustainability Lead SA Well-Architected.

## Introduction

This lab focuses on optimizing hardware patterns for sustainability by minimizing the amount of hardware needed to provision and deploy, and select the most efficient hardware for your individual workload.

## Goals
At the end of this lab you will:

* Understand AWS Well-Architected Sustainability Pillar [best practices for hardware patterns](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/hardware-patterns.html)
* Learn how to optimize your architecture for minimum amount of hardware usage using [AWS Compute Optimizer](https://aws.amazon.com/aws-cost-management/aws-cost-optimization/right-sizing/)
* Learn how to use [Amazon CloutWatch metric math](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html) feature to observe **sustainability key performance indicators (KPIs)**. 

## Prerequisites

* The lab is designed to run in your own AWS account.
* Enable [AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/)
* We will deploy a sample web application and will automatically generate a worklaod to simulate requests from users.

## Costs
* **t4g.xlarge** instance will be deployed as a baseline Amazon EC2 instance. We will change Amazon EC2 instance type from c4.xlarge to **c7g.large** to reduce idle resources.

{{% notice note %}}
**NOTE:** You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}
* [AWS Pricing](https://aws.amazon.com/pricing/)

## Lab duration
Estimated time required to complete this lab is 40 minutes.

## Sustainability improvement process
The improvement process includes understanding what you have and what you can do to improve, selecting targets for improvement, testing improvements, adopting successful improvements, quantifying your success and sharing what you have learned so that it can be replicated elsewhere, and then repeating the cycle.

For more details, refer to [Sustainability Pillar Whitepaper](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/improvement-process.html) which explains the iterative process that evaluates, prioritizes, tests, and deploys sustainability-focused improvements for cloud workloads.

In this lab we shall illustrate each step of the Sustainability improvement process to achieve sustainability goals by following hardware pattern best practices for sustainability in the cloud. 

We shall learn how you can improve the sustanability goals by using the fewest number of compute resources and achieving a high utilization, specifically focused on rightsizing AWS infrastructure based on recommendations that AWS Compute Optimizer analyzed. Also, we will learn how Amazon CloudWatch Logs and Metrics will be able to simply help you measure Proxy metric for provisioned resource, business metrics as well as calculate Key performance indicators for Sustainability to quantify your success.

Refer to [Sustainability Pillar Whitepaper](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/evaluate-specific-improvements.html) for detailed understanding around evaluating specific improvements. At high level:
* Use Proxy metrics to measure the resources provisioned to achieve business outcomes. For this lab, we will use vCPU minutes proxy metrics for Compute resource

  ![Proxy Metrics](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-0/images/proxy_metrics_type.png?classes=lab_picture_small)

* Select business metrics to quantify the achievement of business outcomes. Your business metrics should reflect the value provided by your workload, for example, the number of simultaneous active users, API calls served, or the number of transactions completed. For this lab, we will use total number of API calls served (business outcome) as business metric.

* To calculate a sustainability key performance indicator (KPI), we will use the following formula, divide the provisioned resources by the business outcomes achieved to determine the provisioned resources per unit of work:

    ![Sustainability KPI](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-0/images/sustainability_kpi2.png?classes=lab_picture_small)


## Example Scenario
The following example scenario is referenced in this lab:

Your company has a workload running on Amazon EC2 instance. You have number of API calls served and measured as business metrics to quantify the achievement of business outcomes.

  Our improvement goal is to:
  * To eliminate waste, low utilization, and idle or unused resources
  * To maximize the value from resources you consume


{{< prev_next_button link_next_url="./1_prerequisites/" button_next_text="Start Lab" first_step="true" />}}

## Steps:
{{% children  %}}
