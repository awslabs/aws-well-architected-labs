---
title: "200 - Build AWS Health Aware Operation Change Process"
## menutitle: "Lab #1"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 1
hidden: false
---

## Authors
* **Jerry Chen**, Well-Architected Geo Solutions Architect.

## Contributors
* **Rich Boyd**, Well-Architected Operational Excellence Pillar Lead.
* **Phong Le**, Well-Architected Geo Solutions Architect.

## Introduction

In the context of making production changes on AWS, whenever a failure occurs during the change window, your operation team have to check the root cause apart from potentially reverting the environment back to the last functioning version. They are often under huge pressure to conclude the root cause within the change window, so to make a Go or No-Go decision.

To accelerate the troubleshooting process, you need an approach to determine whether the change failure was caused by active AWS service events before proceeding to other aspects of application related investigations. You can achieve this goal by manually checking the [AWS Health Dashboard](https://health.aws.amazon.com/health), or open an AWS support case to engage AWS support engineers. 

However there's an opportunity to use [AWS Health API](https://docs.aws.amazon.com/health/latest/ug/health-api.html) to build an AWS health aware operation change process with [AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html), so the operation change pipeline is capable of checking the health status of AWS services to ensure there's no active AWS service events before kicking in the change execution, which derisk the change process being impacted by the service events.

## Goals: 

* Build a Systems Manager [automation runbook](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-documents.html) to encapsulate the automated change process.
* Create a Change Template through [AWS Systems Manager Change Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/change-manager.html) to build an AWS health aware operation change process. 
* Simulate a service event scenario, and validate the change process is able to avoid the production change execution when there's an active AWS service event.



## Prerequisites:

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing. The account should not be used for production purposes.
* The AWS account must be enrolled in Business Support, Enterprise On-Ramp, or Enterprise Support to access the AWS Health API. You can change the [Support Plan](https://aws.amazon.com/premiumsupport/knowledge-center/change-support-plan/) if needed.
* An [IAM user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) in your AWS account with full access to [CloudFormation](https://aws.amazon.com/cloudformation/), [Amazon EC2](https://aws.amazon.com/ec2/), [Amazon Systems Manager](https://aws.amazon.com/systems-manager/), [Amazon Simple Notification Service(SNS)](https://aws.amazon.com/sns/), [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/), [Amazon S3](https://aws.amazon.com/s3/).

## Costs

{{% notice note %}}
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

{{< prev_next_button link_next_url="./1_deploy_ssm_application_environment/" button_next_text="Start Lab" first_step="true" />}}

Steps:
{{% children  /%}}
