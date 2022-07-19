---
title: "Prepare Amazon Redshift Consumer Cluster"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 4
pre: "<b>3. </b>"
---

# Lab 3

Now, let’s create the **consumer** Amazon Redshift cluster (we will refer this as **consumer** cluster throughout the lab) in `us-west-1` region, and remember, **we will not load the sample dataset** in this cluster.

## Step-1: Create Redshift Consumer Cluster

1. [Login into AWS Console](https://us-west-1.console.aws.amazon.com/redshiftv2/home?region=us-west-1#landing) (make sure _`us-west-1`_ region is selected in top right corner), and click **Create Cluster**.

2. Provide Cluster name as _`redshift-cluster-west`_, and select _ra3.xlplus_ node type.

{{% notice note %}}
**NOTE:** If you get access error launching cluster with _ra3.xlplus_ node type, then select _ra3.4xlarge_ node type. Please note, Amazon Redshift Data Sharing feature is not supported for previous generation _dc2_ node types, and Amazon Redshift only supports data sharing on the _ra3.16xlarge_, _ra3.4xlarge_, and _ra3.xlplus_ instance types for producer and consumer clusters. Amazon Redshift _ra3_ nodes incurs cost as these nodes are not part of the Amazon Redshift free trial, or AWS Free Tier.
{{% /notice %}}

![Create Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-3/images/create_cluster.png?classes=lab_picture_small)

3. **Do not** select _“Load Sample data”_.

4. Supply a password for _Admin_ user.

![Sample data](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-3/images/sample_data.png?classes=lab_picture_small)
Other configuration settings can be left as default.

5. Click the **Create Cluster** button – it will take few minutes to create the cluster.

## Step-2: Connect to database using query editor

Once the cluster is created (_Status = Available_), using one of the Amazon Redshift query editors is the easiest way to query the Amazon Redshift database. After creating your cluster, use the **query editor v2** to connect to newly created database.

![Query editor](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-3/images/query_editor.png?classes=lab_picture_small)

## Step-3: Validate database
In the query editor, click on the newly created cluster, and it will establish connection to the database. You will then see two databases created automatically – **dev, sample_data_dev**. The **dev** database has one schema called _public_, which will not have any tables as we did not select _“Load Sample Data”_ during cluster creation, unlike **produce** cluster in `us-east-1` region. We will refer this as **consumer** database throughout the lab. Expand the _public_ schema under **dev** database:

![Query editor 2](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/lab-3/images/query_editor-2.png)

We now have both **producer** and **consumer** clusters installed, configured, and loaded sample dataset in Producer database. Next, we will baseline existing metrics and KPIs.

{{< prev_next_button link_prev_url="../2_prepare_redshift_producer_cluster" link_next_url="../4_baseline_sustainability_kpi" />}}
