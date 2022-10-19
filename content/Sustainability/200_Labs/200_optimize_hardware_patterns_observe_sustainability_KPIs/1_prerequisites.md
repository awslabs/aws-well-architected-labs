---
title: "Prerequisites"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 2
pre: "<b>1. </b>"
---

AWS Compute Optimizer provides Amazon EC2 instance recommendations to help you improve performance and save money. You can use these recommendations to decide whether to move to a new instance type. Ensure that you have enabled AWS Compute Optimizer.

## Opt in for AWS Compute Optimizer
[Enable AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/getting-started/) at no additional cost if you have not done so. Compute Optimizer requires at least 30 consecutive hours of metrics data from your resource to generate recommendations. After the analysis is complete, which can take up to 12 hours, Compute Optimizer presents its findings on the dashboard page. 

For more information, see Viewing the [AWS Compute Optimizer dashboard](https://docs.aws.amazon.com/compute-optimizer/latest/ug/viewing-dashboard.html). AWS Compute Optimizer analyzes the configuration and utilization metrics of your Amazon EC2 Instances. It reports whether your resources are optimal and generates optimization recommendations to reduce the cost and improve the performance of your workloads. Our objective is to optimize the energy efficiency of the underlying hardware through rightsizing.

{{% notice note %}}
**Note** - To see recommendations from the AWS Compute Optimizer dashboard, you will need to let your Amazon EC2 Instance run for 42 hours, which will incur costs generated from EC2(t4g.xlarge) in your AWS account. You can refer to the screenshots in this lab to minimize costs from EC2.
{{% /notice %}}

Once AWS Compute Optimizer completes the analysis, you will see saving opportunities and recommendations as follows:
![Section1 AWS Compute Optimizer](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section1/ComputeOptimizer.png)

{{< prev_next_button link_prev_url="../" link_next_url="../2_configure_env" />}}
