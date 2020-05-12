# Quest: Quick Steps to Security Success

[https://wellarchitectedlabs.com](https://wellarchitectedlabs.com)

## Authors

* Byron Pogson, Solutions Architect

## Feedback

If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please create an issue and/or pull request in GitHub.

## About this Guide

This quest is for you to improve your security posture. Every stakeholder involved in your organization and product or service is entitled to make use of a secure platform. Security is important to earn the trust with your customers and your providers. A secure environment also helps to protect your intellectual property. Each set of activities can be done in one day or split over a week in your lunch break. Further discussion can be found in [best practices for your AWS environment](https://aws.amazon.com/organizations/getting-started/best-practices/)

For more context on this quest see [Essential Security Patterns](https://www.youtube.com/watch?v=ScwoR73yr_c) from Public Sector Summit Canberra 2019 and the associated [slide deck on SlideShare](https://www.slideshare.net/AmazonWebServices/essential-security-patterns)

Implementing multiple AWS accounts for your workload improves your security by isolating parts of your workload to limit the blast radius. Understanding cross account access ensures that common resources can continue to be shared among separate workloads. This quest will guide you to setting up a foundational multi-account environment which allows you to implement appropriate controls on top of it while still maintaining a centralized view and flexibility to adapt to your business processes.

This quest leverages [AWS Control Tower](https://aws.amazon.com/controltower/) to implement your best practice landing zone. AWS Control Tower is a managed service to setup up and govern secure multi-account AWS environment. Control Tower is not currently [available in all regions](https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/) so instructions are also provided for an alternate approach too. It is **strongly recommend** that you set up your account landing zone with Control Tower as it is a managed service supported directly by AWS and includes many best practices and guardrails.

## Step 1 - Implement a landing-zone

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

## Step 2 - Federate Identity

Every user must leverage unique credentials so we can trace actions within your accounts. Setup your identity structure in the master account and use cross account access to access the child accounts. As you create roles for your users ensure that you are implementing least privilege access by ensuring that users only have access to perform actions required for their role. Be careful who you give permission to perform IAM actions as they can create their own permissions.

Control Tower sets up your landing zone to leverage [AWS Single Sign-On](https://docs.aws.amazon.com/controltower/latest/userguide/sso.html) as a central place for your users to log on and access AWS accounts. In this step we will federate that access to your existing identity store.

### Walk through

1. In your existing AWS account [perform a credentials audit, add multi factor authentication to root and ensure that details are up to date](../100_AWS_Account_and_Root_User/README.md)
1. Configure [AWS SSO to federate identity](https://controltower.aws-management.tools/infrastructure/sso/). If you are not using SSO you can still federate Identity [leveraging a SAML provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_enable-console-saml.html) and then [use cross account access roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html) to access the accounts that we setup in step 1.

## Step 3 - Enable additional guardrails

### Control Tower guardrails

Control Tower includes a number of [guardrails](https://docs.aws.amazon.com/controltower/latest/userguide/guardrails.html) to help improve your security posture. These guardrails are either preventative or detective. Preventative guardrails limit some actions and are implemented through [AWS Organizations service control policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies.html) and are either enforced or not enabled. Detective guardrails detect resources in your landing zone which are in a noncompliant state. These are implemented via [AWS Config](https://docs.aws.amazon.com/controltower/latest/userguide/config.html)] and show resources that are either clear, in violation or not enabled.

Make sure you review the [mandatory guardrails](https://docs.aws.amazon.com/controltower/latest/userguide/mandatory-guardrails.html) and then review other guardrails you can [enable](https://docs.aws.amazon.com/controltower/latest/userguide/guardrails.html#enable-guardrails). The [strongly recommended guard rails](https://docs.aws.amazon.com/controltower/latest/userguide/strongly-recommended-guardrails.html) follow the best practices for a Well-Architected environment. They are disabled by default but are strongly encouraged to be enabled. There are also additional [elective guardrails](https://docs.aws.amazon.com/controltower/latest/userguide/elective-guardrails.html) to consider which may be suitable for your workload. If you want to add additional service control policies there is an AWS solution [Customizations for AWS Control Tower](https://aws.amazon.com/solutions/customizations-for-aws-control-tower/) to get started.

### Service Control Policies

[AWS Organizations policies](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies.html) allow you to apply additional controls to accounts. In the examples given below these are attached to the root which will affect all accounts within the organization. You can also create specific service control policies for separate organizational units within your organization.

#### Walk through for a non-control tower environment

If you are not leveraging Control Tower it is strongly recommended that you implement the below service control policy to prevent AWS CloudTrail from being disabled.

1. Navigate to **AWS Organization** and select the **Policies** tab
1. Click **Create policy**
1. Enter a *policy name* for your policy and paste the policy JSON below into the *policy* editor
1. Click **Create policy**
1. **Select** the policy you have just created and in the right-hand panel select **roots*
1. Press **Attach** to attach the policy to your organizations root

### Policy to prevent users disabling CloudTrail

*Note:* AWS Control Tower already includes a mandatory guard rail preventing this

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

## Step 4 - Monitoring and Alerting

Lastly, we will setup your foundations for monitoring the security status of your AWS environment and look at how we can build some basic alerting to security incidents. AWS Security Hub gives you a comprehensive view of the security of your account including compliance checks against best practices such as the [Centre for Information Security AWS Foundational Benchmark](https://aws.amazon.com/quickstart/architecture/compliance-cis-benchmark/). We will also enable Amazon GuardDuty - a threat detection service which leverages machine learning to detect anomalies across your AWS CloudTrail, Amazon VPC Flow Logs, and DNS logs.

Both Security Hub and Guard Duty have a concept of a "Master" and "Member" account. The master account will receive data for all member accounts that are enrolled in it. A best practice is to enable your security audit account to be the master where your security team has read-only access to it. In addition to enabling these tools, setup notifications to ensure that you receive alerts as they occur. Develop a process per alert to handle incident response and over time automate your responses.

### Walk through

Note that these steps need to be repeated in each region you wish to monitor.

1. [Amazon GuardDuty](https://aws.amazon.com/guardduty/) has the ability to delegate administration. Follow the instructions in the documentation to [designate a Delegated Administrator and add Member Accounts](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_organizations.html). Use the audit account as your delegated administrator account. This will enable GuardDuty for all accounts within your organization and make the findings accessible from the Audit account.
1. Enable [AWS Security Hub](https://aws.amazon.com/security-hub/). Follow the steps outlined in the blog post [Automating AWS Security Hub Alerts with AWS Control Tower lifecycle events](https://aws.amazon.com/fr/blogs/mt/automating-aws-security-hub-alerts-with-aws-control-tower-lifecycle-events/) If you are not using Control Tower you can leverage the [AWS Security Hub Multi-account Scripts](https://github.com/awslabs/aws-securityhub-multiaccount-scripts) to enable it across accounts.
1. In your audit account, send [AWS Security Findings to Email](https://github.com/aws-samples/aws-securityhub-to-email) to ensure that your security team is alerted as findings are triggered.

## Running your environment and Pricing

Although there are instructions to [Decommissioning a Landing Zone](https://docs.aws.amazon.com/controltower/latest/userguide/decommission-landing-zone.html) in the AWS Control Tower documentation it is strongly recommended that you keep them this quest in place unless you are decommissioning your AWS account structure. The steps in this quest are intended to improve your security posture and tearing down this quest will remove the audit logs and guard rails put in place.

There is no additional cost for AWS Control Tower, you only pay for the [services used by Control Tower](https://docs.aws.amazon.com/controltower/latest/userguide/integrated-services.html) which scales with you. See the [AWS Control Tower pricing](https://aws.amazon.com/controltower/pricing/) page for detailed examples. As a baseline, the setup of just Control Tower has a US$5/month fee for a product in Service Catalogue in additional to a once off cost of US$0.011 for AWS Config to record it's initial state. Security Hub and Guard Duty both have a 30 day free trial to give you an indicative cost. Security Hub has a cost associated with number of security checks and findings ingested which will scale with your AWS usage, see [AWS Secuity Hub pricing](https://aws.amazon.com/security-hub/pricing/) for examples. Guard Duty pricing is based on the total amount of logs consumed by the service, this will also scale cost effectively with your AWS usage, see [AWS Guard Duty pricing](https://aws.amazon.com/guardduty/pricing/)  for examples. Note that you may also additionally incur tax based on your location.

## Additional Resources and next steps

* Find further information on the AWS website around [AWS Cloud Security]( https://aws.amazon.com/security/) and in particular what your responsibilities are under the [shared security model]( https://aws.amazon.com/compliance/shared-responsibility-model/)
* Read more on how [permission boundaries and service control policies]( https://aws.amazon.com/blogs/security/how-to-use-service-control-policies-to-set-permission-guardrails-across-accounts-in-your-aws-organization/) allow you to delegate access across your organization
* Understand the [Well-Architected Framework]( https://aws.amazon.com/architecture/well-architected/) and how applying it can improve your security posture

## Rate Quest

[![1 Star](../../common/images/star.png)](https://wellarchitectedlabs.com/Quest_100_Quick_Steps_to_Security_Success_1star)
[![2 star](../../common/images/star.png)](https://wellarchitectedlabs.com/Quest_100_Quick_Steps_to_Security_Success_2star)
[![3 star](../../common/images/star.png)](https://wellarchitectedlabs.com/Quest_100_Quick_Steps_to_Security_Success_3star)
[![4 star](../../common/images/star.png)](https://wellarchitectedlabs.com/Quest_100_Quick_Steps_to_Security_Success_4star)
[![5 star](../../common/images/star.png)](https://wellarchitectedlabs.com/Quest_100_Quick_Steps_to_Security_Success_5star)

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2019-2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

[https://aws.amazon.com/apache2.0/](https://aws.amazon.com/apache2.0/)

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
