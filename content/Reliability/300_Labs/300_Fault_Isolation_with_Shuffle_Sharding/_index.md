---
title: "Level 300: Fault Isolation with Shuffle Sharding"
menutitle: "Fault isolation with shuffle sharding"
description: "Implement shuffle sharding to minimize scope of impact of failures"
date: 2020-18-11T11:16:08-04:00
chapter: false
weight: 3
tags:
  - mitigate_failure
---
## Author

* Mahanth Jayadeva, Solutions Architect, AWS Well-Architected

## Introduction

In this lab, you will become familiar with the concept of shuffle sharding and how it can help reduce blast radius during failures. You will learn how to distribute user requests to resources in a combinatorial way so that any failures affect only a small subset of users. "Users" in this case refers to any source of requests to your workload.  This can be other services that call your workload, in addition to actual human users.

Without any sharding, any worker (such as servers, queues, or databases) in your workload can handle any request. With this architecture a poisonous request or a flood of requests from one user will spread unabated through the entire fleet. Sharding is the practice of providing logical isolation of capacity (one ore more workers) for each set of users, limiting the propagation of such failures. Shuffle sharding further limits the impact of any one "bad actor" among your users.

In this lab, you will create a workload with a sample application running on EC2 instances. You will then create a strategy to distribute traffic using shuffle sharding and reduce the blast radius when a failure occurs.

The skills you learn will help you [use fault isolation to protect your workload](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/use-fault-isolation-to-protect-your-workload.html) in alignment with Reliability best practices of the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## Goals:

* Deploy a workload with a sharded architecture to limit propagation of failures
* Implement shuffle sharding to further limit failure propagation
* Test failure within the workload and ensure the scope of impact is minimized

## Prerequisites:

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An IAM user or role in your AWS account that has Administrator privileges.

**NOTE**: You will be billed for any applicable AWS resources used as part of this lab, that are not covered in the AWS Free Tier.

{{< prev_next_button link_next_url="./1_deploy_workload/" button_next_text="Start Lab" first_step="true" />}}

## Steps:
{{% children  %}}
