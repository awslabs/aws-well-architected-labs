---
title: "Create Stack"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

## 1. AWS CloudFormation to configure AWS CloudTrail, AWS Config, and Amazon GuardDuty {#deployment}

1. Download the latest version of the CloudFormation template here: [cloudtrail-config-guardduty.yaml](/Security/200_Automated_Deployment_of_Detective_Controls/Code/cloudtrail-config-guardduty.yaml)

{{% common/CreateNewCloudFormationStack stackname="DetectiveControls" templatename="cloudtrail-config-guardduty.yaml" %}}
    * Under *General* section only enable the service if you have not configured already.
    * *CloudTrailBucketName*: The name of the new S3 bucket to create for CloudTrail to send logs to.
    * *ConfigBucketName*: The name of the new S3 bucket to create for Config to save config snapshots to. **IMPORTANT:** Bucket names need to be unique across all AWS buckets.
    * *GuardDutyEmailAddress*: The email address you own that will receive the alerts, you must have access to this address for testing.
{{% /common/CreateNewCloudFormationStack %}}

You have now set up detective controls to log to your buckets and retain events, giving you the ability to search history and later enable pro-active monitoring of your AWS account!
1. You should receive an email to confirm the SNS email subscription, you must confirm this. Note as the email is directly from GuardDuty via SNS is will be JSON format.
