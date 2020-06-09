---
title: "Level 300: Automated CUR Updates and Ingestion"
#menutitle: "Lab #1"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 2
hidden: false
---
## Authors
- Nathan Besh, Cost Lead, Well-Architected
- Derrick Gold, Software Development Engineer, AWS Insights

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
 This hands-on lab will guide you through the steps to enable automated updates of your CUR files into Athena. The skills you learn will help you perform cost and usage analysis in alignment with the AWS Well-Architected Framework.

![Images/Setup.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/Setup.png)

## Goals
- Automatically update the CUR table in Athena/Glue when a new report arrives
- Automatically update the CUR table for multiple Cost and Usage Reports in the same bucket


## Prerequisites
- An AWS Account
- CUR enabled and delivered into S3, with Athena integration
- 6-12 months AWS experience, able to navigate the console, and have an understanding of the underlying services and features


## Steps:
{{% children  %}}

## Best Practice Checklist
- [ ] Run the CloudFormation template to update a single CUR in AWS Glue/Athena
- [ ] Modify and run a CloudFormation template to update multiple CURs in AWS Glue/Athena
