---
title: "Level 200: Enterprise Dashboards"
#menutitle: "Lab #1"
date: 2020-09-07T11:16:08-04:00
chapter: false
weight: 8
hidden: false
---
## Last Updated
September 2020

{{< rawhtml >}}
<video width="600" height="450" controls>
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Cost/Videos/DashboardCostIntelligence.mp4" type="video/mp4">
  Your browser doesn't support video, or if you're on GitHub head to https://wellarchitectedlabs.com to watch the video.
</video>
{{< /rawhtml >}}


## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: quicksightcostdashboards@amazon.com

## Introduction
The goal of the Enterprise Dashboards is to remove the complexities of cost & usage analysis, and provide enterprises with a clear understanding of something, to enable them to make the right business decisions quickly. The Enterprise Dashboard are made up of multiple templates known as modules to help you gain insight into different aspects of your cost and usage as well as enable your teams to better understand the cost of their applications and opportunities to optimize. Every dashboard complements the other modules so you can grow your reporting analytics and gain additional insight. Using separate modules provides greater flexibility, allowing you to customize existing modules and take advantage of the new templates without overwriting your existing customizations. If the dashboards were in a single report it would overwrite all customizations each time you create the latest template. This hands-on lab will guide you through the steps to copy and customize the QuickSight dashboard to better leverage your cost and usage report.
- The Cost Intelligence Dashboard is an interactive, customizable and business accessible QuickSight dashboard to help customers create the foundation for their own Cost Management and Optimization reporting tool. 
- The Data Transfer Dashboard allows your organization to understand their data transfer cost and usage across all AWS products so you can take action on optimization opportunities. 

Interested in a detailed description of the dashboards options to get the dashboards in a single view? Download read the [FAQ](/Cost/200_Enterprise_Dashboards/Cost_Intelligence_Dashboard_ReadMe.pdf)


**Note**: This QuickSight dashboard is not an official AWS dashboard and should be used as a self-service tool.
We recommend validating your data by comparing the aggregate un-grouped Payer and Linked Account spend for a prior month.

![Images/quicksight_opening.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_opening.png)

## Goals
- Create the Cost Intelligence dashboard
- Distribute your dashboards in your organization



## Prerequisites
- An AWS Account with Cost Optimization team permissions
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
- **Cost Intelligence Dashboard**: Should take approximately 45-60 minutes to complete
- **Data Transfer Dashboard**: Should take approximately 15-20 minutes to complete 

## Steps:
{{% children  %}}
