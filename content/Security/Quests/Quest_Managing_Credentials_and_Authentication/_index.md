---
title: "Quest: Managing Credentials & Authentication"
menutitle: "Managing Credentials & Authentication"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 6
description: " "
---
## Authors

- Ben Potter, Security Lead, Well-Architected

## About this Guide

This guide will help you improve your security in the AWS Well-Architected area of [Identity & Access Management](https://wa.aws.amazon.com/wat.pillar.security.en.html#sec.iaam). The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

***

## New AWS Account Setup and Securing Root User

### Walkthrough

This hands-on lab will guide you through the introductory steps to configure a new AWS account and secure the root user.

### [AWS Account and Root User](/security/100_labs/100_aws_account_and_root_user/)

### Further Considerations

* Federate Identity Using SAML: [Leveraging a SAML provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_enable-console-saml.html)
* Separate production, non-production and different workloads using different AWS accounts: [AWS Multiple Account Billing Strategy](https://aws.amazon.com/answers/account-management/aws-multi-account-billing-strategy/)

## Basic Identity and Access Management User, Group, Role

### Walkthrough

This hands-on lab will guide you through the introductory steps to configure AWS Identity and Access Management (IAM).
You will use the AWS Management Console to guide you through how to configure your first IAM user, group and role for administrative access.

### [Basic Identity and Access Management User, Group, Role](/security/100_labs/100_basic_identity_and_access_management_user_group_role/)

## Automated IAM User Cleanup

### Walkthrough
This hands-on lab will guide you through the steps to deploy an AWS Lambda function with [AWS Serverless Application Model (SAM)](https://aws.amazon.com/serverless/sam/) to provide regular insights on IAM User/s and AWS Access Key usage within your account.

### [IAM Tag Based Access Control for EC2](/security/200_labs/200_automated_iam_user_cleanup/)

## IAM Permission Boundaries Delegating Role Creation

### Walkthrough

This hands-on lab will guide you through the steps to configure an example AWS Identity and Access Management (IAM) permission boundary. AWS supports permissions boundaries for IAM entities (users or roles). A permissions boundary is an advanced feature in which you use a managed policy to set the maximum permissions that an identity-based policy can grant to an IAM entity. When you set a permissions boundary for an entity, the entity can perform only the actions that are allowed by the policy.
In this lab you will create a series of policies attached to a role that can be assumed by an individual such as a developer, the developer can then use this role to create additional user roles that are restricted to specific services and regions.
This allows you to delegate access to create IAM roles and policies, without them exceeding the permissions in the permission boundary. We will also use a naming standard with a prefix, making it easier to control and organize policies and roles that your developers create.

### [IAM Permission Boundaries Delegating Role Creation](/security/300_labs/300_iam_permission_boundaries_delegating_role_creation/)

## IAM Tag Based Access Control for EC2

### Walkthrough

This hands-on lab will guide you through the steps to configure example AWS Identity and Access Management (IAM) policies, and a AWS IAM role with associated permissions to use EC2 resource tags for access control. Using tags is powerful as it helps you scale your permission management, however you need to be careful about the management of the tags which you will learn in this lab.
In this lab you will create a series of policies attached to a role that can be assumed by an individual such as an EC2 administrator. This allows the EC2 administrator to create tags when creating resources only if they match the requirements, and control which existing resources and values they can tag.

### [IAM Tag Based Access Control for EC2](/security/300_labs/300_iam_tag_based_access_control_for_ec2/)
