+++
title = "Module 2: Pilot Light"
date = 2021-05-06T09:52:56-04:00
weight = 140
chapter = false
pre = ""
+++

In this module, you will go through the Pilot-Light Disaster Recovery (DR) strategy. To learn more about this DR strategy, you can review this [Disaster Recovery blog](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-iii-pilot-light-and-warm-standby/).

Our test application is Unishop. It is a Spring Boot Java application with a frontend written using bootstrap.

The app uses an Amazon S3 bucket to host a static web interface. A single EC2 instance serves as a proxy for API calls to an Amazon Aurora MySQL database.  The database contains mock user and product information.

We will initially deploy the primary Unishop instance into the N. Virginia region.  Next, the N. California region will host the Pilot-Light DR instance.  To configure and deploy this infrastructure, we will use AWS CloudFormation.  CloudFormation enables Infrastructure as Code (IaC) automation to quickly provision cloud resources.

Afterward, we will verify the DR scenario. Meeting our [RPO / RTO](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html) within 10s of minutes requires Amazon Aurora MySQL Cluster with the Amazon Aurora MySQL Global database feature enabled.  This feature adds cross-region database replication capabilities.

Prior experieince with the AWS Console and Linux command line are helpful but not required.

{{< img arch-2.png >}}

{{< prev_next_button link_next_url="./prerequisites/" button_next_text="Start Lab" first_step="true" />}}
