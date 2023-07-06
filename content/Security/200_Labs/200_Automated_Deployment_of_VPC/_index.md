---
title: "Level 200: Automated Deployment of VPC"
menutitle: "Automated Deployment of VPC"
date: 2020-07-22T01:00:09-04:00
chapter: false
weight: 4
---

**Last Updated:** July 2020

**Authors:** Ben Potter, Security Lead, Well-Architected

## Introduction

This hands-on lab will use [AWS CloudFormation](https://aws.amazon.com/cloudformation/) to create an [Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) to outline some of the AWS security features available. Using CloudFormation to automate the deployment provides a repeatable way to create and update, and you can re-use the template after this lab.

The example [template](/Common/Create_VPC_Stack/Code/vpc-alb-app-db.yaml) will deploy a completely new VPC incorporating a number of AWS security best practices which include:

[Networking subnets](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html) created in 3 availability zones for the following network tiers:
* Application Load Balancer - named *ALB1*
* Application instances - named *App1*
* Shared services - named *Shared1*
* Database - named *DB1*

**VPC Architecture:**
![architecture](/Security/200_Automated_Deployment_of_VPC/Images/architecture.png)
* [VPC endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html) are created for private connectivity to AWS services. Additional endpoints can be enabled for the application tier using the *App1SubnetsPrivateLinkEndpoints* CloudFormation parameter.
* [NAT Gateways](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) are created to allow subnets in the VPC to connect to the internet, without any direct ingress access as defined by the [Route Table](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html).
* [Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html) control access at each subnet tier.
* [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html) captures information about IP traffic and stores it in Amazon CloudWatch Logs.

## Requirements

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An IAM user or role in your AWS account with access to CloudFormation, EC2, VPC, IAM.
* Basic understanding of [AWS CloudFormation](https://aws.amazon.com/cloudformation/), visit the [Getting Started](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/GettingStarted.html) section of the user guide.

{{% notice note %}}
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/). It is recommended to delete the CloudFormation stack when you have completed the lab. 
{{% /notice %}}

## Steps:
{{ children }}

## References & useful resources

* [Well-Architected: Protecting Networks](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/protecting-networks.html)
* [AWS CloudFormation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)
* [Amazon VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
* [Security in Amazon Virtual Private Cloud](https://docs.aws.amazon.com/vpc/latest/userguide/security.html)