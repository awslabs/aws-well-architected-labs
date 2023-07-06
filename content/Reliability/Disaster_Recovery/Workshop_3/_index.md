+++
title = "Module 3: Warm Standby"
date = 2021-05-06T09:52:56-04:00
weight = 140
chapter = false
pre = ""
+++

In this module, you will go through the Warm Standby disaster recovery strategy. To learn more about this disaster recovery strategy, you can review this [Disaster Recovery blog](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-iii-pilot-light-and-warm-standby/).

Warm Standby disaster recovery strategy has [Recovery Point Objective(RPO) / Recovery Time Objective (RTO)](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html) _within minutes_. For the warm standby strategy secondary region, the data is live and core infrastructure is provisioned and the services are running at a reduced capacity.

Our application is currently deployed in our primary region **N. Virginia (us-east-1)** and we will use **N. California (us-west-1)** as our secondary region.

Our test application is Unishop. It is a Spring Boot Java application deployed using [Elastic Load Balancing](https://aws.amazon.com/elasticloadbalancing/) and two [Amazon Elastic Compute Cloud (EC2)](https://aws.amazon.com/ec2) instances using a public subnet.  Our datastore is an [Amazon Aurora](https://aws.amazon.com/rds/aurora/) MySQL database with a frontend written using bootstrap and hosted in [Amazon Simple Storage Service (S3)](https://aws.amazon.com/pm/serv-s3).  

This module takes advantage of [Auto Scaling Groups (ASG)](https://docs.aws.amazon.com/autoscaling/ec2/userguide/auto-scaling-groups.html) which will allow us to scale out our secondary region compute instances during failover. [Amazon Aurora Global Database](https://aws.amazon.com/rds/aurora/global-database/) is used to replicate our Amazon Aurora MySQL data to our secondary region. We are also taking advantage of Amazon Aurora read replica [write forwarding](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-write-forwarding.html). With this feature enabled, writes can be sent to a read replica in a secondary region, and will be seamlessly forwarded to the writer in the primary region over a secure communication channel.

[CloudFormation](https://aws.amazon.com/cloudformation/) will be used to configure the infrastructure and deploy the application. Provisioning your infrastructure with infrastructure as code (IaC) methodologies is a best practice. CloudFormation is an easy way to speed up cloud provisioning with infrastructure as code.

Prior experience with the AWS Console and Linux command line are helpful but not required.

{{< img WarmStandby.png >}}

{{< prev_next_button link_next_url="./1-prerequisites/" button_next_text="Start Lab" first_step="true" />}}

