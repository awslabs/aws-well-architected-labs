---
title: "Automate Lifecycle rule creation using Lambda"
date: 2023-04-03T26:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

In the previous section, we learnt how to enable [S3 Intelligent-Tiering](https://aws.amazon.com/s3/storage-classes/intelligent-tiering/) through a lifecycle rule for a single bucket.
In real-world scenarios, customers may accumulate petabytes of objects in the S3 Standard storage class across tens to hundreds of buckets and in multiple accounts who look for an easier approach to apply a single [S3 Lifecycle](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html) configuration across multiple buckets to transition data from S3 Standard tier to S3 Intelligent-Tiering.

In this lab, we are going to deploy a Lambda function using AWS CloudFormation template to make this process easier.

## Deploy CloudFormation Template

1. Download the [s3lifecycle-automation.yaml](/Cost/200_S3_Intelligent_Tiering/Code/s3lifecycle-automation.yaml) CloudFormation template to your machine.

{{% common/CreateNewCloudFormationStack stackname="S3TieringLifecycleAutomation" templatename="s3lifecycle-automation.yaml" %}}
    * **BucketNameParam** - Name of the bucket to store automation result.
{{% /common/CreateNewCloudFormationStack %}}

## Understanding this automation template deployment

This AWS Cloudformation template creates a stack in your AWS account. Stack resources comprise of a Lambda function with required IAM permissions to create S3 lifecycle policy rules and store the results in the output bucket you specified during the creation of cloudformation stack.

Navigate to AWS Lambda console to review the function code.

This automation logic caters the following two use-cases:

* Case 1 - Check existing lifecycle policies, if there are any then skip the bucket
* Case 2 - If no lifecycle policy exists, then create a new policy and attach it to the bucket

{{% notice note %}}
This automation template does not modify Amazon S3 buckets with existing lifecycle policies. But you can customize this lambda function to modify existing S3 lifecycle policy by adding logic in the placeholder **Additional customization**.
{{% /notice %}}

Review **createPolicy** function. The Amazon S3 lifecycle policy defined in the the lambda function creates a rule to move all the existing objects in all the AWS S3 buckets in a given account to S3 Intelligent Tiering Storage Class on the day 0 of object creation/upload. You can customize this logic to define your own transition rule statements. You can refer to some customization examples [here](https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-configuration-examples.html).

**Trigger Lambda Function**

1. In the Lambda console, click on **Test** to create a test event.
![Images/S3IntelligentTiering14a.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-14a.png)

2. Specify a name for your test event, keep everything else to default and click **Save**.
![Images/S3IntelligentTiering14b.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-14b.png)

3. Before running the event, review the lambda function code for any customization as suggested above. Run **Test**.
![Images/S3IntelligentTiering14c.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-14c.png)

4. Review the execution log to see if the function has been executed successfully. It will generate the output file in the Amazon S3 bucket you specified during cloudformation stack creation.
![Images/S3IntelligentTiering14d.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-14d.png)
![Images/S3IntelligentTiering14e.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-14e.png)

5. Once the lambda function execution is successful, go back to S3 console and verify the bucket lifecycle policies created.
![Images/S3IntelligentTiering14f.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-14f.png)

{{% notice note %}}
You can also deploy this cloudformation template as a stack set if you wish to run this across multiple accounts within your organization. More information around AWS Clouformation Stack set deployment can be found [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-getting-started-create.html#stacksets-getting-started-create-self-managed-console).
{{% /notice %}}

{{% notice note %}}
You can also run this exercise at scale via AWS CLI using S3 commands such as [ListBuckets](https://docs.aws.amazon.com/cli/latest/reference/s3api/list-buckets.html) followed by [PutLifecycleConfiguration](https://docs.aws.amazon.com/cli/latest/reference/s3api/put-bucket-lifecycle.html) to enable lifecycle policy on Amazon S3 buckets. For information on setting up AWS CLI on your machine please refer to the [CLI documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html).
{{% /notice %}}

Refer to the following link for more details:
https://github.com/aws-samples/automated-lifecycle-transition-rules-to-s3int/

{{< prev_next_button link_prev_url="../3_transition_existing_objects/" link_next_url="../5_archive_tiers/" />}}