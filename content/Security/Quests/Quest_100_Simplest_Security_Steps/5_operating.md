---
title: "Operating"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

Although there are instructions for [Decommissioning a Landing Zone](https://docs.aws.amazon.com/controltower/latest/userguide/decommission-landing-zone.html) in the AWS Control Tower documentation it is strongly recommended that you keep them this quest in place unless you are decommissioning your AWS account structure. The steps in this quest are intended to improve your security posture and tearing down this quest will remove the audit logs and guard rails put in place.

There is no additional cost for AWS Control Tower, you only pay for the [services used by Control Tower](https://docs.aws.amazon.com/controltower/latest/userguide/integrated-services.html) which scales with you. See the [AWS Control Tower pricing](https://aws.amazon.com/controltower/pricing/) page for detailed examples. As a baseline, the setup of just Control Tower has a US$5/month fee for a product in Service Catalogue in additional to a once off cost of US$0.011 for AWS Config to record it's initial state. Security Hub and Guard Duty both have a 30 day free trial to give you an indicative cost. Security Hub has a cost associated with number of security checks and findings ingested which will scale with your AWS usage, see [AWS Secuity Hub pricing](https://aws.amazon.com/security-hub/pricing/) for examples. Guard Duty pricing is based on the total amount of logs consumed by the service, this will also scale cost effectively with your AWS usage, see [AWS Guard Duty pricing](https://aws.amazon.com/guardduty/pricing/)  for examples. Note that you may also additionally incur tax based on your location.

### Additional Resources and next steps

* Find further information on the AWS website around [AWS Cloud Security]( https://aws.amazon.com/security/) and in particular what your responsibilities are under the [shared security model]( https://aws.amazon.com/compliance/shared-responsibility-model/)
* Read more on how [permission boundaries and service control policies]( https://aws.amazon.com/blogs/security/how-to-use-service-control-policies-to-set-permission-guardrails-across-accounts-in-your-aws-organization/) allow you to delegate access across your organization
* Understand the [Well-Architected Framework]( https://aws.amazon.com/architecture/well-architected/) and how applying it can improve your security posture
