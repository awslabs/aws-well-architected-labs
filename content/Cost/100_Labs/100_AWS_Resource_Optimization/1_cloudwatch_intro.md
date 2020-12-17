---
title: "Getting to know Amazon CloudWatch"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>1. </b>"
---

> **NOTE:** In order to complete the steps below you will need to have at least one Amazon EC2 instance running in your account.

1. Log into your AWS console via SSO, go to the **Amazon CloudWatch** service page:
![Images/CloudWatch01.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch01.png)

2. Select **EC2** under the **Service Dashboard**:
![Images/CloudWatch02.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch02.png)

3. Observe the **Service Dashboard** and all of its different metrics, but focus on **CPU Utilization** and **Network In Average** and **Network Out Average**:
![Images/CloudWatch03.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch03.png)

4. Select one of the **EC2** resources by clicking either on the chart line or on the icons to the left of the **resource-id** name:
![Images/CloudWatch04.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch04.png)

5. Deselect the **EC2 resource** and now modify the time range on the top right, click **custom** and select the **last 2 weeks**:
![Images/CloudWatch05.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch05.png)

6. Navigate to the **CPU Utilization Average** widget, click the **three dots** and launch the **View in metrics** page. Using the **Graphed metrics** section try to answer the following questions:

- a. What is the instance with the highest CPU Average?
- b. What is the instance with the highest CPU Max?
- c. What is the instance with the lowest CPU Min?

![Images/CloudWatch05.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch06.png)
![Images/CloudWatch05.png](/Cost/100_AWS_Resource_Optimization/Images/CloudWatch07.png)

#### Resources
- [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/)
- [Amazon CloudWatch pricing](https://aws.amazon.com/cloudwatch/pricing/)
- [Amazon CloudWatch FAQ](https://aws.amazon.com/cloudwatch/faqs/)
- [AWS Cost Management - Right Sizing](https://aws.amazon.com/aws-cost-management/aws-cost-optimization/right-sizing/)
- [List of available CloudWatch metrics for EC2 instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html)
- [WA Lab LVL 200 EC2 Right Sizing with Computer Optimizer]({{< ref "/Cost/200_Labs/200_AWS_Resource_Optimization" >}})

{{< prev_next_button link_prev_url="../" link_next_url="../2_resource_opt/" />}}