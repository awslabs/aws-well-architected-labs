---
title: "Automated Deployment of Detective Controls"
menutitle: "Automated Deployment of Detective Controls"
date: 2020-09-19T11:16:08-04:00
chapter: false
weight: 3
hidden: false
---

**Last Updated:** September 2020

**Author:** Ben Potter, Security Lead, Well-Architected


## Introduction

This hands-on lab will guide you through how to use [AWS CloudFormation](https://aws.amazon.com/cloudformation/) to automatically configure detective controls including AWS CloudTrail, AWS Config, and Amazon GuardDuty.
You will use the AWS Management Console and AWS CloudFormation to automate the configuration of each service. The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

[AWS CloudTrail](https://aws.amazon.com/cloudtrail/) is a service that enables governance, compliance, operational auditing, and risk auditing of your AWS account. With CloudTrail, you can log, continuously monitor, and retain account activity related to actions across your AWS infrastructure. CloudTrail provides event history of your AWS account activity, including actions taken through the AWS Management Console, AWS SDKs, command line tools, and other AWS services.

[AWS Config](https://aws.amazon.com/config/) is a service that enables you to assess, audit, and evaluate the configurations of your AWS resources. AWS Config continuously monitors and records your AWS resource configurations and allows you to automate the evaluation of recorded configurations against desired configurations.

[Amazon GuardDuty](https://aws.amazon.com/guardduty/) is a threat detection service that continuously monitors for malicious or unauthorized behavior to help you protect your AWS accounts and workloads. It monitors for activity such as unusual API calls or potentially unauthorized deployments that indicate a possible account compromise. GuardDuty also detects potentially compromised instances or reconnaissance by attackers.

## Prerequisites

- An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing.
- Permissions to create resources in CloudFormation, CloudTrail, GuardDuty, Config, S3, CloudWatch.

## Costs

- Typically less than $2 per month if the account is only used for personal testing or training, and the tear down is not performed
- [AWS CloudTrail pricing](https://aws.amazon.com/cloudtrail/pricing/)
- [Amazon GuardDuty pricing](https://aws.amazon.com/guardduty/pricing/)
- [AWS Config pricing](https://aws.amazon.com/config/pricing/)
- [Amazon S3 pricing](https://aws.amazon.com/s3/pricing/)
- [AWS Pricing](https://aws.amazon.com/pricing/)

## Steps:

{{% children  %}}

## References & Useful Resources

* [Automate alerting on key indicators](https://wa.aws.amazon.com/wat.question.SEC_4.en.html) AWS 
Cloudtrail, AWS Config and Amazon GuardDuty provide insights into your environment.
* [Implement new security services and features:](https://wa.aws.amazon.com/wat.question.SEC_5.en.html) New features such as Amazon GuardDuty have been adopted.
* [Automate configuration management:](https://wa.aws.amazon.com/wat.question.SEC_6.en.html) CloudFormation is being used to configure AWS CloudTrail, AWS Config and Amazon GuardDuty.
* [Implement managed services:](https://wa.aws.amazon.com/wat.question.SEC_7.en.html) Managed services are utilized to increase your visibility and control of your environment.
