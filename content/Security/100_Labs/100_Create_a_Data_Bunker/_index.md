---
title: "Level 100: Create a Data Bunker Account"
menutitle: "Create a Data Bunker Account"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 5
hidden: false
---
## Overview

In this lab we will create a secure data bunker. A data bunker is a secure account which will hold important security data in a secure location. Ensure that only members of your security team have access to this account. In this lab we will create a new security account, create a secure S3 bucket in that account and then turn on CloudTrail for our organisation to send these logs to the bucket in the secure data account. You may want to also think about what other data you need in there such as secure backups.

{{% notice note %}}
If you are using AWS Control Tower the steps in this lab cover what has already been configured for the Control Tower [Log Archive Account](https://docs.aws.amazon.com/controltower/latest/userguide/how-control-tower-works.html#what-shared).
{{% /notice %}}

![Data bunker account structure](/Security/100_Create_a_Data_Bunker/Images/data-bunker-architecture.png)

## Prerequisites

* A multi-account structure with AWS Organizations
* You have access to a role with administrative access to the root account for your AWS Organization

NOTE: You will be billed for the AWS CloudTrail logs and Amazon S3 storage setup as part of this lab. See [AWS CloudTrail Pricing](https://aws.amazon.com/cloudtrail/pricing/) and [Amazon S3 Pricing](https://aws.amazon.com/s3/pricing/) for further details.

## Steps:
{{% children  %}}
