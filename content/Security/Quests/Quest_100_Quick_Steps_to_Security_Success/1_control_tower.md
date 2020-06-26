---
title: "Control Tower"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
Leverage AWS ControlTower to create a set of Core AWS accounts and setup additional accounts for shared services such as build tools and individual environments for your workload. If you currently only have one account, create a new AWS account for your Control Tower master account and invite your existing account to join as a legacy AWS account. You can then migrate your workload to new accounts over time.

Control Tower applies a number of [Service Control Policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scp.html) to all accounts in your AWS Organization. This will prevent modification of AWS CloudTrail trails and AWS Config rule sets in addition to a number of actions on resources matching the pattern '\*aws-controltower\* or '\*AWSControlTower\*'. If you are enabling Control Tower in an existing account you can use an AWS Config conformance pack to evaluate how your accounts may be affected by some AWS Control Tower guardrails. See [AWS Control Tower Detective Guardrails as an AWS Config Conformance Pack](http://aws.amazon.com/blogs/mt/aws-control-tower-detective-guardrails-as-an-aws-config-conformance-pack). 

### Walk through

1. Understand [best practices for your AWS environment](https://aws.amazon.com/organizations/getting-started/best-practices/) and [plan your landing zone](https://docs.aws.amazon.com/controltower/latest/userguide/planning-your-deployment.html). If you are building your own landing zone you should mirror the [landing zone structure](https://docs.aws.amazon.com/controltower/latest/userguide/how-control-tower-works.html). This structure has a root account, specific accounts for logging and auditing, and allows for you to create an account per workload environment. If you are currently operating in a single account it is best practice to sign up for a new master account to enable Control Tower in and invite the existing account to join as a legacy account. This will allow you to continue to use your existing account as is but still apply baseline security controls and logging to it. If you are currently leveraging AWS Organizations it is best practice to sign up for a new master account if your current master account is used for purposes other than enabling Organizations and sharing identity. The only resources in your master account are those for enabling Control Tower, other guard rails and identity.

1. (If required) [Sign up for a new master account](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-sign-up-for-aws.html)
1. [Enable Control Tower](https://docs.aws.amazon.com/controltower/latest/userguide/getting-started-with-control-tower.html) on the master account for your organization
    * If you have an existing organization refer to the documentation on applying [Control Tower to existing organizations](https://docs.aws.amazon.com/controltower/latest/userguide/existing-orgs.html)
    * If you are not leveraging Control Tower, [create an AWS Organization](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_create.html) in the root account
1. Invite any existing AWS accounts by [enrolling an existing account in Control Tower](https://docs.aws.amazon.com/controltower/latest/userguide/enroll-account.html). If you are not using Control Tower then [invite an existing account to join your organization](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_invites.html)
1. For each additional AWS account required [use the account factory](https://docs.aws.amazon.com/controltower/latest/userguide/account-factory.html) to create a new account. Consider applying best practices as a baseline such as [lock away your AWS account root user access keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#lock-away-credentials) and [using multi-factor authentication](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html). If you are not leveraging Control Tower then
   * [Create a new account in organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_create.html). Make note of the organizations account access role.
   * [Create a new IAM role in the root account]( https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html) that has permission to assume that role to access the new AWS account
   *. [Setup a logging  account, secure Amazon S3 bucket and turn on your AWS Organization CloudTrail](../100_Create_a_Data_Bunker/README.md)
