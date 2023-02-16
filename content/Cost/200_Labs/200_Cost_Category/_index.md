---
title: "Level 200: Cost Categories"
#menutitle: "Lab #1"
date: 2023-02-16T11:16:08-04:00
chapter: false
weight: 8
hidden: false
---

## Last Updated
Feb 2023

## Authors
- **Archana Kar**, Associate Solution Architect.
- **Neha Garg**, Enterprise Solution Architect.

## Contributor
- **Jang Whan Han**, Solutions Architect, AWS Well-Architected.
- **Ben Mergen**, Sr Cost Lead SA WA.

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
This hands-on lab will guide you through the steps to **govern cost and usage** of an organisation and create visibility for your **cloud finance** using AWS provided **tag editor** & **cost categories** features. **Tag editor** can be used to see any tags that are attached to resources and allow you to modify tags for them and **cost categories** can be used for resource categorization which can be used for expenditure and usage awareness.

## Goals
- Organize cloud workloads/resources
- Map cost and usage into meaningful categories
- Tracks resource usage and estimate charges associated with AWS account


## Prerequisites
- [AWS Account Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}}) has been completed.


## Permissions required
We will require to login using admin permissions for both the Management Account and Cost Optimization Member Account to complete this lab.

{{% notice note %}}
**Note** - We shall login with administrator permission to run cloud formation template to create multiple resources. We are proceeding with broad permissions here. Best Practice is to reduce the permissions that you grant to work toward least privilege.
{{% /notice %}}

## Costs
- Costs will be less than $5 per day if all steps including the teardown are performed.
  {{% notice note %}}
  **Note** - This lab uses cost allocation tags and cost categories features under Billing Service that can take up to 72 hours for the changes to take effect to complete this lab. 
  You will be billed for any applicable AWS resources used for that duration.  
  {{% /notice %}}

## Time to complete
- The lab should take approximately 60 minutes to complete

## Steps:
{{% children  /%}}

{{< prev_next_button link_next_url="./1_configure_lab_environment/" button_next_text="Start Lab" first_step="true" />}}
