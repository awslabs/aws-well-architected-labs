---
title: "Using AWS Cost Management Rightsizing Recommendations"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

> **NOTE**: In order to complete this step you need to have findings within Rightsizing Recommendations. You can do that by going to *AWS Cost Explorer>>Right Sizing Recommendations (left bar)* section. Allow up to 24 hours after enabling this feature (no additional cost) to start getting recommendations.

AWS Cost Explorer Rightsizing Recommendations offers EC2 resource optimization recommendations without any additional cost. These recommendations identify idle and underutilized instances across your accounts, regions, and tags. To generate these recommendations, AWS analyzes your historical EC2 resource usage (using Amazon CloudWatch metrics) and your existing reservation footprint to identify opportunities for cost savings (e.g., by terminating idle instances or downsizing active instances to lower-cost options within the same family/generation).

#### 1. Navigate to the **AWS Cost Explorer** page
![Images/ResourceOpt01.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt01.png?classes=lab_picture_small)

#### 2. Select **Rightsizing recommendations** in the left menu bar
![Images/ResourceOpt2.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt02.png?classes=lab_picture_small)

In case you haven’t enabled the Amazon Rightsizing Recommendations please do so (no additional cost), it may take up to 24 hours in order to generate your first recommendations. Only regular or a management account can enable Rightsizing Recommendations. After you enable the feature, both member and management account can access Rightsizing Recommendations unless the management account specifically prohibits member account access on the settings page.

