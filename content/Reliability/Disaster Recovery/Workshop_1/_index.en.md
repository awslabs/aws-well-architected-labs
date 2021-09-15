+++
title = "Module 1: Backup and Restore"
date = 2021-05-06T09:52:56-04:00
weight = 110
chapter = false
pre = ""
+++

In this module, you will go through the Backup and Restore DR strategy. To learn more about this DR strategy, you can review this [Disaster Recovery blog](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-ii-backup-and-restore-with-rapid-recovery/).

Our test application is Unishop. It is a Spring Boot Java application connected to a MySQL database with a frontend written using bootstrap.

The app is deployed on a single EC2 instance (t3.small) within a dedicated VPC using a single public subnet. Note that this is not the ideal infrastructure architecture for running highly available production applications but suffices for this workshop.

To configure the infrastructure and deploy the application, we will use CloudFormation. CloudFormation is an easy way to speed up cloud provisioning with infrastructure as code.

We will initially deploy Unishop to the us-east-1 AWS region and verify functionality. Then we will use an AWS EC2 AMI and AWS Backup to create copies of the application server and database in the us-west-1 region. Finally, we will use the copies to create and test a fully functional application in the us-west-1 region.

This workshop takes about 90 minutes to complete. Prior experieince with the AWS Console and Linux command line are helpful but not required.

{{< img AC-1.png >}}

{{< prev_next_button link_next_url="./prerequisites/" button_next_text="Start Lab" first_step="true" />}}

