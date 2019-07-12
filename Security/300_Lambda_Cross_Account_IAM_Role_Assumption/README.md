# Level 300: Lambda Cross Account IAM Role Assumption

## Introduction

This lab demonstrates a Lambda function in AWS account 1 (the origin) using Python boto SDK to assume an IAM role in account 2 (the destination), then list the buckets. If you only have 1 AWS account simply repeat the instructions in that account and use the same account id.

If in classroom and you do not have 2 AWS accounts, buddy up to use each other's accounts, agree who will be account #1 and who will be account #2.

The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Goals

* Cross account role assumption
* Lambda assuming another role

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An IAM user with MFA enabled that can assume roles in your AWS account.
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

## Permissions required

* IAM User with AdministratorAccess AWS managed policy

<BR>

## [Start the Lab!](Lab_Guide.md)

<BR>
<BR>

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


