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
    ./scripts/create-dr-infra.sh <template bucket> <template prefix> <stack name> <REGION> <backup bucket name> <ingress prefix> <ingress CIDR> <backup ARN> <source table ARN> <target table name>

Note that we pass in the primary region as the fourth argument.  The `ingress CIDR` argument is the static IP for our example producer, which you can find in the output of the CFN stack used in the primary region.  The `source table ARN` argument can be found in the DynamoDB console, and the `target table name` argument is `processed_tweets`.  The `backup ARN` argument is optional in case you want to restore from a specific backup rather than using PITR; you can set it to a placeholder value like `arn` otherwise.

For example:

    ./scripts/create-dr-infra.sh backuprestore cfn BackupRestore us-west-2 MyBackupBucket MyPrefix 1.2.3.4/32 arn:aws:dynamodb:us-west-2:XXX:table/processed_tweets/backup/01628628265604-97d01acc arn:aws:dynamodb:us-west-2:XXX:table/processed_tweets processed_tweets

To update the stack, add the `--update` flag as the last argument.

### Start Analtyics Application

Now, navigate to Kinesis Analytics in the AWS Console in the backup region.  Click on the radio button for the application called `<stack name>-KinesisAnalyticsApplication` and select `Run`.

### Enable DynamoDB point-in-time recovery 

Navigate to DynamoDB in the AWS Console.  Select the `processed_tweets` table and go to `Backups`.  Enable PITR and save the changes.

![Point-in-time recovery](/Reliability/200_Backup_Restore_Failback_Analytics/Images/pitr1.png)

![Point-in-time recovery](/Reliability/200_Backup_Restore_Failback_Analytics/Images/pitr2.png)

{{< prev_next_button link_prev_url="../" link_next_url="../endpoint" />}}