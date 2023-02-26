---
title: "Module 1: Static dataset used for reporting"
menutitle: "Module 1: Static dataset used for reporting"
date: 2020-11-18T09:00:08-04:00
chapter: false
weight: 1
hidden: false
---

In this module, you are going to answer this questions for a static CSV dataset. We will:
* Learn how to transform a CSV file to a partitioned Parquet file
* Compare the efficiency of columnar formats (Parquet) compared to plain text format (CSV)
* Explore Amazon S3 Lifecycle rules 

### Introduction

In this module, you will be working with the dataset SaaS-Sales.cvs provided [here](/Sustainability/200_different_datasets_and_their_use_case/Code/SaaS-Sales.csv).

**Context of the dataset**

This dataset represents sales data from a small fictitious SaaS (Software as a Service) company that sells sales and marketing software to other businesses (B2B). Each row of data is one transaction/order. 

You will imagine that you work on the BI business unit of the SaaS company and that our goal is to perform queries to our SaaS-Sales dataset to build monthly reports. Every month, the data team shares with us a new dataset with new data. Thus, each month, you use a new dataset to build the report and you don't need the previous ones.

The company has a focus on sustainability and wants us to optimize our resource usage.

**Business goals**
From the context, you understand that you want to query this dataset and that, after a month, you no longer need it. To optimize our resources you need to:
- Choose a format that makes our dataset more efficient to query
- Make sure that you are not storing data you do not need to minimize our storage resources

**Exercise**

In this walkthrough, you will first explore the dataset configuring a crawler to explore data in an Amazon S3 bucket, transform the CSV file into Parquet, and use AWS Glue and Amazon Athena to compare performance between quering Parquet and CSV data. You want to **reduce the resources needed to query this data**. 

To do so, you will compare how transforming our dataset CSV file to a columnar forma can improve our queries efficiency. To do so you will use:
- [Amazon S3](https://aws.amazon.com/s3/): to store the assets used and created in this lab
- [Amazon Athena](https://aws.amazon.com/athena/): to query our data stored in Amazon S3
- [AWS Glue](https://aws.amazon.com/glue/): to discover and transform our data

Then, you will automate data deletion by exploring [Amazon S3 Lifecycle configuration](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html), as you also want to **reduce the resources needed to store this data**.

### List of submodules
{{% children %}}


