---
title: "Enable Redshift Data Sharing"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 6
pre: "<b>5. </b>"
---

# Lab 5

The _Producer_ cluster administrator, who wants to share data, first sets up the _Producer_ cluster for data sharing by running below commands in query editor:

## Step-1: Create a _datashare_ in Redshift Producer Cluster
Make sure you are connected to Redshift _Producer_ cluster as _Admin_ in _`us-east-1`_ region, and then go to query editor to run below command:

```
CREATE DATASHARE MarketingShare;
```
![Create Datashare](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-5/images/create_marketingshare.png?classes=lab_picture_small)

## Step-2: Add database objects to the _datashare_
_Producer_ cluster administrator then adds the needed database objects. These might be schemas, tables, and views to the _datashare_ and specifies a list of consumers that the objects to be shared with:
```
ALTER DATASHARE MarketingShare ADD SCHEMA public;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_users;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_venue;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_category;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_date;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_event;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_sales;
ALTER DATASHARE MarketingShare ADD TABLE public.lab_listing;
```

## Step-3: Grant access on _datashare_ to Redshift Consumer Cluster
1. Go to **_Consumer_** cluster and note down cluster namespace from Redshift cluster details page:
![Cluster namespace](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-5/images/consumer_query_editor.png?classes=lab_picture_small)

2. Go to **_Producer_** cluster and, then grants access on datashare to the Consumer cluster namespace (noted from previous step) :
```
GRANT USAGE ON DATASHARE MarketingShare TO NAMESPACE 'replace-with-your-consumer-cluster-namespace';
```

![Grant Namespace](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-5/images/grant_namespace.png?classes=lab_picture_small)

## Step-4: Data dictionary validation
Let’s validate the steps performed in above steps by querying data dictionary of **_Producer_** cluster:

1. Run below SQL query to find _MarketShare_ datashare type:
```
SELECT * FROM svv_datashares;
```

![Grant Namespace](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-5/images/query_svv_datashare.png?classes=lab_picture_small)


You can see _MarketShare_ is an OUTBOUND _datashare_ type.

2. Run below SQL query to list objects and types:
```
SELECT * FROM svv_datashare_objects;
```

![Grant Namespace](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-5/images/query_svv_objects.png?classes=lab_picture_small)

You can see list of objects and types (schema, table etc.) shared, and all of them are as OUTBOUND share type.

3. Run below query to verify which cluster namespace has been granted access for datashare:
```
SELECT * FROM svv_datashare_consumers;
```

![Grant Namespace](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-5/images/query_svv_consumers.png?classes=lab_picture_small)

You can see which namespace(s), or clusters have been granted access to the data shares.


We have now granted access on Producer cluster data share to the Consumer cluster. Next, let's validate if Consumer cluster can access this data share.

{{< prev_next_button link_prev_url="../4_baseline_sustainability_kpi" link_next_url="../6_consumer_validation" />}}
