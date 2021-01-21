---
title: "EC2 Right-sizing with AWS Compute Optimizer and Memory Utilization Enabled"
date: 2020-12-18T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

> **NOTE**: In order to complete this step you need to have [AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/getting-started/) enabled.

> **Important:** If you have just installed the CloudWatch agent on your instances it may take a couple of days for AWS Compute Optimizer to start providing updated recommendations. You may not see the memory data during the first checks.

AWS Compute Optimizer recommends optimal AWS Compute resources for your workloads to reduce costs and improve performance by using machine learning to analyze historical utilization metrics. Over-provisioning compute can lead to unnecessary infrastructure cost and under-provisioning compute can lead to poor application performance. Compute Optimizer helps you choose the optimal Amazon EC2 instance types, including those that are part of an Amazon EC2 Auto Scaling group, based on your utilization data.

Why use AWS Compute Optimizer?

- **Lower cost** of EC2 instances, volumes, and auto-scaling groups
- **Optimize performance** with actionable recommendations
- AWS Compute Optimizer is available at **no additional charge**

Let's get started!

#### 1. Navigate to the **AWS Compute Optimizer** page.

![Images/ResourceOpt01.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt01.png)

#### 2. Ensure you are on the **Dashboard** view and have the desired region selected. The Dashboard view will show you all recommendation types and allow you to drill into the desired AWS resource (EC2 instances, EBS volumes, or Auto Scaling groups).

![Images/ResourceOpt2.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt02.png)

#### 3. Navigate to the Compute Optimizer **Dashboard** and select **Over-provisioned instances**.

![Images/ResourceOpt07.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt03.png)

#### 4. Select an instance that is **over-provisioned** and has memory monitoring enabled by clicking the radio button to the left of it then select **View Details**.

![Images/ResourceOpt07.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt04.png)

#### 5. In this scenario, Compute Optimizer recommends we resize to a t3.large. Our CPU utilization graph shows minimal CPU usage with some bursting. This is an ideal workload for the t3 family.

![Images/ResourceOpt07.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt05.png)

Memory utilization is consistent at 90% and downsizing to a cheaper t3.large will keep our memory at the same size (8 GiB). We can get the same memory performance while reducing overall cost of your EC2 instances.

> Note: A case could be made that this instance is under-provisioned and upsizing to an instance with more memory is a better solution. For this scenario, the Compute Optimizer views scaling down CPU and keeping the same memory the best decision for cost and performance. However, having memory utilization enabled per instance is an added benefit to the customer that allows additional data points to be taken into account before making a final decision.

#### 6. Let’s navigate to **under-provisioned EC2 instances**. Click on blue text hyperlink to the right of Under-provisioned instances. If there are none you will be unable to drill into the finding.

![Images/ResourceOpt3.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt06.png)

#### 7. A list of under-provisioned instances will be present. Note the **Recommended instance type**. Select the radio button on the far left of a single instance then select view details in the top right.

![Images/ResourceOpt5.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt07.png)

#### 8. This view will give recommendations on right-sizing the current instance.

![Images/ResourceOpt06.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt08.png)

Notice there can be **multiple options for right-sizing** (t3.xlarge, c5.xlarge, m5.xlarge). All options are recommending we move from 2 vCPUs to 4 vCPU’s. The first option will typically be the cheapest. There are multiple columns that allow you to compare and contrast the right choice for upsizing your instance, including price, [performance risk](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-resize.html), vCPU’s, memory, storage, and network.

#### 9. Click through each option using the blue radio button on the left and notice how the below graphs change to show projections for the recommended instance. The **CPU utilization** graph shows our instance is maxed out on CPU and projects an orange dotted line where CPU will be for our new instance.

![Images/ResourceOpt07.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt09.png)

Note that **memory utilization is not currently enabled on this instance**, therefore Compute Optimizer cannot show you what the memory of the instance is. This could be an important detail when making a decision on upsizing. For example, if memory is not an issue option 2 may be a better choice than option 3. We will double our vCPU’s, retain the same memory, and have a cheaper overall on-demand price. Similarly, option 2 may be preferred over option 1 based on [performance risk](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-resize.html) associated with option 1. Compute Optimizer will never recommend an instance with less memory if memory monitoring is disabled.

#### 10. Let’s take a look at that same instance with memory utilization enabled. Notice we can be more comfortable with our options for right-sizing. 

![Images/ResourceOpt07.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt10.png)

Compute Optimizer will now take memory utilization into account. We can see that memory utilization is low and 8 GiB is sufficient. Choosing option 2 (c5.xlarge) will give us additional CPU power and keep our performance risk low by not having to switch to a burstable instance (t3.xlarge). Depending on your goals option 1 may be ideal for cost savings while option 2 would be ideal for overall performance and stability.

#### Conclusions

Using **AWS Compute Optimizer** to get recommendations for right-sizing EC2 instances is a free and recommended routine. In this lab we explored recommendations for both an under-provisioned and over-provisioned EC2 instance and why having memory utilization enabled makes the recommendations more precise and gives a more holistic view of the EC2 instance performance. The knowledge gained from this lab should help you make right-sizing decisions to decrease cost and improve performance. 

{{< prev_next_button link_prev_url="../4_memory_plugin/" link_next_url="../6_tear_down/" />}}
