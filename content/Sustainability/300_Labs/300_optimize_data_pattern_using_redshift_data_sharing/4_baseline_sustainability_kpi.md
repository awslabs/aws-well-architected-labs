---
title: "Baseline Sustainability KPI"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 5
pre: "<b>4. </b>"
---

# Lab 4

Let’s baseline the metrics which we can use to measure sustainability improvement once workload optimization is completed. 

Connect to _Producer_ cluster (**dev** database, _public_ schema) in east region, and follow below steps.

## Step-1: Proxy metrics
For this lab, we will use below proxy metrics (provisioned resources):

**Total data storage used for storing all tables:**
```
SELECT SUM(size) FROM SVV_TABLE_INFO WHERE "table" NOT LIKE '%auto%';
```

![Data Storage Used](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-4/images/data_storage_used.png?classes=lab_picture_small)

Above query will return data storage size (in MB) of all tables provisioned for all events (business outcome) held (stored in lab_event table). Data storage consumed in _Producer_ Redshift cluster = 1252MB.

We will assume that _Consumer_ Redshift cluster had same amount of storage consumed in current deployment, as it was built, and being refreshed from _Producer_ periodically. With that assumption, running above query against _Consumer_ cluster will provide similar result for data storage size (in MB).

So, total data storage consumed (provisioned) by two clusters (_Producer_ and _Consumer_) = 1252+1252 = 2504MB

**Total data transfer over network to nightly refresh _Consumer_ cluster in west region from _Producer_ cluster in east region:**

Assuming 10% daily data change rate in _Producer_ cluster, Data transfer over network (every night) = 125MB (10% of 1252MB - _Producer_ cluster storage)

## Step-2: Business metrics

Let’s now find out number of events for those above proxy metrics are consumed. These events are business metric.

```
SELECT COUNT(*) FROM lab_event;
```
![Number of Events](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-4/images/events_count.png?classes=lab_picture_small)

Above query will return number of events held by organization = 8798. This will be the business metric we will be using for Sustainability KPI.

## Step-3: Sustainability KPI Baseline

Let’s baseline the KPI:
* per event data storage = 2504MB / 8798 events = 0.28MB
* per event daily data transfer = 125MB / 8798 events = 0.1MB

Our improvement goal is to reduce per event provisioned resources, and in this case:
* per event total storage used
* per event data transfer over network

Now, let’s start optimizing this workload by implementing WA Sustainability Pillar best practices for Data Pattern, and Redshift Data Sharing feature. Our objective is to reduce the per event data storage, and data transfer between east & west region.


{{< prev_next_button link_prev_url="../3_prepare_redshift_consumer_cluster" link_next_url="../5_enable_data_sharing" />}}
