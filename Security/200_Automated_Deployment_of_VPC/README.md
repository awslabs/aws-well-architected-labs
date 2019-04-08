# Level 200: Automated Deployment of VPC

## Introduction
This hands-on lab will guide you through the steps to configure an [Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) and outline some of the available security features. [AWS CloudFormation](https://aws.amazon.com/cloudformation/) will be used to automate the deployment and provide a repeatable way to re-use the template after this lab. The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).  
The example [CloudFormation template](Code/vpc-alb-app-db.yaml) will deploy a complete VPC incorporating a number of AWS security best practices.
Subnets are created in multiple availability zones for the following network tiers:
  * Application Load Balancer - named *ALB1*
  * Application instances - named *App1*
  * Shared services - named *Shared1*
  * Databases - named *DB1*  

[VPC endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html) are created for private connectivity to AWS services. [NAT Gateways](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) created allow different subnets in the VPC to connect to the internet, without any direct ingress access being possible due to [Route Table](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html) configurations. [Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html) control access at each subnet layer, while [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html) captures information about IP traffic and stores in Amazon CloudWatch Logs.

## Goals:
* VPC security features
* VPC layered subnet architecture
* Automated deployments

## Prerequisites:
* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.  
* An IAM user or role in your AWS account with full access to CloudFormation, EC2, VPC, IAM.  
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
* Basic understanding of [AWS CloudFormation](https://aws.amazon.com/cloudformation/), visit the [Getting Started](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/GettingStarted.html) section of the user guide.

## Overview
* **[Lab_Guide.md](Lab_Guide.md) the guide for this lab**
* [/Code](Code/) Code including CloudFormation templates related to this lab
* [/Images](Images/) referenced by this lab

## Permissions required
* IAM User with *AdministratorAccess* AWS managed policy

***

## License
Licensed under the Apache 2.0 and MITnoAttr License. 

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


