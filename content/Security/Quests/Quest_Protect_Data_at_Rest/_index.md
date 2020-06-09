---
title: "Quest: Protect Data at Rest"
menutitle: "Protect Data at Rest"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 14
description: " "
---

## Authors

- Ben Potter, Security Lead, Well-Architected

## About this Guide

This guide will help you improve your security in the AWS Well-Architected area of [Data Protection](https://wa.aws.amazon.com/wat.pillar.security.en.html#sec.daataprot). The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

***

## Create a Data Bunker Account

### Introduction

In this lab we will create a secure data bunker. A data bunker is a secure account which will hold important security data in a secure location. Ensure that only members of your security team have access to this account. In this lab we will create a new security account, create a secure S3 bucket in that account and then turn on CloudTrail for our organisation tp send these logs to th bucket in the secure data account. You may want to also think about what other data you need in there such as secure backups.

### [Start the Lab!](/security/100_labs/100_create_a_data_bunker/)

***

## Further Learning

* [S3: Protecting Data Using Server-Side Encryption with AWS KMS–Managed Keys](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingKMSEncryption.html?ref=wellarchitected)
* [Opt-in to Default Encryption for New EBS Volumes](https://aws.amazon.com/blogs/aws/new-opt-in-to-default-encryption-for-new-ebs-volumes/)
