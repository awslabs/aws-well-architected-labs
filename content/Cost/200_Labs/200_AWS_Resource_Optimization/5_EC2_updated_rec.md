---
title: "Updated Amazon EC2 Resource Optimization recommendations"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

**NOTE**: In order to complete this step you need to have Amazon EC2 Resource Optimization enabled, you can do that going to the AWS Cost Explorer, Recommendations (left bar) section.

**Important:** If you have just installed the CloudWatch agent at your instances it may take a couple of days for Amazon EC2 Resource Optimization to start to provide updated recommendations, so don't worry if you don't see the memory data during the first checks.

Now that we have Memory data as a custom metric in CloudWatch let's check how that affects the Amazon EC2 Resource Optimization recommendations.

Amazon EC2 Resource Optimization offers right sizing recommendations in the AWS Cost Explorer without any additional cost. These recommendations identify likely idle and underutilized instances across your accounts, regions and tags. To generate these recommendations, AWS analyzes your historical EC2 resource usage (last 14 days using Amazon CloudWatch) and your existing reservation footprint to identify opportunities for cost savings. There are two types of recommended actions: **Terminate** if the instance is considered idle (*max CPU utilization is at or below 1%*) or **Downsize** if the instance is underutilized (*max CPU utilization is between 1% and 40%*).

By default Amazon EC2 Resource Optimization doesn't need memory datapoint to provide recommendations, but if that information is available it will take that into consideration updating the **Downsize** recommendation for instances that now have *max CPU and MEM utilization between 1% and 40%* over the past 14 days. Let's validate that with the following steps.

1. Navigate to the **AWS Cost Explorer** page
![Images/ResourceOpt01.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt01.png)

2. Select **Recommendations** in the left menu bar
![Images/ResourceOpt2.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt02.png)





3. Click on the **View All** link associated with the **Amazon EC2 Resource Optimization Recommendations** section.
![Images/ResourceOpt3.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt03.png)

In case you haven’t enabled the Amazon EC2 Resource Optimization please do so (no additional cost), it may take up to 24 hours in order to generate your first recommendations. Only regular or payer accounts can enable it and by default both linked and payer accounts will be able to access their rightsizing recommendations unless the payer account specifically prohibits it on the settings page (top right).
![Images/ResourceOpt4.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt04.png)

4. Assuming you had enabled the Amazon EC2 Resource Optimization Recommendations, you will be presented with a screen that provides recommendations (if any exists). Click to view the **Resource Optimization** recommendations.
![Images/ResourceOpt5.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt05.png)

- **Optimization opportunities** – The number of recommendations available based on your resources and usage
- **Estimated monthly savings** – The sum of the projected monthly savings associated with each of the recommendations provided
- **Estimated savings (%)** – The available savings relative to the direct Amazon EC2 costs (On-Demand) associated with the instances in the recommendation list

You can also filter your recommendations by the type of action (Idle and Underutilized), Linked Account, Region and Tag.

5. Understanding the Amazon EC2 Resource Optimization recommendations.

In the example below we have a recommendation to downsize the **t2.micro** (1vCPU *for a 2h 24m burst* and 1GB RAM) to a **t2.nano** (1vCPU *for a 1h 12m burst* and 0.5 GB RAM) and save $12 USD per year.

![Images/ResourceOpt06.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt06.png)

Over the past 14 days the maximum CPU utilization for this instance was only 9% and this instance was running for 86 hours and all of these were On Demand hours. Observe that there is no memory information available so Amazon EC2 Resource Optimization will ignore that datapoint and recommend to downsize to a t2.nano that have half of the memory available of a t2.micro.

That can be risky and waste engineer time when testing if the proposed right sizing option is valid or not. That said you can improve the accuracy of this recommendation with the CloudWatch agent we just installed.

In this other example we see a recommendation to downsize a r5.8xlarge (32 vCPU and 256GB RAM) to a r5.4xlarge (16 vCPU and 128GB RAM) and save $2,412 USD per year.
![Images/ResourceOpt07.png](/Cost/200_AWS_Resource_Optimization/Images/ResourceOpt07.png)

On this case we have both CPU and Memory information available: the maximum CPU utilization was 21% and Memory was only 5%. That makes the case for downsize much stronger and the recommendation will even try estimate the CPU and Memory utilization for the new instance size. Keep in mind that this is just a simple estimation based on the past utilization data from CloudWatch, before executing the modification all the required load tests must be performed to avoid any impacts on your workload.

As explained above the Amazon EC2 Resource Optimization logic will recommend to downsize any instances where the maximum CPU utilization was between 1% to 40% over the past 14 days. If you do have memory information available the Amazon EC2 Resource Optimization will now consider to downsize instances that have *both CPU and Memory* maximum utilization between 1% and 40%. Idle recommendations are not impacted if memory data is available, so any EC2 instance that during the past 14 days never passed 1% of CPU utlization will be automatically flagged as idle.
