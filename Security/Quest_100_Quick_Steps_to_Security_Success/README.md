# Quest: One Day to Better Security

## About this Guide

This quest is for you to improve your security posture. Every stakeholder involved in your organization and product or service is entitled to make use of a secure platform. Security is important to earn the trust with your customers and your providers. A secure environment also helps to protect your intellectual property. Each set of activities can be done in one day or split over a week in your lunch break. By the end of the quest we will have a set of accounts with security best practices applied, ready to develop your product in knowing that when you launch your workload you have secure foundations in place.

## Step 1 - Multi-Account Strategy

Implementing multiple accounts for our workload improves our security by limiting the blast radius of any potential breaches and separating our workload into discrete accounts.

Leverage AWS Organizations to create separate AWS accounts for a sandbox, your workload, a secure “data bunker” for audit logs and backups, and a shared services account for common tools. If you currently only have one account, create a new AWS account for your organizations master AWS account and invite your existing account to join as your sandbox AWS account.

By the end of this step you will have a separate AWS account for:

* Organizations root account – used only for identity and billing
* Shared services – for common tools such as deployment tooling
* Workload accounts – customers who have a single product will have a separate AWS account for each environment. If you have multiple workloads, or you rely on account separation for separation of customer data you will want to set up further accounts to reflect your structure

### Walkthrough

1. [Define your multi-account strategy](https://d0.awsstatic.com/aws-answers/AWS_Multi_Account_Security_Strategy.pdf). A suggested structure is shown below. If you do not current have AWS Organizations setup it is recommended that you use your existing account as a sandbox

![Suggested account structure](Images/multi-account-suggestion.png)

2. (If required) [Sign up a new root account](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-sign-up-for-aws.html)
3. [Create an AWS Organization](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_create.html) in the root account
4. Invite any existing accounts
4. For each AWS account required
   * [Create a new account in organizations](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_create.html). Make note of the organizations account access role.
   * [Create a new IAM role in the root account]( https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access.html) that has permission to assume that role to access the new AWS account

## Step 2 - Identity

Every user must leverage unique credentials so we can trace actions within our accounts. Setup your identity structure in the master account and use cross account access to access the child accounts. As you create roles for your users ensure that you are implementing least privilege access by ensuring that users only have access to perform actions required for their role. Be careful who you give IAM permissions to as they can create their own permissions.

### Walkthrough

1. [Perform a credentials audit, add multi factor authentication to root and ensure that details are up to date](../100_AWS_Account_and_Root_User/README.md)
2. Federate Identity [leveraging a SAML provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_enable-console-saml.html)
3. [Use cross account access roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html) to access the accounts that we setup in part 1.

## Step 3 - Data Bunker

Now we will create a data bunker account to store secure read only security logs and backups. In this step we will send our logs from CloudTrail to that account. The role for accessing this account will have read only access. Only ensure that this role can be accessed by those with a security role in your organization.

### Walkthrough

1. [Setup a security account, secure Amazon S3 bucket and turn on our AWS Organization CloudTrail](../100_Create_a_Data_Bunker/README.md)

## Step 4 - Enable organizations policies

[AWS Organizations policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies.html) allow you to apply additional controls to accounts. In the examples given below these are attached to the root which will affect all accounts within the organization. You can also create specific service control policies for separate organizational units within your organization.

### Walkthrough (repeat for each policy below)

1. Navigate to **AWS Organization** and select the **Policies** tab
2. Click **Create policy**
3. Enter a *policy name* for your policy and paste the policy JSON below into the *policy* editor
5. Click **Create policy**
6. **Select** the policy you have just created and in the right-hand panel select **roots*
7. Press **Attach** to attach the policy to your organizations root

### Policy to prevent users disabling CloudTrail

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "cloudtrail:StopLogging",
      "Resource": "*"
    }
  ]
}
```

### (Optional) Disable unused regions

This policy specifically enables only _us-east-1_ and _us-west-1_. Replace with the list of [region codes](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) you wish to allow access to.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Deny",
            "Action": [
                "*"
            ],
            "Resource": [
                "*"
            ],
            "Condition": {
                "ForAnyValue:StringNotEquals": {
                    "aws:RequestedRegion": [
                        "us-east-1",
                        "us-west-1"
                    ]
                }
            }
        }
    ]
}
```

## Step 5 - Disable public access to data in S3

Amazon Simple Storage Service (S3) allows you to upload objects to a "bucket" which are then accessible depending on the access control list implemented. It is important to consider how you make data public. By blocking [public access](https://docs.aws.amazon.com/AmazonS3/latest/dev/access-control-block-public-access.html#access-control-block-public-access-policy-status) your team will have to be deliberate when it exposes data.

**Note:** The steps below apply at an individual account level. It is important to consider turning this on as you create additional accounts for your organization. At a minimum you should apply this to any account which hosts production data.

## Walkthrough

1. For each account that you want to block public access to data stored in S3 - use a cross-account access role to [block S3 public access](https://docs.aws.amazon.com/AmazonS3/latest/dev/access-control-block-public-access.html)
2. Repeat the walkthrough in part 4 to apply the policy below. Instead of applying this policy to shit to the root, apply this specifically to the accounts where you have blocked public access.

### Policy to block public

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Effect": "Deny",
			"Action": [
				"s3:PutBucketPublicAccessBlock",
				"s3:PutAccountPublicAccessBlock"
			],
			"Resource": "*"
		}
	]
}
```

## Step 6 - Monitoring and Alerting

Lastly, we will setup our foundations for monitoring the security status of our AWS environment and look at how we can build some basic alerting to security incidents. AWS Security Hub gives you a comprehensive view of the security of your account including compliance checks against best practices such as the [Centre for Information Security AWS Foundational Benchmark](https://aws.amazon.com/quickstart/architecture/compliance-cis-benchmark/). We will also enable Amazon GuardDuty - a threat detection service which leverages machine learning to detect anomalies across our AWS CloudTrail, Amazon VPC Flow Logs, and DNS logs.

### Walkthrough

1. [Enable Security Hub](../100_Enable_Security_Hub/README.md)
2. [Enable Amazon GuardDuty and implement basic detective controls](../200_Automated_Deployment_of_Detective_Controls/README.md)

## Additional Resources and next steps

* Find further information on the AWS website around [AWS Cloud Security]( https://aws.amazon.com/security/) and in particular what your responsibilities are under the [shared security model]( https://aws.amazon.com/compliance/shared-responsibility-model/)
* Read more on how [permission boundaries and service control policies]( https://aws.amazon.com/blogs/security/how-to-use-service-control-policies-to-set-permission-guardrails-across-accounts-in-your-aws-organization/) allow you to delegate access across your organization
* Understand the [Well Architected Framework]( https://aws.amazon.com/architecture/well-architected/) and how applying it can improve your security posture

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
