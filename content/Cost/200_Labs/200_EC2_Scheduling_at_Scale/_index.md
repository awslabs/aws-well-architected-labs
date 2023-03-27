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

## Well-Architected Best Practices

This lab helps you to exercise the following AWS Well-Architected Best Practices in your Cost and Sustainability optimization process:

* [COST06-BP03](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/cost_type_size_number_resources_metrics.html) - **Select resource type, size, and number automatically based on metrics**
* [COST09-BP01](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/cost_manage_demand_resources_cost_analysis.html) - **Perform an analysis on the workload demand**
* [COST09-BP03](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/cost_manage_demand_resources_dynamic.html) - **Supply resources dynamically**


## Introduction

In this lab, we will leverage AWS resource tags and the AWS Instance Scheduler solution to optimize the cost and sustainability footprint of idle workloads at scale.

In this workshop, you will learn best practices for cost and sustainability optimization. We will shift costs and sustainability responsibilities from the Cloud Center of Excellence (CCoE) to end users and application owners aided by automation at scale. Learn about cost efficiency and implementation of mechanisms that empower application owners to have clear, actionable tasks for cost and sustainability optimization, building upon real-world use cases. You must bring your laptop to participate.


## Goals: 

* Deploy and verify the configuration of the [AWS Instance Scheduler solution](https://aws.amazon.com/solutions/implementations/instance-scheduler-on-aws/)
* Leverage the AWS Instance Scheduler to implement a schedule with the following requirements:
    * EC2 instances with "environment" Tag set to "dev" should always be in stopped state outside Seattle business hours

We will use the [AWS Instance Scheduler solution](https://aws.amazon.com/solutions/implementations/instance-scheduler-on-aws/) to achieve the goal above. Note, for security reasons, the role you are assuming to access the workshop account, does not allow to create IAM resources, which is a requirement for the AWS instance Scheduler public cloudformation template. We have customized the environment with a special version of AWS Instance Scheduler cloudformation for this workshop. Use the cloudformation template provided in the instruction in the next step instead of the official one otherwise you will not be able to install Instance Scheduler in this account.


## Prerequisites:

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing. The account should not be used for production purposes.
* An [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) in your AWS account with full access to [CloudFormation](https://aws.amazon.com/cloudformation/), [Amazon EC2](https://aws.amazon.com/ec2/), [Amazon Systems Manager](https://aws.amazon.com/systems-manager/), [Amazon Simple Notification Service(SNS)](https://aws.amazon.com/sns/), [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/), [Amazon S3](https://aws.amazon.com/s3/).

## Costs

* [Instance Scheduler Cost](https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/cost.html): You are responsible for the cost of the AWS services used while running Instance Scheduler on AWS. As of January 2023, the cost for running this solution with default settings in the US East (N. Virginia) Region is approximately $9.90 per month in AWS Lambda charges, or less if you have [Lambda free tier](https://aws.amazon.com/lambda/pricing/) monthly usage credit.
* EC2 sample instances

{{% notice note %}}
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

{{< prev_next_button link_next_url="./1_deploy_sample_instances_and_scheduler_solution/" button_next_text="Start Lab" first_step="true" />}}

Steps:
{{% children  /%}}
