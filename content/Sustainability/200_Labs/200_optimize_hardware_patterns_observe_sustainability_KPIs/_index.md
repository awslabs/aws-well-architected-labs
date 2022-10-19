---
title: "Level 200: Optimize Hardware Patterns and Observe Sustainability KPIs"
menutitle: "Optimize Hardware Patterns and Observe Sustainability KPIs"
date: 2020-11-18T09:00:08-04:00
chapter: false
weight: 1
hidden: false
---
## Author

- **Neha Garg**, Enterprise Solutions Architect.
- **Jang Whan Han**, Solutions Architect, AWS Well-Architected.

## Contributor
- **Stephen Salim**, Well-Architected Geo Solutions Architect.
- **Sam Mokhtari**, Sr Sustainability Lead SA Well-Architected.

## Introduction

This lab focuses on optimizing hardware patterns for sustainability by minimizing the amount of resources required to efficiently deploy your workload.

## Goals
At the end of this lab you will:

* Understand [design principles](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/design-principles-for-sustainability-in-the-cloud.html) in the AWS Well-Architected Sustainability Pillar 
* Understand [best practices for hardware patterns](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/hardware-patterns.html) in the AWS Well-Architected Sustainability Pillar
* Learn how to optimize your architecture for minimum amount of hardware usage using [AWS Compute Optimizer](https://aws.amazon.com/aws-cost-management/aws-cost-optimization/right-sizing/)
* Learn how to use [Amazon CloudWatch  metric math](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html) feature to observe **[sustainability key performance indicators (KPIs)](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/evaluate-specific-improvements.html#key-performance-indicators)**. 

## Prerequisites

* The lab is designed to run in your own AWS account.
* Enable [AWS Compute Optimizer.](https://aws.amazon.com/compute-optimizer/) 
* We will deploy a sample web application and will automatically generate a workload  to simulate requests from users.

## Costs
* **t4g.xlarge** instance (On-Demand hourly rate $0.1344) will be deployed as a baseline Amazon EC2 instance. We will change Amazon EC2 instance type from t4g.xlarge to **c6g.large** (On-Demand hourly rate $0.068) to use the appropriate amount of hardware to meet our business requirements.

{{% notice note %}}
**NOTE:** You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}
* [AWS Pricing](https://aws.amazon.com/pricing/)

## Lab Duration
Estimated time required to complete this lab is 40 minutes using screenshots of AWS Compute Optimizer.
It may take 12 hours if you want to see recommendations from AWS Compute Optimizer in your account. 

## What is the Sustainability Improvement Process?
The sustainability improvement process describes a series of steps which are cyclically performed to improve your workload.

For more details, refer to [Improvement process in Sustainability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/improvement-process.html) which explains the iterative process that evaluates, prioritizes, tests, and deploys sustainability-focused improvements for cloud workloads.

In this lab we will illustrate each step of the Sustainability Improvement Process by following hardware pattern best practices.

You will learn how you can improve the sustainability goals by rightsizing your EC2 instance. You will also learn how Amazon CloudWatch Logs and Metrics can be used to measure Proxy metrics for provisioned resources, business metrics, and KPIs for Sustainability to quantify your success.

Refer to [Evaluate specific improvements in Sustainability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/evaluate-specific-improvements.html) for detailed understanding around evaluating specific improvements. At high level:
* Use Proxy metrics to measure the resources provisioned to achieve business outcomes. For this lab, we will use vCPU minutes as proxy metrics for compute resource.

  ![Proxy Metrics](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-0/images/proxy_metrics_type.png?classes=lab_picture_small)

* Select business metrics to quantify the achievement of business outcomes. Your business metrics should reflect the value provided by your workload, for example, the number of simultaneous active users, API calls served, or the number of transactions completed. For this lab, we will use total number of API calls served (business outcome) as business metric.

* To calculate a sustainability key performance indicator (KPI), we will use the following formula:

    ```
    Resources provisioned per unit of work = Total number of vCPU minutes / The number of API requests per minute
    ```

* Estimate improvement as both the quantitative reduction in resources provisioned (as indicated by your proxy metrics) and the percentage change from your baseline resources provisioned per unit of work:

    ![Estimate Improvement](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section0/EstimateImprovement.png?classes=lab_picture_small)


{{< prev_next_button link_next_url="./1_prerequisites/" button_next_text="Start Lab" first_step="true" />}}

## Steps:
{{% children  %}}
