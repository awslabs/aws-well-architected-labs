---
title: "Cleanup"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 9
---

To avoid incurring further costs for AWS resources, let’s delete the Amazon Redshift clusters in both regions. Login to AWS console, and go to the [Amazon Redshift service](https://us-east-1.console.aws.amazon.com/redshiftv2/home). Then follow the below steps in each region to delete **producer** (`us-east-1` region) and **consumer** (`us-west-1` region) clusters:

1. Select the cluster in respective region, and select _Delete_ from _Actions_ menu:

![Delete Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/cleanup/images/delete_cluster.png?classes=lab_picture_small)


2. To confirm deletion, type in “delete” in the field at the bottom (make sure, you **do not** check _Create final snapshot_ button as it will incur cost for the storage of the snapshot), and click **Delete cluster**.

![Confirm Delete](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/cleanup/images/confirm_delete.png?classes=lab_picture_small)


3. Follow above steps for the cluster in the other region as well. Ensure you have deleted clusters in both `us-east-1` and `us-west-1` or whichever two regions you chose to complete this lab.

{{< prev_next_button link_prev_url="../7_review_sustainability_kpi_optimization"  title="Congratulations!" final_step="true" >}}
You should now have a firm understanding of how to use proxy metric, business metric, and sustainability KPI with AWS Services like Amazon Redshift Data Sharing for optimizing workload data patterns for environmental sustainability improvements.
{{< /prev_next_button >}}
