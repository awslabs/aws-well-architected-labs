---
title: "Quest: Reviewing Security Essential Best Practice - Well-Architected Webinar"
menutitle: "Reviewing Security Essential Best Practice"
date: 2021-06-08T11:16:08-04:00
chapter: false
weight: 3
description: "This quest is a collection of lab patterns which are covered in the June 2021 Webinar 'Reviewing Security Essential Best Practice'"
---

## About this Guide

This quest is a collection of featured lab patterns with are covered in the June 2021 Webinar **Reviewing Security Essential Best Practice**. 

Using this collection of labs, the user will be able to walk through the featured patterns from the session which cover best practice relating to multilayered API security, autonomous patching with EC2 Image Builder and Systems Manager and building incident response playbooks with Jupiter notebooks. 

Using either an AWS supplied, or your own AWS account, you will learn through hands-on labs in the AWS Well-Architected area of [Incident Response](https://wa.aws.amazon.com/wat.pillar.security.en.html#sec.incident). The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.

{{% notice note %}}
**NOTE:** You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}


### Lab 1 - Multilayered API Security With Cognito and WAF.

In this lab we will walk you through an example scenario of building out a multilayered approach to protecting an API using the following services:

* [Amazon API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html) - Used for securing REST API.
* [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html) - Used to securely store secrets.
* [Amazon CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html) - Used to prevent direct access to API as well as to enforce encrypted end-to-end connections to origin.
* [AWS WAF](https://docs.aws.amazon.com/waf/latest/developerguide/waf-chapter.html) - Used to protect our API by filtering, monitoring, and blocking malicious traffic.
* [Amazon Cognito](https://docs.aws.amazon.com/cognito/latest/developerguide/what-is-amazon-cognito.html) - Used to enable access control for our API layer.


### [Start now!](/security/300_labs/300_multilayered_api_security_with_cognito_and_waf/)


### Lab 2 - Autonomous Patching With EC2 Image Builder and Systems Manager.

In this lab we will walk you through a blue/green deployment methodology to build an entirely new [Amazon Machine Image (AMI)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) that contains the latest operating system patch, which can be deployed into an application cluster. We will use the following services to complete the workload deployment:

* [EC2 Image Builder](https://aws.amazon.com/image-builder/) to automate creation of the [AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)
* [Systems Manager Automated Document](https://aws.amazon.com/systems-manager/) to orchestrate the execution.
* [CloudFormation](https://aws.amazon.com/cloudformation/) with [AutoScalingReplacingUpdate](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-updatepolicy.html) update policy, to gracefully deploy the newly created AMI into the workload with minimal interruption to the application availability.

### [Start now!](/security/300_labs/300_autonomous_patching_with_ec2_image_builder_and_systems_manager/)


### Lab 3 - Incident Response Playbook with Jupyter - AWS IAM.

In this lab we will walk you through a hands-on lab which will guide you through running a basic incident response playbook using Jupyter. It is a best practice to be prepared for an incident, and practice your investigation and response tools and processes. We will achieve this :

* [Jupyter Notebook](https://jupyter.org/) 
* [AWS IAM](https://aws.amazon.com/iam/)

### [Start now!](/security/300_labs/300_incident_response_playbook_with_jupyter-aws_iam/)


## Further Learning

[AWS Security Incident Response Guide](https://d1.awsstatic.com/whitepapers/aws_security_incident_response.pdf)

Find further information on the AWS website around [AWS Cloud Security]( https://aws.amazon.com/security/) and in particular what your responsibilities are under the [shared security model]( https://aws.amazon.com/compliance/shared-responsibility-model/)

## Authors

- **Tim Robinson** - Well-Architected Geo Solution Architect
- **Ben Potter** - Principal Security Lead Well-Architected
- **Stephen Salim** - Well-Architected Geo Solution Architect
- **Jang Whan Han** - Well-Architected Geo Solution Architect

