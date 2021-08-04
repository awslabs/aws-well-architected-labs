---
title: "Level 300: Optimization Data Collection - BETA"
#menutitle: "Lab #1"
date: 2020-10-22T11:16:08-04:00
chapter: false
weight: 8
hidden: false
---
## Last Updated
July 2021

## Authors
- Stephanie Gooch, Commercial Architect (AWS)

## Feedback
If you wish to provide feedback on this lab, there is an error, or you have a suggestion, please email: costoptimization@amazon.com

{{% notice note %}}
This lab is in **BETA** and your feedback is key to developing the lab. Please share any feedback, bugs, or ideas to help improve the lab
{{% /notice %}}


## Introduction
This lab is designed to **enable you to collect utilization data from different services to help you identify optimization opportunities**. This lab provides pre made modules to automate data collection and show you how to pull your additional data sets on your own. The CloudFormation modules in this lab follow the structure of using an AWS Lambda function to extract the data, then this is placed into Amazon S3. From there, Amazon Athena is able to read this data using an AWS Glue Crawler to produce a table that can be utilized for optimization analysis and even joined with your AWS Cost & Usage Report (CUR) to enrich it. 

The three main styles of data are:
* Optimization and rightsizing recommendations 
* Service Inventories  
* Resource utilization metrics
 
## Architecture 

![Images/Arc.png](/Cost/300_Optimization_Data_Collection/Images/Arc.png)

## Goals
- Deploy main resources which will be used by the modules
- Deploy modules to collect data 
- Retrieve optimization data 


## Prerequisites
- Access to the Management AWS Account of the AWS Organization to deploy Cloudformation
- Access to a sub account within the Organization - referred to as **Cost Optimization Account**
- Completed the [Account Setup Lab]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}})
- Completed the [Cost and Usage Analysis lab]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}})
- Completed the [Cost Visualization Lab]({{< ref "/Cost/200_Labs/200_5_Cost_Visualization" >}}) 

## Deployment Options
We suggest you do not deploy the main resources and collectors into your management account and instead use the cost account created in [Account Setup Lab]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}}). However, Some IAM resources will be needed to read data from the management account. 

## Permissions required

Be able to create the below in the management account:
- IAM role and policy
- Deploy CloudFormation

Be able to create the below in a sub account where your CUR data is accessible:
- Deploy CloudFormation
- Amazon S3 Bucket 
- AWS Lambda function 
- IAM role and policy
- Amazon CloudWatch trigger
- Amazon Athena Table
- AWS Glue Crawler


## Costs
- Estimated costs should be <$5 a month for small Organization 


## Time to complete
- 30 minutes

## Steps:
{{% children  /%}}


{{< prev_next_button link_next_url="./1_deploy_main_resources/" button_next_text="Start Lab" first_step="true" />}}
