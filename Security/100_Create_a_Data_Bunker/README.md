# Level 100: Create a Data Bunker Account

[https://wellarchitectedlabs.com](https://wellarchitectedlabs.com )

## Introduction

In this lab we will create a secure data bunker. A data bunker is a secure account which will hold important security data in a secure location. Ensure that only members of your security team have access to this account. In this lab we will create a new logging account, create a secure S3 bucket in that account and then turn on CloudTrail for our organization to send these logs to the bucket in the secure data account. You may want to also think about what other data you need in there such as secure backups.

## Goals

- Create a secure S3 bucket to store logs in
- Create a new CloudTrail trail to write logs into the new bucket

## Prerequisites

* An multi-account structure with AWS Organizations has been setup for your organization
* You have access to a role with administrative access to the root account for your AWS Organization

NOTE: You will be billed for the AWS CloudTrail logs and Amazon S3 storage setup as part of this lab. See [AWS CloudTrail Pricing](https://aws.amazon.com/cloudtrail/pricing/) and [Amazon S3 Pricing](https://aws.amazon.com/s3/pricing/) for further details.

NOTE: If you are using AWS Control Tower the steps in this lab cover what has already been configured for the Control Tower [Log Archive Account](https://docs.aws.amazon.com/controltower/latest/userguide/how-control-tower-works.html#what-shared). The instructions in step 2 will help you create additional secure 


## Permissions required

- Create an S3 Bucket and enable Object Lock

## Costs

- TBA

## Time to complete

- The lab should take approximately 20-30 minutes to complete  

[![Start the lab](../../common/images/startthelab.png)](Lab_Guide.md)  

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2019-2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

[https://aws.amazon.com/apache2.0/](https://aws.amazon.com/apache2.0/)

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
