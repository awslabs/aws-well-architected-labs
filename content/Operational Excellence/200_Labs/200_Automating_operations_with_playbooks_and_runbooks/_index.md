---
title: "200 - Automating operations with Playbooks and Runbooks"
## menutitle: "Lab #1"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 1
hidden: false
---

## Authors
* **Stephen Salim**, Well-Architected Geo Solutions Architect.

## Contributors
* **Brian Carlson**, Well-Architected Operational Excellence Pillar Lead.
* **Jang Whan Han**, Well-Architected Geo Solutions Architect.

## Introduction

Manually running your [runbooks](https://wa.aws.amazon.com/wat.concept.runbook.en.html) and [playbooks](https://wa.aws.amazon.com/wat.concept.playbook.en.html) for operational activities has a number of drawbacks:

* Activities are prone to errors & difficult to trace. 
* Manual activities do not allow your operational practice to scale in line with your business requirements. 

In contrast, implementing automation in these activities has the following benefits:

* Improved reliability by preventing the introduction of errors through manual processes.
* Increased scalability by allowing non linear resource investment to operate your workload.
* Increased traceability on your operation through log collection of the automation activity.
* Improved incident response by reducing idle time and automatically triggering activity based on known events.

At a glance, both **runbooks** and **playbooks** appear to be similar documents that technical users, can use to perform operational activities. However, there an essential difference between them:

* A [playbook](https://wa.aws.amazon.com/wellarchitected/2020-07-02T19-33-23/wat.concept.playbook.en.html) documents contain processes that guides you through activities to investigate an issue. For example, gathering applicable information, identifying potential sources of failure, isolating faults, or determining the root cause of issues. Playbooks can follow multiple paths and yield more than one outcome.

* A [runbook](https://wa.aws.amazon.com/wat.concept.runbook.en.html) contains procedures necessary to achieve a specific outcome. For example, creating a user, rolling back configuration, or scaling resource to resolve the issue identified.

This hands-on lab will guide you through the steps to automate your operational activities using runbooks and playbooks built with AWS tools.

We will show how you can build automated runbooks and playbooks to investigate and remediate application issues using the following AWS services:

* [Systems Manager Automation](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-automation.html)
* [Simple Notification Service](https://aws.amazon.com/sns/?whats-new-cards.sort-by=item.additionalFields.postDateTime&whats-new-cards.sort-order=desc)
* [Amazon CloudWatch synthetic monitoring](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries.html)

## Goals: 

* Build and run automated playbooks to support your investigations
* Build and run automated runbooks to remediate specific faults
* Enabling traceability of operations activities in your environment


## Prerequisites:

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing. The account should not be used for production purposes.  
* An [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) in your AWS account with full access to [CloudFormation,](https://aws.amazon.com/cloudformation/) [Amazon ECS,](https://aws.amazon.com/ecs/)[Amazon RDS,](https://aws.amazon.com/rds/)[Amazon Virtual Private Cloud (VPC),](https://aws.amazon.com/vpc/) [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/).  

## Costs

{{% notice note %}}
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

{{< prev_next_button link_next_url="./1_deploy_base_application_environment/" button_next_text="Start Lab" first_step="true" />}}

Steps:
{{% children  /%}}
