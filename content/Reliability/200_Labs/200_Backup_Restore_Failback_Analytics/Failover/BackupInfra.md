---
title: "Backup Region Infrastructure"
date: 2020-04-28T10:02:27-06:00
weight: 10
---

## Workload in the Backup Region

If we've decided to fail over to the backup region, the first thing we need to do is deploy the rest of the workload in the backup region.

Review the files `scripts/create-dr-infra.sh` and the CloudFormation templates in the `cfn/` directory. Adjust any CloudFormation variables to suit your preferences.  You must update at least the following:

* `AllowedPrefixIngress`: Set this to a prefix list that represents your producer traffic
* `AllowedCidrIngress`: Set this to the value found in the output of the primary region's CFN stack.  It's the static IP for our example producer.
* `BackupBucket`: Set this to the name of the S3 bucket in the backup region

Now create the stack in the backup region:

    ./scripts/create-dr-infra.sh <template bucket> <template prefix> <stack name> <REGION>

Again note that the last argument is the primary region.

For example:

    ./scripts/create-dr-infra.sh backuprestore cfn BackupRestoreInfra us-west-2

To update the stack, add the `--update` flag as the last argument.