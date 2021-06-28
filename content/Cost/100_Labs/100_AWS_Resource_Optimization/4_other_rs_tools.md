---
title: "Other Rightsizing Tools"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

#### Other AWS Right Sizing tools


Launched during re:Invent 2019, [AWS Compute Optimizer](http://aws.amazon.com/compute-optimizer/) is another tool that can help identify EC2 right sizing opportunities. AWS Compute Optimizer recommends optimal AWS resources for your workloads to reduce costs and improve performance by using machine learning to analyze historical utilization metrics. Over-provisioning resources can lead to unnecessary infrastructure cost and under-provisioning resources can lead to poor application performance. Compute Optimizer helps you choose the optimal Amazon EC2 instance types, including those that are part of an Amazon EC2 Auto Scaling group, as well as optimal Amazon EBS volume configurations, based on your utilization data.

Compute Optimizer is available to you at no additional charge. To get started, you can opt in to the service in the AWS Compute Optimizer Console.

##### AWS Computer Optimizer vs Amazon EC2 Resource Optimization

Both AWS Computer Optimizer and Amazon EC2 Resource Optimization use the same engine to provide right sizing recommendations. Amazon EC2 Resource Optimization focuses on cost reduction providing recommendations only for over-provisioned resources. AWS Computer Optimizer aggregates *over and under provisioned resources* on their recommendations. In addition to EC2 it also covers Auto-Scaling Groups, Lambda functions, and EBS volumes.

If you are a cloud engineer looking for more detailed metrics and a technical approach to right sizing check out AWS Computer Optimizer on our [200 level EC2 Right Sizing lab]({{< ref "/Cost/200_Labs/200_AWS_Resource_Optimization" >}}). If you are a cloud financial analyst trying to measure the potential savings your company can get with right sizing then Amazon EC2 Resource Optimization can give you a good starting point and help you evangelize the teams around the financial benefits involved.

{{< prev_next_button link_prev_url="../3_prio_resource_opt/" link_next_url="../5_tear_down/" />}}
