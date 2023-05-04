---
title: "Restoring archived data"
date: 2023-04-03T26:16:08-04:00
chapter: false
weight: 6
pre: "<b>6. </b>"
---

In this step, you will learn how to restore a file. This will happen after the file remains in deep archive storage class for 180 days. After 180 days, before you can download a file stored in the Deep Archive Access tier, you must initiate the restore request and wait until the object is moved to the Frequent Access tier.

1. Log into your AWS Account and navigate to S3 Bucket console. Then select the bucket you used in [section 5]({{< ref "5_archive_tiers" >}}).

2. In the **Objects** tab, select the file stored in the Intelligent-Tiering Deep Archive Access tier.
In **Properties** tab, you will notice that both **Download** and **Open** buttons are grayed out, and a banner notifies you that in order to access the file you must first restore it. Click **Inititate restore**.
![Images/S3IntelligentTiering27.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-27.png)
<!--- ![Images/S3IntelligentTiering28.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-28.png) --->

3. In the following **Initiate restore** form, you can select the type of restore. **Bulk retrieval** typically completes within 48 hours while **Standard retrieval** typically completes within 12 hours; both options are available at no charge. See [Archive retrieval options](https://docs.aws.amazon.com/AmazonS3/latest/userguide/restoring-objects-retrieval-options.html) for more information.
For the purpose of this lab, select **Standard retrieval**. Now you can initiate the restore by choosing **Initiate restore**.
![Images/S3IntelligentTiering29.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-29.png)

4. After initiating restore, you will be presented with a summary of the operation indicating if it has initiated successfully or not. Click **Close**.
![Images/S3IntelligentTiering30.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-30.png)

5. In the **Properties** tab of the file, you can monitor the status of the restoration process.
![Images/S3IntelligentTiering31.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-31.png)

6. Once the restore operation has completed (typically within 12 hours), you are able to download the file by choosing **Download**.

Click on **Next Step** to continue to the next section.
{{< prev_next_button link_prev_url="../5_archive_tiers/" link_next_url="../7_clean_up/" />}}