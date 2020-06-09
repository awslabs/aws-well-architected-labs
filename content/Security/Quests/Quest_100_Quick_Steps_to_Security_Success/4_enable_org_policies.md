---
title: "Enable organizations policies"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

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

**Note:** Not all AWS global services are shown in this example policy. Replace the list of services in red italicized text with the global services used by accounts in your organization.

**Note:** This example policy blocks access to the AWS Security Token Service global endpoint (sts.amazonaws.com). To use AWS STS with this policy, use regional endpoints or add "sts:*" to the NotAction element. For more information on AWS STS endpoints, see Activating and Deactivating AWS STS in an AWS Region in the IAM User Guide.
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DenyAllOutsideEU",
            "Effect": "Deny",
            "NotAction": [
               "iam:*",
               "organizations:*",
               "route53:*",
               "budgets:*",
               "waf:*",
               "cloudfront:*",
               "globalaccelerator:*",
               "importexport:*",
               "support:*"
            ],
            "Resource": "*",
            "Condition": {
                "StringNotEquals": {
                    "aws:RequestedRegion": [
                        "eu-central-1",
                        "eu-west-1"
                    ]
                }
            }
        }
    ]
}
```
