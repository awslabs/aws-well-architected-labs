---
title: "Export Well-Architected content to XLSX Spreadsheet"
menutitle: "Export to XLSX"
date: 2021-05-04T11:16:09-04:00
chapter: false
weight: 3
hidden: false
---

## Authors
- Eric Pullen, Performance Efficiency Lead Well-Architected

## Introduction

The purpose of this lab is to teach you how to use the AWS SDK for Python (Boto3) to retrieve all of the questions, best practices, and improvement plan links for each lens and export the results to a XLSX spreadsheet.  You can use this spreadsheet to prepare for upcoming Well-Architected reviews or to utilize WA reviews in non-supported regions.

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
