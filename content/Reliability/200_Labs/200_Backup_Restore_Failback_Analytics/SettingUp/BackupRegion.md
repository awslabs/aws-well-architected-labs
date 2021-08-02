---
title: "Backup Region"
date: 2020-04-28T10:02:27-06:00
weight: 10
---

## Backup Region

In this section we'll deploy necessary infrastructure to the backup region to support data backup and workload failover.

First, clone this repository and go into the repository directory.

Next, create an S3 bucket to hold the CloudFormation templates.

    aws s3 mb s3://<template bucket> --region <REGION>

Enable versioning on this bucket in the console.

Review the files `scripts/create-dr.sh` and the CloudFormation templates in the `cfn/` directory. Adjust any CloudFormation variables to suit your preferences.  

Now create the stack in the backup region:

    export AWS_PROFILE=BACKUP
    ./scripts/create-dr.sh <template bucket> <template prefix> <stack name> <REGION>

Note that we pass in the primary region as the last argument.

For example:

    ./scripts/create-dr.sh backuprestore cfn BackupRestore us-west-2

To update the stack, add the `--update` flag as the last argument.