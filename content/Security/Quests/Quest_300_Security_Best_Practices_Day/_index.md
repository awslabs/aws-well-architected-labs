---
title: "Quest: AWS Security Best Practices Day"
menutitle: "Security Best Practices Day"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 5
description: "This quest is the guide for an AWS led event including security best practices day. Includes identity & access management, detective controls, infrastructure protection, data protection and incident response."
---

## Authors

- Ben Potter, Security Lead, Well-Architected

## About this Guide

This quest is the guide for an AWS led event including security best practices day. Using your own AWS account you will learn through hands-on labs including identity & access management, detective controls, infrastructure protection, data protection and incident response. The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

***

## Lab 1: Identity & Access Management

For Lab 1 choose labs based on your interest or experience, its important to secure your AWS account so start with the introductory ones if you have not already completed:

### Introductory

### Lab 1.1: AWS Account and Root User

This hands-on lab will guide you through the introductory steps to configure a new AWS account and secure the root user.

### [AWS Account and Root User](/security/100_labs/100_aws_account_and_root_user/)

### Lab 1.2 Basic Identity and Access Management User, Group, Role

This hands-on lab will guide you through the introductory steps to configure AWS Identity and Access Management (IAM). You will use the AWS Management Console to guide you through how to configure your first IAM user, group and role for administrative access.

### [Basic Identity and Access Management User, Group, Role](/security/100_labs/100_basic_identity_and_access_management_user_group_role/)

### Advanced

### Lab 1.3 - IAM Permission Boundaries Delegating Role Creation

This hands-on lab will guide you through the steps to configure an example AWS Identity and Access Management (IAM) permission boundary. AWS supports permissions boundaries for IAM entities (users or roles). A permissions boundary is an advanced feature in which you use a managed policy to set the maximum permissions that an identity-based policy can grant to an IAM entity. When you set a permissions boundary for an entity, the entity can perform only the actions that are allowed by the policy.
In this lab you will create a series of policies attached to a role that can be assumed by an individual such as a developer, the developer can then use this role to create additional user roles that are restricted to specific services and regions.
This allows you to delegate access to create IAM roles and policies, without them exceeding the permissions in the permission boundary. We will also use a naming standard with a prefix, making it easier to control and organize policies and roles that your developers create.

### [IAM Permission Boundaries Delegating Role Creation](/security/300_labs/300_iam_permission_boundaries_delegating_role_creation/)

### Lab 1.4 - IAM Tag Based Access Control for EC2

This hands-on lab will guide you through the steps to configure example AWS Identity and Access Management (IAM) policies, and a AWS IAM role with associated permissions to use EC2 resource tags for access control. Using tags is powerful as it helps you scale your permission management, however you need to be careful about the management of the tags which you will learn in this lab.
In this lab you will create a series of policies attached to a role that can be assumed by an individual such as an EC2 administrator. This allows the EC2 administrator to create tags when creating resources only if they match the requirements, and control which existing resources and values they can tag.

### [IAM Tag Based Access Control for EC2](/security/300_labs/300_iam_tag_based_access_control_for_ec2/)

## Lab 2 - Automated Deployment of Detective Controls

This hands-on lab will guide you through how to use AWS CloudFormation to automatically configure detective controls including AWS CloudTrail, AWS Config, and Amazon GuardDuty. You will use the AWS Management Console and AWS CloudFormation to guide you through how to automate the configuration of each service.

### [Automated Deployment of Detective Controls](/security/200_labs/200_automated_deployment_of_detective_controls/)

## Lab 3 - Enable Security Hub

