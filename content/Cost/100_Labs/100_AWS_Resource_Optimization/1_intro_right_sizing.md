---
title: "Right Sizing on AWS"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

#### Introduction

Right sizing is the process of matching instance types and sizes to your workload performance and capacity requirements at the lowest possible cost. It’s also the process of looking at deployed instances and identifying opportunities to eliminate or downsize without compromising capacity or other requirements, which results in lower costs.

**Right sizing is an ongoing process** and it's the most effective way to control cloud costs. It involves continually analyzing instance performance and usage needs and patterns—and then turning off idle instances and right sizing instances that are either overprovisioned or poorly matched to the workload. Because your resource needs are always changing, right sizing must become an ongoing process to continually achieve cost optimization. You can make right sizing a smooth process by establishing a right-sizing schedule for each team, enforcing tagging for all instances, and taking full advantage of the powerful tools that AWS and others provide to simplify resource monitoring and analysis.

#### Right Sizing for Amazon EC2 instances

Amazon EC2 provides [a wide selection of instance types optimized to fit different use cases](https://aws.amazon.com/ec2/instance-types/). Instance types comprise varying combinations of CPU, memory, storage, and networking capacity and give you the flexibility to choose the appropriate mix of resources for your applications. Each instance type includes one or more instance sizes, allowing you to scale your resources to the requirements of your target workload. 

The first step to perform right sizing on EC2 is to monitor your current use and gain insight into instance performance and usage patterns. To gather sufficient data, **observe performance over at least a two-week period (ideally, over a one-month period)** to capture the workload and business peaks. The most common metrics that define instance performance are: vCPU utilization, memory utilization, network utilization, and disk use.

#### EC2 Right Sizing Best Practices

* **Start simple:** idle resources, non-critical development/QA and previous generation instances will require less testing hours and provide quick wins (The Amazon EC2 Launch time statistics can be used to identify instances that have been running longer than others and is a good statistic to sort your Amazon EC2 instances by).
* **Right Size before performing a migration:** If you skip right sizing to save time, your migration speed might increase, but you will end up with higher cloud infrastructure spend for a potentially longer period of time. Instead, leverage the test and QA cycles during a migration exercise to test several instance types and families. Also, take that opportunity to test different sizes and burstable instances like the “t” family.
* **The best right sizing starts on day 1:** As you perform right sizing analysis, and ultimately rightsize resources, ensure any learnings are being shared across your organization and influencing the design of new workloads and upcoming migrations.
* **Measure Twice, Cut Once: Test, then test some more:** The last thing you want is for a new resource type to be uncapable of handling load, or functioning incorrectly.
* **Test once and perform multiple right sizing:** Aggregate instances per autoscaling group and tags to scale right sizing activities.
* **Combine Reserved Instance or Savings Plans strategy with Right Sizing to maximize savings:** For Standard RIs and EC2 Instance SP: Perform your pricing model purchases after rightsizing and for Convertible RIs, exchange them after rightsizing. Compute Savings plan will automatically adjust the commitment for the new environment.
* **Ignore burstable instance families (T types):** These families are designed to typically run at low CPU percentages for significant periods of time and shouldn’t be part of the instance types being analyzed for rightsizing.

#### Resources
- [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/)
- [Amazon CloudWatch pricing](https://aws.amazon.com/cloudwatch/pricing/)
- [Amazon CloudWatch FAQ](https://aws.amazon.com/cloudwatch/faqs/)
- [AWS Cost Management - Right Sizing](https://aws.amazon.com/aws-cost-management/aws-cost-optimization/right-sizing/)
- [List of available CloudWatch metrics for EC2 instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html)
- [WA Lab LVL 200 EC2 Right Sizing with Computer Optimizer]({{< ref "/Cost/200_Labs/200_AWS_Resource_Optimization" >}})

{{< prev_next_button link_prev_url="../" link_next_url="../2_cloudwatch_intro/" />}}