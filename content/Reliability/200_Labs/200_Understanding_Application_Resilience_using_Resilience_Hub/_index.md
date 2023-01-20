---
title: "Level 200: Understanding application resilience using AWS Resilience Hub"
menutitle: "Understand resilience with Resilience Hub"
description: "Implement shuffle sharding to minimize scope of impact of failures"
date: 2020-18-11T11:16:08-04:00
chapter: false
weight: 3
tags:
  - mitigate_failure
---
## Author

* Mahanth Jayadeva, Resilience Architect, AWS Resilience Hub

## Introduction

In this lab, you will become familiar with using AWS Resilience Hub to understand the resilience of your applications. You will define an application and run assessments against it. Resilience Hub analyzes your application to see conformance to AWS Well-Architected best practices and provides guidance on how the architecture can be improved to meet your resilience targets.

In addition to resiliency recommendations, Resilience Hub also provides operational recommendations that will help you detect disruptions to your application as well as Standard Operating Procedures (SOPs) that you can use to speed up recovery. Resilience Hub also integrates with AWS Fault Injection Simulator (FIS) which will enable you to run chaos engineering experiments to validate the resilience of your applications.

The skills you learn will help you understand and implement multiple [Reliability best practices](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html) of the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## Goals:

* Deploy a workload and measure its resilience
* Implement resiliency recommendations and observe improvements
* Implement operational recommendations and observe improvements

## Prerequisites:

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An IAM user or role in your AWS account that has Administrator privileges.

**NOTE**: You will be billed for any applicable AWS resources used as part of this lab, that are not covered in the AWS Free Tier.

## [Start the lab](https://catalog.workshops.aws/aws-resilience-hub-lab/en-US)