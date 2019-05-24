# Level 300: Multi Account CUR Access
http://wellarchitectedlabs.com 

## Introduction
 This hands-on lab will guide you through the different methods to share and analyze cost and usage data across accounts. This will ensure that all users and business units throughout your organization can access their cost and usage information, critical to ensuring they can track and further optimize their cost. 


## Goals
- Allow users in another account (either a member/linked or another master/payer) account, access to the (full) payer account cost and usage data


## Prerequisites
- Multiple AWS Accounts (At least two)
- Billing reports auto update configured as per [300_Automated_CUR_Updates_and_Ingestion](../300_Automated_CUR_Updates_and_Ingestion/README.md) 


## Permissions required
- IAM - create role, users, groups, and policies
- Modify S3 Bucket Policies
- Modify an existing Lambda function
- Upload a file to your S3 billing bucket


<BR>

## [Start the Lab!](Lab_Guide.md)

<BR>
<BR> 


## Best Practice Checklist
- [ ] Create a role to allow cross account least privilege access to resouces
- [ ] Serverless automated access configuration 


***

## License
Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
