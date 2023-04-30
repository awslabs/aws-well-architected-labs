---
title: "Use CloudFormation to create Lifecycle rules at scale"
date: 2023-04-03T26:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

In the previous section, we learnt how to enable [S3 Intelligent-Tiering](https://aws.amazon.com/s3/storage-classes/intelligent-tiering/) through a lifecycle rule for a single bucket.
In real-world scenarios, customers may accumulate petabytes of objects in the S3 Standard storage class across tens to hundreds of buckets and in multiple accounts who look for an easier way to apply a single [S3 Lifecycle](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html) configuration across all of their buckets to transition data from S3 Standard into S3 Intelligent-Tiering.

In this lab, we are going to deploy a AWS CloudFormation template to make this process easier.

## Deploy CloudFormation Template

1. Download the [s3lifecycle-automation.yaml](/Cost/100_S3_Intelligent_Tiering/Code/s3lifecycle-automation.yaml) CloudFormation template to your machine.

{{% common/CreateNewCloudFormationStack stackname="S3TieringLifecycleAutomation" templatename="s3lifecycle-automation.yaml" /%}}

## Understanding this automation template deployment

This AWS Cloudformation template creates stack into your AWS environment that consists of Lambda function with required permissions to create lifecycle policy rules and store output result in the bucket for your reference. 

The Amazon S3 lifecycle policy defined in the template creates a rule to move all the existing objects in all the buckets in a given account to S3 Intelligent Tiering Storage Class. 

Once the stack is deployed, you can run go to the resource tab to select the lambda function deployed by the stack. You can optionally customize this to update specific buckets by modifying the lambda function code. You can also update the filter condition in policy definition to modify only certain objects within the bucket. Deploy and run the lambda function.
Once the lambda function execution is successfully, you can go back to S3 console and verify the bucket lifecycle policies created. 

You can also deploy this cloudformation template as a stack set if you wish to run this across multiple accounts within your organization. 

Refer to the following link for more details:
https://github.com/aws-samples/automated-lifecycle-transition-rules-to-s3int/

{{< prev_next_button link_prev_url="../3_transition_existing_objects/" link_next_url="../5_archive_tiers/" />}}