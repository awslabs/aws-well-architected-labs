---
title: "Level 300: Testing for Resiliency of EC2, RDS, and AZ"
menutitle: "Test Resiliency EC2, RDS, & AZ"
description: "Use code to inject faults simulating EC2, RDS, and Availability Zone failures. These are used as part of Chaos Engineering to test workload resiliency"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 2
tags:
  - test_resiliency
---

{{< rawhtml >}}
<center>
<video width="600" height="450" controls>
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Reliability/Videos/chaos1.mp4" type="video/mp4">
  Your browser doesn't support video, or if you're on GitHub head to [wellarchitectedlabs.com](https://www.wellarchitectedlabs.com/reliability/300_labs/300_testing_for_resiliency_of_ec2_rds_and_s3/) to watch the video.
</video>
</center>
{{< /rawhtml >}}

## Authors

* Rodney Lester, Senior Solutions Architect Manager, AWS Well-Architected
* Adrian Hornsby, Principal Tech Evangelist, AWS
* Seth Eliot, Principal Reliability Solutions Architect, AWS Well-Architected

## Introduction

The purpose if this lab is to teach you the fundamentals of using tests to ensure your implementation is resilient to failure by injecting failure modes into your application. This may be a familiar concept to companies that practice Failure Mode Engineering Analysis (FMEA). It is also a key component of Chaos Engineering, which uses such failure injection to test hypotheses about workload resiliency. One primary capability that AWS provides is the ability to test your systems at a production scale, under load.

It is not sufficient to only design for failure, you must also test to ensure that you understand how the failure will cause your systems to behave. The act of conducting these tests will also give you the ability to create playbooks how to investigate failures. You will also be able to create playbooks for identifying root causes. If you conduct these tests regularly, then you will identify changes to your application that are not resilient to failure and also create the skills to react to unexpected failures in a calm and predictable manner.

In this lab, you will deploy a 3-tier resource, with a reverse proxy (Application Load Balancer), Web Application on Amazon Elastic Compute Cloud (EC2), and MySQL database using Amazon Relational Database Service (RDS). There is also an option to deploy the same stack into a different region, then using MySQL Read Replicas in the other region deployed with Amazon RDS, and then using AWS Database Migration Service to synchronize the data from the primary region into the secondary region. This will provide you the ability to progress from simpler failure testing of an application to failure testing under a simulated AWS regional failure.

The skills you learn will help you build resilient workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## Goals:

* Reduce fear of implementing resiliency testing by providing examples in common development and scripting languages
* Resilience testing of EC2 instances
* Resilience testing of RDS Multi-AZ instances
* Resilience testing using Availability Zones failures
* Resilience testing of S3 objects
* Learn how to implement resiliency using those tests
* Learn how to think about what a failure will cause within your infrastructure
* Learn how common AWS services can reduce mean time to recovery (MTTR)

## Prequisites:

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to create Amazon Virtual Private Cloud(s) (VPCs), including subnets, security groups, internet gateways, NAT Gateways, Elastic IP Addresses, and route tables. The credentials must also be able to create the database subnet group needed for a Multi-AZ RDS instance. The credential will need permissions to create IAM Role, instance profiles, AWS Auto Scaling launch configurations, application load balancers, auto scaling group, and EC2 instances.
* An IAM user or federated credentials into that account that has permissions to deploy the deployment automation, which consists of IAM service linked roles, AWS Lambda functions, and an AWS Step Functions state machine to execute the deployment.

NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

## Note:

This 300 level lab covers multiple failure injection scenarios. If you would prefer a simpler 200 level lab that demonstrates only EC2 failure injection, then see [Level 200: Testing for Resiliency of EC2 instances]({{< ref "/reliability/200_labs/200_testing_for_resiliency_of_ec2" >}}). This 300 level lab here includes everything in the 200 level lab, plus additional fault simulations.

## Additional lab resources:

* [Troubleshooting Guide]({{% ref "/Reliability/300_Labs/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/TroubleShooting_Guide.md" %}}) for common problems encountered while deploying and conducting this lab
* [Builders Guide]({{% ref "/Reliability/300_Labs/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Builders_Guide.md" %}}) for building the AWS Lambda functions and the web server and where to make changes in the lab guide to use the code you built instead of the publicly available executables.

## Steps:
{{% children  %}}
