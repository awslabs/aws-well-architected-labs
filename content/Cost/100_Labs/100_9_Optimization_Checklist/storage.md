---
title: " Storage Checklist "
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
 
# Storage Checklist
 
### Amazon S3
* Include reviews of [Amazon S3 analytics](https://docs.aws.amazon.com/AmazonS3/latest/userguide/analytics-storage-class.html) – Storage class analysis to analyse storage patterns and idle data to make right storage class decisions or remove data from S3.
* Enable [Amazon S3 Storage Lens](https://aws.amazon.com/blogs/aws/s3-storage-lens/) for your organization 
* Ensure all S3 Buckets have [lifecycle policies](https://docs.aws.amazon.com/AmazonS3/latest/userguide/
 

### Amazon EBS
* Restrict EBS volumes to [latest volumes types](https://wellarchitectedlabs.com/cost/200_labs/200_2_cost_and_usage_governance/5_ec2_volume_type/) (gp3, io2, st1, sc1) Use Service Control Policies to apply this across your account
* Ensure you have an [EBS snapshot policy](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/snapshot-lifecycle.html) in place. We recommend you use AWS Backup to uniformly set the policy, and to restrict snapshots to be less than 45 days old. However this should be aligned to your business SLAs and backup policies to prevent unnecessary copies of data but stops data being accidentally deleted.
* Have controls or reviews of EC2 AMI retention to determine if you have any AMI no longer in use.
object-lifecycle-mgmt.html) in place. Not sure what the policy should be? Use S3 Intelligent Tiering

 
### Amazon EFS
* Ensure that EFS has a [lifecycle policy](https://docs.aws.amazon.com/efs/latest/ug/lifecycle-management-efs.html) in place

