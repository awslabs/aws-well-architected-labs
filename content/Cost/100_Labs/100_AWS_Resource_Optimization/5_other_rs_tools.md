---
title: "Other Right Sizing tools"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

#### Other AWS Right Sizing tools


Launched during reInvent 2019 [AWS Compute Optimizer](http://aws.amazon.com/compute-optimizer/) is another tool that can help you identify EC2 right sizing opportunitites. AWS Compute Optimizer recommends optimal AWS resources for your workloads to reduce costs and improve performance by using machine learning to analyze historical utilization metrics. Over-provisioning resources can lead to unnecessary infrastructure cost and under-provisioning resources can lead to poor application performance. Compute Optimizer helps you choose the optimal Amazon EC2 instance types, including those that are part of an Amazon EC2 Auto Scaling group, as well as optimal Amazon EBS volume configurations, based on your utilization data.

Compute Optimizer is available to you at no additional charge. To get started, you can opt in to the service in the AWS Compute Optimizer Console.

##### AWS Computer Optimizer vs Amazon EC2 Resource Optimization

Both AWS Computer Optimizer and Amazon EC2 Resource Optimization use the same engine to provide right sizing recommendations. Amazon EC2 Resource Optimization focus on cost reduction providing recommendation only for over-provisioned resources. AWS Computer Optimizes aggregares *over and under provisioned resources* on their recommendations, and in addition to EC2 it also covers Auto-Scaling Groups and EBS resources.

if you are a cloud engineer looking for more detailed metrics and a technical approach to right sizing definitely check AWS Computer Optimizer on our [200 level EC2 Right Sizing lab]({{< ref "/Cost/200_Labs/200_AWS_Resource_Optimization" >}}). However, if you are a cloud financial analyst trying to measure the potential savings your company can get with right sizing the Amazon EC2 Resource Optimization can give your a good start point and help you evangelize the teams around the financial benefits involved.

{{< prev_next_button link_prev_url="../4_prio_resource_opt/" link_next_url="../6_tear_down/" />}}