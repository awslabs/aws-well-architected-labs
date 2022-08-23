---
title: "Primary Region"
date: 2020-04-28T10:02:27-06:00
weight: 20
---

## Primary Region

In this section we'll deploy the workload to the primary region.

### Create a prefix list for ingress

Follow the [instructions](https://docs.aws.amazon.com/vpc/latest/userguide/managed-prefix-lists.html#working-with-managed-prefix-lists) to create a VPC prefix list that specifies the CIDR ranges for ingress.  We use this prefix list to control access to lab resources from an approved network block.  If you are using an Event Engine account, you can create a prefix list that just contains `0.0.0.0/0`.

### Download and review scripts and templates

Download the following files:

* [create.sh](/Reliability/200_Backup_Restore_Failback_Analytics/Code/scripts/create.sh)
* [workload.yaml](/Reliability/200_Backup_Restore_Failback_Analytics/Code/cfn/workload.yaml)
* [tweetmaker.py](/Reliability/200_Backup_Restore_Failback_Analytics/Code/src/tweetmaker.py)
* [compaction.py](/Reliability/200_Backup_Restore_Failback_Analytics/Code/glue/compaction.py)

Let's review what's in these files.  You can open them in your favorite text editor to review in detail.  The CloudFormation script, `workload.yaml`, creates the analytics workload, including the S3 CRR policy.  The script accepts six groups of inputs, and we have provided sane default values for most of them.

* VPC networking parameters.  The defaults will work for most of these arguments, and the driver script `create.sh` will prompt for the others.
* The Global Accelerator endpoint name.  The default value should work well.
* AWS Glue database and table names.  The default values should be fine.
* Settings for the EC2 instance that we use as a tweet producer.  The default values should be fine.
* The shard count for the Kinesis streams we use.  The default values should be fine for this workshop.
* A tag value we use to identify resources used in this stack.  The default value should be fine.
* The bucket name we use to store data and a bucket name used for cross-region replication in the backup region.  Both of these arguments come from the previous section where we deployed some DR infrastructure in the backup region.

The `tweetmaker.py` script is the Python code that simulates sending incoming tweets to our endpoint.  The `compaction.py` script is code for a Glue ETL job that processes raw data into a more efficient storage format.

The `create.sh` script is purely for convenience.  It uploads `workload.yaml` and the Python scripts to the S3 template bucket, and then creates the CloudFormation stack, passing in the required input arguments.

In your working directory, place `create.sh` in a directory called `scripts` and place the file `workload.yaml` in a directory called `cfn`.  Place `tweetmaker.py` in a directory called `src` and `compaction.py` in a directory called `glue`.

### Deploy stack

Now create the stack in the primary region:

    export AWS_PROFILE=PRIMARY
    chmod +x ./scripts/create.sh
    ./scripts/create.sh <template bucket> <template prefix> <stack name> <REGION> <backup bucket name> <ingress prefix list> 

The input arguments are:

* `template bucket` - the name of the S3 bucket we created in the previous section.  We use it to store the CloudFormation templates and other data.
* `template prefix` - An S3 prefix we append to the CloudFormation template file names.  We use `cfn` as a convention.
* `stack name` - The name of the CloudFormation stack.  You can pick any suitable name.
* `REGION` - The primary region.  This argument is the region that the template bucket is in, and we created the template bucket in the primary region.
* `backup bucket name` - The name for the S3 bucket used for data replication.  Use the name of the backup bucket you created in the previous section.
* `ingress prefix list` - Use the identifier of the VPC prefix list you created for the primary region in the `Getting Started` section.

For example:

    ./scripts/create.sh backuprestore cfn BackupRestore us-west-2 MyBackupBucket MyPrefixList 

To update the stack, add the `--update` flag as the last argument.

{{< prev_next_button link_prev_url="../backupregion" link_next_url="../testworkload" />}}