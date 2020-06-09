---
title: "Level 200: Automated Deployment of VPC"
menutitle: "Automated Deployment of VPC"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 4
---
## Authors

- Ben Potter, Security Lead, Well-Architected

## Introduction

This hands-on lab will guide you through the steps to configure an [Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) and outline some of the AWS security features. [AWS CloudFormation](https://aws.amazon.com/cloudformation/) will be used to automate the deployment and provide a repeatable way to re-use the template after this lab.
<br />
The example [CloudFormation template](/Security/200_Automated_Deployment_of_VPC/Code/vpc-alb-app-db.yaml) will deploy a completely new VPC incorporating a number of AWS security best practices which are:

[Networking subnets](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html) created in multiple availability zones for the following network tiers:
  * Application Load Balancer - named *ALB1*
  * Application instances - named *App1*
  * Shared services - named *Shared1*
  * Databases - named *DB1*

VPC Architecture:
![architecture](/Security/200_Automated_Deployment_of_VPC/Images/architecture.png)

[VPC endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html) are created for private connectivity to AWS services.<br />
[NAT Gateways](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) are created to allow different subnets in the VPC to connect to the internet, without any direct ingress access being possible due to [Route Table](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html) configurations.<br />
[Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html) control access at each subnet layer.<br />
While [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html) captures information about IP traffic and stores it in Amazon CloudWatch Logs.

**Goals**

* Security groups restrict network traffic to a minimum.
* Use Internet Gateways and NAT Gateways to control traffic flows.
* CloudFormation to automate configuration management.
* Control traffic with multiple layers, using subnets with different route tables.

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An IAM user or role in your AWS account with full access to CloudFormation, EC2, VPC, IAM.
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
* Basic understanding of [AWS CloudFormation](https://aws.amazon.com/cloudformation/), visit the [Getting Started](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/GettingStarted.html) section of the user guide.
* We recommend you [clone the Git repository](https://help.github.com/en/articles/cloning-a-repository) for easy access to the AWS CloudFormation templates.

## Steps:
{{% children  %}}
