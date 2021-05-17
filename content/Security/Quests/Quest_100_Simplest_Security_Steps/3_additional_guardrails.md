---
title: "Enable Additional Guardrails"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---
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

#