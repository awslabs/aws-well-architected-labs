---
title: "Level 300: Implementing Health Checks and Managing Dependencies to improve Reliability"
menutitle: "Health Checks & Dependencies"
description: "Improve reliability of a service by decoupling service dependencies, using health checks, and demonstrating when to use fail-open and fail-closed behaviors"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 1
hidden: false
tags:
  - mitigate_failure
---
## Author

* Seth Eliot, Principal Reliability Solutions Architect, AWS Well-Architected


## Introduction

This hands-on lab will guide you through the steps to improve reliability of a service by decoupling service dependencies, using health checks, and demonstrating when to use fail-open and fail-closed behaviors.

The skills you learn will help you build resilient workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

![ArchitectureOverview_small](/Reliability/300_Health_Checks_and_Dependencies/Images/ArchitectureOverview_small.png)

## Amazon Builders' Library

This lab additionally illustrates best practices as described in the Amazon Builders' Library article: [Implementing health checks](https://aws.amazon.com/builders-library/implementing-health-checks/)

## Goals

After you have completed this lab, you will be able to:

* Implement graceful degradation to transform applicable hard dependencies into soft dependencies
* Monitor all layers of the workload to detect failures
* Route traffic only to healthy application instances
* Configure fail-open and fail-closed behaviors as appropriate in response to detected faults
* Use AWS services to reduce mean time to recovery (MTTR)

## Prequisites

If you are running the at an AWS sponsored workshop then you may be provided with an AWS Account to use, in which case the following pre-requisites will be satisfied by the provided AWS account.  If you are running this using your own AWS Account, then please note the following prerequisites:

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing. This account MUST NOT be used for production or other purposes.
* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to create Amazon Virtual Private Cloud(s) (VPCs), including subnets and route tables, Security Groups, Internet Gateways, NAT Gateways, Elastic IP Addresses, IAM Roles, instance profiles, AWS Auto Scaling launch configurations, Application Load Balancers, Auto Scaling Groups, DynamoDB tables, SSM Parameters, and EC2 instances.

NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

## Steps:
{{% children  %}}
