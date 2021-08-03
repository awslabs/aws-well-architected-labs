---
title: "Backup Region Infrastructure"
date: 2020-04-28T10:02:27-06:00
weight: 10
---

## Workload in the Backup Region

If we've decided to fail over to the backup region, the first thing we need to do is deploy the rest of the workload in the backup region.

### Download and review scripts and templates

Download the following files:

* [create-dr-infra.sh](/Reliability/200_Backup_Restore_Failback_Analytics/Code/scripts/create-dr-infra.sh)
* [dr-infra.yaml](/Reliability/200_Backup_Restore_Failback_Analytics/Code/cfn/dr-infra.yaml)

Review these files and adjust any of the input parameters to suit your needs.

In your working directory, place `create-dr-infra.sh` in a directory called `scripts` and place the file `dr-infra.yaml` in a directory called `cfn`.

### Deploy stack

Now create the stack in the backup region:

    export AWS_PROFILE=BACKUP
    chmod +x ./scripts/create-dr-infra.sh
    ./scripts/create-dr-infra.sh <template bucket> <template prefix> <stack name> <REGION> <backup bucket name> <ingress prefix> <ingress CIDR> 

Note that we pass in the primary region as the last argument.  The `ingress CIDR` argument is the static IP for our example producer, which you can find in the output of the CFN stack used in the primary region.

For example:

    ./scripts/create-dr-infra.sh backuprestore cfn BackupRestore us-west-2 MyBackupBucket MyPrefix 1.2.3.4/32 

To update the stack, add the `--update` flag as the last argument.

{{< prev_next_button link_prev_url="../" link_next_url="../endpoint" />}}