---
title: "Level 200: EC2 Scheduling at Scale"
date: 2023-02-06T01:00:00+11:00
chapter: false
weight: 1
hidden: false
---

## Authors
* **Enrico Bonaccorsi**, Principal Technical Account Manager.
* **Francesc Sala**, Principal Technical Account Manager.

## Contributors
* **Carlos Perez**, Geo Solutions Architect, AWS Well-Architected.
* **Ben Mergen**, Sr Cost Lead SA WA.

## Well-Architected Best Practices

This lab helps you to exercise the following AWS Well-Architected Best Practices in your Cost Optimization process:

* [COST06-BP03](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/cost_type_size_number_resources_metrics.html) - **Select resource type, size, and number automatically based on metrics**
* [COST09-BP01](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/cost_manage_demand_resources_cost_analysis.html) - **Perform an analysis on the workload demand**
* [COST09-BP03](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/cost_manage_demand_resources_dynamic.html) - **Supply resources dynamically**


## Introduction

In this lab, we will leverage AWS resource tags and the AWS Instance Scheduler solution to optimize the cost of idle workloads at scale.

Implementing an [effective tagging strategy](https://docs.aws.amazon.com/whitepapers/latest/cost-optimization-laying-the-foundation/tagging.html) is fundamental for setting up your environment for cost optimization. Among many advantages, such as attributing your costs and usage throughout your organization, tagging also allows you to categorize and distinguish resources between your development, test and production environments. This can help you to effectively identify workloads and implement mechanisms to supply resources dynamically based on the environment.

The [Instance Scheduler solution](https://aws.amazon.com/solutions/implementations/instance-scheduler-on-aws/) used in this lab allows you to follow a time-based approach for making resources available only at times when they are actually needed. In addition, the solution leverages [AWS resource tags](https://docs.aws.amazon.com/tag-editor/latest/userguide/tagging.html) and [AWS Lambda](https://aws.amazon.com/lambda/) for automating the starting and stopping of Amazon EC2 and Amazon RDS instances, which can result in up to 70% savings of operational costs.

You will learn about best practices for cost optimization and the implementation of mechanisms, aided by automation at scale, that empower application owners to follow actionable tasks for cost optimization.

**References:** *This lab focuses in one of the modules from the re:Invent 2022 workshop [SUP304 - Continuous Cost and Sustainability Optimization](https://catalog.us-east-1.prod.workshops.aws/workshops/42c0fe7e-8d1c-4d5f-8b48-c818c7952242/en-US)*


## Goals

* Deploy and verify the configuration of the [AWS Instance Scheduler solution](https://aws.amazon.com/solutions/implementations/instance-scheduler-on-aws/)
* Leverage the AWS Instance Scheduler to implement a schedule with the following requirement:
    * EC2 instances with the tag key **"walab-environment"** and value **"dev"** should be in stopped state outside of the Seattle business hours


## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing. The account should not be used for production purposes.
* An [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) in your AWS account who has either AdministratorAccess or PowerUserAccess (with full IAM access).

## Costs

* **Instance Scheduler Cost:** As of January 2023, the cost for running the [Instance Scheduler solution](https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/cost.html) with default settings in the US East (N. Virginia) Region is approximately 9.90USD per month in AWS Lambda charges, or less if you have [Lambda free tier](https://aws.amazon.com/lambda/pricing/) monthly usage credit.
* **Sample workload instances Cost:** Five on-demand **t3.nano** EC2 instances will be launched as part of a sample fleet. The cost per **t3.nano** instance is $0.0052 per hour. For 5 instances running, for the whole month, the cost would be 18.98USD.
* After completion of the lab, in section 4, you will find steps to delete the resources created. The cost figures mentioned above are only in case this lab's related resources are left running for the whole month.

{{% notice note %}}
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

{{< prev_next_button link_next_url="./1_deploy_sample_instances_and_scheduler_solution/" button_next_text="Start Lab" first_step="true" />}}

Steps:
{{% children  /%}}
