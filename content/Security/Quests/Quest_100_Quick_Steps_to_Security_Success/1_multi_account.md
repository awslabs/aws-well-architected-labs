---
title: "Multi-Account Strategy"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
Implementing multiple accounts for our workload improves our security by limiting the blast radius of any potential breaches and separating our workload into discrete accounts.

Leverage AWS Organizations to create separate AWS accounts for a sandbox, your workload, a secure “data bunker” for audit logs and backups, and a shared services account for common tools. If you currently only have one account, create a new AWS account for your organizations master AWS account and invite your existing account to join as your sandbox AWS account.

By the end of this step you will have a separate AWS account for:

* Organizations root account – used only for identity and billing
* Shared services – for common tools such as deployment tooling
* Workload accounts – customers who have a single product will have a separate AWS account for each environment. If you have multiple workloads, or you rely on account separation for separation of customer data you will want to set up further accounts to reflect your structure

### Walkthrough

1. [Define your multi-account strategy](https://d0.awsstatic.com/aws-answers/AWS_Multi_Account_Security_Strategy.pdf). A suggested structure is shown below. If you do not current have AWS Organizations setup it is recommended that you use your existing account as a sandbox

![Suggested account structure](/Security/Quests/Quest_100_Quick_Steps_to_Security_Success/Images/multi-account-suggestion.png)

2. (If required) [Sign up a new root account](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-sign-up-for-aws.html)
3. [Create an AWS Organization](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_create.html) in the root account
4. Invite any existing accounts
4. For each AWS account required
   * [Create a new account in organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_create.html). Make note of the organizations account access role.
   * [Create a new IAM role in the root account]( https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html) that has permission to assume that role to access the new AWS account
   * Consider applying best practices as a baseline such as [lock away your AWS account root user access keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#lock-away-credentials) and [using multi-factor authentication](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html)
