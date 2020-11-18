---
title: "Level 300: Minimize Blast Radius with Shuffle Sharding"
menutitle: "Minimize Blast Radius with Shuffle Sharding"
description: "Implement shuffle-sharding to minimize blast radius of failures"
date: 2020-18-11T11:16:08-04:00
chapter: false
weight: 3
tags:
  - shuffle_sharding
---
## Authors

* Mahanth Jayadeva, Solutions Architect, Well-Architected

## Introduction

In this lab, you will become familiar with the concept of shuffle-sharding and how it can help reduce blast radius during failures. You will learn how to distribute traffic in a combinatorial way so that any failures affect only a small subset of users.

While most workloads are designed to withstand infrastructure failures, issues introduced by the application could propagate through the workload and take down the entire fleet of services. It is important to have a strategy to minimize disruption to users that could be caused by such application issues.

In this lab, you will create a workload with a sample application running on EC2 instances. You will then create a strategy to distribute traffic using shuffle-sharding and reduce the blast radius when a failure occurs.

The skills you learn will help you create bulkhead architectures in alignment with Reliability best practices of the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## Goals:

* Deploy a workload with a bulkhead architecture
* Test failure within the workload and ensure the blast radius is minimized

## Prerequisites:

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An IAM user or role in your AWS account that has Administrator privileges.

**NOTE**: You will be billed for any applicable AWS resources used as part of this lab, that are not covered in the AWS Free Tier.


## Steps:
{{% children  %}}
