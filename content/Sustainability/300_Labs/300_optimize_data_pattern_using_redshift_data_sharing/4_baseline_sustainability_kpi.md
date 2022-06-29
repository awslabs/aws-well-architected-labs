---
title: "Baseline Sustainability KPI"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 5
pre: "<b>4. </b>"
---

# Lab 4

Recall, our sustainability improvement goal is:
- To eliminate waste, low utilization, and idle or unused resources.
- To maximize the value from resources you consume.

Let’s baseline the metrics which we can use to measure sustainability improvement once workload optimization is completed - in this case, AWS resources provisioned (storage, network traffic) to support the business outcome (number of events).

**Connect to _producer_ cluster** (_dev_ database, _public_ schema) in `us-east-1` region, and follow below steps.

## Step-1: Proxy metrics

Let's baseline below proxy metrics (provisioned resources) by executing the following SQL query in **producer** database:

1. **Total data storage used for storing all tables:**

```sql
SELECT SUM(size) FROM SVV_TABLE_INFO WHERE "table" NOT LIKE '%auto%';
```

![Data Storage Used](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-4/images/data_storage_used.png?classes=lab_picture_small)

Above query will return data storage size (in MB) of all tables provisioned for all business events (business outcome) held by AnyCompany (stored in lab_event table). Data storage consumed in **producer** cluster = 640MB.

{{% notice note %}}
**Note** - if you had selected _ra3.4xlarge_ node type for Producer cluster creation in Lab-2, then you will receive 1252MB as output from above query. Please adjust rest of the lab steps accordingly for calculation
{{% /notice %}}

We will assume that the **consumer** cluster had the same amount of storage consumed in the current deployment, as it was built, and being refreshed from the **producer** cluster periodically. With that assumption, running the above query against the **consumer** cluster will provide similar result for data storage size (in MB).

So, total data storage consumed (provisioned) by two clusters (**producer** and **consumer**) = 640+640 = 1280MB

2. **Total data transfer over network to nightly refresh _consumer_ cluster in `us-west-1` region from _producer_ cluster in `us-east-1` region:**

Assuming 10% daily data change rate in _Producer_ cluster, Data transfer over network (every night) = 64MB (10% of 640MB - _Producer_ cluster storage)

## Step-2: Business metrics

Let’s now find out number of marketing events held by AnyCompany. The above proxy metrics (resources consumed) are consumed for those events. These events are business metrics, and we can find this out by running SQL query in **producer** database:

```sql
SELECT COUNT(*) FROM lab_event;
```
![Number of Events](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-4/images/events_count.png?classes=lab_picture_small)

Above query will return the number of events held by AnyCompany = 8798. This will be the business metric we will be using for our sustainability KPI.

## Step-3: Sustainability KPI Baseline

Let’s baseline the KPI:
* per event data storage = 1280MB / 8798 events = 0.14MB
* per event daily data transfer = 64MB / 8798 events = 0.007MB

Our improvement goal is to reduce per event provisioned resources, and in this case:
* per event total storage used
* per event data transfer over network

Now, let’s start optimizing this workload by implementing Well-Architected Sustainability Pillar best practices for Data Pattern, and Amazon Redshift Data Sharing feature. Our objective is to reduce the per event data storage, and data transfer between `us-east-1` & `us-west-1` region.

{{< prev_next_button link_prev_url="../3_prepare_redshift_consumer_cluster" link_next_url="../5_enable_data_sharing" />}}
