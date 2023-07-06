---
title: "Level 200: Manage Workload Risks with OpsCenter"
menutitle: "Level 200: Manage Workload Risks with OpsCenter"
description: "Create a risk management workflow for improved Operational Excellence"
date: 2021-08-31T11:16:09-04:00
chapter: false
weight: 3
tags:
  - workload_risk_management
---
## Authors

* Mahanth Jayadeva, Solutions Architect, AWS Well-Architected

## Introduction

In this lab, you will become familiar with how you can better manage workload risks identified in the [AWS Well-Architected Tool](https://aws.amazon.com/well-architected-tool/) (AWS WA Tool). You will learn how to efficiently track risks across your entire technology portfolio while maintaining a single source of truth for risk information in an automated manner.

Most workloads contain risks or opportunities for improvement which can lead to better business outcomes when addressed. Risk mitigation should be prioritized based on the impact it can have on your business. As the number of workloads increases, it can be a challenge to manage and prioritize which risks to address first.

By tracking all risks in a single location, you can better understand which risks are related, prioritize them accordingly, and implement best practices to mitigate them. Being able to track risks across workloads will allow you to prevent duplication of efforts and enables teams to be aligned on priorities for risk remediation.

In this lab, you will use AWS WA Tool APIs and create OpsItems in [AWS Systems Manager OpsCenter](https://docs.aws.amazon.com/systems-manager/latest/userguide/OpsCenter.html) to track best practices missing from your workloads. You can then view, investigate, and resolve those OpsItems in a single location, and automatically update the risk status of the workload on the AWS WA Tool. The entire process will be automated using [AWS Lambda](https://aws.amazon.com/lambda/) functions.

The skills you learn will help you create risk management workflows which will help you determine your priorities in alignment with Operational Excellence best practices of the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## Goals:

* Create actionable work items from workload risks
* Maintain a single source of truth for workload risk information

## Prerequisites:

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An IAM user or role in your AWS account that has Administrator privileges.
* [Define and document the workload state](https://wellarchitectedlabs.com/well-architectedtool/100_labs/100_walkthrough_of_the_well-architected_tool/) for one or more workloads in the AWS WA Tool.

**NOTE**: You will be billed for any applicable AWS resources used as part of this lab, that are not covered in the AWS Free Tier.

{{< prev_next_button link_next_url="./1_deploy_infrastructure/" button_next_text="Start Lab" first_step="true" />}}

## Steps:
{{ children }}
