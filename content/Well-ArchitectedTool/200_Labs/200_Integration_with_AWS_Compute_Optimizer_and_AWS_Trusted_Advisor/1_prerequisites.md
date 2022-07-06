---
title: "Prerequisites"
menutitle: "Prerequisites"
date: 2021-01-15T11:16:09-04:00
chapter: false
pre: "<b>1. </b>"
weight: 1
---

## Opt in for AWS Compute Optimizer
[Opt in for AWS Compute Optimizer](https://docs.aws.amazon.com/compute-optimizer/latest/ug/getting-started.html) if you have not done so. 
You will need to opt in for AWS Compute Optimizer if you have not done so. AWS Compute Optimizer analyzes metrics from the past 14 days to generate recommendations.

![Section1 AWS Compute Optimizer](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section1/ComputeOptimizer.png)

## Cost Optimization checks in Amazon Trusted Advisor 
[Amazon Trusted Advisor](https://aws.amazon.com/premiumsupport/knowledge-center/trusted-advisor-intro/) provides best practices (or checks) in four categories: cost optimization, security, fault tolerance, and performance improvement. This demo will use "Low Utilization Amazon EC2 Instances" check in Cost Optimization.

![Section1 AWS Trusted Advisor](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section1/TA.png)

## Attach AWS Tags to Amazon EC2 Instances 
Amazon EC2 Instances must have AWS Tags. If you have not associated AWS Tags with Amazon EC2 Instances with any AWS Tags, [tag your Amazon EC2 resources](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html). You can use your own key and value.

![Section1 AWS Trusted Advisor](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section1/Tags.png)

{{< prev_next_button link_prev_url="../" link_next_url="../2_configure_env/" />}}
