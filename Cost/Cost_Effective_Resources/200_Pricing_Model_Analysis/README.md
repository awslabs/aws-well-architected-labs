# Level 200: Pricing Model Analysis
http://wellarchitectedlabs.com 


<video width="600" height="450" controls>
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Cost/Videos/PricingModelAnalysis.mp4" type="video/mp4">
  Your browser doesnt support video, or if you're on GitHub head to https://wellarchitectedlabs.com to watch the video.
</video> 

## Introduction
This hands-on lab will guide you through setting up pricing and usage data sources, then creating a visualization to view your costs over time for EC2 in Savings Plans rates, allowing you to make low risk, high return purchases for pricing models. The data sources will also allow you to do custom allocation of discounts for your organization (a separate lab).

You will create two pricing data sources, by using Lambda to download the AWS price list files (On Demand EC2 pricing, and Savings Plans rates from all regions) and extract the pricing components required. You can configure CloudWatch Events to peridoically run these functions to ensure you have the most up to date pricing and the latest instances in your data.

The pricing files are then combined with your Cost and Usage Report (CUR), to provide an hourly usage report with multiple pricing dimensions, this allows you query and analyze your usage by on demand rates, savings plan rates, or the difference between the two (discount level).

Finally you create a visualization with calculations in QuickSight which allows you to view your usage patterns, and also perform analysis to understand the commitment levels that are right for your business.  

**NOTE**: this lab demonstrates EC2 savings plans only, but can be extended to cover other services such as Fargate or Lambda.


![Images/AWSCostReadme.png](Images/AWSCostReadme.png)

## Goals
- Setup the pricing and usage data sources
- Create the visualization for recommendations and analysis


## Prerequisites
- An AWS Account
- An Amazon QuickSight Account
- A Cost and Usage Report (CUR)
- Amazon Athena and QuickSight have been setup
- Completed the [Cost and Usage Analysis lab](../../Cost_Fundamentals/200_4_Cost_and_Usage_Analysis/README.md)
- Completed the [Cost and Usage Visualization lab](../../Cost_Fundamentals/200_5_Cost_Visualization/README.md)
- Basic knowledge of AWS Lambda, Amazon Athena and Amazon Quicksight


## Permissions required
- Create a Lambda function, trigger it via CloudWatch
- Access to create an S3 bucket
- Access to your CUR files
- Access to setup a data source and create a visualization in QuickSight

## Costs
- TBA


## Time to complete
- The lab should take approximately 50-60 minutes to complete


<BR>

[![Start the lab](../../../common/images/startthelab.png)](Lab_Guide.md)

<BR>
<BR> 



***

## License
Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
