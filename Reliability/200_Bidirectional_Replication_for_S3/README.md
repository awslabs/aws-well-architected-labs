# Level 200: Implementing Bi-Directional Cross-Region Replication for Amazon Simple Storage Service (Amazon S3)

<https://wellarchitectedlabs.com>

## Introduction

This hands-on lab will guide you through the steps to improve reliability of a service by performing automatic asynchronous backup of encrypted data you store in Amazon S3. Your Amazon S3 data will be securely backed up to a different AWS region.

The skills you learn will help you build resilient workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

![TwoReplicationRules](Images/TwoReplicationRules.png)

## Goals

By the end of this lab, you will be able to:

* Perform data backup automatically for objects in Amazon S3 buckets
* Secure and encrypt backups of objects in Amazon S3
* Automate disaster recovery (DR) of your objects in Amazon S3
* Query CloudTrail logs to improve your understanding of how cross-region replication works for Amazon S3

## Prequisites

If you are running the at an AWS sponsored workshop then you may be provided with an AWS Account to use, in which case the following pre-requisites will be satisfied by the provided AWS account.  If you are running this using your own AWS Account, then please note the following prerequisites:

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing. This account MUST NOT be used for production or other purposes.
* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to create IAM Polices and Roles, create S3 buckets and bucket policies, get and put objects into S3 buckets, and create and read CloudTrail trails and CloudWatch Log Groups.

NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

## [Start the Lab!](Lab_Guide.md)

***

## License

### Documentation License

Licensed under the [Creative Commons Share Alike 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license.

### Code LicenseLicensed under the Apache 2.0 and MITnoAttr License

Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
