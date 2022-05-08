---
title: "Review Sustainability KPI Optimization"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 8
pre: "<b>7. </b>"
---

# Lab 7

With optimization completed in previous steps, let’s follow below steps in **Consumer** cluster to measure the improvement on Sustainability KPI:

1. Connect to **Consumer** cluster in `us-west-1` region, and click/expand on “consumer_marketing”. You can see in the tool tip that it is a datashare which is connected to a **Producer** cluster. All the tables listed below are from **Producer** cluster.

![View Producer Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-7/images/view_producer_cluster2.png?classes=lab_picture_small)

2. Now, let check if Consumer cluster is storing any table locally in the database by running below query:
```
SELECT SUM(size) FROM SVV_TABLE_INFO WHERE "table" NOT LIKE '%auto%';
```

![Tables Size](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-7/images/sum_tables.png?classes=lab_picture_small)

Above query did not return any table size, which means that **Consumer** database does not have any table locally, hence not consuming any data storage to store the tables.

With, that below are revised (improved) metrics and KPI:
* Data storage
    * total data storage consumed (provisioned) by two clusters (Producer and Consumer) = 640+0 = 640MB
    * per event data storage = 640MB / 8798 events = 0.07MB
* Data transfer
    * total data transfer over network = per use case, and amount of data processed by queries executed in Consumer cluster
    * per event daily data transfer = total data processed by query / 8798 events

**For per event data storage Sustainability KPI, we see there is 50% reduction (improvement) by using the Redshift Data Sharing feature.**

For per event data transfer KPI, trade-off analysis should be performed comparing daily refresh data transfer vs. all queries execution dataset transfer over network. One option is to analyze data transfer between regions is using AWS Cost Explorer. [Refer to this](https://aws.amazon.com/blogs/mt/using-aws-cost-explorer-to-analyze-data-transfer-costs/) Blog explaining how to use AWS Cost Explorer to analyze data transfer volume and cost.

With above comparison of baseline & revised metrics and KPI, we tested how Redshift Data Sharing feature helped to improve Sustainability KPI for AnyCompany's Marketing data warehouse environment. Next, we will cleanup the AWS resources created to make sure no further cost incurred.

{{< prev_next_button link_prev_url="../6_consumer_validation" link_next_url="../cleanup" />}}
