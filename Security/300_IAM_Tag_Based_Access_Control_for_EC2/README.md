# Level 300: IAM Tag Based Access Control for EC2

## Introduction
This hands-on lab will guide you through the steps to configure example AWS Identity and Access Management (IAM) policies, and a AWS IAM role with associated permissions to use EC2 resource tags for access control. Using tags is powerful as it helps you scale your permission management, however you need to be careful about the management of the tags which you will learn in this lab.
<br>
In this lab you will create a series of policies attached to a role that can be assumed by an individual such as an EC2 administrator. This allows the EC2 administrator to create tags when creating resources only if they match the requirements, and control which existing resources and values they can tag.

The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Goals:
* IAM least privilege
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

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


