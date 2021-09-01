---
title: "Architecture"
date: 2020-04-28T10:02:27-06:00
weight: 20
---

## Architecture

In this workshop we'll work with a typical Big Data workload with streaming ingest and batch processing.

![Big Data Workload](/Reliability/200_Backup_Restore_Failback_Analytics/Images/backup-restore-analytics-workshop.png)

### Ingest

Our data source is streaming data coming from external applications.  We present a Global Accelerator endpoint for the producers to send data to.  The endpoint is serviced in a particular region by a Lambda function behind an Application Load Balancer.  The Lambda function relays the data to a Kinesis stream.

### Batch Processing

Once the data lands in a Kinesis stream, the batch processing flow picks up with a Firehose landing the data in S3.  A nightly Glue job performs batch processing.  A Lambda function registers new partitions in the Glue catalog.

## Disaster Recovery

Looking at our architecture, we have three primary data stores, S3, DynamoDB, and the Glue catalog.  For S3, we use cross-region replication to backup data to a DR region.  For DynamodB, we use the point-in-time-recovery (PITR) feature of DynamoDB, and AWS Backup for taking an hourly backup. 

For the Glue catalog, we use a Lambda function to register new partitions in the Glue catalog.  The function triggers when objects are created in S3.  It looks at the object prefix to understand the partition structure, and creates a new partition in the Glue catalog if necessary.  Because the function is running in the primary region and the backup region, we do not need to take extra steps to replicate the Glue catalog.  The function in the backup region will create new partitions as S3 cross-region replication copies objects into the bucket in the backup region.

![Failover Strategy](/Reliability/200_Backup_Restore_Failback_Analytics/Images/backup-restore-workshop.png)

{{< prev_next_button link_prev_url="../account" link_next_url="../../settingup" />}}