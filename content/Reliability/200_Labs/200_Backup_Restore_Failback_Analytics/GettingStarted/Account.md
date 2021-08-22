---
title: "Prerequisites"
date: 2020-04-28T10:02:27-06:00
weight: 10
---

## Prerequisites

To run this workshop, you need an AWS account, and a user identity with access to the following services:

* Glue
* S3
* Athena
* DynamoDB
* Global Accelerator
* EC2 and ELB
* Lambda
* Kinesis

You can use your own account, or an account provided through Event Engine as part of an AWS organized workshop.  Using an account provided by Event Engine is the easier path, as you will have full access to all AWS services, and the account will terminate automatically when the event is over.

You should also have familiarity with using the AWS CLI, including configuring the CLI for a specific account and region profile.  If not, please follow the [CLI setup instructions](https://github.com/aws/aws-cli).  Make sure you have a default profile set up; you may need to run `aws configure` if you have never set up the CLI before.

### Account setup 

#### Using an account provided through Event Engine

If you are running this workshop as part of an Event Engine lab, please log into the console using [this link](https://dashboard.eventengine.run/) and enter the hash provided to you as part of the workshop.

#### Using your own AWS account

If you are using your own AWS account, be sure you have access to create and manage resources in the services noted above.

*After completing the workshop, remember to complete the [cleanup](../../next) section to remove any unnecessary AWS resources.*

#### Note your account and region

After you have your account identified, pick a primary AWS region to work in, such as `us-west-2`.  We'll refer to this as `REGION` going forward.  Then pick a backup region, such as `us-east-2`.  We'll refer to this as `BACKUPREGION` going forward.

##### CLI Profiles 

Set up two CLI profiles, one for the primary region and one for the backup region.  We'll refer to these as `PRIMARY` and `BACKUP` going forward.

In this example `PRIMARY=us-west-2` and `BACKUP=us-east-2`.  Choose whichever regions you prefer.

```
$ aws configure --profile BACKUP
AWS Access Key ID [None]: <<provide access key id>>
AWS Secret Access Key [None]: <<provide access key >>
Default region name [None]: us-east-2
Default output format [None]: 
```

```
$ aws configure --profile PRIMARY
AWS Access Key ID [None]: <<provide access key id>>
AWS Secret Access Key [None]: <<provide access key >>
Default region name [None]: us-west-2
Default output format [None]: 
```

For more details refer to the [CLI documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).

##### Regions

This workshop should work in `us-east-1`, `us-east-2`, or `us-west-2`.  You can likely use it in other regions but may have to make some minor adjustments to the CloudFormation templates.

##### Account Number
Also note your AWS account number.  You find this in the console or by running `aws sts get-caller-identity` on the CLI.  We'll refer to this as `ACCOUNT` going forward.

##### Managed Prefix List

You will have to create two prefix list in each region, one in the backup region and another one in the primary region. 

For instructions on creating prefix list, refer to the [documentation](https://docs.aws.amazon.com/vpc/latest/userguide/managed-prefix-lists.html).

{{< prev_next_button link_prev_url="../" link_next_url="../architecture" />}}

