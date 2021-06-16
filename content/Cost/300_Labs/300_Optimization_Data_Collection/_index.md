---
title: "Level 300: Optimization Data Collection"
#menutitle: "Lab #1"
date: 2020-10-22T11:16:08-04:00
chapter: false
weight: 8
hidden: false
---
## Last Updated
June 2021

## Authors
- Stephanie Gooch, Commercial Architect (AWS)

## Feedback
If you wish to provide feedback on this lab, there is an error, or you have a suggestion, please email: costoptimization@amazon.com

## Introduction
When reviewing costs in AWS it important to have all the data you need in one place. Following on from the Cost and Usage Report setup, which you can see in this [Lab]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}}) this lab will give you a template of how you can pull your own sets of data as well as some pre made modules to help collect data for optimization and chargeback. Using either CloudFormation or Terraform the modules will follow the structure of using an AWS Lambda function to extract the data, then this will then be place into Amazon S3. From there, Amazon Athena will be able to read this data to produce a table that can be connected to your AWS Cost & Usage Report to enrich it. 

## Architecture 

![Images/Arc.png](/Cost/300_Optimization_Data_Collection/Images/Arc.png)

## Goals
- Deploy base resources that will be reused in multiple modules
- Deploy modules to collect data 


## Prerequisites
- Access to the management AWS Account of the AWS Organization to deploy a cross account role
- A sub account within the Organization - referred to as **Cost Optimization Account**
- Completed the Account Setup Lab [100_1_AWS_Account_Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}})
- Completed the Cost and Usage Analysis lab [200_4_Cost_and_Usage_Analysis]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}})
- Completed the Cost Visualization Lab [200_5_Cost_Visualization]({{< ref "/Cost/200_Labs/200_5_Cost_Visualization" >}}) 

## Deployment Options
We suggest you do not deploy resources into your management account and instead use the cost account created in [100_1_AWS_Account_Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}}). However, there are options to deploy all resources into your management account if you wish. To do this complete all steps in you management account and do not create the role in the 'Create IAM Role and Policies in Management account' step.

## Permissions required

Be able to create the below in the management account:
- IAM role and policy

Be able to create the below in the all accounts you wish to collect data from:
- IAM role and policy

Be able to create the below in a sub account where your CUR data is accessible:
- Deploy CloudFormation
- Amazon S3 Bucket 
- AWS Lambda function 
- IAM role and policy
- Amazon CloudWatch trigger
- Amazon Athena Table
- AWS Glue Crawler


## Optional
- Completed the Enterprise Dashboards lab [200_Enterprise_Dashboards]({{< ref "/Cost/200_Labs/200_Enterprise_Dashboards" >}})


## Costs
- Estimated costs should be <$5 a month for small Organization 


## Time to complete
- 30 minutes

## Steps:
{{% children  /%}}

{{% notice tip %}}
TBC
{{% /notice %}}

{{< prev_next_button link_next_url="./1_create_static_resources_source/" button_next_text="Start Lab" first_step="true" />}}
