---
title: "Level 200: Implementing Bi-Directional Cross-Region Replication (CRR) for Amazon Simple Storage Service (Amazon S3)"
menutitle: "S3 Bi-Directional Replication"
description: "Improve reliability using automatic asynchronous backup of encrypted data in Amazon S3"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 1
hidden: false
tags:
  - data_backup
---
## Author

* Seth Eliot, Principal Reliability Solutions Architect, AWS Well-Architected

## Introduction

This hands-on lab will guide you through the steps to improve reliability of your service and its data using automatic asynchronous backup of encrypted data you store in Amazon S3. Your Amazon S3 data will be securely backed up to a different AWS region.

The skills you learn will help you build resilient workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

![TwoReplicationRules](/Reliability/200_Bidirectional_Replication_for_S3/Images/TwoReplicationRules.png)

## Goals

By the end of this lab, you will be able to:

* Perform data backup automatically for objects in Amazon S3 buckets
* Secure and encrypt backups of objects in Amazon S3
* Automate disaster recovery (DR) of your objects in Amazon S3
* Query CloudTrail logs to improve your understanding of how cross-region replication works for Amazon S3

## Prequisites

If you are running this at an AWS sponsored workshop then you may be provided with an AWS Account to use, in which case the following pre-requisites will be satisfied by the provided AWS account.  If you are running this using your own AWS Account, then please note the following prerequisites:

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing. This account MUST NOT be used for production or other purposes.
* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to create IAM Polices and Roles, create S3 buckets and bucket policies, get and put objects into S3 buckets, and create and read CloudTrail trails and CloudWatch Log Groups.

{{% notice note %}}
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

{{< prev_next_button link_next_url="./1_deploy_infra/" button_next_text="Start Lab" first_step="true" />}}

## Steps:
{{% children /%}}

## Costs
{{% notice note %}}
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

* In this lab you will do three S3 PUTs, store under 1MB of data in two S3 buckets, and transfer under 1MB of data from one region to another.
* The total of these operations will not exceed $0.01. Under normal conditions there should be no accrued charges for this lab.
* Please follow the directions for [Tear Down](./6_cleanup/) to remove all deployed resources when you are done with this lab.
