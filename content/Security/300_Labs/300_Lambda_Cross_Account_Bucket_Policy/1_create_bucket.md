---
title: "Identify (or create) S3 bucket in account 2"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

## This lab is best run using two AWS accounts

* Identify the AWS account number for account 1 (no dashes)
* Identify the AWS account number for account 2 (no dashes)

If you only have one AWS account, then use the same AWS account number for both **account1** and **account2**

1. In account 2 sign in to the S3 Management Console as an IAM user or role in your AWS account, and open the S3 console at <https://console.aws.amazon.com/s3>
1. Choose an S3 bucket that contains some objects. You will enable the ability to list the objects in this bucket from the other account.
   * If you would rather create a new bucket to use, [follow these directions]({{% ref "/common/documentation/CreateNewS3BucketAndAddObjects.md" %}})
   * Record the **bucketname**
