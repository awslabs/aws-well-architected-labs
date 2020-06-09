---
title: "Level 300: Lambda Cross Account Using Bucket Policy"
menutitle: "Lambda Cross Account Using Bucket Policy"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 5
---

## Authors

* Seth Eliot, Resiliency Lead, Well-Architected, AWS

## Introduction

This lab demonstrates configuration of an S3 bucket policy (which is a type of resource based policy) in AWS account 2 (the destination) that enables a Lambda function in AWS account 1 (the origin) to list the objects in that bucket using Python boto SDK. If you only have 1 AWS account simply repeat the instructions in that account and use the same account id.

If in classroom and you do not have 2 AWS accounts, buddy up to use each other's accounts, agree who will be account #1 and who will be account #2.

The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Goals

* S3 bucket policies
* Resource based policies versus identity based policies

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An IAM user with MFA enabled that can assume roles in your AWS account.
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

## Steps:

{{% children  %}}

## References & useful resources

* <https://docs.aws.amazon.com/AmazonS3/latest/dev/using-iam-policies.html>
* <https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_identity-vs-resource.html>
