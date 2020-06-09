---
title: "Disable public access to data in S3"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---
Amazon Simple Storage Service (S3) allows you to upload objects to a "bucket" which are then accessible depending on the access control list implemented. It is important to consider how you make data public. By blocking [public access](https://docs.aws.amazon.com/AmazonS3/latest/dev/access-control-block-public-access.html#access-control-block-public-access-policy-status) your team will have to be deliberate when it exposes data.

**Note:** The steps below apply at an individual account level. It is important to consider turning this on as you create additional accounts for your organization. At a minimum you should apply this to any account which hosts production data.

## Walkthrough

1. For each account that you want to block public access to data stored in S3 - use a cross-account access role to [block S3 public access](https://docs.aws.amazon.com/AmazonS3/latest/dev/access-control-block-public-access.html)
2. Repeat the walkthrough in part 4 to apply the policy below. Instead of applying this policy to the root, apply this specifically to the accounts where you have blocked public access.

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
