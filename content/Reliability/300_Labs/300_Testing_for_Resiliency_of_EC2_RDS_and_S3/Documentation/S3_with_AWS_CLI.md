---
title: "Disable All Public Read Access to an S3 Bucket using AWS CLI"
date: 2020-04-24T11:16:09-04:00
chapter: false
hidden: true
---

## Disable read access to S3 bucket

* This command will disable public read from an entire bucket. If you want to only disable public read from one object, use the **AWS Console** instructions
* If your S3 bucket is in a _different_ aWS account, you will need to provide credentials for that account first.

        aws ssm start-automation-execution --document-name AWS-DisableS3BucketPublicReadWrite --parameters "{\"S3BucketName\": [\"<bucket-name>\"]}"

[Return to the Lab Guide]({{< ref "../7_failure_injection_optional.md" >}}), but keep this page open if you want to re-enable public read access to the bucket after testing.

---

## Re-enable access (after testing) using the S3 console

1. This requires using the S3 console. Go to the S3 console: <https://console.aws.amazon.com/s3>
1. Select the bucket name where the image is located
1. Select the "Permissions" tab
1. Click Edit (upper-right)
1. Un-check all the boxes
1. Click Save
1. You are asked to type "confirm" - this is a security feature to ensure you truly intend this bucket to allow public access.

---
**[Click here to return to the Lab Guide]({{< ref "../7_failure_injection_optional.md#s3response" >}})**
