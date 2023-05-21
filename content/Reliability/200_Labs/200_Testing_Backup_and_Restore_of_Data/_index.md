---
title: "Level 200: Testing Backup and Restore of Data"
menutitle: "Testing Backup and Restore"
description: "Create a strategy to backup data sources periodically using AWS Backup, and automate the testing of the restore process"
date: 2021-02-21T11:16:08-04:00
chapter: false
weight: 3
tags:
  - data_backup
---
## Authors

* Mahanth Jayadeva, Solutions Architect, Well-Architected

## Introduction

It is not sufficient to just create backups of data sources, you must also test these backups to ensure they can be used to recover data. A backup is useless if you are unable to restore your data from it. Testing the restore process after each backup will ensure you are aware of any issues that might arise during a restore down the line.

In this lab, you will create an EC2 Instance as a data source. You will then create a strategy to backup these data sources periodically using AWS Backup, and finally, automate the testing of the restore process as well as cleanup of resources using AWS Lambda.

The skills you learn will help you define a backup and restore plan in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## Goals:

* Create a Backup Strategy to ensure mission-critical data is being backed up regularly
* Test restoring from backups to ensure there are no data recovery issues
* Learn how to automate this process

## Prerequisites:

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An IAM user or role in your AWS account that has Administrator privileges.
Launch the CloudFormation Stack to provision resources that will act as data sources.

{{% notice note %}}
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

{{< prev_next_button link_next_url="./1_prerequisite/" button_next_text="Start Lab" first_step="true" />}}


## Steps:
{{< children  />}}
