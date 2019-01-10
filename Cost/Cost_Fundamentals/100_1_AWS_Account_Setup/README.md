# Level 100: AWS Account Setup

## Introduction
 This hands-on lab will guide you through the steps to create and setup an initial account structure, and enable access to billing reports. This will ensure that you can complete the Well-Architected Cost workshops, and enable you to optimize your workloads inline with the Well-Architected Framework.
 

## Goals
- Implemenet an account structure
- Configure billing services


## Prerequisites
- Multiple AWS accounts (at least two) 
- Root user access to the master account

## Overview

- [Lab Guide.md](Lab Guide.md) the guide for this lab
- [Checklist.md](Checklist.md) best practice checklist related to this lab
- [/Code](Code/) including CloudFormation templates related to this lab
- [/Images](Images/) referenced by this lab

## Permissions required

- Root user access to the master account
- [./Code/master_policy](./Code/master_policy) IAM policy required for Master account user
- [./Code/member_policy](./Code/member_policy) IAM policy required for Member account user 
- NOTE: There may be permission error messages during the lab, as the console may require additional privileges. These errors will not impact the lab, and we follow security best practices by implementing the minimum set of privileges required.


## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
