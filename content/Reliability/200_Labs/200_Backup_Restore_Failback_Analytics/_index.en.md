+++
title = "Level 200: Backup and Restore with Failback for Analytics Workload"
menutitle = "Backup and Restore for Analytics Workload"
description = "Implement the backup and restore DR pattern with failback capability for an analytics workload"
date = 2021-05-06T09:52:56-04:00
weight = 5
chapter = false
hidden = false
pre = ""
+++

In this module, you will go through the Backup and Restore DR strategy for an analytics workload. To learn more about this DR strategy, you can review this [Disaster Recovery blog](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-ii-backup-and-restore-with-rapid-recovery/).

The workload includes streaming ingest and batch processing.

![Big Data Workload](/Reliability/200_Backup_Restore_Failback_Analytics/Images/backup-restore-analytics-workshop.png)

In a nutshell, there are three primary data stores, S3, DynamoDB, and the Glue catalog.  The Glue catalog only receives new partitions as updates, and we use a Lambda function to create those when new partitions land in S3.  One S3 bucket is receiving streaming data, and another is receiving the output of a nightly batch processing job.  Both buckets use S3 CRR to replicate to the backup region.  We use DynamoDB point-in-time-recovery (PITR) to handle the database.

In terms of RTO, the failover process involves detecting the failure, deploying the rest of the infrastructure in the backup region, and switching the Global Accelerator endpoint for data producers.  That entire process can be done in as little as 10 minutes once you make the decision to fail over.

For RPO, you will lose whatever data your producers were trying to send to the endpoint from the time it became unhealthy to the time the failover completed.  You may also lose some data in the original region that was not successfully replicated.  

To configure the infrastructure and deploy the application, we will use CloudFormation. CloudFormation is an easy way to speed up cloud provisioning with infrastructure as code.

This workshop takes about two hours to complete. Prior experience with the AWS Console and Linux command line are helpful but not required.  You should also have basic familiarity with batch and stream processing architectures on AWS.

## Steps:
{{% children /%}}
