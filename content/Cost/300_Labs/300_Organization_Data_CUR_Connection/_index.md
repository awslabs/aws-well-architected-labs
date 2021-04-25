---
title: "Level 300: Organization Data CUR Connection"
#menutitle: "Lab #1"
date: 2020-10-22T11:16:08-04:00
chapter: false
weight: 8
hidden: false
---
## Last Updated
December 2020

## Authors
- Stephanie Gooch, Commercial Architect (AWS)

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
This lab will show you how to combine your organizations information with your AWS Cost & Usage Report, this will enable you to view cost & usage in a way that is more relevant to your organization. It will guide you through the process of setting up an AWS Lambda function to extract the data from AWS Organizations, such as account ID and name, and place it into Amazon S3. From there, Amazon Athena will be able to read this data to produce a table that can be connected to your AWS Cost & Usage Report to enrich it.


## Architecture 

![Images/create_role.png](/Cost/300_Organization_Data_CUR_Connection/Images/Arch.png)


## Goals
- Combine your AWS Organizations information with your CUR
- Allows you to view costs against accounts with names you provide enriching the data


## Prerequisites
- Access to the management AWS Account of the AWS Organisation to deploy a cross account role
- A sub account within the Organization
- Completed the Account Setup Lab [100_1_AWS_Account_Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}})
- Completed the Cost and Usage Analysis lab [200_4_Cost_and_Usage_Analysis]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}})
- Completed the Cost Visualization Lab [200_5_Cost_Visualization]({{< ref "/Cost/200_Labs/200_5_Cost_Visualization" >}}) 


## Permissions required

Be able to create the below in the management account:
- IAM role and policy

Be able to create the below in a sub account where your CUR data is accessible:
- Amazon S3 Bucket 
- AWS Lambda function 
- IAM role and policy
- Amazon CloudWatch trigger
- Amazon Athena Table


## Optional
- Completed the Enterprise Dashboards lab [200_Enterprise_Dashboards]({{< ref "/Cost/200_Labs/200_Enterprise_Dashboards" >}})


## Costs
- Estimated costs should be <$5 a month for small Organization 
- [Amazon QuickSight pricing](https://aws.amazon.com/quicksight/pricing/?nc=sn&loc=4)

## Time to complete
- 30 minutes

## Steps:
{{% children  /%}}

{{% notice tip %}}
If you wish to deploy this in your AWS Management Account instead of a Member Account then there is a seporate code version which can do this. You do not have to make the IAM Role and Policy made in the Managment account in the next step. 
{{% /notice %}}

{{< prev_next_button link_next_url="./1_create_static_resources_source/" button_next_text="Start Lab" first_step="true" />}}
