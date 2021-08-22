---
title: "Primary Region"
date: 2020-04-28T10:02:27-06:00
weight: 20
---

## Primary Region

In this section we'll deploy the workload to the primary region.

### Create a prefix list for ingress

Follow the [instructions](https://docs.aws.amazon.com/vpc/latest/userguide/managed-prefix-lists.html#working-with-managed-prefix-lists) to create a VPC prefix list that specifes the CIDR ranges for ingress.  We use this prefix list to control access to lab resources from an approved network block.  If you are using an Event Engine account, you can create a prefix list that just contains `0.0.0.0/0`.

### Download and review scripts and templates

Download the following files:

* [create.sh](/Reliability/200_Backup_Restore_Failback_Analytics/Code/scripts/create.sh)
* [workload.yaml](/Reliability/200_Backup_Restore_Failback_Analytics/Code/cfn/workload.yaml)
* [tweetmaker.py](/Reliability/200_Backup_Restore_Failback_Analytics/Code/src/tweetmaker.py)
* [compaction.py](/Reliability/200_Backup_Restore_Failback_Analytics/Code/glue/compaction.py)

Review these files and adjust any of the input parameters to suit your needs.

In your working directory, place `create.sh` in a directory called `scripts` and place the file `workload.yaml` in a directory called `cfn`.  Place `tweetmaker.py` in a directory called `src` and `compation.py` in a directory called `glue`.

### Deploy stack

Now create the stack in the primary region:

    export AWS_PROFILE=PRIMARY
    chmod +x ./scripts/create.sh
    ./scripts/create.sh <template bucket> <template prefix> <stack name> <REGION> <backup bucket name> <ingress prefix list> 

Note that we pass in the primary region as the fourth argument.

For example:

    ./scripts/create.sh backuprestore cfn BackupRestore us-west-2 MyBackupBucket MyPrefixList 

To update the stack, add the `--update` flag as the last argument.

{{< prev_next_button link_prev_url="../backupregion" link_next_url="../testworkload" />}}