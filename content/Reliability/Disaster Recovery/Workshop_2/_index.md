+++
title = "Module 2: Pilot Light"
date = 2021-05-06T09:52:56-04:00
weight = 140
chapter = false
pre = ""
+++

In this module, you will go through the Pilot Light Disaster Recovery (DR) strategy. To learn more about this DR strategy, you can review this [Disaster Recovery blog](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-iii-pilot-light-and-warm-standby/).

Pilot Light Disaster Recovery strategy has [Recovery Point Objective(RPO) / Recovery Time Objective (RTO)](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html) _within tens of minutes_.

Our test application is Unishop. It is a Spring Boot Java application deployed on a single Amazon EC2 instance using a public subnet.  Our datastore is an Amazon Aurora MySQL database with a frontend written using bootstrap and hosted in Amazon S3.  

Our application is currently deployed in our primary region **N. Virginia (us-east-1)** and we will use **N. California (us-west-1)** as our secondary region.

{{% notice note %}}
Note that this architecture does not meet the AWS Well Architected Framework best practices for running highly available production applications but suffices for this workshop.
{{% /notice %}}

[CloudFormation](https://aws.amazon.com/cloudformation/) will be used to configure the infrastructure and deploy the application. Provisioning your infrastructure with infrastructure as code (IaC) methodologies is a best practice. CloudFormation is an easy way to speed up cloud provisioning with infrastructure as code.

This module takes advantage of [Amazon Machine Images(AMI)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html/) which we will use to launch our Amazon EC2 instance and [Amazon Aurora Global Database](https://aws.amazon.com/rds/aurora/global-database/) to replicate our Amazon Aurora MySQL data to our secondary region. 

Prior experience with the AWS Console and Linux command line are helpful but not required.

{{< img arch-2.png >}}

{{< prev_next_button link_next_url="./prerequisites/" button_next_text="Start Lab" first_step="true" />}}
