# Level 100: AWS Account Setup
https://wellarchitectedlabs.com 

## Introduction
 This hands-on lab will guide you through the steps to create and setup an initial account structure, and enable access to billing reports. This will ensure that you can complete the Well-Architected Cost workshops, and enable you to optimize your workloads inline with the Well-Architected Framework.
 

## Goals
- Implement an account structure
- Configure billing services


## Prerequisites
- Multiple AWS accounts (at least two) 
- Root user access to the master account


## Permissions required
- Root user access to the master account
- [./Code/master_policy](./Code/master_policy.md) IAM policy required for Master account user
- [./Code/member_policy](./Code/member_policy.md) IAM policy required for Member account user 
- [./Code/IAM_policy](./Code/IAM_policy.md) IAM policy required to create the cost optimization team
- NOTE: There may be permission error messages during the lab, as the console may require additional privileges. These errors will not impact the lab, and we follow security best practices by implementing the minimum set of privileges required.


<BR>

## [Start the Lab!](Lab_Guide.md)

<BR>
<BR> 


## Best Practice Checklist
- [ ] Create a basic account structure, with a master (payer) account and at least 1 member (linked) account
- [ ] Configure account parameters
- [ ] Configure IAM access to billing information
- [ ] Configure a Cost and Usage Report (CUR)
- [ ] Enable AWS Cost Explorer
- [ ] Enable AWS-Generated Cost Allocation Tags
- [ ] Create a cost optimization team, to manage cost optimization across your organization

***

## License
Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
