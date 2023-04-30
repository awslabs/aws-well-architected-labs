---
title: "Restoring archived data"
date: 2023-04-03T26:16:08-04:00
chapter: false
weight: 6
pre: "<b>6. </b>"
---

In this step, you will learn how to restore a file. This will happen after the file remains in deep archive storage class for 180 days. After 180 days, before you can download a file stored in the Deep Archive Access tier, you must initiate the restore request and wait until the object is moved into the Frequent Access tier.

1. From the AWS Management Console session, navigate to the [S3 console](https://s3.console.aws.amazon.com/s3/home) and select the Buckets menu option. From the list of available buckets, select the bucket name of the bucket you created in Step 1.

2. In the Objects tab, select the file stored in the Intelligent-Tiering Deep Archive Access tier.
Then move to Properties tab, In Properties tab, you will notice that both the Download and Open buttons are grayed out, and a banner notifies you that in order to access the file you must first restore it. To initiate the restore, choose Initiate restore.
![Images/S3IntelligentTiering27.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-27.png)
<!--- ![Images/S3IntelligentTiering28.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-28.png) --->

3. In the following Initiate restore form, you can select the type of restore. The Bulk retrieval typically completes within 48 hours while the Standard retrieval typically completes within 12 hours; both options are available at no charge. See [Archive retrieval options](https://docs.aws.amazon.com/AmazonS3/latest/userguide/restoring-objects-retrieval-options.html) for more information. For this workload, select the Standard retrieval option because it is required to complete the restore within 12 hours. Now you can initiate the restore by choosing Initiate restore.
![Images/S3IntelligentTiering29.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-29.png)

4. After initiating the restore, you will be presented with a summary of the operations indicating if it has initiated successfully or if it has failed. In this case, the restore has initiated successfully. Choose Close.
![Images/S3IntelligentTiering30.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-30.png)

5. In the Properties tab of the file, you can monitor the status of the restoration process.
![Images/S3IntelligentTiering31.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-31.png)

6. Once the restore operation has completed (typically within 12 hours), you are able to download the file by choosing Download.

Click on **Next Step** to continue to the next section.
{{< prev_next_button link_prev_url="../5_archive_tiers/" link_next_url="../7_clean_up/" />}}