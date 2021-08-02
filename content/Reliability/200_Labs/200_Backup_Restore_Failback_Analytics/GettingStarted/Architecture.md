---
title: "Architecture"
date: 2020-04-28T10:02:27-06:00
weight: 20
---

## Architecture

In this workshop we'll work with a typical Big Data workload with batch and stream processing components.

![Big Data Workload](/images/backup-restore-analytics.png)

### Ingest

Our data source is streaming data coming from external applications.  We present a Global Accelerator endpoint for the producers to send data to.  The endpoint is serviced in a particular region by a Lambda function behind an Application Load Balancer.  The Lambda function relays the data to a Kinesis stream.

### Batch Processing

Once the data lands in a Kinesis stream, the batch processing flow picks up with a Firehose landing the data in S3.  A nightly Glue job performs batch processing.  A Lambda function registers new partitions in the Glue catalog.

### Stream Processing

From the original Kinesis stream, a Kinesis Analytics application performs the stream processing and writes the output into another data stream.  From the second data stream, the data flows to both S3 via Firehose and to DynamoDB via Lambda.

## Disaster Recovery

Looking at our architecture, we have two primary data stores, S3 and the Glue catalog.  For S3, we use cross-region replication to backup data to a DR region.  We use Lambda functions in both regions to keep the partitions up to date, so no replication is required.