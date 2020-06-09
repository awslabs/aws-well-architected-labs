---
title: "Level 300: Lambda Cross Account IAM Role Assumption"
menutitle: "Lambda Cross Account IAM Role Assumption"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 6
---

## Authors

* Ben Potter, Security Lead, Well-Architected

## Introduction

This lab demonstrates a Lambda function in AWS account 1 (the origin) using Python boto SDK to assume an IAM role in account 2 (the destination), then list the buckets. If you only have 1 AWS account simply repeat the instructions in that account and use the same account id.

If in classroom and you do not have 2 AWS accounts, buddy up to use each other's accounts, agree who will be account #1 and who will be account #2.

The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Goals

* Cross account role assumption
* Lambda assuming another role

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An IAM user with MFA enabled that can assume roles in your AWS account.
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

## Steps:

{{% children  %}}

## References & useful resources

<https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_condition-keys.html>
