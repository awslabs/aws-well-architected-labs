---
title: "Creating your first Identity and Access Management User, Group, Role"
menutitle: "Identity and Access Management User, Group, Role"
date: 2020-09-16T11:16:08-04:00
chapter: false
weight: 2
---

**Last Updated:** September 2020

**Author:** Ben Potter, Security Lead, Well-Architected


## Introduction

This hands-on lab will guide you through the introductory steps to configure AWS Identity and Access Management (IAM).
You will use the AWS Management Console to guide you through how to configure your first IAM user, group and role for administrative access. The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

{{% notice note %}}
It is strongly recommended you centralize your identities instead of using IAM Users and Groups as outlined in this lab. If you have more than a  single test account for personal use, use [AWS Single Sign-On](http://aws.amazon.com/single-sign-on) or an [identity provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers.html?ref=wellarchitected) configured in IAM, instead of IAM users. IAM users should not have access keys, for Command Line Interface (CLI) you should instead assume a role, or use [integration with AWS Single Sign-on](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html) making it easy to get short term credentials for CLI use without needing to store long lived credentials. Use separate accounts for development/test and production, If you don’t have an existing organizational structure with [AWS Organizations](https://aws.amazon.com/organizations/), [AWS Control Tower](https://aws.amazon.com/controltower/) is the easiest way to get started. For more information see [Security Foundations](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/security.html) and [Identity and Access Management](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/identity-and-access-management.html) in the [AWS Well-Architected](https://aws.amazon.com/architecture/well-architected/) security whitepaper.
{{% /notice %}}

## Prerequisites

- An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing.
- Permissions to create resources in IAM, or the root user if you are just getting started.

## Costs

- There are no costs for this lab
- [AWS Pricing](https://aws.amazon.com/pricing/)

## Steps:
{{% children  %}}

## References & Useful Resources

* [AWS Tasks That Require Root User](https://docs.aws.amazon.com/general/latest/gr/aws_tasks-that-require-root.html)
* [Credential Report](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_getting-report.html)
* [AWS Identity and Access Management User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
* [IAM Best Practices and Use Cases](https://docs.aws.amazon.com/IAM/latest/UserGuide/IAMBestPracticesAndUseCases.html)
