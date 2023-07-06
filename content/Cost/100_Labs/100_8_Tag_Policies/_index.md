---
title: "Level 100: Tag Policies"
#menutitle: "Lab #2"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 8
---
## Last Updated
May 2021

## Authors
- Tony Weldon, Commercial Architect
- Stephanie Gooch, Commercial Architect (AWS)

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com


## Introduction
This lab will help you to develop Tagging Policies utilizing your AWS Organization. Tags allow you to label resources using key-value pairs, which can be used to segment or identify resources by dimensions such as owner, cost center, or environment. Tag Policies help to ensure that the AWS users within your AWS Organization are tagging resources consistently and aligned to the strategy your Organization has defined. Tags can serve many purposes, but this lab will be focused specifically on using tags to distribute the cost of AWS services.

Effective tagging requires standardization. Each technology team in your organization deploying AWS resources needs to apply tags consistent with how resources are expected to be categorized. When this doesn’t happen, it often leads to missing tags, misnamed tags, and inconsistent tags that ultimately make them an unreliable source of resource categorization.

Standardization can be challenging when you have a large organization with multiple technology teams and AWS accounts. Tools that automate the enforcement of applying the proper tags, like Tag Policies, help prevent and remediate tags that don’t comply with the standard.

AWS Cost Explorer and Cost and Usage Report provide the ability to break down AWS costs by tag. Typically, customers use business tags such as cost center, business unit, or project to associate AWS costs with traditional financial reporting dimensions within their organization. Tags are also a great way to enforce a governance model within an Organization, determining who in the Organization can access which resources.



## Goals
-	Create a Tag policy
-	Visualize resources not in compliance with the policy


## Prerequisites
- [AWS Account Setup]({{< ref "100_1_AWS_Account_Setup" >}}) has been completed
-	AWS organization must have all features enabled - If you aren’t sure if all features is enabled, please reference [this](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_org_support-all-features.html") documentation.
-	Must be signed into organization's Management account


## Permissions required
- Access to the Cost Optimization team created in [AWS Account Setup]({{< ref "100_1_AWS_Account_Setup" >}})

## Costs
- https://aws.amazon.com/aws-cost-management/pricing/
- Less than $1 per month if the tear down is not performed

## Time to complete
- The lab should take approximately 15 minutes to complete

## Steps:
{{ children }}

{{< prev_next_button link_next_url="./1_tag_policy/" button_next_text="Start Lab" first_step="true" />}}
