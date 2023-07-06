+++
title = "Module 4: Hot Standby"
date = 2021-05-06T09:52:56-04:00
weight = 140
chapter = false
pre = ""
+++

In this module, you will go through the Hot Standby disaster recovery strategy. To learn more about this disaster recovery strategy, you can review this [Disaster Recovery blog](https://aws.amazon.com/blogs/architecture/disaster-recovery-dr-architecture-on-aws-part-iii-pilot-light-and-warm-standby/).

Hot Standby disaster recovery strategy has [Recovery Point Objective(RPO) / Recovery Time Objective (RTO)](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html) _in almost real time_. For the hot standby strategy secondary region, the data is live, core infrastructure is provisioned and the services are running at full production capacity.

Our application is currently deployed in our primary region **N. Virginia (us-east-1)** and we will use **N. California (us-west-1)** as our secondary region.

Our test application is Unishop. It is a Spring Boot Java application deployed on a single [Amazon Elastic Compute Cloud (EC2)](https://aws.amazon.com/ec2) instance using a public subnet. Our datastore is an [Amazon Aurora](https://aws.amazon.com/rds/aurora/) MySQL database which has user data. Our test application is also deployed using [Amazon API Gateway](https://aws.amazon.com/api-gateway/) and [AWS Lambda](https://aws.amazon.com/lambda/). Our datastore is [Amazon DynamoDB](https://aws.amazon.com/dynamodb) which has shopping cart data. The frontend is written using bootstrap and hosted in [Amazon Simple Storage Service (S3)](https://aws.amazon.com/pm/serv-s3).  

Our test application is using two datastores, Amazon Aurora and DynamoDB to showcase the Disaster Recovery features of each. For your workloads, you would choose the right datastore for your use case.

This module takes advantage of [Amazon CloudFront](https://aws.amazon.com/cloudfront/) which we will use as our content delivery network. We are also taking advantage of [Amazon Aurora Global Database](https://aws.amazon.com/rds/aurora/global-database/) to replicate our Amazon Aurora MySQL data to our secondary region and [Amazon DynamoDB Global Tables](https://aws.amazon.com/dynamodb/global-tables/) to replicate our DynamoDB data to our secondary region. 

[CloudFormation](https://aws.amazon.com/cloudformation/) will be used to configure the infrastructure and deploy the application. Provisioning your infrastructure with infrastructure as code (IaC) methodologies is a best practice. CloudFormation is an easy way to speed up cloud provisioning with infrastructure as code.

Prior experience with the AWS Console and Linux command line are helpful but not required.

{{< img HotStandby.png >}}

{{< prev_next_button link_next_url="./1-prerequisites/" button_next_text="Start Lab" first_step="true" />}}
