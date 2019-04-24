# Quest: One Day to Better Security

## About this Guide
This quest is for you to improve your security posture. Every stakeholder involved in your organisation and product or service is entitled to make use of a secure platform. Security is important to earn the trust with your customers and your providers. A secure environment also helps to protect your intellectual property. Each set of activities can be done in one day or split over a week in your lunch break. By the end of the quest we will have a set of accounts with security best practices applied, ready to develop your product in knowing that when you launch your workload you have secure foundations in place.

## Step 1 - Multi-Account Strategy
Implementing multiple accounts for our workload improves our security by limiting the blast radius of any potential breaches and separating our workload into discrete accounts.

Leverage AWS Organisations to create separate AWS accounts for a sandbox, your workload, a secure “data bunker” for audit logs and backups, and a shared services account for common tools. If you currently only have one account, create a new AWS account for your organisations master AWS account and invite your existing account to join as your sandbox AWS account.

By the end of this step you will have a separate AWS account for:
* Organisations root account – used only for identity and billing
* Shared services – for common tools such as deployment tooling
* Workload accounts – customers who have a single product will have a separate AWS account for each environment. If you have multiple workloads, or you rely on account separation for separation of customer data you will want to set up further accounts to reflect your structure

### Walkthrough
1. [Define your multi-account strategy](https://aws.amazon.com/answers/account-management/aws-multi-account-security-strategy/)
2. (If required) [Sign up a new root account](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-sign-up-for-aws.html)
3. [Create an AWS Organisations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_create.html) in the root account
4. Invite any existing accounts 
4. For each AWS account required
   * [Create a new account in organisations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_create.html). Make note of the organisations account access role.
   * Create a new role for accessing that AWS account

## Step 2 - Identity
Every user must leverage unique credentials so we can trace actions within our accounts. Setup your identity structure in the master account and use cross account access to access the child accounts. As you create roles for your users ensure that you are implementing least privilege access by ensuring that users only have access to perform actions required for their role. Be careful who you give IAM permissions to as they can create their own permissions.

### Walkthrough
1. Credentials audit
2. [Add multi factor authentication to root](../100_AWS_Account_and_Root_User/README.md)
3. Federate Identity Using SAML
   * [Leveraging a SAML provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_enable-console-saml.html)
4. [Use cross account access roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html) that we setup in Step 1.

## Step 3 - Data Bunker
Now we will create a data bunker account to store secure read only security logs and backups. In this step we will send our logs from CloudTrail to that account. The role for accessing this account will have read only access. Only ensure that this role can be accessed by those with a security role in your organisation.

### Walkthrough ** New Lab? **
1. Create a Security account
2. Create a security role
3. Create a target bucket for CloudTrail
4. Turn on CloudTrail (CloudFormation?)

## Step 4 - Setup organisations policies
### Walkthrough
1. Block public S3 buckets
2. Prevent CloudTrail from being removed
Config?
Block access keys?
Regions?

## Step 5 - Detection and Alerting

### Walkthrough
Guard duty?
1. Lab - Enable security hub + alert on it (being worked on)
2. Lab - Setup some AWS Config rules in production

## Additional Resources
* Permission Boundaries

***

## License
Licensed under the Apache 2.0 and MITnoAttr License. 

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
