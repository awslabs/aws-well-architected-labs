---
title: "Level 200: EC2 Scheduling at Scale"
## menutitle: "Lab #1"
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

## Well-Architected Best Practices

This lab helps you to exercise the following AWS Well-Architected Best Practices in your Cost and Sustainability optimization process:

* [COST06-BP03](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/cost_type_size_number_resources_metrics.html) - **Select resource type, size, and number automatically based on metrics**
* [CCOST09-BP01](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/cost_manage_demand_resources_cost_analysis.html) - **Perform an analysis on the workload demand**
* [COST09-BP03](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/cost_manage_demand_resources_dynamic.html) - **Supply resources dynamically**


## Introduction

In this lab, we will leverage AWS resource tags and the AWS Instance Scheduler solution to optimize the cost and sustainability footprint of idle workloads at scale.

In this workshop, you will learn best practices for cost and sustainability optimization. We will shift costs and sustainability responsibilities from the Cloud Center of Excellence (CCoE) to end users and application owners aided by automation at scale. Learn about cost efficiency and implementation of mechanisms that empower application owners to have clear, actionable tasks for cost and sustainability optimization, building upon real-world use cases. You must bring your laptop to participate.

## Goals: 

* Build a Systems Manager [automation runbook](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-documents.html) to encapsulate the automated change process.
* Create a Change Template through [AWS Systems Manager Change Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/change-manager.html) to build an AWS health aware operation change process. 
* Simulate a service event scenario, and validate the change process is able to avoid the production change execution when there's an active AWS service event.



## Prerequisites:

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing. The account should not be used for production purposes.
* An [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) in your AWS account with full access to [CloudFormation](https://aws.amazon.com/cloudformation/), [Amazon EC2](https://aws.amazon.com/ec2/), [Amazon Systems Manager](https://aws.amazon.com/systems-manager/), [Amazon Simple Notification Service(SNS)](https://aws.amazon.com/sns/), [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/), [Amazon S3](https://aws.amazon.com/s3/).

## Costs

{{% notice note %}}
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

{{< prev_next_button link_next_url="./1_deploy_ssm_application_environment/" button_next_text="Start Lab" first_step="true" />}}

Steps:
{{% children  /%}}
