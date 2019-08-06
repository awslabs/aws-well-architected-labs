# Quest: AWS Incident Response Day

## About this Guide

This quest is the guide for an AWS led event including incident response day. Using an AWS supplied, or your own AWS account, you will learn through hands-on labs in the AWS Well-Architected area of [Incident Response](https://wa.aws.amazon.com/wat.pillar.security.en.html#sec.incident). The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

***

## Lab 1 - Automated Deployment of Detective Controls

This hands-on lab will guide you through how to use AWS CloudFormation to automatically configure detective controls including AWS CloudTrail, AWS Config, and Amazon GuardDuty. You will use the AWS Management Console and AWS CloudFormation to guide you through how to automate the configuration of each service.

### [Start now!](https://wellarchitectedlabs.com/Security/200_Automated_Deployment_of_Detective_Controls/README.html)

## Lab 2 - Protecting workloads on AWS from the instance to the edge

In this workshop, you will build an environment consisting of two Amazon Linux web servers behind an application load balancer. The web servers will be running a PHP web site that contains several vulnerabilities. You will then use AWS Web Application Firewall (WAF), Amazon Inspector and AWS Systems Manager to identify the vulnerabilities and remediate them.

### [Start now!](https://protecting-workloads.awssecworkshops.com/workshop/)

## Lab 3 - Incident Response with AWS Console and CLI

This hands-on lab will guide you through a number of examples of how you could use the AWS Console and Command Line Interface (CLI) for responding to a security incident. It is a best practice to be prepared for an incident, and have appropriate detective controls enabled.

### [Start now!](https://wellarchitectedlabs.com/Security/300_Incident_Response_with_AWS_Console_and_CLI/README.html)

## Lab 4 - Getting Hands on with Amazon GuardDuty

Walks you through a scenario covering threat detection and automated remediation using Amazon GuardDuty; a managed threat detection service. The scenario simulates an attack that spans a few threat vectors, representing just a small sample of the threats that GuardDuty is able to detect.

### [Start now!](https://hands-on-guardduty.awssecworkshops.com/)

## Lab 5 - Open Source AWS Memory Forensics

This lab consists of using an open source python module for orchestrating memory acquisitions and analysis using [AWS Systems Manager](https://aws.amazon.com/systems-manager/). It analyzes the memory dump using [Rekall](http://www.rekall-forensic.com/) with the most common plugins: psaux, pstree, netstat, ifconfig, pidhashtable.

### [Start now!](https://github.com/mozilla/ssm-acquire)

***

## Further Learning

[AWS Security Incident Response Guide](https://d1.awsstatic.com/whitepapers/aws_security_incident_response.pdf)

Find further information on the AWS website around [AWS Cloud Security]( https://aws.amazon.com/security/) and in particular what your responsibilities are under the [shared security model]( https://aws.amazon.com/compliance/shared-responsibility-model/)

***

## Authors

- Ben Potter, Security Lead, Well-Architected

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
