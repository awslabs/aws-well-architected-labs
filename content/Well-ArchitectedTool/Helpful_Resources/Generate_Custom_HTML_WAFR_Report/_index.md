---
title: "Generate a custom WellArchitected Framework HTML Report"
menutitle: "Custom WAF Report"
date: 2021-04-18T11:16:09-04:00
chapter: false
weight: 2
hidden: false
---

## Authors
- Eric Pullen, Performance Efficiency Lead Well-Architected

## Introduction

The purpose of this lab is to teach you how to use the AWS SDK for Python (Boto3) to copy create a Well-Architected Framework report in HTML. The python application in this lab will also show you how to incorporate the Improvement Plan text relevant for each of the unchecked best practices.

## Prerequisites:

* An
[AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to use Well-Architected Tool (WellArchitectedConsoleFullAccess managed policy).
* [Python 3.9+](https://www.python.org/)
* [AWS SDK for Python (Boto3) installed](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html)


## Costs:
* There are no costs for copying or creating new WellArchitected Reviews

## Steps:
{{ children }}

{{< prev_next_button link_next_url="./1_configure_env/" button_next_text="Start Lab" first_step="true" />}}
