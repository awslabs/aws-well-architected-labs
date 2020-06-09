---
title: "Teardown"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

Savings Plan analysis is a critical requirement of cost optimization, so there is no specific tear down for this lab.

The following resources were created in this lab:

- S3 Bucket: (custom name)
- Lambda Functions: SPTool_ODPricing_Download and SPTool_SPPricing_Download
- IAM Role: SPTool_Lambda
- IAM Policy: s3_pricing_lambda
- CloudWatch Event, Rule: SPTool-Pricing
- Glue Crawlers: OD_Pricing and SP_Pricing
- IAM Role: AWSGlueServiceRole-SPToolPricing
- Glue Database: Pricing
- Athena Views: pricing.pricing and costmaster.SP_USage
- QuickSight Dataset: SP_Usage
- QuickSight Analysis: sp_usage analysis
