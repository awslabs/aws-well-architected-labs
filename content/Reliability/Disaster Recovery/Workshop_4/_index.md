+++
title = "Module 4: Hot Standby"
date = 2021-05-06T09:52:56-04:00
weight = 140
chapter = false
pre = ""
+++


Our test application is Unishop. It is a Spring Boot Java application with a frontend written using bootstrap.
The app uses an Amazon S3 bucket to host a static web interface. A single EC2 instance serves as a proxy for API calls to an Amazon Aurora MySQL database.  The database contains mock user and product information. Amazon API Gateway is used to connect via AWS Lambda to a DynamoDB database storing shopping cart and session information.

To configure the infrastructure and deploy the application we will use CloudFormation. CloudFormation enables Infrastructure as Code (IaC) automation to quickly provision cloud resources.

We will initially deploy the primary Unishop instance into the us-east-1 (N. Virginia) region.  Next, the us-west-1 (N. California) region will host the Hot-Standby Disaster Recovery (DR) instance.  To configure and deploy this infrastructure, we will use AWS CloudFormation.

Afterward, we will verify the DR scenario. Meeting our [RPO / RTO](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html) _virtually instantaneously_, requires an Amazon CloudFront distribution with Orgin Failover policy.  Additionally, the workshop deploys an Amazon RDS Aurora MySQL Cluster in each region, and enables **1/** Read-Replica Write Forwarding and **2/** Amazon Aurora MySQL Global tables. These features support replicating database changes from either region. Finally we will configure DynamoDB Global Tables which will replicate data between regions.

Prior experience with the AWS Console and Linux command line are helpful but not required.

{{< img workshop-4-arch.png >}}

{{< prev_next_button link_next_url="./prerequisites/" button_next_text="Start Lab" first_step="true" />}}
