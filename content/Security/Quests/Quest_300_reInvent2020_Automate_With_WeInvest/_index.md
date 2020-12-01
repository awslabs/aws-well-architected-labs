---
title: "Quest: re:Invent 2020 - Automate The Well-Architected Way With WeInvest"
menutitle: "Automate The Well-Architected Way With WeInvest"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 3
description: "This quest is a collection of lab patterns which are covered in the upcoming session at re:Invent 2020: Automate The Well-Architected Way with WeInvest"
---

## About this Guide

This quest is a collection of featured lab patterns with are covered in the **re:Invent 2020 session: Automate The Well-Architected Way with WeInvest**. 

Using this collection of labs, the user will be able to walk through the featured patterns from the session which **WeInvest** have worked with AWS to implement within their business to build an improved and effective security posture. 

Using either an AWS supplied, or your own AWS account, you will learn through hands-on labs in the AWS Well-Architected area of [Incident Response](https://wa.aws.amazon.com/wat.pillar.security.en.html#sec.incident). The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.

{{% notice note %}}
**NOTE:** You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}


### Lab 1 - Autonomous Montoring Of Cryptographic Activity With KMS.

In this lab we will walk you through an example scenario of monitoring our KMS service for encryption and decryption activity. We will autonomously detect abormal activity beyond a predefined threshold and respond accordingly, using the following services:

* [AWS CloudTrail](https://aws.amazon.com/cloudtrail/) - Used for capturing API events within the environment. 
* [Amazon CloudWatch Log Groups](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Working-with-log-groups-and-streams.html) - Used to log our CloudTrail API events.
* [Amazon CloudWatch Metric Filter](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/MonitoringPolicyExamples.html) to create apply filter so we can measure the only the events that matters for us.
* [Amazon CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html) to allow our system to react against pre created events
* [Amazon Simple Notification Service](https://aws.amazon.com/sns/) to allow us to send email notification when an event occurs.


### [Start now!](/Security/300_Labs/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/_index.md)

### Lab 2 - Autonomous Patching With EC2 Image Builder and Systems Manager.

In this lab we will walk you through a blue/green deployment methodology to build an entirely new [Amazon Machine Image (AMI)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) that contains the latest operating system patch, which can be deployed into an application cluster. We will use the following services to complete the workload deployment:

* [EC2 Image Builder](https://aws.amazon.com/image-builder/) to automate creation of the [AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)
* [Systems Manager Automated Document](https://aws.amazon.com/systems-manager/) to orchestrate the execution.
* [CloudFormation](https://aws.amazon.com/cloudformation/) with [AutoScalingReplacingUpdate](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-updatepolicy.html) update policy, to gracefully deploy the newly created AMI into the workload with minimal interruption to the application availability.

### [Start now!](/Security/300_labs/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/)

***

## Further Learning

[AWS Security Incident Response Guide](https://d1.awsstatic.com/whitepapers/aws_security_incident_response.pdf)

Find further information on the AWS website around [AWS Cloud Security]( https://aws.amazon.com/security/) and in particular what your responsibilities are under the [shared security model]( https://aws.amazon.com/compliance/shared-responsibility-model/)

***

## Authors

- **Tim Robinson** - Well-Architected Geo Solution Architect (Asia)
