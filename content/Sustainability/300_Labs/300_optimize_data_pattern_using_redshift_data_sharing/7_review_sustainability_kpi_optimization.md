---
title: "Review Sustainability KPI Optimization"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 8
pre: "<b>7. </b>"
---

# Lab 7

With optimization completed in the previous lab, let’s follow below steps on the **consumer** cluster to measure the improvement on our sustainability KPI:

1. Connect to the **consumer** cluster in `us-west-1` region, and click/expand on “consumer_marketing”. You can see in the tool tip that it is a datashare which is connected to a **producer** cluster. All the tables listed below are from **producer** cluster.

![View Producer Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-7/images/view_producer_cluster2.png?classes=lab_picture_small)

2. Now, let check if the **consumer** cluster is storing any tables locally in the database by running below query:

```sql
SELECT SUM(size) FROM SVV_TABLE_INFO WHERE "table" NOT LIKE '%auto%';
```

![Tables Size](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-7/images/sum_tables.png?classes=lab_picture_small)

The above query did not return any table size, which means that the **consumer** database does not have any tables locally, hence not consuming any data storage to store the tables.

With, that below are revised (improved) metrics and KPI:
* Data storage
    * Total data storage consumed (provisioned) by two clusters (**producer** and **consumer**) = 640+0 = 640MB
    * Per event data storage = 640MB / 8798 events = 0.07MB
* Data transfer
    * Total data transfer over network = per use case, and amount of data processed by queries executed in Consumer cluster
    * Per event daily data transfer = total data processed by query / 8798 events

**For per event data storage sustainability KPI, we see there is 50% reduction (improvement) by using the Amazon Redshift Data Sharing feature.**

For per event data transfer KPI, trade-off analysis should be performed comparing daily refresh data transfer vs. all queries execution dataset transfer over network. One option is to analyze data transfer between regions is using AWS Cost Explorer. [Refer to this AWS blog post](https://aws.amazon.com/blogs/mt/using-aws-cost-explorer-to-analyze-data-transfer-costs/) explaining how to use AWS Cost Explorer to analyze data transfer volume and cost.

With the above comparison of the baseline & revised metrics and KPI, we tested how the Amazon Redshift Data Sharing feature helped to improve our sustainability KPI for AnyCompany's Marketing data warehouse environment.

Next, we will cleanup the AWS resources created to make sure no further costs are incurred.

{{< prev_next_button link_prev_url="../6_consumer_validation" link_next_url="../cleanup" />}}
