---
title: "Primary Region"
date: 2020-04-28T10:02:27-06:00
weight: 20
---

## Primary Region

In this section we'll deploy the workload to the primary region.

Review the files `scripts/create.sh` and the CloudFormation templates in the `cfn/` directory. Adjust any CloudFormation variables to suit your preferences.  

Now create the stack:

    export AWS_PROFILE=PRIMARY
    ./scripts/create.sh <template bucket> <template prefix> <stack name> <REGION>

For example:

    ./scripts/create.sh backuprestore cfn BackupRestore us-west-2

To update the stack, add the `--update` flag as the last argument.