
---
title: "Prerequisites"
menutitle: "Prerequisites"
date: 2021-01-15T11:16:09-04:00
chapter: false
pre: "<b>1. </b>"
weight: 1
---

Check if you can see data in AWS Compute Optimizer and AWS Trusted Advisor. 

If there is no data available, complete the following steps and wait until data is available. 

## Opt in for AWS Compute Optimizer
[Opt in for AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/getting-started/) if you have not done so. 
Enable AWS Compute Optimizer at no additional cost. After AWS Compute Optimizer is enabled it may take up to **12 hours** to fully analyze the AWS resources in your account.
 
![Section1 AWS Compute Optimizer](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section1/ComputeOptimizer.png)
 
## Cost Optimization checks in Amazon Trusted Advisor 
[Amazon Trusted Advisor](https://aws.amazon.com/premiumsupport/knowledge-center/trusted-advisor-intro/) provides best practices (or checks) in four categories: cost optimization, security, fault tolerance, and performance improvement. This demo will use "**Low Utilization Amazon EC2 Instances**" check in Cost optimization.
 
![Section1 AWS Trusted Advisor](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section1/TA.png)
 
## Attach AWS Tags to Amazon EC2 Instances 

Attach the following tags to your existing EC2 Instances as follows:

    Key = Environment
    Value = watooldemo

![Section1 AWS Trusted Advisor](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section1/Tags.png)

{{% notice note %}}    
**NOTE:** Use the same tags when defining a workload later.
{{% /notice %}}

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../" link_next_url="../2_configure_env/" />}}
