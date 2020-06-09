---
title: "Level 200: Automated Deployment of EC2 Web Application"
menutitle: "Automated Deployment of EC2 Web Application"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 2
---
## Authors

- Ben Potter, Security Lead, Well-Architected
- Rodney Lester, Manager, Well-Architected


## Introduction

This hands-on lab will guide you through the steps to configure a web application in [Amazon EC2](https://aws.amazon.com/ec2/) with a defense in depth approach incorporating a number of AWS security best practices. The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).
The [WordPress](https://wordpress.org/) example [CloudFormation template](/Security/200_Automated_Deployment_of_EC2_Web_Application/Code/wordpress.yaml) will deploy a basic WordPress  content management system, This example is not intended to be a comprehensive WordPress system, please consult [Build a WordPress Website](https://aws.amazon.com/getting-started/projects/build-wordpress-website/) for more information.

This lab will create the web application and all components using the example CloudFormation template, inside the VPC you have created previously. The components created include:

* Auto scaling group of web instances
* Application load balancer
* Security groups for load balancer and web instances
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

**Goals**

* Get temporary security credentials securely by using a role attached to the auto-scaled instances.
* Restrict network traffic allowed through security groups.
* CloudFormation to automate configuration management.
* Instances do not allow for SSH, instead Systems Manager may be used for administration.
* AWS Key Management Service is used for key management of Aurora database.
* Allow for Systems Manager to be used for management instead of SSH

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An IAM user or role in your AWS account with full access to CloudFormation, EC2, VPC, IAM, Elastic Load Balancing.
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
* Basic understanding of [AWS CloudFormation](https://aws.amazon.com/cloudformation/), visit the [Getting Started](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/GettingStarted.html) section of the user guide.
* Deployed the CloudFormation VPC stack in the lab [Automated Deployment of VPC](../200_Automated_Deployment_of_VPC/README.md).

## Steps:
{{% children  %}}
