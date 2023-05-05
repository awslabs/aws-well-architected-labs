---
title: "Configure Opt-in Archive Access Tier"
date: 2023-04-03T26:16:08-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

To save even more on data that doesn’t require immediate retrieval, you can activate the optional asynchronous Archive Access and Deep Archive Access tiers. When these tiers are activated, objects not accessed for 90 consecutive days are automatically moved directly to the Archive Access tier. Objects are then moved to the Deep Archive Access tier after 180 consecutive days of no access.

![Images/S3IntelligentTiering15.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-02.png)

The chart below shows how it adds into upto 95% of cost savings once you start utilizing your archive access tier for storage

![Images/S3IntelligentTiering15b.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-15b.png)


1. Log into your AWS Account and navigate to S3 Bucket console. Then select the bucket you used in [section 2]({{< ref "2_upload_new_object" >}}).
![Images/S3IntelligentTiering16.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-16.png)

2. Select the **Properties** tab.
![Images/S3IntelligentTiering17.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-17.png)

3. Navigate to the **Intelligent-Tiering Archive configurations** section and choose **Create configuration**.
![Images/S3IntelligentTiering18.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-18.png)

4. In the **Archive configuration settings** section, specify a descriptive **Configuration name** for your S3 Intelligent-Tiering Archive configuration.
![Images/S3IntelligentTiering19.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-19.png)

5. For this lab, we are going to limit the scope of configuration by using tags. To do so, under **Choose a configuration scope**, select **Limit the scope of this configuration using one or more filters**.
In the **Object Tags** section, click **Add tag**, and then enter "opt-in-archive" as **Key** and “true” as **Value**. Make sure that **Status** configuration is **Enable**.
![Images/S3IntelligentTiering20.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-20.png)

6. Objects in S3 Intelligent-Tiering storage class are archived to Deep Archive Access tier after they haven’t been accessed for a time between six months and two years depending on your configuration. 

Refer to the following object flow e.g with minimum days of object storage required before object is moved from frequent access tier to deep archive access tier
![Images/S3IntelligentTiering21.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-21.png)

For this lab, we want to archive objects that haven’t been accessed for 6 months, to ensure that we only archive data that is not being used. To do so, in the **Archive rule actions** section, select **Deep Archive Access tier**, enter **180** as number of consecutive days without access before archiving the objects to the Deep Archive Access tier, and choose **Create**.
![Images/S3IntelligentTiering22.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-22.png)

7. To upload a new object with **opt-in-archive** tag, go to your S3 Bucket and click **Upload**:
![Images/S3IntelligentTiering23.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-23.png)

8. Then, choose Add files. Navigate to your local file system to locate the file you would like to upload. Select the file and then choose **Open**. Your file will be listed in **Files and folders** section.
![Images/S3IntelligentTiering24.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-24.png)

9. In the **Properties** section, select **Intelligent-Tiering**. For more information about the Amazon S3 Intelligent-Tiering storage class, see the [Amazon S3 User Guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/intelligent-tiering.html).
![Images/S3IntelligentTiering25.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-25.png)

10. Because we want the file to be archived after 6 months of no access, in the **Tags – optional** section we select **Add tag** with **Key** “opt-in-archive” and **Value** “true”, and click **Upload**.
![Images/S3IntelligentTiering26.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-26.png)

### Congratulations! 
You have completed this section of the lab. In this section you learned how to configure optional archive storage tier and use object tag to transfer objects to deep archive access tier.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../4_cfn_lifecycle_policy/" link_next_url="../6_restore_data/" />}}