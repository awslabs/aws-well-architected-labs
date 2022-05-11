---
title: "Enable Amazon Redshift Data Sharing"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 6
pre: "<b>5. </b>"
---

# Lab 5

The **producer** cluster administrator, who wants to share data, first sets up the **producer** cluster for data sharing by running the below commands in the query editor:

## Step-1: Create a _datashare_ on the producer cluster
Make sure you are connected to the **producer** cluster as _Admin_ in _`us-east-1`_ region. Then go to query editor to run below command:

```sql
CREATE DATASHARE MarketingShare;
```
![Create Datashare](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-5/images/create_marketingshare.png?classes=lab_picture_small)

## Step-2: Add database objects to the _datashare_
The **producer** cluster administrator then adds the needed database objects. These might be schemas, tables, and views to the _datashare_ and specifies a list of consumers that the objects to be shared with:

```sql
ALTER DATASHARE MarketingShare ADD SCHEMA public;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_users;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_venue;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_category;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_date;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_event;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_sales;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_listing;
```

## Step-3: Grant access on _datashare_ to the consumer cluster
1. Go to the **consumer** cluster in `us-west-1` and note down the cluster namespace from the Amazon Redshift cluster details page:
![Cluster namespace](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-5/images/consumer_query_editor.png?classes=lab_picture_small)

2. Go to **producer** cluster in `us-east-1` and grant access on datashare to the Consumer cluster namespace (noted from previous step) :

```sql
GRANT USAGE ON DATASHARE MarketingShare TO NAMESPACE 'replace-with-your-consumer-cluster-namespace';
```

![Grant Namespace](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-5/images/grant_namespace.png?classes=lab_picture_small)

## Step-4: Data dictionary validation
Let’s validate the steps performed in above steps by querying data dictionary of **producer** cluster:

1. Run below SQL query to find _MarketingShare_ datashare type:

```sql
SELECT * FROM svv_datashares;
```

![Query datashare](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-5/images/query_svv_datashare.png?classes=lab_picture_small)


You can see _MarketingShare_ is an OUTBOUND _datashare_ type.

2. Run the below SQL query to list objects and types:

```sql
SELECT * FROM svv_datashare_objects;
```

![Query datashare 2](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-5/images/query_svv_objects.png?classes=lab_picture_small)

You can see list of objects and types (schema, table etc.) shared, and all of them are as OUTBOUND share type.

3. Run below query to verify which cluster namespace has been granted access for datashare:

```sql
SELECT * FROM svv_datashare_consumers;
```

![Query datashare 3](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-5/images/query_svv_consumers.png?classes=lab_picture_small)

You can see which namespace(s), or clusters have been granted access to the data shares.


We have now granted access on the **producer** cluster data share to the **consumer** cluster. Next, let's validate if the **consumer** cluster can access this data share.

{{< prev_next_button link_prev_url="../4_baseline_sustainability_kpi" link_next_url="../6_consumer_validation" />}}
