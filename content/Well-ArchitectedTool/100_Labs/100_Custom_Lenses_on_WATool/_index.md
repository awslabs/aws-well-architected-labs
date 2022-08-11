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

Since November 2021, the Well-Architected Tool has included the ability to create [custom lenses,](https://docs.aws.amazon.com/wellarchitected/latest/userguide/lenses-custom.html) which are capable of tailoring a review to a customers specific needs. Within a custom lens, customers can create their own pillars, questions, best practices, helpful resources and improvement plans. Custom lenses can also specify rules which are used to determine if a high or medium risk issues is flagged. Customers can then provide their own guidance for resolving the risk. Custom lenses can be shared across multiple AWS accounts for more visibility.

This lab introduces the AWS Well-Architected Tool's [Custom lenses feature](https://docs.aws.amazon.com/wellarchitected/latest/userguide/lenses-custom.html). Using [Amazon DynamoDB Configuration Checks as the example](https://github.com/aws-samples/custom-lens-wa-sample), we demonstrate how a self-defined pillar and questions structure can be used for a domain-specific review.

## Goals:

* Learn how to build custom lenses for domain-specific reviews.
* Understand the difference between a Well-Architected Framework Review and a Custom Lens Review.

## Prerequisites:

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An Identity and Access Management (IAM) user or federated credentials that have permissions to access the AWS Well-Architected Tool with the [**WellArchitectedConsoleFullAccess**](https://docs.aws.amazon.com/wellarchitected/latest/userguide/iam-auth-access.html) managed policy.

## Costs:
* There are no costs for this lab
* [AWS Pricing](https://aws.amazon.com/pricing/)

## Time to complete
- The lab should take approximately 30 minutes to complete 

## References & Blogs:
* [AWS Well-Architected Custom Lenses: Extend the Well-Architected Framework with Your Internal Best Practices](https://aws.amazon.com/blogs/aws/well-architected-custom-lenses-internal-best-practices/)
* [Implementing the AWS Well-Architected Custom Lens lifecycle in your organization](https://aws.amazon.com/blogs/architecture/implementing-the-aws-well-architected-custom-lens-lifecycle-in-your-organization/)

## Steps:
{{% children /%}}

{{< prev_next_button link_next_url="./1_ddb_config_pillars_and_bps/" button_next_text="Start Lab" first_step="true" />}}
