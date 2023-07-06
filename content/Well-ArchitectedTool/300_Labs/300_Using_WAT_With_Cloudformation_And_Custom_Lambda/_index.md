---
title: "Level 300: Using custom resource in AWS CloudFormation to create and update Well-Architected Reviews"
menutitle: "Using custom resource in AWS CloudFormation to create and update Well-Architected Reviews"
date: 2021-03-25T11:16:09-04:00
chapter: false
weight: 1
hidden: false
---

## Authors
- Eric Pullen, Performance Efficiency Lead Well-Architected

## Introduction

The purpose if this lab is to walk you through deploying a pair of AWS Lambda-backed custom resources for AWS CloudFormation so you can integrate the creation and modification of a Well-Architected workload as part of a CloudFormation deployment. One of the Lambda-backed custom resources is for workload creation and a second for selecting various best practices for questions in a Well-Architected pillar. Finally, you will deploy a sample Lambda/API Gateway application that also creates and updates the Well-Architected Tool.

The knowledge you acquire will help you learn how to programmatically access content in the Well-Architected tool in alignment with the [AWS Well-Architected Framework.](https://aws.amazon.com/architecture/well-architected/)

## Goals:

* Learn how to deploy AWS Lambda-backed custom resources to be used for Well-Architected workload deployments
* Utilize the custom resources in a sample AWS Lambda/API Gateway application.
* Understand how tagging can be used for both the Well-Architected Tool as well as the sample application

## Prerequisites:

* An
[AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to create new IAM roles, deploy Lambda function, and use Well-Architected Tool (WellArchitectedConsoleFullAccess managed policy)

## Costs
- The [Lambda functions](https://aws.amazon.com/lambda/pricing/) deployed in this lab should fit within the free tier usage assuming you haven't already consumed it.
- The [API Gateway](https://aws.amazon.com/api-gateway/pricing/) deployed in this lab should fit within the free tier usage assuming you haven't already consumed it.


## Time to complete
- The lab should take approximately 30 minutes to complete

{{< prev_next_button link_next_url="./1_deploy_cfn/" button_next_text="Start Lab" first_step="true" />}}

## Steps:
{{ children }}
