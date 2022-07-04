---
title: "Automated Deployment of EC2 Web Application"
menutitle: "Automated Deployment of EC2 Web Application"
date: 2020-09-19T11:16:08-04:00
chapter: false
weight: 3
---

**Last Updated:** September 2020

**Authors:** Ben Potter, Security Lead, Well-Architected & Rodney Lester, Manager, Well-Architected

## Introduction

This hands-on lab will guide you through the steps to configure a web application in [Amazon EC2](https://aws.amazon.com/ec2/) with a defense in depth approach incorporating a number of AWS security best practices. The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).
The [WordPress](https://wordpress.org/) example [CloudFormation template](/Security/200_Automated_Deployment_of_EC2_Web_Application/Code/wordpress.yaml) will deploy a basic WordPress  content management system, This example is not intended to be a comprehensive WordPress system, please consult [Build a WordPress Website](https://aws.amazon.com/getting-started/projects/build-wordpress-website/) for more information.

This lab will create the web application and all components using the example CloudFormation template, inside the VPC you have created previously. The components created include:

* Application load balancer
* Auto scaling group of web instances
* A role attached to the auto-scaled instances allows temporary security credentials to be used
* Instances use Systems Manager instead of SSH for administration
* Amazon Aurora serverless database cluster
* Secrets manager secret for database cluster
* AWS Key Management Service is used for key management of Aurora database
* Security groups for load balancer and web instances to restrict network traffic
* Custom CloudWatch metrics and logs for web instances
* IAM role for web instances that grants permission to Systems Manager and CloudWatch
* Instances are configured from the latest [Amazon Linux 2](https://aws.amazon.com/amazon-linux-2/) [Amazon Machine Image](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) at boot time using [user data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) to install agents and configure services

Overview of wordpress stack architecture:
![architecture](/Security/200_Automated_Deployment_of_EC2_Web_Application/Images/architecture.png)

{{% notice note %}}
An SSH key is not configured in this lab, instead [AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html) should be used to manage the EC2 instances as a more secure and scalable method.  
The Application Load Balancer will listen on unencrypted HTTP (port 80), it is a best practice to encrypt data in transit, you can [configure a HTTPS listener](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html) after completion of this lab.  
An example amazon-cloudwatch-agent.json file is provided and automatically downloaded by the instances to configure CloudWatch metrics and logs, this requires that you follow the example naming prefix of *WebApp1*.
{{% /notice %}}

## Prerequisites

- An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing.
- Permissions to create resources in CloudFormation, EC2, VPC, IAM, Elastic Load Balancing, CloudWatch, Aurora RDS, KMS, Secrets Manager, Systems Manager.
- Basic understanding of [AWS CloudFormation](https://aws.amazon.com/cloudformation/), visit the [Getting Started](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/GettingStarted.html) section of the user guide.
- Deployed the CloudFormation VPC stack in the lab [Automated Deployment of VPC]({{< ref "/Security/200_Labs/200_Automated_Deployment_of_VPC" >}}).

## Costs

Typically less than $20 per month if the account is only used for personal testing or training, and the tear down is not performed:

- [EC2 instance](https://aws.amazon.com/ec2/pricing/on-demand/) default t3.micro X2 (default value) is $0.0208 per hour in us-east-1 region
- [Aurora serverless database](https://aws.amazon.com/rds/aurora/pricing/?nc=sn&loc=4) default of 2 capacity units is $0.12 per hour in us-east-1 region
- [AWS KMS key](https://aws.amazon.com/kms/pricing/) for Aurora database is $1.00 per month plus $0.03 per 10,000 requests in us-east-1 region
- [Elastic Load Balancing, Application Load Balancer](https://aws.amazon.com/elasticloadbalancing/pricing/?nc=sn&loc=3) for Application Load Balancer is $0.0225 per hour in us-east-1 region
- [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/pricing/) secret for database password is $0.40 per month
- [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/pricing/) custom metrics X8 is $2.40 per month per instance in us-east-1 region
- [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/pricing/) logs is $0.50 per GB in us-east-1 region
- [AWS Pricing](https://aws.amazon.com/pricing/)

## Steps:
{{% children  %}}
