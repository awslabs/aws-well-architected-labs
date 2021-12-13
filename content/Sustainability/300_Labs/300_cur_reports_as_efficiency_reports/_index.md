---
title: "Level 300: Turning Cost & Usage Reports into Efficiency Reports"
menutitle: "Turning Cost & Usage Reports into Efficiency Reports"
date: 2020-11-18T09:00:08-04:00
chapter: false
weight: 1
hidden: false
---
## Authors

- **Steffen Grunwald**, Principal Solutions Architect.
- **Thomas Attree**, Solutions Architect.

## Introduction

**Video Placeholder**
* explain proxy Metrics, introduce some candidates
* describe what the customer will build in the lab

{{%expand "Video Script"%}}
{{% /expand%}}

## Goals
At the end of this lab you will:

* Understand the need for proxy metrics and identify candidates
* Draw these KPIs from your AWS Cost & Usage Report (or sample data) and prepare the data ready for dashboarding with e.g. Amazon QuickSight
* Learn how you can add your own data and combine it with the AWS Cost & Usage Reports

## Prerequisites

The lab is designed to run in your account. You can pick a region in which you run the lab. If you have existing AWS Cost & Usage Report (CUR) data in a bucket, you should run the lab in the region of this bucket. [Pick a region where Amazon Athena is available](https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/).

{{% notice note %}}
**NOTE:** You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
When you decide to stop the lab at any point in time, please revisit the [clean up]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/cleanup.md" >}}) instructions at the end so you stop incuring cost (e.g. for storage in Amazon S3).
{{% /notice %}}

{{< prev_next_button link_next_url="./1-1_prepare_cur_data/" button_next_text="Start Lab" first_step="true" />}}

## Steps:
{{% children  %}}
