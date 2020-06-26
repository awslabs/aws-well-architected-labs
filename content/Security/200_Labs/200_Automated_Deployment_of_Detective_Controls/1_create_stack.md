---
title: "Create Stack"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

Creating this CloudFormation stack will configure CloudTrail including a new trail, an S3 bucket, and a CloudWatch Logs group for CloudTrail logs. You can optionally configure AWS Config and Amazon GuardDuty by setting the CloudFormation parameter for each.
1. Download the latest version of the CloudFormation template here: [cloudtrail-config-guardduty.yaml](/Security/200_Automated_Deployment_of_Detective_Controls/Code/cloudtrail-config-guardduty.yaml)

{{% common/CreateNewCloudFormationStack stackname="DetectiveControls" templatename="cloudtrail-config-guardduty.yaml" %}}
    * Under *General* section only enable the service if you have not configured already. CloudTrail is enabled by default, if you have enabled already this will create another trail and S3 bucket.
    * *CloudTrailBucketName*: The name of the new S3 bucket to create for CloudTrail to send logs to. 
    * **IMPORTANT:** Bucket names need to be unique across all AWS buckets, and only contain lowercase letters, numbers, and hyphens.
    * *ConfigBucketName*: The name of the new S3 bucket to create for Config to save config snapshots to. 
    * *GuardDutyEmailAddress*: The email address you own that will receive the alerts, you must have access to this address for testing.
{{% /common/CreateNewCloudFormationStack %}}

You have now set up detective controls to log to your buckets and retain events, giving you the ability to search history and later enable pro-active monitoring of your AWS account!

{{% notice note %}}
You should receive an email to confirm the SNS email subscription, you must confirm this. Note as the email is directly from GuardDuty via SNS is will be JSON format.
{{% /notice %}}
