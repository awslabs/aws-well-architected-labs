# Quest: AWS Security Best Practices Workshop

## Authors
- Ben Potter, Security Lead, Well-Architected
- Pierre Liddle, Principal Solutions Architect

## About this Guide
This quest is the guide for an AWS led event including [AWS Summits](https://aws.amazon.com/events/summits/) security best practices workshop. Using your own AWS account you will learn through hands-on labs in securing an Amazon EC2-based web application covering identity & access management, detective controls, infrastructure protection, data protection and incident response. The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Prerequisites:
* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.  
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

***

## Lab 1 -  Identity & Access Management:
For Lab 1 choose one of labs to run based on your interest or experience:  

### Lab 1a - IAM Permission Boundaries Delegating Role Creation:
This hands-on lab will guide you through the steps to configure an example AWS Identity and Access Management (IAM) permission boundary. AWS supports permissions boundaries for IAM entities (users or roles). A permissions boundary is an advanced feature in which you use a managed policy to set the maximum permissions that an identity-based policy can grant to an IAM entity. When you set a permissions boundary for an entity, the entity can perform only the actions that are allowed by the policy.<br />
<br />
In this lab you will create a series of policies attached to a role that can be assumed by an individual such as a developer, the developer can then use this role to create additional user roles that are restricted to specific services and regions.
This allows you to delegate access to create IAM roles and policies, without them exceeding the permissions in the permission boundary. We will also use a naming standard with a prefix, making it easier to control and organize policies and roles that your developers create.  
### [IAM Permission Boundaries Delegating Role Creation](../300_IAM_Permission_Boundaries_Delegating_Role_Creation/README.md)

### Lab 1b - IAM Tag Based Access Control for EC2:
This hands-on lab will guide you through the steps to configure example AWS Identity and Access Management (IAM) policies, and a AWS IAM role with associated permissions to use EC2 resource tags for access control. Using tags is powerful as it helps you scale your permission management, however you need to be careful about the management of the tags which you will learn in this lab.<br />
<br />
In this lab you will create a series of policies attached to a role that can be assumed by an individual such as an EC2 administrator. This allows the EC2 administrator to create tags when creating resources only if they match the requirements, and control which existing resources and values they can tag.  
### [IAM Tag Based Access Control for EC2](../300_IAM_Tag_Based_Access_Control_for_EC2/README.md)

## Lab 2 - Automated Deployment of VPC:
This hands-on lab will guide you through the steps to configure an [Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) and outline some of the AWS security features. [AWS CloudFormation](https://aws.amazon.com/cloudformation/) will be used to automate the deployment and provide a repeatable way to re-use the template after this lab.  
<br />
The example CloudFormation template will deploy a completely new VPC incorporating a number of AWS security best practices which are:
  
[Networking subnets](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html) created in multiple availability zones for the following network tiers:

  * Application Load Balancer - named *ALB1*
  * Application instances - named *App1*
  * Shared services - named *Shared1*
  * Databases - named *DB1*

[VPC endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html) are created for private connectivity to AWS services.<br />
[NAT Gateways](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) are created to allow different subnets in the VPC to connect to the internet, without any direct ingress access being possible due to [Route Table](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html) configurations.<br />
[Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html) control access at each subnet layer.<br />
While [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html) captures information about IP traffic and stores it in Amazon CloudWatch Logs.  
Do not follow tear down instructions until you have completed this quest, as the EC2 lab requires this VPC.
### [Automated Deployment of VPC](../200_Automated_Deployment_of_VPC/README.md)

## Lab 3 - Automated Deployment of EC2 Web Application:
This hands-on lab will guide you through the steps to configure a web application in [Amazon EC2](https://aws.amazon.com/ec2/) with a defense in depth approach.<br />

The [WordPress](https://wordpress.org/) example [CloudFormation template](../200_Automated_Deployment_of_EC2_Web_Application/Code/wordpress.yaml) will deploy a basic WordPress  content management system, incorporating a number of AWS security best practices. This example is not intended to be a comprehensive WordPress system, please consult [Build a WordPress Website](https://aws.amazon.com/getting-started/projects/build-wordpress-website/) for more information.

### [Automated Deployment of EC2 Web Application](../200_Automated_Deployment_of_EC2_Web_Application/README.md)

## Lab 4 - Automated Deployment of Detective Controls:
This hands-on lab will guide you through how to use AWS CloudFormation to automatically configure detective controls including AWS CloudTrail, AWS Config, and Amazon GuardDuty. You will use the AWS Management Console and AWS CloudFormation to guide you through how to automate the configuration of each service.

### [Automated Deployment of Detective Controls](../200_Automated_Deployment_of_Detective_Controls/README.md)

## Lab 5 - Enable Security Hub:

[AWS Security Hub](https://aws.amazon.com/security-hub/) gives you a comprehensive view of your high-priority security alerts and compliance status across AWS accounts. There are a range of powerful security tools at your disposal, from firewalls and endpoint protection to vulnerability and compliance scanners. But oftentimes this leaves your team switching back-and-forth between these tools to deal with hundreds, and sometimes thousands, of security alerts every day. With Security Hub, you now have a single place that aggregates, organizes, and prioritizes your security alerts, or findings, from multiple AWS services, such as Amazon GuardDuty, Amazon Inspector, and Amazon Macie, as well as from AWS Partner solutions. Your findings are visually summarized on integrated dashboards with actionable graphs and tables. You can also continuously monitor your environment using automated compliance checks based on the AWS best practices and industry standards your organization follows. Get started with AWS Security Hub in just a few clicks in the Management Console and once enabled, Security Hub will begin aggregating and prioritizing findings.

### [Enable Security Hub](../100_Enable_Security_Hub/README.md)

## Lab 6 - Incident Response with AWS Console and CLI:
This hands-on lab will guide you through a number of examples of how you could use the AWS Console and Command Line Interface (CLI) for responding to a security incident. It is a best practice to be prepared for an incident, and have appropriate detective controls enabled. You can find more best practices by reading the [Security Pillar of the AWS Well-Architected Framework](https://wa.aws.amazon.com/wat.pillar.security.en.html).

### [Incident Response with AWS Console and CLI](../300_Incident_Response_with_AWS_Console_and_CLI/README.md)

***

## License
Licensed under the Apache 2.0 and MITnoAttr License. 

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
