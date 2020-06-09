---
title: "Level 200: Deploy and Update CloudFormation"
menutitle: "Update CloudFormation"
description: "Improve reliability of a service by using automation to make changes in your cloud infrastructure"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 2
tags:
  - implement_change
---

## Author

* Seth Eliot, Principal Reliability Solutions Architect, AWS Well-Architected

## Introduction

This hands-on lab will guide you through the steps to improve reliability of a service by using automation to make changes in your cloud infrastructure. When this lab is completed, you will have deployed and edited a CloudFormation template. Using this template you will deploy and modify a VPC, an S3 bucket and an EC2 instance running a simple web server.

AWS Well-Architected offers _two different_ CloudFormation labs illustrating Reliability best practices. **Choose which lab you prefer (or do both)**:

* This is the **200** level lab where you create an infrastructure using CloudFormation and then make several modifications to it. Because this **200** level lab includes modification and update as part of the exercise, it uses a simplified, single-tier  architecture, which does _not_ follow best practices for reliability
* If you prefer a simpler lab that does deployment _only_, or want to see how to use CloudFormation to deploy a a multi-tier _reliable_ architecture using Amazon EC2, see this **100** level lab: [Deploy a Reliable Multi-tier Infrastructure using CloudFormation]({{< ref "Reliability/100_Labs/100_Deploy_CloudFormation">}})

The skills you learn will help you build resilient workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

![StackUpdates](/Reliability/200_Deploy_and_Update_CloudFormation/Images/StackUpdates.png)

## Goals

By the end of this lab, you will be able to:

* Automate change for your workload
* Document and track changes in code
* Implement infrastructure as a service

## Prequisites

If you are running the at an AWS sponsored workshop then you may be provided with an AWS Account to use, in which case the following pre-requisites will be satisfied by the provided AWS account.  If you are running this using your own AWS Account, then please note the following prerequisites:

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing. This account MUST NOT be used for production or other purposes.
* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to create IAM Roles, EC2 instances, S3 buckets, VPCs, Subnets, and Internet Gateways

NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).


## Steps:
{{% children  %}}
