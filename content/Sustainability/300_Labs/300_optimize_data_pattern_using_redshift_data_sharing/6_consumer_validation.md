---
title: "Redshift Consumer Cluster Validation"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 7
pre: "<b>6. </b>"
---

# Lab 6

Connect to Consumer cluster in us-west-1 region to perform below steps:

## Step-1: Validate _datashare_ is accessible

```
SELECT * FROM svv_datashares;
```

![svv_datashare](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-6/images/query_svv_datashare.png?classes=lab_picture_small)

You can see MarketShare is an INBOUND type data share type.

```
SELECT * FROM svv_datashare_objects;
```
![svv_objects](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-6/images/query_svv_objects.png?classes=lab_picture_small)

You can see list of objects and types (schema, table etc.) shared, and all of them are as INBOUND share type.

## Step-2: Create database using _datashare_

To consume shared data, each Consumer cluster administrator creates an Amazon Redshift database from the datashare:
```
CREATE DATABASE consumer_marketing FROM DATASHARE MarketingShare of NAMESPACE <<producer_redshift_cluster_namespace>>;
```

## Step-3: Optionally, grant permissions
The Consumer cluster administrator then assigns permissions to appropriate users and groups in the Consumer cluster:
```
GRANT USAGE ON DATABASE consumer_marketing TO <<user_or_group>>;
```
![Grant Usage](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-6/images/grant_access.png?classes=lab_picture_small)


## Step-4: Validate access to database and objects
Users and groups can list the shared objects as part of the standard metadata queries by viewing the following metadata system views and can start querying data immediately:
```
SELECT * FROM SVV_REDSHIFT_DATABASES;
```
![svv_database](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-6/images/svv_database.png?classes=lab_picture_small)

You can see the database type is “shared” for the “consumer_marketing” database.
```
SELECT * FROM SVV_REDSHIFT_SCHEMAS WHERE database_name = ‘consumer_marketing’;
```

![svv_schema](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-6/images/svv_schema.png?classes=lab_picture_small)

You can see the schema type is “shared” for the schemas shared via the  “consumer_marketing” database.
```
SELECT * FROM SVV_REDSHIFT_TABLES WHERE database_name = ‘consumer_marketing’;
```

![svv_table](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-6/images/svv_table.png?classes=lab_picture_small)

## Step-5: Run queries
You can now run queries on the data in Producer cluster, without having data stored locally. You can also run queries by joining tables from your local database, and tables shared from Producer cluster.
```
SELECT COUNT(*) FROM consumer_marketing.public.lab_event;
```
![Query LabEvent](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-6/images/query_labevent.png?classes=lab_picture_small)

Above query, fetches the total events from lab_event table stored in Producer cluster in us-east-1 region via the datashare created earlier. The table is not stored locally in Consumer cluster in us-west-1 region, so it reduced the data storage by half. You can also join Consumer cluster locally stored tables with Producer cluster shared tables in SQL queries.

One key consideration is to note here is that, during the query execution, it did transfer the query processed result dataset over network, but limited to the result set (whereas current deployment transfer 10% data every night part of refresh cycle). Depending on use case, trade-off analysis should be performed comparing daily refresh data transfer vs. all queries execution dataset transfer over network.

We have now validated that Consumer cluster can access the data shared by Producer cluster, and ran queries against Producer database. Next, we will revist metrics and KPIs to measure the Sustainability optimization achieved by implementing Redshift Data Sharing feature.

{{< prev_next_button link_prev_url="../5_enable_data_sharing" link_next_url="../7_review_sustainability_kpi_optimization" />}}
