---
title: "Prepare Redshift Consumer Cluster"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 4
pre: "<b>3. </b>"
---

# Lab 3

Now, let’s create Consumer Redshift cluster (we will refer this as Consumer cluster throughout the lab) in us-west-1 region, and remember, **we will not load sample dataset** in this cluster. 

## Step-1: Create Redshift Consumer Cluster

[Login into AWS Console](https://us-west-1.console.aws.amazon.com/redshiftv2/home?region=us-west-1#landing) (make sure _us-west-1_ region is selected in top right corner), and click **Create Cluster**..

Provide Cluster name as _redshift-cluster-west_, and select _ra3.4xlarge_ node type. Please note, Redshift Data Sharing feature is not supported for previous generation _dc2_ node types, and Amazon Redshift only supports data sharing on the ra3.16xlarge, ra3.4xlarge, and ra3.xlplus instance types for producer and consumer clusters. Redshift ra3 nodes incurs cost as these nodes are not part of Redshift free trial, or AWS Free Tier.types.

![Create Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-3/images/create_cluster.png?classes=lab_picture_small)

**Do not** select _“Load Sample data”_. Supply password for _Admin_ user. Click **Create Cluster** button – it will take few minutes to create cluster.

![Create Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-3/images/sample_data.png?classes=lab_picture_small)


## Step-2: Connect to database using query editor

Once cluster is created (_Status = Available_), using one of the Amazon Redshift query editors is the easiest way to query Redshift database. After creating your cluster, use the **query editor v2** to connect to newly created database.

![Create Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-3/images/query_editor.png?classes=lab_picture_small)

## Step-3: Validate database
In query editor, click on newly created cluster, and it will establish connection to the database. You will then see two databases created automatically – **dev, sample_data_dev**. The **dev** database has one schema called _public_, which will not have any tables as we did not select _“Load Sample Data”_ during cluster creation, unlike _Producer_ cluster in east region. We will refer this Consumer database throughout the lab. Expand the _public_ schema under **dev** database:

![Create Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-3/images/query_editor-2.png?classes=lab_picture_small)

We now have both Producer and Consumer clusters installed, configured, and loaded sample dataset in Producer database. Next, we will baseline existing metrics and KPIs.

{{< prev_next_button link_prev_url="../2_prepare_redshift_producer_cluster" link_next_url="../4_baseline_sustainability_kpi" />}}
