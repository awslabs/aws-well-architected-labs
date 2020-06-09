---
title: "Quest: Detect & Investigate Events"
menutitle: "Detect & Investigate Events"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 9
description: " "
---
## Authors

- Ben Potter, Security Lead, Well-Architected

## About this Guide

This guide will help you improve your security in the AWS Well-Architected area of [Detective Controls](https://wa.aws.amazon.com/wat.pillar.security.en.html#sec.detective). The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

***

## Automated Deployment of Detective Controls

### Introduction

This hands-on lab will guide you through how to use AWS CloudFormation to automatically configure detective controls including AWS CloudTrail, AWS Config, and Amazon GuardDuty.
You will use the AWS Management Console and AWS CloudFormation to guide you through how to automate the configuration of each service.

### [Start the Lab!](/security/200_labs/200_automated_deployment_of_detective_controls/)

***

## Enable Security Hub

### Introduction

[AWS Security Hub](https://aws.amazon.com/security-hub/) gives you a comprehensive view of your high-priority security alerts and compliance status across AWS accounts. There are a range of powerful security tools at your disposal, from firewalls and endpoint protection to vulnerability and compliance scanners. But oftentimes this leaves your team switching back-and-forth between these tools to deal with hundreds, and sometimes thousands, of security alerts every day. With Security Hub, you now have a single place that aggregates, organizes, and prioritizes your security alerts, or findings, from multiple AWS services, such as Amazon GuardDuty, Amazon Inspector, and Amazon Macie, as well as from AWS Partner solutions. Your findings are visually summarized on integrated dashboards with actionable graphs and tables. You can also continuously monitor your environment using automated compliance checks based on the AWS best practices and industry standards your organization follows. Get started with AWS Security Hub in just a few clicks in the Management Console and once enabled, Security Hub will begin aggregating and prioritizing findings.

### [Start the Lab!](/security/100_labs/100_enable_security_hub/)

***

## Further Learning:
[AWS CloudTrail User Guide](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)
[AWS CloudFormation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)
[Amazon GuardDuty User Guide](https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html)
[AWS Config User Guide](https://docs.aws.amazon.com/config/latest/)
