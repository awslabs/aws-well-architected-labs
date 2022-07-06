---
title: "Level 200: Integration with AWS Compute Optimizer and AWS Trusted Advisor"
#menutitle: "Lab #1"
date: 2021-01-15T11:16:09-04:00
chapter: false
weight: 1
hidden: false
---

## Authors
- **Jang Whan Han**, Solutions Architect, AWS Well-Architected
- **Phong Le**, Solutions Architect, AWS Well-Architected

## Introduction

The one of best ways to get the maximum amount of impact from the AWS Well-Architected Framework Review is to prepare data before the review and be armed with data that can be shared during the review. We are going to focus on **cost optimization** review with data that supports **Rightsize** usecase to align your service allocation size to your actual workload demand. The purpose of this lab is to walk you through one of many integration examples with Well-Architected Tool to have a data-driven Cost Optimization review using [AWS Cloud Financial Management Services](https://aws.amazon.com/aws-cost-management/). 
This lab enables you to automatically have cost optimization data thta AWS Compute Optimizer and AWS Trusted Advisor analyzed for **COST 6** question in Cost Optimization Pillar as soon as you define a workload in Well-Architected Tool.

The knowledge you acquire will help you learn how to programmatically access content in the Well-Architected Tool in alignment with the [AWS Well-Architected Framework.](https://aws.amazon.com/architecture/well-architected/)

## Goals

* Identify cost optimization opportunities through a data-driven Well-Architected Framework Review
* Learn about AWS Cloud Financial Management Services.
* Evaluate Cost When Selecting Services
* Select the Correct Resource Type, Size, and Number
* Select the Best Pricing Model

## Prerequisites
Now that we retrive cost optimization data from AWS Cloud Financial Management Services, there are a couple of prerequisites required.

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.

* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to use Well-Architected Tool ([WellArchitectedConsoleFullAccess managed policy](https://docs.aws.amazon.com/wellarchitected/latest/userguide/security_iam_id-based-policy-examples.html#security_iam_id-based-policy-examples-full-access)).

* [Opt in for AWS Compute Optimizer](https://docs.aws.amazon.com/compute-optimizer/latest/ug/getting-started.html) You will need to opt in for AWS Compute Optimizer if you have not done so. AWS Compute Optimizer analyzes metrics from the past 14 days to generate recommendations.

* [AWS Trusted Advisor](https://aws.amazon.com/premiumsupport/knowledge-center/trusted-advisor-intro/) Amazon Trusted Advisor provides best practices (or checks) in four categories: cost optimization, security, fault tolerance, and performance improvement. This demo will use "Low Utilization Amazon EC2 Instances" check in Cost Optimization.

* Attach AWS Tags to your existing AWS resources that you would like to review against if you have not done so. We will attach the same AWS Tags to a workload that you will define through Well-Architected Tool later. If there is no AWS Tags attached to your AWS resources, please attach the following AWS Tags to your existing Amazon EC2 Instances as follows:
    ```
    Key = workload
    Value = wademo
    ```
{{% notice note %}}    
**NOTE:** If you attached your own key and value to AWS resources, please use the same key and value when defining a workload later.
{{% /notice %}}


## Costs
{{% notice note %}}
**NOTE:** You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}
* [AWS Pricing](https://aws.amazon.com/pricing/)

## Time to complete
- The lab should take approximately 30 minutes to complete

## Steps
{{% children /%}}

{{< prev_next_button link_next_url="./1_prerequisites/" button_next_text="Start Lab" first_step="true" />}}
