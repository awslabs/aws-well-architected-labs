---
title: "Level 200: Enterprise Dashboards"
#menutitle: "Lab #1"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 8
hidden: false
---
## Last Updated
July 2020

{{< rawhtml >}}
<video width="600" height="450" controls>
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Cost/Videos/DashboardCostIntelligence.mp4" type="video/mp4">
  Your browser doesn't support video, or if you're on GitHub head to https://wellarchitectedlabs.com to watch the video.
</video>
{{< /rawhtml >}}


## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
The Cost Intelligence Dashboard is an interactive, customizable and accessible QuickSight dashboard to help customers create the foundation for their own Cost Management and Optimization reporting tool. This hands-on lab will guide you through the steps to copy and customize the QuickSight dashboard to better leverage your cost and usage report.

**Note**: This QuickSight dashboard is not an official AWS dashboard and should be used as a self-service tool.
We recommend validating your data by comparing the aggregate un-grouped Payer and Linked Account spend for a prior month.

![Images/quicksight_opening.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_opening.png)

## Goals
- Create the Cost Intelligence dashboard
- Distribute your dashboards in your organization



## Prerequisites
- An AWS Account
- An Amazon **Enterprise Edition** QuickSight Account
- A Cost and Usage Report (CUR)
- Amazon Athena and QuickSight have been setup
- Completed the [Cost and Usage Analysis lab]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}})
- Completed the [Cost and Usage Visualization lab]({{< ref "/Cost/200_Labs/200_5_Cost_Visualization" >}})
- Requested template access [here](http://d3ozd1vexgt67t.cloudfront.net/)


## Permissions required
- Log in as the Cost Optimization team, created in [AWS Account Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}})
- Access to AWS CLI


## Costs
- Small accounts approximately <$5 when using your free QuickSight trial 


## Time to complete
- **Cost Intelligence Dashboard**: The lab should take approximately 45-60 minutes to complete

## Steps:
{{% children  %}}
