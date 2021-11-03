---
title: "Backup Region"
date: 2020-04-28T10:02:27-06:00
weight: 10
---

## Backup Region

In this section we'll deploy necessary infrastructure to the backup region to support data backup and workload failover.  

### S3 bucket for templates

First, create an S3 bucket to hold the CloudFormation templates.  We'll call this the `TEMPLATEBUCKET`.  Choose a globally unique bucket name that adheres to the [bucket naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html).

    aws s3 mb s3://<TEMPLATEBUCKET> --region <REGION>
    aws s3api put-bucket-versioning --bucket <TEMPLATEBUCKET> --versioning-configuration Status=Enabled

### Download and review scripts and templates

Download the following files:

* [create-dr.sh](/Reliability/200_Backup_Restore_Failback_Analytics/Code/scripts/create-dr.sh)
* [dr-data.yaml](/Reliability/200_Backup_Restore_Failback_Analytics/Code/cfn/dr-data.yaml)

Let's review what's in these files.  You can open them in your favorite text editor to review in detail.  The CloudFormation script, `dr-data.yaml`, creates the S3 buckets used for data replication and inventory, the AWS Glue metadata catalog and table definitions, and a Lambda function used to update metadata catalog partitions.  The script accepts eight input parameters.  Five of these are for the AWS Glue metadata catalog, and the default settings should be fine, although you are free to change them.  Another parameter defines a tag value that helps us identify resources used in this stack, and again the default value should be fine.  The last two parameters define the names of the S3 buckets that we use for data replication and for capturing S3 inventory.  We will pass in these parameters through the `create-dr.sh` script.

The `create-dr.sh` script is purely for convenience.  It uploads `dr-data.yaml` to the S3 template bucket, and then creates the CloudFormation stack, passing in the required input arguments.

In your working directory, place `create-dr.sh` in a directory called `scripts` and place the file `dr-data.yaml` in a directory called `cfn`.

### Deploy stack

Now create the stack in the backup region:

    export AWS_PROFILE=BACKUP
    chmod +x ./scripts/create-dr.sh
    ./scripts/create-dr.sh <template bucket> <template prefix> <stack name> <REGION> <backup bucket name> <inventory bucket name> 

The input arguments are:

* `template bucket` - the name of the S3 bucket we created earlier in this section.  We use it to store the CloudFormation templates and other data.
* `template prefix` - An S3 prefix we append to the CloudFormation template file names.  We use `cfn` as a convention.
* `stack name` - The name of the CloudFormation stack.  You can pick any suitable name.
* `REGION` - The primary region.  This argument is the region that the template bucket is in, and we created the template bucket in the primary region.
* `backup bucket name` - The name for the S3 bucket used for data replication.  You can pick any globally unique name that satisfies the S3 bucket naming rules.
* `inventory bucket name` - The name for the S3 bucket used for S3 inventory.  You can pick any globally unique name that satisfies the S3 bucket naming rules.

For example:

    ./scripts/create-dr.sh backuprestore cfn BackupRestore us-west-2 MyBackupBucket MyInventoryBucket 

To update the stack, add the `--update` flag as the last argument.

{{< prev_next_button link_prev_url="../" link_next_url="../primaryregion" />}}