---
title: "Transition existing objects to S3 Intelligent-Tiering"
date: 2023-04-03T26:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

For scenarios where objects pre-exist in your S3 bucket or programmatically uploaded by clients which might not be compatible with the S3 Intelligent-Tiering storage class, you can use [Amazon S3 Lifecycle](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html) to immediately transition objects to S3 Intelligent-Tiering storage class. 

In this section of the lab, you will learn how to configure an S3 Lifecycle policy on your bucket.

1. Navigate to the S3 bucket for which you want to configure transition policy for S3 Intelligent-Tiering storage class. 

2. Once in the bucket console, Select the **Management** tab and then click **Create lifecycle rule** in the **Lifecycle rules** section.
![Images/S3IntelligentTiering11.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-11.png)

3. When you create S3 Lifecycle rule, you have the option to limit the scope of the rule by prefix, tag, or object size. For this lab we want to apply the Lifecycle rule to all objects in the bucket and therefore we won’t apply any filters.

    * Enter a descriptive **Lifecycle rule name**.
    * Select **Apply to all objects in the bucket**.
    * Select **I acknowledge that this rule will apply to all objects in the bucket checkbox**.
    * Under **Lifecycle rule actions** section, select **Move current versions of objects between storage classes**. For more information, see [Using versioning in S3 buckets](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html).
    * Under **Transition current versions of objects between storage classes** section, select **Intelligent-Tiering** using **Choose storage class transitions** drop-down menu, and input **0** in **Days after object creation** field.
    * Finally, choose **Create rule**.
![Images/S3IntelligentTiering12.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-12.png)

{{% notice note %}}
You can use [Amazon S3 Versioning](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html) to retain multiple variants of the same object, which you can use to quickly recover data if it is accidentally deleted or overwritten. Versioning can also have a cost implication if you accumulate a large number of previous versions and do not put in place the necessary lifecycle policies to manage them. We recommend that you enable them for S3 Intelligent tiering transition to further optimize the cost.
{{% /notice %}}

In this section, we created a Lifecycle rule to immediately transition files uploaded in the S3 Standard storage class to the S3 Intelligent-Tiering storage class.
![Images/S3IntelligentTiering13.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-13.png)

It is important to note that your first-month cost for S3 Intelligent-Tiering will be slightly higher than the S3 Standard storage class. This is because objects uploaded to S3 Intelligent-Tiering storage class are automatically stored in the Frequent Access tier, and charged a small charge per object for monitoring and automation. And, if you are transitioning objects from S3 Standard using S3 Lifecycle policy, you also pay a one-time transition request charge. Once the data is moved into S3 Intelligent-Tiering, you can expect to observe cost savings in the second month when objects that have not been accessed for 30 consecutive days automatically transition to S3 Intelligent-Tiering Infrequent Access tier. You should expect to see substantial storage cost savings in the fourth month when objects not accessed for 90 consecutive days move to Archive Instant Access tier.

Let’s take an example to visualize this in action over a period of 4 months. In the following, we assume 5 PB of data was stored using only Amazon S3 Standard Storage with unknown access patterns in Amazon S3. We enabled transition to move this data from S3 Standard tier to S3 Intelligent Tiering. Enabling Intelligent tiering led to very nominal Monitoring & Automation costs which included small API charge for the initial transition to Intelligent tier. Overall cost reduced from 125k to 60k (~50% saving) after INT-Infrequent access tier kicked in after 30 days and further down to 20k (85% savings) after INT-Archive Instant Access tier storage started after 90 days. You can use [Amazon S3 pricing calculator](https://calculator.aws/#/createCalculator/S3) to calculate expected savings for your business use case.

![Images/S3IntelligentTiering14.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-14.png)

### Congratulations! 
You have completed this section of the lab. In this section you created Amazon S3 lifesycle rule to transition objects from S3 Standard storage class to S3 Intelligent tiering storage

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../2_upload_new_object/" link_next_url="../4_cfn_lifecycle_policy/" />}}