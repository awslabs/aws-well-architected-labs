---
title: "Level 100: Deploy a Reliable Multi-tier Infrastructure using CloudFormation"
menutitle: "Deploy using CloudFormation"
description: "Learn to improve reliability of a service by using automation to deploy a reliable cloud infrastructure"
date: 2020-05-06T11:16:08-04:00
chapter: false
weight: 1
tags:
  - implement_change
---

## Author

* Seth Eliot, Principal Reliability Solutions Architect, AWS Well-Architected

## Introduction

This hands-on lab will guide you through the steps to improve reliability of a service by using automation to deploy a reliable cloud infrastructure. When this lab is completed, you will have deployed two CloudFormation templates. The first will deploy an Amazon Virtual Private Cloud (VPC). The second will deploy into your VPC, a reliable 3-tier infrastructure using Amazon EC2 distributed across three Availability Zones. You will then review the features of the deployed infrastructure and learn how they contribute to reliability.

AWS Well-Architected offers _two different_ CloudFormation labs illustrating Reliability best practices. **Choose which lab you prefer (or do both)**:

* This lab is a **100** lab where you will do deployment-only using an AWS CloudFormation template. You will deploy a multi-tier reliable architecture.
* If you would prefer a more advanced lab where you create and modify CloudFormation, please see the **200** level lab [Deploy and Update CloudFormation]({{< ref "200_Deploy_and_Update_CloudFormation">}}). Because the **200** lab includes modification and update as part of the exercise, it uses a simplified, single-tier, non-reliable architecture.

The skills you learn will help you build resilient workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) best practices for reliability:

The architecture of the infrastructure you will deploy is represented by this diagram:
![ArchitectureOverview](/Reliability/100_Deploy_CloudFormation/Images/ArchitectureOverview.png)

## Goals

By the end of this lab, you will be able to:

* Automate infrastructure deployment for a workload
* Understand how the deployed workload infrastructure contributes to reliability of the workload

## Prequisites

If you are running the at an AWS sponsored workshop then you may be provided with an AWS Account to use, in which case the following pre-requisites will be satisfied by the provided AWS account.  If you are running this using your own AWS Account, then please note the following prerequisites:

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing. This account MUST NOT be used for production or other purposes.
* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to create IAM Roles, EC2 instances, S3 buckets, DynamoDb tables, VPCs, Subnets, and Internet Gateways

NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

## Steps:
{{% children  %}}
