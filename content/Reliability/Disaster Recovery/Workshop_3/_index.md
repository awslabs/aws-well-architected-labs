+++
title = "Module 3: Warm Standby"
date = 2021-05-06T09:52:56-04:00
weight = 140
chapter = false
pre = ""
+++

In this module, you will go through the Warm Standby Disaster Recovery (DR) strategy. To learn more about this DR strategy, you can review this [Disaster Recovery blog](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-iii-pilot-light-and-warm-standby/).

Warm Standby Disaster Recovery strategy has [Recovery Point Objective(RPO) / Recovery Time Objective (RTO)](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html) _within minutes_.

Our test application is Unishop. It is a Spring Boot Java application deployed across a fleet of Amazon EC2 instance using a public subnet and an Amazon Elastic Load Balancer to balance requests. Our datastore is an Amazon Aurora MySQL database with a frontend written using bootstrap and hosted in Amazon S3.

Our application is currently deployed in our primary region **N. Virginia (us-east-1)** and we will use **N. California (us-west-1)** as our secondary region.

[CloudFormation](https://aws.amazon.com/cloudformation/) will be used to configure the infrastructure and deploy the application. Provisioning your infrastructure with infrastructure as code (IaC) methodologies is a best practice. CloudFormation is an easy way to speed up cloud provisioning with infrastructure as code.

Prior experience with the AWS Console and Linux command line are helpful but not required.

{{< img arch-3.png >}}

{{< prev_next_button link_next_url="./prerequisites/" button_next_text="Start Lab" first_step="true" />}}

