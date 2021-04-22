---
title: "Copy a workload from one account or region to another"
menutitle: "Copying a WA Workload"
date: 2021-04-18T11:16:09-04:00
chapter: false
weight: 1
hidden: false
---

## Authors
- Eric Pullen, Performance Efficiency Lead Well-Architected

## Introduction

The purpose of this lab is to teach you how to use the AWS SDK for Python (Boto3) to copy a Well-Architected review to a new location. The python application in this lab allows you to copy a workload between accounts, regions, or a combination of both.

## Prerequisites:

* An
[AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to use Well-Architected Tool (WellArchitectedConsoleFullAccess managed policy).
* [Python 3.9+](https://www.python.org/)
* [AWS SDK for Python (Boto3) installed](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/quickstart.html)

## Costs:
* There are no costs for copying or creating new WellArchitected Reviews

## Steps:
{{% children /%}}
