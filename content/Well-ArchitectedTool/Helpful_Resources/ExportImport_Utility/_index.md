---
title: "Export and Import Workload Utility"
menutitle: "Export Import Utility"
date: 2021-05-19T11:16:09-04:00
chapter: false
weight: 4
hidden: false
---

## Authors
- Eric Pullen, Performance Efficiency Lead Well-Architected

## Introduction

The purpose of this lab is to teach you how to use the AWS SDK for Python (Boto3) to retrieve all of the questions, best practices, and improvement plan links for each lens and export the results to a JSON file or import all of the workload properties from a JSON file into the Well-Architected tool.

## Prerequisites:

* An
[AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to use Well-Architected Tool (WellArchitectedConsoleFullAccess managed policy).
* [Python 3.9+](https://www.python.org/)
* [AWS SDK for Python (Boto3) installed](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html)

## Costs:
* There are no costs for exporting or importing Well-Architected Reviews

## Steps:
{{% children /%}}

{{< prev_next_button link_next_url="./1_configure_env/" button_next_text="Start Lab" first_step="true" />}}
