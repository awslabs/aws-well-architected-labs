---
title: "Teardown"
date: 2023-04-03T26:16:08-04:00
chapter: false
weight: 7
pre: "<b>7. </b>"
---

In the following steps, you clean up the resources you created in this tutorial. It is a best practice to delete resources that you are no longer using so that you do not incur unintended charges.

1. **Delete test objects**

If you have logged out of your AWS Management Console session, log back in. Navigate to the [S3 console](https://s3.console.aws.amazon.com/s3/home) and select the Buckets menu option. First you will need to delete the test object(s) from your test bucket. Select the radio button to the left of the bucket you created for this tutorial, and then choose Empty.

![Images/S3IntelligentTiering32.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-32.png)

In the Empty bucket page, type “permanently delete” into the Permanently delete all objects confirmation box. Then, choose Empty to continue.

Next, you will be presented with a banner indicating if the deletion has been successful.

2. **Delete test bucket**

Finally, you need to delete the test bucket you have created. Return to the list of buckets in your account. Select the radio button to the left of the bucket you created for this tutorial, and then choose Delete.

Review the warning message. If you desire to continue deletion of this bucket, type the bucket name into the Delete bucket confirmation box and choose Delete bucket.
![Images/S3IntelligentTiering33.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-33.png)
![Images/S3IntelligentTiering34.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-34.png)



**Conclusion**

Congratulations, you have now completed this lab. Objects that are not in the intelligent tiering storage class, will be assessed and transitioned daily by the lifecycle rule as needed. This will reduce your costs for this S3 bucket. Now, to implement such best practices proactively, you could propose your organization to have such rule implemented by default in every newly created S3 bucket.
