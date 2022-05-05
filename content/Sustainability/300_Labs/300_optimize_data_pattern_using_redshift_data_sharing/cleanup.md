---
title: "Cleanup"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 9
---

To avoid incurring further cost for AWS resources, let’s delete the Redshift clusters in both regions. Login to AWS console, and go to Redshift service. Then follow the below steps in each region to delete Producer (us-east-1 region) and Consumer (us-west-1 region) clusters:

Select the cluster in respective region, and select _Delete_ from _Actions_ menu:

![Delete Cluster](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/cleanup/images/delete_cluster.png?classes=lab_picture_small)


To confirm deletion, type in “delete” in the field at the bottom (make sure, you do not check _Create final snapshot_ button as it will incur cost), and click **Delete cluster**.

![Confirm Delete](/Sustainability/300_optimize_data_pattern_using_redshift_data_sharing/cleanup/images/confirm_delete.png?classes=lab_picture_small)


Follow above step for cluster in other region as well.

{{< prev_next_button link_prev_url="../7_review_sustainability_kpi_optimization"  title="Congratulations!" final_step="true" >}}
You should now have a firm understanding of how to use proxy metric, business metric, and sustainability KPI with AWS Services like Redshift Data Sharing for optimizing workload data patterns for environmental sustainability improvements.
{{< /prev_next_button >}}

