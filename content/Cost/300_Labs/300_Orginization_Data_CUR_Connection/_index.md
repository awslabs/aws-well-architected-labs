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
This lab will show you how to combine your organizations information with your Cost & Usage Report, this will enable you to view cost & usage in a way that is more relevant to your organizations. It will guide you through the process of setting up a regular lambda to extract the data from AWS Organisations, such as account id and name, into S3. From there Athena will be able to read this data and we will have a table that can be connected to your Cost and Usage report data to enrich it. 


## Architecture 

![Images/create_role.png](/Cost/300_Orginization_Data_CUR_Connection/Images/Arch.png)


## Goals
- Combine your organizations information with your CUR
- Allows you to view costs against accounts with names you provide enriching the data


## Prerequisites
- Access to the managment AWS Account of the AWS Organisation to deploy a cross account role
- A sub account within the Orginization
- Completed the Account Setup Lab [100_1_AWS_Account_Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}})
- Completed the Cost and Usage Analysis lab [200_4_Cost_and_Usage_Analysis]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}})
- Completed the Cost Visualization Lab [200_5_Cost_Visualization]({{< ref "/Cost/200_Labs/200_5_Cost_Visualization" >}}) 


## Permissions required

Be able to create the below in the managment account:
- IAM role and policy

Be able to create the below in a sub account where your CUR data is accessable:
- S3 Bucket 
- Lambda function 
- IAM role and policy
- CloudWatch trigger
- Athena Table


## Optional
- Completed the Enterprise Dashboards lab [200_Enterprise_Dashboards]({{< ref "/Cost/200_Labs/200_Enterprise_Dashboards" >}})


## Costs
- Estimated costs should be <$5 a month for small Organization 
- [QuickSight pricing](https://aws.amazon.com/quicksight/pricing/?nc=sn&loc=4)

## Time to complete
- 30 minutes

## Steps:
{{% children  /%}}


{{< prev_next_button link_next_url="./1_create_static_resources_source/" button_next_text="Start Lab" first_step="true" />}}
