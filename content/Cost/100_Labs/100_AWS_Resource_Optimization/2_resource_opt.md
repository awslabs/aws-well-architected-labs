---
title: "Using Amazon EC2 Resource Optimization Recommendations"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

**NOTE**: In order to complete this step you need to have Amazon EC2 Resource Optimization enabled, you can do that by going to AWS Cost Explorer, Recommendations (left bar) section.

Amazon EC2 Resource Optimization offers right sizing recommendations in AWS Cost Explorer without any additional cost. These recommendations identify likely idle and underutilized instances across your accounts, regions and tags. To generate these recommendations, AWS analyzes your historical EC2 resource usage (using Amazon CloudWatch) and your existing reservation footprint to identify opportunities for cost savings (e.g., by terminating idle instances or downsizing active instances to lower-cost options within the same family/generation).

1. Navigate to the **AWS Cost Explorer** page
![Images/ResourceOpt01.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt01.png)

2. Select **Recommendations** in the left menu bar
![Images/ResourceOpt2.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt02.png)

3. Click on the **View All** link associated with the **Amazon EC2 Resource Optimization Recommendations** section.
![Images/ResourceOpt3.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt03.png)

In case you haven’t enabled the Amazon EC2 Resource Optimization please do so (no additional cost), it may take up to 24 hours in order to generate your first recommendations. Only regular or payer accounts can enable it and by default both linked and payer accounts will be able to access their rightsizing recommendations unless the payer account specifically prohibits it on the settings page (top right).
![Images/ResourceOpt4.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt04.png)

To improve the quality of recommendations, AWS might use other utilization metrics that you might be collecting, such as disk or memory utilization. All resource utilization metrics are anonymized and aggregated before AWS uses them for model training. If you would like to opt out of this experience and request your metrics not be stored and used for model improvement, please [submit an AWS support ticket](https://docs.aws.amazon.com/awssupport/latest/user/getting-started.html). For more information, see [AWS Service Terms](https://aws.amazon.com/service-terms/).

4. Assuming you had enabled the Amazon EC2 Resource Optimization Recommendations, you will be presented with a screen that provides recommendations (if any exists):
![Images/ResourceOpt5.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt05.png)

- **Optimization opportunities** – The number of recommendations available based on your resources and usage
- **Estimated monthly savings** – The sum of the projected monthly savings associated with each of the recommendations provided
- **Estimated savings (%)** – The available savings relative to the direct Amazon EC2 costs (On-Demand) associated with the instances in the recommendation list

You can also filter your recommendations by the type of action (Idle and Underutilized), Linked Account, Region and Tag.

5. Click on **view** next to a recommendation, to view the details:
![Images/ResourceOpt6.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt06.png)

How are the potential savings calculated? AWS will first examine the instance running during the last 14 days to identify if it was partially or fully covered by an RI or running On-Demand. Another factor is whether the RI is instance size-flexible. The cost to run the instance is calculated based on the On-Demand hours and the hourly rate for the instance type. For each recommendation, AWS calculates the cost to operate a new instance. AWS assumes that an instance size-flexible Reserved Instance will cover the new instance in the same way as the previous instance. Savings are calculated based on the number of On-Demand running hours and the difference in On-Demand rates. If the Reserved Instance isn't instance size-flexible, the savings calculation is based on whether the instance hours during the last 14 days are operated as On-Demand. AWS will only provide recommendations with estimated savings greater than or equal to $0.

Amazon EC2 Resource Optimization recommendations already excludes Spot usage and takes into consideration the existing Reserved Instances and Savings Plan footprint to provide recommendations. There are two types of recommended actions: **Terminate** if the instance is considered idle (*max CPU utilization is at or below 1%*) or **Downsize** if the instance is underutilized (*max CPU utilization is between 1% and 40%*).

You can enable Amazon CloudWatch to report memory utilization and improve the recommendation accuracy. Please check the [200 level EC2 Right Sizing lab]({{< ref "/Cost/200_Labs/200_AWS_Resource_Optimization" >}}) for more information on how to enable memory utilization metrics. Finally, Amazon EC2 Resource Optimization recommendations will only ever recommend up to three, same-family instances as target instances for downsizing.
