+++
title = "Module 4: Hot Standby"
date = 2021-05-06T09:52:56-04:00
weight = 140
chapter = true
pre = ""
+++


Our test application is Unishop. It's a Spring Boot Java application  with frontend written using bootstrap.

The app is deployed using an S3 bucket to host the static frontend. A single EC2 instance is used as a proxy for API calls to an Aurora MYSQL database storing user and product information.  Amazon API Gateway is used to connect via AWS Lambda to a DynamoDB database storing shopping cart and session information.

To configure the infrastructure and deploy the application we will use CloudFormation. CloudFormation is an easy way to speed up cloud provisioning with infrastructure as code.

We will initially deploy Unishop to both the N. Virginia us-east-1 AWS region and N. California us-west-1 AWS region and verify functionality. 
In order to have almost instantaneous failover for minimal [RPO / RTO](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/disaster-recovery-dr-objectives.html)  we will utilize CloudFront, Aurora MYSQL Cluster and DynamoDB.  We will create a CloudFront distribution and configure Origin Failover which allows for requests to be automatically redirected to a secondary region (bucket) in the case that we cannot run this workload in the primary region.  We will then configure the Aurora MYSQL database with Read Replica Write Forwarding which allows seamless promotion of secondary region in the case that we cannot run this workload in the primary region within one minute.  Finally we will configure DynamoDB Global Tables which will replicate data between regions.

This workshop takes about 60 minutes to complete. Prior experieince with the AWS Console and Linux command line are helpful but not required.

{{< img workshop-4-arch.png >}}

