---
title: "Failback"
date: 2020-07-29T13:22:15-06:00
weight: 45
chapter: true
pre: "<b>4. </b>"
---

### Failback

In this chapter, we'll see how to move the workload back to the primary region when the primary region is functional again.

We have three things to consider:

* We have data in the S3 bucket in the backup region that is not in the primary region.
* We have infrastructure deployed in the backup region that we don't want to live permanently.
* Our incoming traffic is still going to the backup region.

We'll tackle these one at a time.
