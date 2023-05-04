---
title: "Upload new object to S3 Intelligent-Tiering"
date: 2023-04-03T26:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

New objects uploaded to S3 Intelligent-Tiering storage class are initially stored in the Frequent Access Tier and if not accessed until their minimum duration in the standard access tier will be moved to Infrequent Access Tier and further to Archive tier to save cost for infrequently accessed data.

This section walks you through the steps to first create a new S3 bucket and then upload an object to S3 Intelligent-Tiering storage class. If you prefer to use an existing bucket for the purpose of this lab, you can skip steps 1 to 4 and go straight to step 5.

1. Log into the [AWS Management Console](https://console.aws.amazon.com/). Navigate to Amazon S3 console by typing **S3** in the services search bar and clicking **S3** in the search results.
![Images/S3IntelligentTiering03.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-03.png)

2. In the **Amazon S3** navigation pane on the left, select **Buckets**, and then click **Create bucket** in the **Buckets** section.
![Images/S3IntelligentTiering04.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-04.png)

3. Enter a descriptive name for your bucket. Bucket names are globally unique; if you encounter an error with the name you selected, please try again with a different name. Select an **AWS Region** from the drop down menu where you would like to create your bucket.
![Images/S3IntelligentTiering05.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-05.png)

4. Leave rest of the configurations as default and click **Create bucket** at the bottom of the page to continue. 

{{% notice note %}}
You can optionally add a [bucket tag](https://docs.aws.amazon.com/AmazonS3/latest/userguide/CostAllocTagging.html) to help track costs associated with workloads. AWS uses the bucket tags to organize your resource costs on your [cost allocation report](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/configurecostallocreport.html), to make it easier for you to categorize and track your AWS costs. For more information, see [Using Cost Allocation Tags](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/cost-alloc-tags.html) in the AWS Billing User Guide.
{{% /notice %}}

![Images/S3IntelligentTiering06.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-06.png)

Now that your bucket has been created and configured, you are ready to upload data to Amazon S3 Intelligent-Tiering storage class.

5. Navigate to your S3 bucket.
![Images/S3IntelligentTiering07.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-07.png)

6. Select the **Objects** tab and then click **Upload**.
![Images/S3IntelligentTiering08.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-08.png)

7. In the **Upload** window, click **Add files**. Navigate to your local file system to locate the file you would like to upload. Select the file you like to upload, and then click **Open**. Your file will be listed under the **Files and folders** section.
![Images/S3IntelligentTiering09.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-09.png)

8. In the **Properties** section, select **Intelligent-Tiering**. Leave rest of the options as default, and click **Upload**.
![Images/S3IntelligentTiering10.png](/Cost/100_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-10.png)

At the end of upload operation, a summary is presented to indicate whether the object is uploaded successfully or not. Click **Close** to return to the bucket

### Congratulations!
You have completed this section of the lab. In this section you created Amazon S3 bucket and uploaded an object to the S3 Intelligent tiering storage class.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../1_int_tiering_overview/" link_next_url="../3_transition_existing_objects/" />}}