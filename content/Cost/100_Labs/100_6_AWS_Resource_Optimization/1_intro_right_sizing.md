---
title: "Intro to Rightsizing on AWS"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### Introduction

Rightsizing is the process of matching instance types and sizes to your workload performance and capacity requirements at the lowest possible cost. It’s also the process of looking at deployed instances and identifying opportunities to eliminate or downsize without compromising capacity or other requirements, which results in lower costs.

**Rightsizing is an ongoing process** and it's the most effective way to control cloud costs. It involves continually analyzing instance performance and usage needs and patterns—and then turning off idle instances and rightsizing instances that are either overprovisioned or poorly matched to the workload. Because your resource needs are always changing, rightsizing must become an ongoing process to continually achieve cost optimization. You can make rightsizing a smooth process by establishing a rightsizing schedule for each team, enforcing tagging for all instances, and taking full advantage of the powerful tools that AWS and others provide to simplify resource monitoring and analysis.

### Rightsizing for Amazon EC2 instances

Amazon EC2 provides [a wide selection of instance types optimized to fit different use cases](https://aws.amazon.com/ec2/instance-types/). Instance types comprise varying combinations of CPU, memory, storage, and networking capacity and give you the flexibility to choose the appropriate mix of resources for your applications. Each instance type includes one or more instance sizes, allowing you to scale your resources to the requirements of your target workload.

The first step to perform rightsizing on EC2 is to monitor your current use and gain insight into instance performance and usage patterns. To gather sufficient data, **observe performance over at least a two-week period (ideally, over a one-month period)** to capture the workload and business peaks. The most common metrics that define instance performance are: vCPU utilization, memory utilization, network utilization, and disk use.

This 100 level hands-on lab will give you an overview on **Rightsizing recommendations** and how to prioritize your EC2 rightsizing efforts. By the end of this lab you should: 1) Enable and use Rightsizing recommendations; 2) Learn how to filter Rightsizing recommendations report and focus only on the less complex high saving cases.

### EC2 Rightsizing Best Practices

* **Start simple:** Idle resources, non-critical development/QA, and previous generation instances will require less testing hours and provide quick wins (The Amazon EC2 Launch time statistics can be used to identify instances that have been running longer than others and is a good statistic to sort your Amazon EC2 instances by).
* **Rightsize before performing a migration:** If you skip rightsizing to save time, your migration speed might increase, but you will end up with higher cloud infrastructure spend for a potentially longer period of time. Instead, leverage the test and QA cycles during a migration exercise to test several instance types and families. Also, take that opportunity to test different sizes and burstable instances like the [“t” family](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-performance-instances.html).
* **The best rightsizing starts on day 1:** As you perform rightsizing analysis, and ultimately rightsize resources, ensure any learnings are being shared across your organization and influencing the design of new workloads and upcoming migrations.
* **Measure Twice, Cut Once: Test, then test some more:** The last thing you want is for a new resource type to be uncapable of handling load or functioning incorrectly.
* **Test once and perform multiple rightsizing:** Aggregate instances per autoscaling group and tags to scale rightsizing activities.
* **Combine Reserved Instance or Savings Plans strategies with rightsizing to maximize savings:** For Standard RIs and EC2 Instance SP: Perform your pricing model purchases after rightsizing and for Convertible RIs, exchange them after rightsizing. Compute Savings Plans will automatically adjust the commitment for the new environment.
* **Ignore burstable instance families (T types):** These families are designed to typically run at low CPU percentages for significant periods of time and shouldn’t be part of the instance types being analyzed for rightsizing.

#### Resources
- [AWS Cost Management - Rightsizing](https://aws.amazon.com/aws-cost-management/aws-cost-optimization/right-sizing/)
- [List of available CloudWatch metrics for EC2 instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html)
- [200 Level Rightsizing with AWS Compute Optimizer]({{< ref "/Cost/200_Labs/200_AWS_Resource_Optimization" >}})

{{< prev_next_button link_prev_url="../" link_next_url="../2_resource_opt/" />}}
