---
title: "Level 200: Pricing Model Analysis"
#menutitle: "Lab #1"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 7
hidden: false
---
{{< rawhtml >}}
<video width="600" height="450" controls>
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Cost/Videos/PricingModelAnalysis.mp4" type="video/mp4">
  Your browser doesn't support video, or if you're on GitHub head to https://wellarchitectedlabs.com to watch the video.
</video>
{{< /rawhtml >}}

## Authors
- Nathan Besh, Cost Lead, Well-Architected (AWS)
- Nataliya Godunok, Technical Account Manager (AWS)

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
This hands-on lab will guide you through setting up pricing and usage data sources, then creating a visualization to view your costs over time for EC2 in Savings Plans rates, allowing you to make low risk, high return purchases for pricing models. The data sources will also allow you to do custom allocation of discounts for your organization (a separate lab).

You will create two pricing data sources, by using Lambda to download the AWS price list files (On Demand EC2 pricing, and Savings Plans rates from all regions) and extract the pricing components required. You can configure CloudWatch Events to periodically run these functions to ensure you have the most up to date pricing and the latest instances in your data.

The pricing files are then combined with your Cost and Usage Report (CUR), to provide an hourly usage report with multiple pricing dimensions, this allows you query and analyze your usage by on demand rates, savings plan rates, or the difference between the two (discount level).

Finally you create a visualization with calculations in QuickSight which allows you to view your usage patterns, and also perform analysis to understand the commitment levels that are right for your business.  

**NOTE**: this lab demonstrates EC2 savings plans only, but can be extended to cover other services such as Fargate or Lambda.


![Images/AWSCostReadme.png](/Cost/200_Pricing_Model_Analysis/Images/AWSCostReadme.png)

## Goals
- Setup the pricing and usage data sources
- Create the visualization for recommendations and analysis


## Prerequisites
- An AWS Account
- An Amazon QuickSight Account
- A Cost and Usage Report (CUR)
- Amazon Athena and QuickSight have been setup
- Completed the [Cost and Usage Analysis lab]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}})
- Completed the [Cost and Usage Visualization lab]({{< ref "/Cost/200_Labs/200_5_Cost_Visualization" >}})
- Basic knowledge of AWS Lambda, Amazon Athena and Amazon Quicksight


## Permissions required
- Log in as the Cost Optimization team, created in [AWS Account Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}})
- Additional: Create a Lambda function with assiciated IAM roles, trigger it via CloudWatch


## Costs
- Small accounts approximately <$5

## Time to complete
- The lab should take approximately 50-60 minutes to complete

## Steps:
{{% children  %}}
