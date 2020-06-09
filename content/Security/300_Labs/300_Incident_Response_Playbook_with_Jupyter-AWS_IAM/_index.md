---
title: "Level 300: Incident Response Playbook with Jupyter - AWS IAM"
menutitle: "Incident Response Playbook with Jupyter - AWS IAM"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 3
---
## Authors

- Ben Potter, Security Lead, Well-Architected
- Byron Pogson, Solutions Architect, AWS

## Introduction

This hands-on lab will guide you through running a basic incident response playbook using Jupyter. It is a best practice to be prepared for an incident, and practice your investigation and response tools and processes. You can find more best practices by reading the [Security Pillar of the AWS Well-Architected Framework](https://wa.aws.amazon.com/wat.pillar.security.en.html).

The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Goals

* Identify tooling for incident response
* Automate containment for incident response
* Pre-deploy tools for incident response

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An IAM user or role in your AWS account.
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
* CloudTrail must already be enabled in your account and logging to CloudWatch Logs, follow the [Automated Deployment of Detective Controls](../200_Automated_Deployment_of_Detective_Controls/README.md) lab to enable.

## Steps:
{{% children  %}}

## References & useful resources

* [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/)
* [AWS Identity and Access Management User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
* [CloudWatch Logs Insights Query Syntax](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html)
* [Jupyter](https://jupyter.org/)
