---
title: "Getting to know Amazon Cloudwatch"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

**NOTE:** In order to run this lab you will need to have at least one **EC2 instance** running and have **AWS Cost Explorer** and **Amazon EC2 Resource Optimization** enabled.

During this lab we will create a **custom metric** at **Amazon CloudWatch** and install an agent in one EC2 instance to start collecting Memory utilization and improve the recommendation accuracy of the **Amazon EC2 Resource Optimization** report. Be aware that *custom metrics are not part of the Amazon CloudWatch [free tier](https://aws.amazon.com/free/)* usage so **additional costs will incur at your bill**. For more information read the [Amazon CloudWatch pricing](https://aws.amazon.com/cloudwatch/pricing/) page.

All custom metrics charges are prorated by the hour and metered only when you send metrics to Amazon CloudWatch. **Each custom metrics costs $0.30 per metric/month for the first 10,000 metrics** and can go down to $0.02 per metric/month at the lowest priced tier (*US Virginia prices from November 2019*).

## 1. Getting to know Amazon Cloudwatch

The first step to perform right sizing is to monitor and analyze your current use of services to gain insight into instance performance and usage patterns. To gather sufficient data, observe performance over at least a two-week period (ideally, over a one-month period) to capture the workload and business peak. The most common metrics that define instance performance are vCPU utilization, memory utilization, network utilization, and disk use.

1. Log into your AWS console, go to the **Amazon CloudWatch** service page:
![Images/CloudWatch01.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch01.png)

2. Select **EC2** under the **Service Dashboard**:
![Images/CloudWatch02.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch02.png)

3. Observe the **Service Dashboard** and all of its different metrics, but focus on **CPU Utilization** and **Network In** and **Out**:
![Images/CloudWatch03.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch03.png)

4. Select one of the **EC2** resources by clicking on the little color icon to the left of the **resource-id** name:
![Images/CloudWatch04.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch04.png)

5. Deselect the **EC2 resource** and now modify the time range on the top right, click **custom** and select the **last 2 weeks**:
![Images/CloudWatch05.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch05.png)

6. Navigate to the **CPU Utilization Average** widget and launch the **View Metrics detailed** page. Using the **Graphed metrics** session try to answer the following questions:

- a) What is the instance with the lowest CPU Average?
- b) What is the instance with the lowest CPU Max?
- c) What is the instance with the lowest CPU Min?

![Images/CloudWatch06.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch06.png)
![Images/CloudWatch07.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch07.png)
