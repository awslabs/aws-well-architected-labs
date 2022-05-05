---
title: "Prepare Redshift Producer Cluster"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 3
pre: "<b>2. </b>"
---

# Lab 2

We will first create Producer Redshift cluster (we will refer this as Producer cluster throughout the lab) in us-east-1 region, and will also load sample dataset which we will use for our Sustainability use case.

## Step-1: Create Redshift Producer Cluster

1. [Login into AWS Console](https://us-east-1.console.aws.amazon.com/redshiftv2/home?region=us-east-1#landing) (make sure _us-east-1_ region is selected in top right corner), and click **Create Cluster**.

2. Provide Cluster name as _redshift-cluster-east_, and select _ra3.4xlarge_ node type. Please note, Redshift Data Sharing feature is not supported for previous generation _dc2_ node types, and Amazon Redshift only supports data sharing on the ra3.16xlarge, ra3.4xlarge, and ra3.xlplus instance types for producer and consumer clusters. Redshift ra3 nodes incurs cost as these nodes are not part of Redshift free trial, or AWS Free Tier.

![Create Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-2/images/create_cluster.png?classes=lab_picture_small)

3. Select **“Load Sample data”**, and supply password for _Admin_ user. Click _Create Cluster_ button – it will take few minutes to create cluster, and load sample data into database.

![Create Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-2/images/sample_data.png?classes=lab_picture_small)

Other configuration settings can be left as default.

## Step-2: Connect to database using query editor

Once cluster is created (_Status = Available_), using one of the Amazon Redshift query editors is the easiest way to query Redshift database. After creating your cluster, use the **query editor v2** to connect to newly created database.

![Create Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-2/images/query_editor.png?classes=lab_picture_small)

## Step-3: Validate database
1. In query editor, click on newly created cluster, and it will establish connection to the database. You will then see two databases created automatically – _dev_, _sample_data_dev_. The _dev_ database has one schema called _public_, which holds the 7 sample tables loaded during the cluster creation. Expand the _public_ schema under _dev_ database, and you will see list of tables. We will refer this as Producer database throughout the lab.

![Create Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-2/images/query_editor-2.png?classes=lab_picture_small)

2. These tables were bootstrapped during cluster creation, and can’t be shared using Redshift Data Sharing feature. For this lab, we will use these bootstrapped tables to create our own tables to test Redshift Data Sharing feature. Go to the query editor and execute these SQL commands:


```sql
CREATE TABLE lab_users AS SELECT * FROM users;
CREATE TABLE lab_venue AS SELECT * FROM venue;
CREATE TABLE lab_category AS SELECT * FROM category;
CREATE TABLE lab_date AS SELECT * FROM date;
CREATE TABLE lab_event AS SELECT * FROM event;
CREATE TABLE lab_sales AS SELECT * FROM sales;
CREATE TABLE lab_listing AS SELECT * FROM listing;
```

![Create Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-2/images/query_editor-3.png?classes=lab_picture_small)

3. And then, drop the bootstrapped tables using below SQL commands. This will help with estimating data storage consumed, and comparison between Producer and Consumer databases.

```sql
DROP TABLE users;
DROP TABLE venue;
DROP TABLE category;
DROP TABLE date;
DROP TABLE event;
DROP TABLE sales;
DROP TABLE listing;
```

![Create Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-2/images/query_editor-4.png?classes=lab_picture_small)

So far, we have installed & configured Producer cluster, and loaded sample dataset in Producer database in us-east-1 region. Next, we will install and configure Redshift Consumer cluster in us-west-1 region.

{{< prev_next_button link_prev_url="../1_understand_data_sharing" link_next_url="../3_prepare_redshift_consumer_cluster" />}}