[AWS Security Hub](https://aws.amazon.com/security-hub/) gives you a comprehensive view of your high-priority security alerts and compliance status across AWS accounts. There are a range of powerful security tools at your disposal, from firewalls and endpoint protection to vulnerability and compliance scanners. But oftentimes this leaves your team switching back-and-forth between these tools to deal with hundreds, and sometimes thousands, of security alerts every day. With Security Hub, you now have a single place that aggregates, organizes, and prioritizes your security alerts, or findings, from multiple AWS services, such as Amazon GuardDuty, Amazon Inspector, and Amazon Macie, as well as from AWS Partner solutions. Your findings are visually summarized on integrated dashboards with actionable graphs and tables. You can also continuously monitor your environment using automated compliance checks based on the AWS best practices and industry standards your organization follows. Get started with AWS Security Hub in just a few clicks in the Management Console and once enabled, Security Hub will begin aggregating and prioritizing findings.

### [Enable Security Hub](/security/100_labs/100_enable_security_hub/)

## Lab 4 - Automated Deployment of VPC

This hands-on lab will guide you through the steps to configure an [Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) and outline some of the AWS security features. [AWS CloudFormation](https://aws.amazon.com/cloudformation/) will be used to automate the deployment and provide a repeatable way to re-use the template after this lab.
The example CloudFormation template will deploy a completely new VPC incorporating a number of AWS security best practices which are:
[Networking subnets](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html) created in multiple availability zones for the following network tiers:

  * Application Load Balancer - named *ALB1*
  * Application instances - named *App1*
  * Shared services - named *Shared1*
  * Databases - named *DB1*
[VPC endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html) are created for private connectivity to AWS services.
[NAT Gateways](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) are created to allow different subnets in the VPC to connect to the internet, without any direct ingress access being possible due to [Route Table](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html) configurations.
[Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html) control access at each subnet layer.
While [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html) captures information about IP traffic and stores it in Amazon CloudWatch Logs.
Do not follow tear down instructions until you have completed this quest, as the EC2 lab requires this VPC.

### [Automated Deployment of VPC](/security/200_labs/200_automated_deployment_of_vpc/)

## Lab 5 - Automated Deployment of EC2 Web Application

This hands-on lab will guide you through the steps to configure a web application in [Amazon EC2](https://aws.amazon.com/ec2/) with a defense in depth approach.
The [WordPress](https://wordpress.org/) example [CloudFormation template](../200_Automated_Deployment_of_EC2_Web_Application/Code/wordpress.yaml) will deploy a basic WordPress  content management system, incorporating a number of AWS security best practices. This example is not intended to be a comprehensive WordPress system, please consult [Build a WordPress Website](https://aws.amazon.com/getting-started/projects/build-wordpress-website/) for more information.

### [Automated Deployment of EC2 Web Application](/security/200_labs/200_automated_deployment_of_ec2_web_application/)

## Lab 6 - Automated Deployment of Web Application Firewall

This hands-on lab will guide you through the steps to protect a workload from network based attacks using AWS Web Application Firewall (WAF) integrated with Amazon CloudFront.
You will use the AWS Management Console and AWS CloudFormation to guide you through how to deploy AWS Web Application Firewall (WAF) with CloudFront integration to apply defense in depth methods.

### [Automated Deployment of Web Application Firewall](/security/200_labs/200_automated_deployment_of_web_application_firewall/)

## Lab 7 - CloudFront for Web Application

This hands-on lab will guide you through the steps to help protect a web application from network based attacks using Amazon CloudFront.
You will use the AWS Management Console and AWS CloudFormation to guide you through how to deploy CloudFront.

### [CloudFront for Web Application](/security/200_labs/200_cloudfront_for_web_application/)

## Lab 8 - Incident Response with AWS Console and CLI

This hands-on lab will guide you through a number of examples of how you could use the AWS Console and Command Line Interface (CLI) for responding to a security incident. It is a best practice to be prepared for an incident, and have appropriate detective controls enabled. You can find more best practices by reading the [Security Pillar of the AWS Well-Architected Framework](https://wa.aws.amazon.com/wat.pillar.security.en.html).

### [Incident Response with AWS Console and CLI](/security/300_labs/300_incident_response_with_aws_console_and_cli/)
