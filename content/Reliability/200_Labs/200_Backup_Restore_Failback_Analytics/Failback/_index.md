---
title: "Failback"
date: 2020-07-29T13:22:15-06:00
weight: 45
chapter: true
pre: "<b>4. </b>"
---

### Failback

In this chapter, we'll see how to move the workload back to the primary region when the primary region is functional again.

We have four things to consider:

* We have data in a DynamoDB table in the backup region that is not in the primary region.
* Our incoming traffic is still going to the backup region.
* We have data in the S3 bucket in the backup region that is not in the primary region.
* We have infrastructure deployed in the backup region that we don't want to live permanently.

We'll tackle these one at a time.  We'll start by restoring the DynamoDB table from the backup region to the primary region, as that requires deleting and recreating the table.  Then we'll switch the endpoint to redirect traffic to the primary region, and take care of any data in S3.

{{< prev_next_button link_prev_url="../" link_next_url="recreatedynamodb" />}}