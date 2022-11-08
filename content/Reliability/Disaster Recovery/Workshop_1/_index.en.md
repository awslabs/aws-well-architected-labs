+++
title = "Module 1: Backup and Restore"
date = 2021-05-06T09:52:56-04:00
weight = 110
chapter = false
pre = ""
+++

In this module, you will go through the Backup and Restore disaster recovery strategy. To learn more about this disaster recovery strategy, you can review this [Disaster Recovery blog](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-ii-backup-and-restore-with-rapid-recovery/).

Backup and Restore disaster recovery strategy has [Recovery Point Objective(RPO) / Recovery Time Objective (RTO)](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html) within _hours_. For the backup and restore strategy secondary region, all data, infrastructure and services need to be provisioned.

Our application is currently deployed in our primary region **N. Virginia (us-east-1)** and we will use **N. California (us-west-1)** as our secondary region.

Our test application is Unishop. It is a Spring Boot Java application deployed on a single [Amazon Elastic Compute Cloud (EC2)](https://aws.amazon.com/ec2) instance using a public subnet.  Our datastore is an [Amazon RDS](https://aws.amazon.com/rds/) MySQL database with a frontend written using bootstrap and hosted in [Amazon Simple Storage Service (S3)](https://aws.amazon.com/pm/serv-s3).  

This module takes advantage of [AWS Backup](https://aws.amazon.com/backup/) which will be our single pane of glass to backup, copy and restore our Amazon EC2 instance and Amazon RDS database to the secondary region.

We will use [Amazon S3 Cross-Region Replication (CRR)](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html#crr-scenario) to replicate our S3 objects to the secondary region.

[CloudFormation](https://aws.amazon.com/cloudformation/) will be used to configure the infrastructure and deploy the application. Provisioning your infrastructure with infrastructure as code (IaC) methodologies is a best practice. CloudFormation is an easy way to speed up cloud provisioning with infrastructure as code.

Prior experience with the AWS Console and Linux command line are helpful but not required.

{{% notice info %}}
Because this workload has only **one** EC2 instance that is deployed in only **one** Availability Zone, this architecture does not meet the AWS Well Architected Framework best practices for running highly available production applications but suffices for this workshop.
{{% /notice %}}

{{< img BackupAndRestore.png >}}

{{< prev_next_button link_next_url="./1-prerequisites/" button_next_text="Start Lab" first_step="true" />}}

