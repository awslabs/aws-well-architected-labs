# Level 300: Splitting the CUR and Sharing Access
http://wellarchitectedlabs.com 

## Introduction
 This hands-on lab will guide you on how to automatically extract part of your CUR file, and then deliver it to another S3 bucket and folder to allow another account to access it. This is useful to allow sub accounts or business units to access their data, but not see the rest of the original CUR file. You can also exclude specific columns such as pricing - only allowing a sub account to view their usage information.


Common use cases are:

 - Separate linked account data, so each linked account can see only their data
 - Providing sub accounts their data without pricing
 - Separate out specific usage, by tag or service


The lab has been designed to configure a system that can expand easily, for any new requirement:

 - Create a new folder in S3 with the required bucket policy
 - Do the one-off back fill for previous months (if required)
 - Create the saved queries in Athena
 - Specify the permissions in the Lambda script
 
 
![Images/configuration.png](Images/configuration.png)

## Goals
- Automatically extract a portion of the CUR file each time it is delivered
- Deliver this to a location that is accessible to another account


## Prerequisites
- Multiple AWS Accounts (At least two)
- Billing reports auto update configured as per [300_Automated_CUR_Updates_and_Ingestion](../300_Automated_CUR_Updates_and_Ingestion/README.md) 


## Permissions required
- Create IAM policies and roles
- Create and modify S3 Buckets, including policies and events
- Create and modify Lambda functions
- Modify CloudFormation teamplates
- Create, save and execute Athena queries
- Create and run a Glue crawler


<BR>

## [Start the Lab!](Lab_Guide.md)

<BR>
<BR> 



***

## License
Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
