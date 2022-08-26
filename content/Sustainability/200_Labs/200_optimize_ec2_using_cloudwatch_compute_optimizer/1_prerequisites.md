---
title: "Prerequisites"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 2
pre: "<b>1. </b>"
---

AWS Compute Optimizer provides Amazon EC2 instance recommendations to help you improve performance, save money, or both. You can use these recommendations to decide whether to move to a new instance type. Ensure if you enabled AWS Compute Optimizer in your AWS account. 

## Opt in for AWS Compute Optimizer
[Enable AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/getting-started/) at no additional cost if you have not done so. After After AWS Compute Optimizer is enabled, it may take up to 12 hours to fully analyze the AWS resources in your account. AWS Compute Optimizer analyzes the configuration and utilization metrics of your Amazon EC2 Instances. It reports whether your resources are optimal and generates optimization recommendations to reduce the cost and improve the performance of your workloads. Our objective is to optimize the energy efficiency of the underlying hardware.

{{% notice note %}}
**Note** - It may take up to 12 hours for AWS Compute Optimizer to fully analyze the AWS resources in your account, which will incur costs in your account. You can check out the screenshots I'm going to share to minimize your cost to this lab.
{{% /notice %}}

![Section1 AWS Compute Optimizer](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section1/ComputeOptimizer.png)

{{< prev_next_button link_prev_url="../" link_next_url="../2_configure_env" />}}
