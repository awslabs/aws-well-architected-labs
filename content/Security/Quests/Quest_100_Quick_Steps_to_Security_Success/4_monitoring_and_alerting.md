---
title: "Monitoring and Alerting"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

Lastly, we will setup your foundations for monitoring the security status of your AWS environment and look at how we can build some basic alerting to security incidents. AWS Security Hub gives you a comprehensive view of the security of your account including compliance checks against best practices such as the [Centre for Information Security AWS Foundational Benchmark](https://aws.amazon.com/quickstart/architecture/compliance-cis-benchmark/). We will also enable Amazon GuardDuty - a threat detection service which leverages machine learning to detect anomalies across your AWS CloudTrail, Amazon VPC Flow Logs, and DNS logs.

Both Security Hub and Guard Duty have a concept of a "Master" and "Member" account. The master account will receive data for all member accounts that are enrolled in it. A best practice is to enable your security audit account to be the master where your security team has read-only access to it. In addition to enabling these tools, setup notifications to ensure that you receive alerts as they occur. Develop a process per alert to handle incident response and over time automate your responses.

### Walk through

Note that these steps need to be repeated in each region you wish to monitor.

1. [Amazon GuardDuty](https://aws.amazon.com/guardduty/) has the ability to delegate administration. Follow the instructions in the documentation to [designate a Delegated Administrator and add Member Accounts](https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_organizations.html). Use the audit account as your delegated administrator account. This will enable GuardDuty for all accounts within your organization and make the findings accessible from the Audit account.
1. Enable [AWS Security Hub](https://aws.amazon.com/security-hub/). Follow the steps outlined in the blog post [Automating AWS Security Hub Alerts with AWS Control Tower lifecycle events](https://aws.amazon.com/fr/blogs/mt/automating-aws-security-hub-alerts-with-aws-control-tower-lifecycle-events/) If you are not using Control Tower you can leverage the [AWS Security Hub Multi-account Scripts](https://github.com/awslabs/aws-securityhub-multiaccount-scripts) to enable it across accounts.
1. In your audit account, send [AWS Security Findings to Email](https://github.com/aws-samples/aws-securityhub-to-email) to ensure that your security team is alerted as findings are triggered.