| *To improve the recommendation quality, AWS might use your published utilization metrics, such as disk or memory utilization, to improve our recommendation models and algorithms. All metrics are anonymized and aggregated before AWS uses them for model training. If you want to opt out of this experience and request that your metrics not be stored and used for model improvement, contact AWS Support. For more information, see [AWS Service Terms](https://aws.amazon.com/service-terms/).* |
|------|

#### 3. Getting to know the Amazon Rightsizing recommendation parameters
![Images/ResourceOpt4.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt04.png?classes=lab_picture_small)

AWS Cost Explorer Rightsizing recommendations will analyze the usage for the last 14 days for each account. If the instance was stopped or terminated, AWS removes it from recommendation. For all remaining instances, AWS uses Amazon CloudWatch to get maximum CPU utilization data, memory utilization (if enabled), network in/out, local disk input/ output (I/O), and performance of attached EBS volumes for the last 14 days. This is to produce conservative recommendations, not to recommend instance modifications that could be detrimental to application performance or that could unexpectedly impact your performance.

**Recommendation parameters**
- **Display recommendations:** Option to generate recommendations within the instance family (more conservative), or across multiple instance families. The last will present more instance options to choose from which can lead to higher savings. More options also means that you should separate more time to test instance types that you may not be familiar with.
- **Finding types:** Filter your recommendations by selecting any or all of the following check boxes: idle (terminate) and underutilized instances.
- **Advanced options:** Select to consider (or not) existing Savings Plans or Reserved Instance coverage in recommendation savings calculations. Amazon EC2 Spot usage is not considered for Rightsizing recommendations.

**Recommendations**
- **Optimization opportunities:** The number of recommendations available based on your resource consumption
- **Estimated monthly savings:** The sum of the projected monthly savings associated with each of the recommendations provided
- **Estimated savings (%):** The available savings relative to the direct Amazon EC2 costs (On-Demand) associated with the instances in the recommendation list

**Determining if an instance is idle, underutilized, or neither**

Amazon Resource Recommendations looks at the maximum CPU utilization of the instance for the last 14 days to make one of the following assessments: **Idle:** If the maximum CPU utilization is at or below 1%. A termination recommendation is generated, and savings are calculated.
**Underutilized:** If the maximum CPU utilization is above 1% and cost savings are available in modifying the instance type, a modification recommendation is generated. If the instance isn't idle or underutilized, no recommendations will be generated.

#### 4. Use filtering to sort recommendations by Account ID, Region, and Tag:

![Images/ResourceOpt5.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt05.png?classes=lab_picture_small)

#### 5. Under **Findings**, click on the **Instance ID** to view the details of the recommendation
![Images/ResourceOpt6.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt06.png?classes=lab_picture_small)

#### 6. Understanding the AWS Cost Explorer Rightsizing recommendations

Rightsizing recommendations uses machine learning to identify the optimal Amazon EC2 instance types for a particular workload. The recommendations engine analyzes the configuration and resource usage of a workload to identify dozens of defining characteristics. For example, it can determine whether a workload is CPU-intensive or whether it exhibits a daily pattern. The recommendations engine analyzes these characteristics and identifies the hardware resources that the workload requires. Finally, it simulates how the workload would perform on various Amazon EC2 instances to later make recommendations for the optimal AWS compute resources.

**Idle instance recommendation**

It's not uncommon for companies, due to lack of governance and control, to have resources that were launched and forgotten. Amazon EC2 and EBS are the most common cases, and at scale they can contribute to a significant waste for your company. Rightsizing recommendations will help you track these resources and will recommend users to terminate instances where the CPU utilization is at or below 1% over the past 14 days.

AWS recommends you to start your rightsizing exercises with idle instances because they represent a higher savings (for larger instances) and it's easier to identify if a workload is using that instance or not. In addition to the instance utilization metrics shown below, Rightsizing recommendations will also report which account the instance belongs to, the instance id, region, type, and tags. These is useful information if you are trying to track the resource owner to discuss terminating it.

> Please check with your technical team and advisors before moving forward and terminating idle instances. There are unique situations (eg disaster recover systems) where an idle utilization is expected.

Below you can see an example of an idle recommendation. Highlighted areas show the estimated annual savings after turning off this instance as well as the the account name, region and instance ID to facilitate tracking it accross your environment. On the bottom of the page you can also find tagging information.

![Images/ResourceOpt07-idle-01.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt07-idle-01.png?classes=lab_picture_small)

![Images/ResourceOpt07-idle-02.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt07-idle-02.png?classes=lab_picture_small)

Keep scrolling down to find additional information about that instance, like CPU, Network and Disk utilization. You can also add [AWS CloudWatch agents](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html) to collect memory utilization from your instances and get a more accurate recommendation. Check the [200 level EC2 Right Sizing lab]({{< ref "/Cost/200_Labs/200_AWS_Resource_Optimization" >}}) for more information. Finally, under the **running hours** section you can see which pricing model this instance is running, on the example above all the 336 hours (14 days) are On Demand.

**Underutilized instance recommendation**

For instances where the CPU utilization is above 1% over the past 14 days Rightsizing recommendations will look for instances that are cheaper and can sustain the utilization reported on CloudWatch. You can check the estimated savings on the top row as well as the target instance that workload should be using to achieve these savings. AWS also uses the rightsizing engine to project the CPU utilization for the recommended instance type.

![Images/ResourceOpt7.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt07.png?classes=lab_picture_small)

Depending on the case, Rightsizing recommendations will generate multiple recommendations per underutilized instance. If you want to check  additional suggestions just expand the "Other recommended options" section. For each suggested instance you will also get an estimated savings and the projected CPU utilization.

> **NOTE**: Remember to select "Across instance families" radio button within the Recommendation parameters to see recommendations outside of the current instance family.

![Images/ResourceOpt8.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt08.png?classes=lab_picture_small)

**Savings Calculation**

In order to estimate the savings for your organization AWS first examine the instance running in the last 14 days to identify whether it was partially or fully covered by a Reserved Instance (RI), Savings Plans (SP), or running On-Demand. Another factor is whether the RI is [size-flexible](https://aws.amazon.com/blogs/aws/new-instance-size-flexibility-for-ec2-reserved-instances/). The cost to run the instance is calculated based on the On-Demand hours and the rate of the instance type.

For each recommendation, we calculate the cost to operate a new instance. We assume that a size-flexible RI covers the new instance in the same way as the previous instance if the new instance is within the same family. Estimated savings are calculated based on the number of On-Demand running hours and the difference in On-Demand rates. If the RI isn't size-flexible or if the new instance is in a different instance family, the estimated savings calculation is based on whether the new instance had been running during the last 14 days as On-Demand. You can choose to view the estimated savings with or without consideration for RI or Savings Plans discounts. Considering RI or Savings Plans discounts might result in some recommendations showing a savings value of $0.

AWS Cost Explorer Rightsizing recommendations only provides recommendations with an estimated savings greater than or equal to $0. These recommendations are a subset of AWS Compute Optimizer results. For more performance-based recommendations that might result in a cost increase, see [AWS Compute Optimizer](http://aws.amazon.com/compute-optimizer/).

> Rightsizing recommendations do not capture second-order effects of rightsizing, such as the resulting RI hour’s availability and how they will apply to other instances. Potential savings based on reallocation of the RI hours aren't included in the calculation.

{{< prev_next_button link_prev_url="../1_intro_right_sizing/" link_next_url="../3_prio_resource_opt/" />}}
