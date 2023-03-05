---
title: "Level 200: Different datasets and their use case"
menutitle: "Different datasets and their use case"
date: 2022-01-10T09:00:08-04:00
chapter: false
weight: 1
hidden: false
---
## Author

- **Ana Suja**, Solutions Architect.
- **Bob Molitor**, Solutions Architect.

## Introduction

This lab focuses on optimizing [data patterns for sustainability](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/data-patterns.html) to reduce the provisioned storage required to support your workload, and the resources required to use it. 

In this lab you will find different independent modules. In each of them you will analyse a different dataset, with a different use case where data is used to achieve different business goals.

From a sustainability perspective, you will learn how to trade off those needs with the best approach for *availability*, *retention*, and *deletion* of your data, to **efficiently use your resources**.

{{% notice note %}}
**NOTE:** Each module is independent. You don't need to follow any order. 
{{% /notice %}}

One of the best practices from the Well Architected Framework Sustainability Pillar, is to [Align SLAs with sustainability goals](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/sus_sus_user_a3.html):

 *"Define and update Service Level Agreements (SLAs) such as availability or data retention periods to minimize the number of resources required to support your workload while continuing to meet business requirements"*.

 To define your SLAs aligned with your sustainability goals, you need to think about:
* What are your business objectives?
* How long do you need to store this dataset?
* Is this data easy to reproduce?

Thus, in these series of Modules, you will cover topics such as:

* Exploring metrics to monitor to understand data access patterns and usage
* Leveraging Amazon S3 Storage tiers for sustainability according to those patterns
* Choosing the best data format
* Identifying and managing unused storage resources
* Deduplicating data


## Goals
By the end of this lab you will:

* Understand design principles in the [AWS Well-Architected Sustainability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/sustainability-pillar.html)
* Understand best practices for [data patterns](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/data-patterns.html) in the AWS Well-Architected Sustainability Pillar
* Learn how to optimize your workload for data usage
* Choose the most appropriate lifecycle for your data
* Choose the best storage class for your data

## Prerequisites

* The lab is designed to run in your own AWS account.
* TBD

## Costs
* TBD

{{% notice note %}}
**NOTE:** You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}
* [AWS Pricing](https://aws.amazon.com/pricing/)

## Lab Duration
This lab consists of different independent modules that have different durations. 
## Modules

{{% children depth=1 %}}


