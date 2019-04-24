# Level 200: Automated Deployment of EC2 Web Application

## Introduction
This hands-on lab will guide you through the steps to configure a web application in [Amazon EC2](https://aws.amazon.com/ec2/) with a defense in depth approach. The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).  
The [WordPress](https://wordpress.org/) example [CloudFormation template](Code/wordpress.yaml) will deploy a basic WordPress  content management system, incorporating a number of AWS security best practices. This example is not intended to be a comprehensive WordPress system, please consult [Build a WordPress Website](https://aws.amazon.com/getting-started/projects/build-wordpress-website/) for more information.

## Goals:
* EC2 automated deployment
* Autoscaling and load balancing

## Prerequisites:
* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.  
* An IAM user or role in your AWS account with full access to CloudFormation, EC2, VPC, IAM, Elastic Load Balancing.  
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
* Basic understanding of [AWS CloudFormation](https://aws.amazon.com/cloudformation/), visit the [Getting Started](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/GettingStarted.html) section of the user guide.
* Deployed the CloudFormation VPC stack in the lab [Automated Deployment of VPC](../200_Automated_Deployment_of_VPC/README.md).
* [EC2 SSH key](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair) for accessing instances.

## Permissions required
* IAM User with *AdministratorAccess* AWS managed policy

<BR>

## [Start the Lab!](Lab_Guide.md)

<BR>
<BR>

***

## License
Licensed under the Apache 2.0 and MITnoAttr License. 

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


