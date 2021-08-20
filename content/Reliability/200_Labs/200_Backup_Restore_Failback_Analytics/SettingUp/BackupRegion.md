---
title: "Backup Region"
date: 2020-04-28T10:02:27-06:00
weight: 10
---

## Backup Region

In this section we'll deploy necessary infrastructure to the backup region to support data backup and workload failover.

### S3 bucket for templates

First, create an S3 bucket to hold the CloudFormation templates.  We'll call this the `TEMPLATEBUCKET`.

    aws s3 mb s3://<TEMPLATEBUCKET> --region <REGION>
    aws s3api put-bucket-versioning --bucket <TEMPLATEBUCKET> --versioning-configuration Status=Enabled

### Download and review scripts and templates

Download the following files:

* [create-dr.sh](/Reliability/200_Backup_Restore_Failback_Analytics/Code/scripts/create-dr.sh)
* [dr-data.yaml](/Reliability/200_Backup_Restore_Failback_Analytics/Code/cfn/dr-data.yaml)

Review these files and adjust any of the input parameters to suit your needs.

In your working directory, place `create-dr.sh` in a directory called `scripts` and place the file `dr-data.yaml` in a directory called `cfn`.

### Deploy stack

Now create the stack in the backup region:

    export AWS_PROFILE=BACKUP
    chmod +x ./scripts/create-dr.sh
    ./scripts/create-dr.sh <template bucket> <template prefix> <stack name> <REGION> <backup bucket name> <inventory bucket name> 

Note that we pass in the primary region as the fourth argument.

For example:

    ./scripts/create-dr.sh backuprestore cfn BackupRestore us-west-2 MyBackupBucket MyInventoryBucket 

To update the stack, add the `--update` flag as the last argument.

{{< prev_next_button link_prev_url="../" link_next_url="../primaryregion" />}}