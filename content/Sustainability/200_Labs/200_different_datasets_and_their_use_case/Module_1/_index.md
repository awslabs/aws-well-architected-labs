---
title: "Module 1: Static dataset used for reporting"
menutitle: "Module 1: Static dataset used for reporting"
date: 2020-11-18T09:00:08-04:00
chapter: false
weight: 1
hidden: false
---

In this module, we are going to answer this questions for a static CSV dataset. We will:
* Compare the efficiency of columnar formats (Parquet) compared to plain text format (CSV)
* Learn how to transform a CSV file to a partitioned Parquet file

### Introduction

In this module, we will be working with the dataset SaaS-Sales.cvs provided [here](/Sustainability/200_different_datasets_and_their_use_case/Code/SaaS-Sales.csv).

This dataset represents sales data from a small fictitious SaaS (Software as a Service) company that sells sales and marketing software to other businesses (B2B). Each row of data is one transaction/order. 

We will imagine that we work on the BI business unit and that our goal is to perform queries to this dataset.

In this walkthrough, we will explore the dataset configuring a crawler to explore data in an Amazon S3 bucket, transform the CSV file into Parquet, and use AWS Glue and Amazon Athena to compare performance.

{{% notice note %}}
In this lab we will explore different options and explore trade-offs. There is no one decision that fits all use cases. To make decisions about our data, we first need to understand business SLAs and sustainability goals.
{{% /notice %}}

Here, we are deciding about a dataset that is going to be queried, thus, we want to **reduce the resources needed to query this data**. 

To do so, we will compare how transforming our dataset CSV file to a columnar forma can improve our queries efficiency. To do so we will use:
- [Amazon S3](https://aws.amazon.com/s3/): to store the assets used and created in this lab
- [Amazon Athena](https://aws.amazon.com/athena/): to query our data stored in Amazon S3
- [AWS Glue](https://aws.amazon.com/glue/): to discover and transform our data

### List of submodules
{{% children %}}


