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


{{< prev_next_button link_prev_url="../5_format_dashboard/"  title="Congratulations!" final_step="true"  />}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST7 - "How do you use pricing models to reduce cost?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-cost-effective-resources.html)
{{< prev_next_button />}}


