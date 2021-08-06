---
title: "Rightsizing with AWS Compute Optimizer and Memory Utilization Enabled"
date: 2020-12-18T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

> **NOTE**: In order to complete this step you need to have [AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer/getting-started/) enabled.

AWS Compute Optimizer uses machine learning to analyzes the configuration and utilization data of your AWS resources. It reports whether your resources are optimal, and generates recommendations (findings) to reduce the cost and improve the performance of your workloads.

When it comes to EC2 instances there are three types of findings:

- **Over-provisioned**. An EC2 instance is considered over-provisioned when at least one of the utilization metrics (CPU, Memory, Network) can be sized down while still meeting the performance requirements of your workload, and when no specification is under-provisioned. Over-provisioned EC2 instances might lead to unnecessary infrastructure cost.
- **Under-provisioned**. An EC2 instance is considered under-provisioned when at least one of the utilization metrics (CPU, Memory, Network) does not meet the performance requirements of your workload. Under-provisioned EC2 instances might lead to poor application performance.
- **Optimized**. An EC2 instance is considered optimized when all the utilization metrics (CPU, Memory, Network) meet the performance requirements of your workload, and the instance is not over-provisioned. For optimized instances, Compute Optimizer might sometimes recommend a new generation instance type.

You can enable AWS Compute Optimizer across your AWS Organization and filter the recommendations by AWS Accounts, AWS resource (EC2 instances, EBS volumes, Auto Scaling groups or Lambda functions) and AWS regions.

> **NOTE:** If you have just installed the CloudWatch agent on your instances it may take a couple of days for AWS Compute Optimizer to start providing updated recommendations. You may not see the memory data during the first checks.

During the steps below we will review some AWS Computer Optimizer examples and how the recommendations are affected by having an additional datapoint from the EC2 instance memory utilization.

#### 1. Navigate to the **AWS Compute Optimizer** page.

![Images/ResourceOpt01.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt01.png?classes=lab_picture_small)

#### 2. Ensure you are on the **Dashboard** view and have the desired region selected.

![Images/ResourceOpt2.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt02.png?classes=lab_picture_small)

#### 3. Select **Over-provisioned instances**.

![Images/ResourceOpt07.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt03.png?classes=lab_picture_small)

#### 4. Select an instance that is **over-provisioned** and has memory monitoring enabled by clicking the radio button to the left and select **View Details**.

![Images/ResourceOpt07.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt04.png?classes=lab_picture_small)

#### 5. In this scenario, AWS Compute Optimizer recommends we resize to a t3.large. Our CPU utilization graph shows minimal CPU usage with some bursting. This is an ideal workload for the t3 family.

![Images/ResourceOpt07.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt05.png?classes=lab_picture_small)

Memory utilization is consistent at 90% and downsizing to a cheaper t3.large will keep our memory at the same size (8 GiB). In other words, we can get the same memory performance while reducing overall cost.

> **NOTE:** A case could be made that this instance is under-provisioned and upsizing to an instance with more memory is a better solution. For this scenario, AWS Compute Optimizer views scaling down CPU and keeping the same memory the best decision for cost and performance. Having memory utilization enabled provides an additional datapoint for customers before making a final decision.

#### 6. Select **Under-provisioned instances**.

![Images/ResourceOpt3.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt06.png?classes=lab_picture_small)

#### 7. A list of under-provisioned instances will be present. Note the **Recommended instance type**. Select the radio button on the far left of the instance and then select **View details** in the top right.

![Images/ResourceOpt5.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt07.png?classes=lab_picture_small)

#### 8. This view will give recommendations on rightsizing the current instance.

![Images/ResourceOpt06.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt08.png?classes=lab_picture_small)

Notice there can be **multiple options for rightsizing** (t3.xlarge, c5.xlarge, m5.xlarge). All options are recommending we move from 2 vCPUs to 4 vCPU’s. The first option will typically be the cheapest. There are multiple columns that allow you to compare and contrast the right choice for upsizing your instance, including price, [performance risk](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-resize.html), CPU, memory, storage, and network.

#### 9. Click through each option using the blue radio button on the left and notice how the below graphs change to show projections for the recommended instance. The **CPU utilization** graph shows our instance is maxed out on CPU and projects an orange dotted line where CPU will be for our new instance.

![Images/ResourceOpt07.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt09.png?classes=lab_picture_small)

On the example above you might have noticed that **memory utilization is not currently enabled on this instance**, therefore AWS Compute Optimizer will not report memory utilization. This could be an important datapoint when making a decision to which instance to upsize. For example, if memory is not an issue option 2 may be a better choice than option 3 from a cost perspective. AWS Compute Optimizer will not recommend instances with lower memory if memory monitoring is not available.

#### 10. Let’s take a look at that same instance with memory utilization enabled. Notice we can be more comfortable with our options for rightsizing.

![Images/ResourceOpt07.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt10.png?classes=lab_picture_small)

AWS Compute Optimizer will now take memory utilization into account. We can see that memory utilization is low and 8 GiB is sufficient. Choosing option 2 (c5.xlarge) will give us additional CPU power and keep our performance risk low by not having to switch to a burstable instance (t3.xlarge). Depending on your goals option 1 may be ideal for cost savings while option 2 would be ideal for overall performance and stability.

#### Conclusions

Using **AWS Compute Optimizer** to get recommendations for rightsizing EC2 instances is a free and recommended routine. In this lab we explored recommendations for both an under-provisioned and over-provisioned EC2 instance and why having memory utilization enabled makes the recommendations more precise and gives a more holistic view of the EC2 instance performance. The knowledge gained from this lab should help you make rightsizing decisions to decrease cost and improve performance.

{{< prev_next_button link_prev_url="../4_memory_plugin/" link_next_url="../6_tear_down/" />}}
