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

This lab focuses on optimizing [data patterns for sustainability](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/data-patterns.html) to reduce the provisioned storage required to support your workload, and the resources required to use it. In this lab you will analyse 2 different datasets, with different use case.

You will assess how each of those datasets is used to achieve business goals. From a sustainability perspective, you will learn how to trade off those needs with the best approach for distribution, retention, and deletion of your data, to efficiently use your resources.

We cover topics such as:

* Metrics to monitor to understand data access patterns and usage
* Storage tiers to leverage in Amazon S3 according to those patterns
* Optimal data formats for each case
* Identify and manage unused storage resources
* Deduplicate data


## Goals
At the end of this lab you will:

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
This lab consists of different independent modules. Each module should take around ¿45? min to complete.
## Modules
### Introduction to he modules
In each of the following modules, you will analyse the significance to business outcomes of one dataset to determine the best storage tier to use, the most appropriate data format and consider compression from a sustainability perspective. 

For each dataset, you will go through the process of understanding its access data patterns, choosing the best technologies that support data access and storage patterns, understanding how to implement lifecycle policies to store efficiently your data and to delete unnecessary and redundant data, etc.

{{< prev_next_button link_next_url="./1_static_csv_dataset/" button_next_text="First module" first_step="true" />}}

List of modules:

{{% children  %}}


