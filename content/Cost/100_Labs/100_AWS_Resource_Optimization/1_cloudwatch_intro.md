---
title: "Getting to know Amazon Cloudwatch"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

The first step to perform right sizing is to monitor and analyze your current use of services to gain insight into instance performance and usage patterns. To gather sufficient data, observe performance over at least a two-week period (ideally, over a one-month period) to capture the workload and business peak. The most common metrics that define instance performance are vCPU utilization, memory utilization, network utilization, and disk use.

1. Log into your AWS console via SSO, go to the **Amazon CloudWatch** service page:
![Images/CloudWatch01.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch01.png)

2. Select **EC2** under the **Service Dashboard**:
![Images/CloudWatch02.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch02.png)

3. Observe the **Service Dashboard** and all of its different metrics, but focus on **CPU Utilization** and **Network In** and **Out**:
![Images/CloudWatch03.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch03.png)

4. Select one of the **EC2** resources by clicking on the little color icon to the left of the **resource-id** name:
![Images/CloudWatch04.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch04.png)

5. Deselect the **EC2 resource** and now modify the time range on the top right, click **custom** and select the **last 2 weeks**:
![Images/CloudWatch05.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch05.png)

6. Navigate to the **CPU Utilization Average** widget, click the **three dots** and launch the **View in metrics** page. Using the **Graphed metrics** section try to answer the following questions:

- a. What is the instance with the highest CPU Average?
- b. What is the instance with the highest CPU Max?
- c. What is the instance with the lowest CPU Min?

![Images/CloudWatch05.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch06.png)
![Images/CloudWatch05.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch07.png)
