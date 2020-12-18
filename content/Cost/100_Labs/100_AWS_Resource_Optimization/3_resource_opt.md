---
title: "Using Amazon EC2 Resource Optimization Recommendations"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

> **NOTE**: In order to complete this step you need to have Amazon EC2 Resource Optimization enabled (no additional cost). You can do that by going to AWS Cost Explorer>>Recommendations (left bar) section. Allow up to 24 hours after enabling this feature to start getting recommendations.

Amazon EC2 Resource Optimization offers right sizing recommendations in AWS Cost Explorer without any additional cost. These recommendations identify likely idle and underutilized instances across your accounts, regions and tags. To generate these recommendations, AWS analyzes your historical EC2 resource usage (using Amazon CloudWatch) and your existing reservation footprint to identify opportunities for cost savings (e.g., by terminating idle instances or downsizing active instances to lower-cost options within the same family/generation).

#### 1. Navigate to the **AWS Cost Explorer** page
![Images/ResourceOpt01.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt01.png)

#### 2. Select **Recommendations** in the left menu bar
![Images/ResourceOpt2.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt02.png)

#### 3. Click on the **View All** link associated with the **Resource optimizations** section.
![Images/ResourceOpt3.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt03.png)

In case you haven’t enabled the Amazon EC2 Resource Optimization please do so (no additional cost), it may take up to 24 hours in order to generate your first recommendations. Only regular or a management account can enable rightsizing recommendations. After you enable the feature, both member and management account can access rightsizing recommendations unless the management account specifically prohibits member account access on the settings page.

To improve the recommendation quality, AWS might use your published utilization metrics, such as disk or memory utilization, to improve our recommendation models and algorithms. All metrics are anonymized and aggregated before AWS uses them for model training. If you want to opt out of this experience and request that your metrics not be stored and used for model improvement, contact AWS Support. For more information, see [AWS Service Terms](https://aws.amazon.com/service-terms/).

#### 4. Getting to know the Amazon EC2 Resource Optimization Recommendations parameters.
![Images/ResourceOpt5.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt04.png)

**Recommendation parameters**
- **Display recommendations:** Option to generate recommendations within the instance family, or across multiple instance families.
- **Finding types:** Filter your recommendations by selecting any or all of the following check boxes: idle (terminate) and underutilized instances.
- **Advanced options:** Select to consider (or not) existing Savings Plans or Reserved Instance coverage in recommendation savings calculations.

**Recommendations**
- **Optimization opportunities:** The number of recommendations available based on your resources and usage
- **Estimated monthly savings:** The sum of the projected monthly savings associated with each of the recommendations provided
- **Estimated savings (%):** The available savings relative to the direct Amazon EC2 costs (On-Demand) associated with the instances in the recommendation list

**Determining if an instance is idle, underutilized, or neither**

Amazon EC2 Resource Optimization look at the maximum CPU utilization of the instance for the last 14 days to make one of the following assessments:
- **Idle:** If the maximum CPU utilization is at or below 1%. A termination recommendation is generated, and savings are calculated.
- **Underutilized:** If the maximum CPU utilization is above 1% and cost savings are available in modifying the instance type, a modification recommendation is generated.

If the instance isn't idle or underutilized, Amazon EC2 Resource Optimization will not generate any recommendation. Amazon EC2 Resource Optimization recommendations also excludes Spot usage and takes into consideration the existing Reserved Instances and Savings Plan footprint to provide recommendations.

You can also filter your recommendations by Account ID, Region and Tag.

![Images/ResourceOpt5.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt05.png)

To identify all instances for all accounts in the consolidated billing family, rightsizing recommendations look at the usage for the last 14 days for each account. If the instance was stopped or terminated, we remove it from consideration. For all remaining instances, we call CloudWatch to get maximum CPU utilization data, memory utilization (if enabled), network in/out, local disk input/ output (I/O), and performance of attached EBS volumes for the last 14 days. This is to produce conservative recommendations, not to recommend instance modifications that could be detrimental to application performance or that could unexpectedly impact your performance.

#### 5. Click on the **finding column** to view the details of the recommendation:
![Images/ResourceOpt6.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt06.png)

#### 6. Understanding the Amazon EC2 Resource Optimization recommendations:
![Images/ResourceOpt7.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt07.png)

**Generating modification recommendations**
Recommendations use a machine learning engine to identify the optimal Amazon EC2 instance types for a particular workload. Instance types include those that are a part of AWS Auto Scaling groups.

The recommendations engine analyzes the configuration and resource usage of a workload to identify dozens of defining characteristics. For example, it can determine whether a workload is CPU-intensive or whether it exhibits a daily pattern. The recommendations engine analyzes these characteristics and identifies the hardware resources that the workload requires.

Finally, it concludes how the workload would perform on various Amazon EC2 instances to make recommendations for the optimal AWS compute resources that the specific workload.

**Savings Calculation**

We first examine the instance running in the last 14 days to identify whether it was partially or fully covered by an RI or Savings Plans, or running On-Demand. Another factor is whether the RI is size-flexible. The cost to run the instance is calculated based on the On-Demand hours and the rate of the instance type.

For each recommendation, we calculate the cost to operate a new instance. We assume that a size-flexible RI covers the new instance in the same way as the previous instance if the new instance is within the same instance family. Estimated savings are calculated based on the number of On-Demand running hours and the difference in On-Demand rates. If the RI isn't size-flexible, or if the new instance is in a different instance family, the estimated savings calculation is based on whether the new instance had been running during the last 14 days as On-Demand.

Cost Explorer only provides recommendations with an estimated savings greater than or equal to $0. These recommendations are a subset of Compute Optimizer results. For more performance-based recommendations that might result in a cost increase, see Compute Optimizer.

You can choose to view saving with or without consideration for RI or Savings Plans discounts. Recommendations consider both discounts by default. Considering RI or Savings Plans discounts might result in some recommendations showing a savings value of $0. To change this option, see Using your rightsizing recommendations.

Note
Rightsizing recommendations doesn't capture second-order effects of rightsizing, such as the resulting RI hour’s availability and how they will apply to other instances. Potential savings based on reallocation of the RI hours aren't included in the calculation.

**How are the potential savings calculated?** AWS will first examine the instance running during the last 14 days to identify if it was partially or fully covered by a Reserved Instance (RI), Savings Plan (SP) or running On-Demand. Another factor is [whether the RI is instance size-flexible](https://aws.amazon.com/premiumsupport/knowledge-center/regional-flexible-ri/). The cost to run the instance is calculated based on the On-Demand hours and the hourly rate for the instance type. For each recommendation, AWS calculates the cost to operate a new instance. AWS assumes that an instance size-flexible Reserved Instance or Savings Plan will cover the new instance in the same way as the previous instance. Savings are calculated based on the number of On-Demand running hours and the difference in On-Demand rates. If the Reserved Instance isn't instance size-flexible, the savings calculation is based on whether the instance hours during the last 14 days are operated as On-Demand. AWS will only provide recommendations with estimated savings greater than or equal to $0.

![Images/ResourceOpt8.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt08.png)

![Images/ResourceOpt8.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt09.png)



You can enable Amazon CloudWatch to report memory utilization and improve the recommendation accuracy. Please check the [200 level EC2 Right Sizing lab]({{< ref "/Cost/200_Labs/200_AWS_Resource_Optimization" >}}) for more information on how to enable memory utilization metrics. Finally, Amazon EC2 Resource Optimization recommendations will only ever recommend up to three, same-family instances as target instances for downsizing.

{{< prev_next_button link_prev_url="../2_cloudwatch_intro/" link_next_url="../4_prio_resource_opt/" />}}
