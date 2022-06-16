+++
title = "Module 1: Backup and Restore"
date = 2021-05-06T09:52:56-04:00
weight = 110
chapter = false
pre = ""
+++

In this module, you will go through the Backup and Restore DR strategy. To learn more about this DR strategy, you can review this [Disaster Recovery blog](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-ii-backup-and-restore-with-rapid-recovery/).

Our test application is Unishop. It is a Spring Boot Java application deployed on a single Amazon EC2 instance using a public subnet.  Our datastore is an Amazon RDS MySQL database with a frontend written using bootstrap and hosted in Amazon S3.  

Our application is currently deployed in our primary region **N. Virginia (us-east-1)** and we will use **N. California (us-west-1)** as our secondary region.

{{% notice note %}}
Note that this architecture does not meet the AWS Well Architected Framework best practices for running highly available production applications but suffices for this workshop.
{{% /notice %}}

[CloudFormation](https://aws.amazon.com/cloudformation/) will be used to configure the infrastructure and deploy the application. Provisioning your infrastructure with infrastructure as code (IaC) methodologies is a best practice. CloudFormation is an easy way to speed up cloud provisioning with infrastructure as code.

This module takes advantage of [AWS Backup](https://aws.amazon.com/backup/) which will be our single pane of glass to copy and restore our Amazon EC2 instance, Amazon RDS database and Amazon S3 bucket into the secondary region.

Prior experience with the AWS Console and Linux command line are helpful but not required.

{{< img AC-1.png >}}

{{< prev_next_button link_next_url="./prerequisites/" button_next_text="Start Lab" first_step="true" />}}

