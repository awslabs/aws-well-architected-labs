---
title: "CloudFront with S3 Bucket Origin"
menutitle: "CloudFront with S3 Bucket Origin"
date: 2020-09-16T11:16:08-04:00
chapter: false
weight: 3
---

**Last Updated:** September 2020

**Author:** Ben Potter, Security Lead, Well-Architected

## Introduction

This hands-on lab will guide you through the steps to host static web content in an [Amazon S3 bucket](https://aws.amazon.com/s3/), protected and accelerated by [Amazon CloudFront](https://aws.amazon.com/cloudfront). Skills learned will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

![s3-cloudfront-diagram](/Security/100_CloudFront_with_S3_Bucket_Origin/Images/s3-cloudfront-diagram.png)

## Prerequisites

- An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing.
- Permissions to Amazon S3 and Amazon CloudFront.

## Costs

- Typically less than $1 per month if the account is only used for personal testing or training, and the tear down is not performed.
- [Amazon S3 pricing](https://aws.amazon.com/s3/pricing/) [Amazon CloudFront Pricing](https://aws.amazon.com/cloudfront/pricing/)
- [Amazon CloudFront pricing](https://aws.amazon.com/cloudfront/pricing/)
- [AWS Pricing](https://aws.amazon.com/pricing/)

## Steps:

{{% children  %}}

## References & useful resources

[Amazon S3 Developer Guide](https://docs.aws.amazon.com/AmazonS3/latest/dev/Welcome.html)
[Amazon CloudFront Developer Guide](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)
