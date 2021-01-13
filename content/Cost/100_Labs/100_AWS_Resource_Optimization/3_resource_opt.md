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

Amazon EC2 Resource Optimization recommendations will analyze the usage for the last 14 days for each account. If the instance was stopped or terminated, AWS removes it from recommendation. For all remaining instances, AWS uses Amazon CloudWatch to get maximum CPU utilization data, memory utilization (if enabled), network in/out, local disk input/ output (I/O), and performance of attached EBS volumes for the last 14 days. This is to produce conservative recommendations, not to recommend instance modifications that could be detrimental to application performance or that could unexpectedly impact your performance.

**Recommendation parameters**
- **Display recommendations:** Option to generate recommendations within the instance family (more conservative), or across multiple instance families. The last will present more instance options to choose from which can lead to higher savings. More options also means that you should separate more time to test instance types that you may not be familiar with.
- **Finding types:** Filter your recommendations by selecting any or all of the following check boxes: idle (terminate) and underutilized instances.
- **Advanced options:** Select to consider (or not) existing Savings Plans or Reserved Instance coverage in recommendation savings calculations. Amazon EC2 Spot usage is not considered for Amazon EC2 Resource Optimization recommendations.

**Recommendations**
- **Optimization opportunities:** The number of recommendations available based on your resource consumption
- **Estimated monthly savings:** The sum of the projected monthly savings associated with each of the recommendations provided
- **Estimated savings (%):** The available savings relative to the direct Amazon EC2 costs (On-Demand) associated with the instances in the recommendation list

**Determining if an instance is idle, underutilized, or neither**

Amazon EC2 Resource Optimization look at the maximum CPU utilization of the instance for the last 14 days to make one of the following assessments: **Idle:** If the maximum CPU utilization is at or below 1%. A termination recommendation is generated, and savings are calculated.
**Underutilized:** If the maximum CPU utilization is above 1% and cost savings are available in modifying the instance type, a modification recommendation is generated. If the instance isn't idle or underutilized, Amazon EC2 Resource Optimization will not generate any recommendation.

You can also filter your recommendations by Account ID, Region and Tag.

![Images/ResourceOpt5.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt05.png)

#### 5. Click on the **finding column** to view the details of the recommendation:
![Images/ResourceOpt6.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt06.png)

#### 6. Understanding the Amazon EC2 Resource Optimization recommendations:

Amazon EC2 Resource Optimization recommendations uses machine learning to identify the optimal Amazon EC2 instance types for a particular workload. The recommendations engine analyzes the configuration and resource usage of a workload to identify dozens of defining characteristics. For example, it can determine whether a workload is CPU-intensive or whether it exhibits a daily pattern. The recommendations engine analyzes these characteristics and identifies the hardware resources that the workload requires. Finally, it simulates how the workload would perform on various Amazon EC2 instances to later make recommendations for the optimal AWS compute resources.

**Idle instance recommendation** 

It's not uncommon for companies due to lack of governance and control to have resources that were launched and forgotten. Amazon EC2 and EBS are the most common cases, and at scale they can contribute to a significant waste for your company. Amazon EC2 Resource Optimization will help you track these resources and will recomend users to terminate instances where the CPU utilization is at or below 1% over the past 14 days. 

AWS recommends you to start your right sizing exercises with idle instances because in general they represent a higher saving (for larger instances) and because it's easier to identify if a workload is using that instance or not. In addition to the instance utilization metrics shown below, Amazon EC2 Resource optimization will also report which account the instance belongs to, the instance id, region, type and tags. These are useful information if you are trying to track the resource owner to discuss terminating it.

> Please check with your technical team and advisors before moving forward and terminating idle instances. There are unique situations (eg disaster recover systems) where an idle utilization is expected.

![Images/ResourceOpt7.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt07mem.png)

On the right column you can check how the last 14 days (or 336 hours) were charged for that instance. In this example, all the hours were On Demand so the potential savings of terminating this resource corresponds to the entire cost of running a r5.8xlarge.

Finally, for the instance reported above we have installed the Amazon CloudWatch memory agent to collect memory consumption, that's why we can see a memory utilization in the bottom left. You can enable Amazon CloudWatch to report memory utilization and improve the recommendation accuracy. Please check the [200 level EC2 Right Sizing lab]({{< ref "/Cost/200_Labs/200_AWS_Resource_Optimization" >}}) for more information on how to enable memory utilization metrics.

**Underutilized instance recommendation**

For instances where the CPU utilization is above 1% over the past 14 days Amazon EC2 Resource Optimization will look for instances that are cheaper and can sustain the utilization reported on CloudWatch. You can check the estimated savings on the top row, as well as the target instance that workloak should be using to achieve these savings. AWS also uses the right sizing engine to project the CPU utilization for the recommended instance type.

On the example below we haven't enabled the CloudWatch agent to collect memory and disk utilization. On these cases Amazon EC2 Resource Optimization will still provide a recommendation, however if you need more data to take action make sure to enable these agents. Check the [200 level EC2 Right Sizing lab]({{< ref "/Cost/200_Labs/200_AWS_Resource_Optimization" >}}) for further instructions.

![Images/ResourceOpt7.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt07.png)

Depending on the case, Amazon EC2 Resource Optimization will generate multiple recommendations per underutilized instance. If you want to check  additional suggestions just click on the "other recommendation" section. For each suggested instance you will also get an estimated savings and the projected CPU utilization.

![Images/ResourceOpt8.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt08.png)

**Savings Calculation**

In order to estimate the savings for your organization AWS first examine the instance running in the last 14 days to identify whether it was partially or fully covered by a Reserved Instance (RI) or Savings Plans (SP), or running On-Demand. Another factor is whether the RI is [size-flexible](https://aws.amazon.com/blogs/aws/new-instance-size-flexibility-for-ec2-reserved-instances/). The cost to run the instance is calculated based on the On-Demand hours and the rate of the instance type.

For each recommendation, we calculate the cost to operate a new instance. We assume that a size-flexible RI covers the new instance in the same way as the previous instance if the new instance is within the same instance family. Estimated savings are calculated based on the number of On-Demand running hours and the difference in On-Demand rates. If the RI isn't size-flexible, or if the new instance is in a different instance family, the estimated savings calculation is based on whether the new instance had been running during the last 14 days as On-Demand. You can choose to view the estimated savings with or without consideration for RI or Savings Plans discounts. Considering RI or Savings Plans discounts might result in some recommendations showing a savings value of $0.

Amazon EC2 Resource Optimization only provides recommendations with an estimated savings greater than or equal to $0. These recommendations are a subset of Compute Optimizer results. For more performance-based recommendations that might result in a cost increase, see [Compute Optimizer](http://aws.amazon.com/compute-optimizer/).

> Rightsizing recommendations doesn't capture second-order effects of rightsizing, such as the resulting RI hour’s availability and how they will apply to other instances. Potential savings based on reallocation of the RI hours aren't included in the calculation.

{{< prev_next_button link_prev_url="../2_cloudwatch_intro/" link_next_url="../4_prio_resource_opt/" />}}
