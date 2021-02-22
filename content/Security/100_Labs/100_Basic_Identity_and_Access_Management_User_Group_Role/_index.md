---
title: "Creating your first Identity and Access Management User, Group, Role"
menutitle: "Identity and Access Management User, Group, Role"
date: 2020-09-16T11:16:08-04:00
chapter: false
weight: 2
---

**Last Updated:** February 2021

**Author:** Ben Potter, Security Lead, Well-Architected


{{% notice note %}}
This lab has been retired. It is strongly recommended you centralize your identities instead of using IAM Users. If you have more than a  single test account for personal use, use [AWS Single Sign-On](http://aws.amazon.com/single-sign-on) or an [identity provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers.html?ref=wellarchitected) configured in IAM, instead of IAM users. IAM users should not have access keys, for Command Line Interface (CLI) you should instead assume a role, or use [integration with AWS Single Sign-on](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html) making it easy to get short term credentials for CLI use without needing to store long lived credentials. Use separate accounts for development/test and production, If you don’t have an existing organizational structure with [AWS Organizations](https://aws.amazon.com/organizations/), [AWS Control Tower](https://aws.amazon.com/controltower/) is the easiest way to get started. For more information see [Security Foundations](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/security.html) and [Identity and Access Management](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/identity-and-access-management.html) in the [AWS Well-Architected](https://aws.amazon.com/architecture/well-architected/) security whitepaper.
{{% /notice %}}
