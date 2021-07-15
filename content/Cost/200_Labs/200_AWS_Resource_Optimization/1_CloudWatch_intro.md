---
title: "Getting to know Amazon Cloudwatch"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

**NOTE:** In order to run this lab you will need to have at least one **EC2 instance** running and have [Rightsizing recommendations](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/ce-rightsizing.html#rr-getting-started) enable in **AWS Cost Explorer**.

During this lab we will create a **custom metric** in **Amazon CloudWatch** and install the CloudWatch agent on one EC2 instance to collect memory utilization. This will help improve the recommendation accuracy of **AWS Cost Explorer Rightsizing recommendations and AWS Compute Optimizer**. Be aware that *custom metrics are not part of the Amazon CloudWatch [free tier](https://aws.amazon.com/free/)* usage so **additional costs will be incurred**. For more information read the [Amazon CloudWatch pricing](https://aws.amazon.com/cloudwatch/pricing/) page.

## 1. Getting to know Amazon CloudWatch

The first step to perform rightsizing is to monitor and analyze your current use of services to gain insight into instance performance and usage patterns. Observe performance over at least a two-week period (ideally, over a one-month period) to capture the workload and business peak. The most common metrics that define instance performance are vCPU utilization, memory utilization, network utilization, and disk i/o.

1. Log into the AWS console and go to the **Amazon CloudWatch** service page:
![Images/CloudWatch01.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch01.png?classes=lab_picture_small)

2. Select **Dashboards** on the left column, then select **Automatic dashboards**, followed by **EC2**:
![Images/CloudWatch02.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch02.png?classes=lab_picture_small)

3. Observe the **Service Dashboard** and all of its different metrics, but focus on **CPU Utilization** and **Network In** and **Out**:
![Images/CloudWatch03.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch03.png?classes=lab_picture_small)

4. Select one of the **EC2** resources by clicking on the little color icon to the left of the **resource-id** name:
![Images/CloudWatch04.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch04.png?classes=lab_picture_small)

5. Deselect the **EC2 resource** and now modify the time range on the top right, click **custom** and select the **last 2 weeks**:
![Images/CloudWatch05.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch05.png?classes=lab_picture_small)

6. Navigate to the **CPU Utilization Average** widget and launch the **View Metrics detailed** page. Using the **Graphed metrics** session try to answer the following questions:

- a) What is the instance with the lowest CPU Average?
- b) What is the instance with the lowest CPU Max?
- c) What is the instance with the lowest CPU Min?

![Images/CloudWatch06.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch06.png?classes=lab_picture_small)
![Images/CloudWatch07.png](/Cost/200_AWS_Resource_Optimization/Images/CloudWatch07.png?classes=lab_picture_small)

{{< prev_next_button link_prev_url="../" link_next_url="../2_create_iamrole/" />}}
