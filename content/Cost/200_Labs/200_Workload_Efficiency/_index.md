---
title: "Level 200: Workload Efficiency"
#menutitle: "Lab #1"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 11
hidden: false
---

## Last Updated
May 2020

{{< rawhtml >}}
<video width="600" height="450" controls>
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Cost/Videos/CostEfficiency.mp4" type="video/mp4">
  Your browser doesnt support video, or if you're on GitHub head to https://wellarchitectedlabs.com to watch the video.
</video>
{{< /rawhtml >}}

## Authors
- Nathan Besh, Cost Lead, Well-Architected

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
This hands-on lab will guide you through the steps to measure the efficiency of a workload. It shows you how to get the overall efficiency, then look deeper for patterns in usage to be able to allocate different weights to different outputs of a system.

The lab uses a simple web application to demonstrate the efficiency, but will teach you the techniques so that it can be applied to **ANY** workload you have, whether its born in the cloud or legacy.

The first time you perform this lab it is recommended to use the sample files supplied, then you can use your own application and billing files for each workload you have.


![Images/AWSReadme.png](/Cost/200_Workload_Efficiency/Images/AWSReadme.png)

## Goals
- Setup the application data source
- Combine the application and cost data sources
- Create the visualization for efficiency


## Prerequisites
- An AWS Account
- An Amazon QuickSight Account
- Amazon Athena and QuickSight have been setup
- Completed the [Cost and Usage Analysis lab]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}})
- Completed the [Cost and Usage Visualization lab]({{< ref "/Cost/200_Labs/200_5_Cost_Visualization" >}})


## Permissions required
- Log in as the Cost Optimization team, created in [AWS Account Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}})


## Costs
- <$5 depending on the size of your data sources, and existing QuickSight subscription


## Time to complete
- The lab should take approximately 50-60 minutes to complete

## Steps:
{{% children  /%}}

{{< prev_next_button link_next_url="./1_data_sources/" button_next_text="Start Lab" first_step="true" />}}
