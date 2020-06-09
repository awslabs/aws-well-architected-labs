---
title: "Level 200: Automated IAM User Cleanup"
menutitle: "Automated IAM User Cleanup"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 6
---

## Authors

- Pierre Liddle, Principal Security Architect
- Byron Pogson, Solutions Architect

## Introduction

This hands-on lab will guide you through the steps to deploy a AWS Lambda function with [AWS Serverless Application Model (SAM)](https://aws.amazon.com/serverless/sam/) to provide regular insights on IAM User/s and AWS Access Key usage within your account.
You will use the [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-reference.html#serverless-sam-cli) to package your deployment.
Skills learned will help you secure your AWS account in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

The AWS Lambda function is triggered by a regular scheduled event in Amazon CloudWatch Events.
Once the Lambda function runs to check the status of the AWS IAM Users and associated IAM Access Keys the results are sent the designated email contact via Amazon SNS. A check is also performed for unused roles.
The logs from the AWS Lambda function are captured in Amazon CloudWatch Logs for review and trouble shooting purposes.

![architecture](/Security/200_Automated_IAM_User_Cleanup/Images/architecture.png)

## Goals

* Identify orphaned IAM Users and AWS Access Keys
* Take action to automatically remove IAM Users and AWS Access Keys no longer needed
* Reduce identity sprawl

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
NOTE: You will be billed for any applicable AWS resources used if you complete this lab.
* Select region with support for AWS Lambda from the list: [AWS Regions and Endpoints](https://docs.aws.amazon.com/general/latest/gr/rande.html).
* [AWS Serverless Application Model (SAM)](https://aws.amazon.com/serverless/sam/)  installed and configured.
The AWS Serverless Application Model (SAM) is an open-source framework for building serverless applications.
It provides shorthand syntax to express functions, APIs, databases, and event source mappings.
With just a few lines per resource, you can define the application you want and model it using YAML.
During deployment, SAM transforms and expands the SAM syntax into AWS CloudFormation syntax, enabling you to build serverless applications faster.

## Steps:
{{% children  %}}

## References & useful resources

[AWS Identity and Access Management User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
[IAM Best Practices and Use Cases](https://docs.aws.amazon.com/IAM/latest/UserGuide/IAMBestPracticesAndUseCases.html)
[AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-reference.html#serverless-sam-cli)
[AWS Serverless Application Model (SAM)](https://aws.amazon.com/serverless/sam/)
