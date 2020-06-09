---
title: "Level 300: Splitting the CUR and Sharing Access"
#menutitle: "Lab #3"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 4
---
## Authors
- Nathan Besh, Cost Lead, Well-Architected

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
 This hands-on lab will guide you on how to automatically extract part of your CUR file, and then deliver it to another S3 bucket and folder to allow another account to access it. This is useful to allow sub accounts or business units to access their data, but not see the rest of the original CUR file. You can also exclude specific columns such as pricing - only allowing a sub account to view their usage information.


Common use cases are:

 - Separate linked account data, so each linked account can see only their data
 - Providing sub accounts their data without pricing
 - Separate out specific usage, by tag or service


The lab has been designed to configure a system that can expand easily, for any new requirement:

 - Create a new folder in S3 with the required bucket policy
 - Do the one-off back fill for previous months (if required)
 - Create the saved queries in Athena
 - Specify the permissions in the Lambda script


![Images/configuration.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/configuration.png)

## Goals
- Automatically extract a portion of the CUR file each time it is delivered
- Deliver this to a location that is accessible to another account


## Prerequisites
- Multiple AWS Accounts (At least two)
- Billing reports auto update configured as per [300_Automated_CUR_Updates_and_Ingestion]({{< ref "/Cost/300_Labs/300_Automated_CUR_Updates_and_Ingestion" >}})


## Permissions required
- Create IAM policies and roles
- Create and modify S3 Buckets, including policies and events
- Create and modify Lambda functions
- Modify CloudFormation templates
- Create, save and execute Athena queries
- Create and run a Glue crawler

## Steps:
{{% children  %}}
