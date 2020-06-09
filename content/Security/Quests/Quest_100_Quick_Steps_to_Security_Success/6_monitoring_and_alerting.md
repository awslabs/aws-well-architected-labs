---
title: "Monitoring and Alerting"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

Lastly, we will setup our foundations for monitoring the security status of our AWS environment and look at how we can build some basic alerting to security incidents. AWS Security Hub gives you a comprehensive view of the security of your account including compliance checks against best practices such as the [Centre for Information Security AWS Foundational Benchmark](https://aws.amazon.com/quickstart/architecture/compliance-cis-benchmark/). We will also enable Amazon GuardDuty - a threat detection service which leverages machine learning to detect anomalies across our AWS CloudTrail, Amazon VPC Flow Logs, and DNS logs.

### Walkthrough

1. Enable [AWS Security Hub](https://aws.amazon.com/security-hub/). Leverage the [AWS Security Hub Multiaccount Scripts](https://github.com/awslabs/aws-securityhub-multiaccount-scripts) to enable it across accounts.
2. Enable [Amazon GuardDuty](https://aws.amazon.com/guardduty/). Leverage [Amazon ](https://github.com/aws-samples/amazon-guardduty-multiaccount-scripts) to enable it across accounts.

## Additional Resources and next steps

* Find further information on the AWS website around [AWS Cloud Security]( https://aws.amazon.com/security/) and in particular what your responsibilities are under the [shared security model]( https://aws.amazon.com/compliance/shared-responsibility-model/)
* Read more on how [permission boundaries and service control policies]( https://aws.amazon.com/blogs/security/how-to-use-service-control-policies-to-set-permission-guardrails-across-accounts-in-your-aws-organization/) allow you to delegate access across your organization
* Understand the [Well Architected Framework]( https://aws.amazon.com/architecture/well-architected/) and how applying it can improve your security posture
