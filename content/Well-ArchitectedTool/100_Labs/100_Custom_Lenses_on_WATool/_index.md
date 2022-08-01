---
title: "Level 100: Custom Lenses on AWS Well-Architected Tool"
#menutitle: "Lab #2"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 2
hidden: false
---
## Authors
- Bob Yeh, AWS Well-Architected Geo SA
- Duncan Bell, AWS Well-Architected Geo SA
- Ray Wang, Solutions Architect, Analytics SME 

## Introduction

The AWS Well-Architected Tool supports [Custom lenses](https://docs.aws.amazon.com/wellarchitected/latest/userguide/lenses-custom.html) in Nov 2021, providing a consolidated view and a consistent way to measure and improve workloads on AWS without relying on spreadsheets or third-party systems.

This lab introduces the AWS Well-Architected Tool's [Custom lenses feature](https://docs.aws.amazon.com/wellarchitected/latest/userguide/lenses-custom.html). Using [Amazon DynamoDB Configuration Checks as the example](https://github.com/aws-samples/custom-lens-wa-sample), we demonstrate how a self-defined pillar and questions structure can be used for a domain-specific review.

## Goals:

* Learn how to build custom lenses for domain-specific reviews.
* Use the example to understand the difference between a Well-Architected Framework Review and a Custom Lenses Review.

## Prerequisites:

* An
[AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to use the AWS Well-Architected Tool [**(WellArchitectedConsoleFullAccess managed policy)**](https://docs.aws.amazon.com/wellarchitected/latest/userguide/iam-auth-access.html).

## Costs:
* There are no costs for this lab
* [AWS Pricing](https://aws.amazon.com/pricing/)

## Time to complete
- The lab should take approximately 30 minutes to complete 

## References:
* AWS News Blog: [AWS Well-Architected Custom Lenses: Extend the Well-Architected Framework with Your Internal Best Practices](https://aws.amazon.com/blogs/aws/well-architected-custom-lenses-internal-best-practices/)
* AWS Architecture Blog: [Implementing the AWS Well-Architected Custom Lens lifecycle in your organization](https://aws.amazon.com/blogs/architecture/implementing-the-aws-well-architected-custom-lens-lifecycle-in-your-organization/)

## Steps:
{{% children /%}}

{{< prev_next_button link_next_url="./1_ddb_config_pillars_and_bps/" button_next_text="Start Lab" first_step="true" />}}
