# Level 300: IAM Permission Boundaries Delegating Role Creation

## Introduction
This hands-on lab will guide you through the steps to configure an example AWS Identity and Access Management (IAM) permission boundary. AWS supports permissions boundaries for IAM entities (users or roles). A permissions boundary is an advanced feature in which you use a managed policy to set the maximum permissions that an identity-based policy can grant to an IAM entity. When you set a permissions boundary for an entity, the entity can perform only the actions that are allowed by the policy.
<br>
In this lab you will create a series of policies attached to a role that can be assumed by an individual such as a developer, the developer can then use this role to create additional user roles that are restricted to specific services and regions.
This allows you to delegate access to create IAM roles and policies, without them exceeding the permissions in the permission boundary. We will also use a naming standard with a prefix, making it easier to control and organize policies and roles that your developers create.  

The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Goals:
* IAM permission boundaries
* IAM policy conditions

## Prerequisites:
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

Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


