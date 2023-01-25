---
title: "Module 1: Static .csv dataset used for business intelligence"
date: 2023-01-24T09:16:09-04:00
chapter: false
weight: 2
pre: "<b>Module 1: </b>"
---

## Objectives

* learn how to set up lifecycle policies on Amazon S3
* Learn how/when to convert data to columnar format

### Dataset description, usage and requirements

For this first module, you will use the dataset *SaaS-Sales.csv* file provided here : Download [SaaS-Sales.csv](https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/337d5d05acc64a6fa37bcba6b921071c/v1/SaaS-Sales.csv). This data set represents sales data from a fictitious SaaS (Software as a Service) company that sells sales and marketing software to other businesses (B2B). Each row of data is one transaction/order.

This dataset is exported monthly for the Business Intelligence team to analyse and report results at the end of the mont to the management. After that, this data is needed for aggregated yearly analysis during the next 5 years.

This data is provided by the operations team, which are the owners of the data, to the BI team. The operations team keeps the whole of their data for audit and operation purposes, having all the necessary backups needed for the business.


#### Exercise

1. **Upload the data to S3**
    1. How to check Amazon S3 metrics:
        1. BucketSizeBytes: [Metrics and dimensions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/metrics-dimensions.html)
        2. S3 Object Access: Logging requests using [server access logging](https://docs.aws.amazon.com/AmazonS3/latest/userguide/ServerLogs.html)
2. **Choose most appropriate format to store the data**
    1. This data is going to be queried to build different reports
        1. Columnar data formats like Parquet and ORC require less storage capacity compared to row-based formats like CSV and JSON. 
        2. [Parquet consumes up to six times](https://docs.aws.amazon.com/redshift/latest/dg/r_UNLOAD.html) less storage in Amazon S3 compared to text formats. This is because of features such as column-wise compression, different encodings, or compression based on data type, as shown in the [Top 10 Performance Tuning Tips for Amazon Athena](https://aws.amazon.com/blogs/big-data/top-10-performance-tuning-tips-for-amazon-athena/) blog post.
        3. You can improve performance and reduce query costs of [Amazon Athena](https://aws.amazon.com/athena/) by [30–90 percent](https://aws.amazon.com/athena/faqs/) by compressing, partitioning, and converting your data into columnar formats. **Using columnar data formats and compressions reduces the amount of data scanned. [Blog](https://aws.amazon.com/blogs/architecture/optimizing-your-aws-infrastructure-for-sustainability-part-ii-storage/)**
    2. Convert data format (Glue)
    3. Check metrics to compare
3. **Choose best lifecycle and best storage tier for this data**
    1. This dataset is obtained once every month and needs only to be used at that point of time. → possibility to change tier
    2. The data needs to be kept for 5 years after that → deletion afterwards 
    3. How to set up a lifecycle configuration rule on Amazon S3
4. **Other factors: analysing backup needs**
    1. Is this data critical? Is it difficult to reproduce?
    2. The owners of the data are already backing up the data which means this is an easy to reproduce dataset, that does not need a back up.


**Click on *Next Step* to continue to the next module.**

{{< prev_next_button link_prev_url="../" link_next_url="../2_configure_env" />}}
