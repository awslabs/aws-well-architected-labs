---
title: "Level 200: Cost and Usage Governance"
#menutitle: "Lab #1"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 2
hidden: false
---
## Last Updated
May 2020

## Authors
- Nathan Besh, Cost Lead Well-Architected
- Spencer Marley, Commercial Architect

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
 This hands-on lab will guide you through the steps to implement cost and usage governance. The skills you learn will help you control your cost and usage in alignment with your business requirements.

![Images/AWSCostReadme.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSCostReadme.png)

## Goals
- Implement IAM Policies to control usage


## Prerequisites
- [AWS Account Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}}) has been completed


## Permissions required
- Log in as the Cost Optimization team, created in [AWS Account Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}})
- Add the following [IAM Policy]({{< ref "Code/IAM_policy.md" >}}) for this lab
- NOTE: There may be permission error messages during the lab, as the console may require additional privileges. These errors will not impact the lab, and we follow security best practices by implementing the minimum set of privileges required.

## Costs
- A small number of instances will be started & then immediately terminated
- Costs will be less than $5 if all steps including the teardown are performed

## Time to complete
- The lab should take approximately 15 minutes to complete

## Steps:
{{% children  %}}

