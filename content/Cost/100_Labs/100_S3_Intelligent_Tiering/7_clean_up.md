---
title: "Teardown"
date: 2023-04-03T26:16:08-04:00
chapter: false
weight: 7
pre: "<b>7. </b>"
---

In this section, you will clean up the resources you created as part of this workshop. It is a best practice to delete resources you are no longer require to avoid incurring on-going charges.

1. **Delete test objects**

If you have logged out of your AWS Account, log back in. Navigate to [S3 console](https://s3.console.aws.amazon.com/s3/home) and click **Buckets** on the left navigation pane. Before deleting the bucket, all its objects need to be deleted. Select the radio button against your bucket and then click **Empty**.

![Images/S3IntelligentTiering32.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-32.png)

Type “*permanently delete*” in the confirmation window that pops up. Then, click **Empty** to continue.

Next, you will be presented with a banner indicating if the deletion has been successful.

2. **Delete test bucket**

To delete your bucket, return to the S3 bucket console. Select the radio button against your bucket and then click **Delete**.

Review the warning message. If you desire to continue deleting your bucket, type the bucket name in the confirmation pop-up window and then click **Delete bucket**.
![Images/S3IntelligentTiering33.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-33.png)
![Images/S3IntelligentTiering34.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-34.png)

3. **Delete CloudFormation Stack**

To delete the CloudFormation stack created as part of [section 4]({{< ref "4_cfn_lifecycle_policy" >}}), navigate to AWS Cloudformation console, select the stack and click **Delete**.
![Images/S3IntelligentTiering35.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-35.png)

Click **Delete** on the confirmation window to continue. 
![Images/S3IntelligentTiering36.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-36.png)

Stack deletion will remove the lambda function and the associated IAM role. 

**Important** - this cleanup process deletes resources created by cloudformation template but it retains the policies created and applied to Amazon S3 bucket. If you wish to modify/remove those then you need to do it manually by navigating to **Amazon S3 bucket** → **Management tab** → **Lifecycle Rules** 


## Conclusion

Congratulations, you have now completed this lab. Objects that are not in the intelligent tiering storage class, will be assessed and transitioned daily by the lifecycle rule as needed. This will reduce your costs for this S3 bucket. Now, to implement such best practices proactively, you could propose your organization to have such rule implemented by default in every newly created S3 bucket.
