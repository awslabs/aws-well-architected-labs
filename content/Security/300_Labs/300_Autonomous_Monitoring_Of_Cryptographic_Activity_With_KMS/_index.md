---
title: "Level 300: Autonomous Monitoring Of Cryptographic Activity With KMS"
menutitle: "Autonomous Monitoring Of Cryptographic Activity With KMS"
date: 2020-11-01T11:16:08-04:00
chapter: false
weight: 1
hidden: false
---
## Authors

- **Tim Robinson**, Well-Architected Geo Solutions Architect.
- **Stephen Salim**, Well-Architected Geo Solutions Architect.

## Introduction

The ability to provide traceability and automatically react to security events occurring in your workload is vital to maintaining a high security posture within your application. Through the use monitoring key activity metrics, architects are able to detect potentially malicious behaviour at an early stage and respond according to the event. By combining this early detection approach with appropriate alerting, we can create an autonomous feedback loop which ensures that cloud administrators are adequately informed before a serious event takes place.

In AWS you can use [AWS CloudTrail](https://aws.amazon.com/cloudtrail/) to capture all API based activity within an AWS account. However, simply capturing these activities is not be sufficient without the ability to contextualize events and create the mechanism to automatically react in an appropriate manner. The integration of [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/) in combination with CloudTrail and our other services, allows customers to produce adequate alerting and visibility to important system events triggered by a key activity metric. 

One such example of a key activity metric would be [Key Management Service (KMS)](https://aws.amazon.com/kms/) activity. KMS is integral to most secure architecture designs and responsible for autonomous encryption and decryption activity. Whilst we would expect regular activity which is triggered as a byproduct from user interaction with an architecture, significantly high activity could be an early warning signal that the architecture could be subject to data exfiltration by an interested third party or competitor.

In this lab we will walk you through an example scenario of monitoring our KMS service for encryption and decryption activity. We will autonomously detect abormal activity beyond a predefined threshold and respond accordingly, using the following services:

* [AWS CloudTrail](https://aws.amazon.com/cloudtrail/) - Used for capturing API events within the environment. 
* [Amazon CloudWatch Log Groups](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Working-with-log-groups-and-streams.html) - Used to log our CloudTrail API events.
* [Amazon CloudWatch Metric Filter](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/MonitoringPolicyExamples.html) to create apply filter so we can measure the only the events that matters for us.
* [Amazon CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html) to allow our system to react against pre created events
* [Amazon Simple Notification Service](https://aws.amazon.com/sns/) to allow us to send email notification when an event occurs.

Our lab is divided into several sections as follows:

1. Deploy the lab base infrastructure.
2. Configure the ECS repository and deploy the application stack.
3. Configure the workload logging and alarm.
4. Testing the workload functionality.

We have included CloudFormation templates for the first few steps to get your started, and also provide optional templates for the rest of the lab so you can choose between creating the monitoring resources via cloudformation or manually through the console.

{{% notice note %}}
**Note:** For simplicity, we have used Sydney **'ap-southeast-2'** as the default region for this lab. Please ensure all lab interaction is completed from this region.
{{% /notice %}}

## Goals

* Analyze CloudTrail and target specific API events.
* Integrate CloudTrail events with A CloudWatch Log Group to record the event.
* Apply appropriate metric filters and alarms to trigger an event.
* Integrate SNS to respond appropriately to the event.

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* If you want to follow the command line instructions, you should have the AWS command line installed and configured. Please follow this [guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
* In this Lab we will be creating a local docker image, please ensure you have [docker](https://www.docker.com/) installed in your machine, and you are running **Docker version 18.09.9** or above.

{{% notice note %}}
**NOTE:** You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

## Steps:
{{% children  %}}
