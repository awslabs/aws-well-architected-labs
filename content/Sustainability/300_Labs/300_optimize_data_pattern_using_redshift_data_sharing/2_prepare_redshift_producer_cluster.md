---
title: "Prepare Amazon Redshift Producer Cluster"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 3
pre: "<b>2. </b>"
---

# Lab 2

We will first create the producer Amazon Redshift cluster (we will refer this as the **producer** cluster throughout the lab) in `us-east-1` region, and will also load sample dataset which we will use for our sustainability use case.

## Step-1: Create Redshift Producer Cluster

1. [Login into the AWS Console](https://us-east-1.console.aws.amazon.com/redshiftv2/home?region=us-east-1#landing) (make sure _`us-east-1`_ region is selected in top right corner), and click **Create Cluster**.

2. Provide Cluster name as _`redshift-cluster-east`_, and select _ra3.xlplus_ node type -

{{% notice note %}}
**NOTE:** If you get access error launching cluster with _ra3.xlplus_ node type, then select _ra3.4xlarge_ node type. Please note, Amazon Redshift Data Sharing feature is not supported for previous generation _dc2_ node types, and Amazon Redshift only supports data sharing on the _ra3.16xlarge_, _ra3.4xlarge_, and _ra3.xlplus_ instance types for producer and consumer clusters. Amazon Redshift _ra3_ nodes incurs cost as these nodes are not part of the Amazon Redshift free trial, or AWS Free Tier.
{{% /notice %}}

![Create Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-2/images/create_cluster.png?classes=lab_picture_small)

3. Select **“Load Sample data”**.

4. Supply a password for _Admin_ user.

![Sample Data](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-2/images/sample_data.png?classes=lab_picture_small)

Other configuration settings can be left as default.

5. Click the **Create Cluster** button – it will take few minutes to create cluster, and load sample data into database.

## Step-2: Connect to database using query editor

Once the cluster is created (_Status = Available_), using one of the Amazon Redshift query editors is the easiest way to query the Amazon Redshift database. After creating your cluster, use the **query editor v2** to connect to newly created database.

![Query editor](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-2/images/query_editor.png?classes=lab_picture_small)

## Step-3: Validate database
1. In the query editor, click on the newly created cluster, and it will establish connection to the database. You will then see two databases created automatically – _dev_, _sample_data_dev_. The _dev_ database has one schema called _public_, which holds the 7 sample tables loaded during the cluster creation. Expand the _public_ schema under _dev_ database, and you will see list of tables. We will refer to this as **producer** database throughout the lab.

![Query editor 2](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-2/images/query_editor-2.png)

2. These tables were bootstrapped during cluster creation, and can’t be shared using Amazon Redshift Data Sharing feature. For this lab, we will use these bootstrapped tables to create our own tables to test the Amazon Redshift Data Sharing feature. Go to the query editor and execute these SQL commands:


```sql
CREATE TABLE lab_users AS SELECT * FROM users;
CREATE TABLE lab_venue AS SELECT * FROM venue;
CREATE TABLE lab_category AS SELECT * FROM category;
CREATE TABLE lab_date AS SELECT * FROM date;
CREATE TABLE lab_event AS SELECT * FROM event;
CREATE TABLE lab_sales AS SELECT * FROM sales;
CREATE TABLE lab_listing AS SELECT * FROM listing;
```

![Query editor 3](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-2/images/query_editor-3.png?classes=lab_picture_small)

3. Once above `CREATE TABLE` commands are successfully completed, then drop the bootstrapped tables using below SQL commands. This will help with estimating data storage consumed, and comparison between **producer** and **consumer** databases.

```sql
DROP TABLE users;
DROP TABLE venue;
DROP TABLE category;
DROP TABLE date;
DROP TABLE event;
DROP TABLE sales;
DROP TABLE listing;
```

![Query editor 4](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-2/images/query_editor-4.png?classes=lab_picture_small)

So far, we have installed & configured the **producer** cluster, and loaded a sample dataset into the **producer** database in `us-east-1` region. Next, we will install and configure the Amazon Redshift **consumer** cluster in `us-west-1` region.

{{< prev_next_button link_prev_url="../1_understand_data_sharing" link_next_url="../3_prepare_redshift_consumer_cluster" />}}
