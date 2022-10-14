---
title: "Configure bi-directional cross-region replication (CRR) for S3 buckets"
menutitle: "Configure CRR"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

Amazon S3 replication enables automatic, asynchronous copying of objects across Amazon S3 buckets. Buckets that are configured for object replication can be owned by the same AWS account or by different accounts. You can copy objects between different AWS Regions or within the same Region. You will setup bi-directional replication between S3 buckets in two different regions, owned by the same AWS account.

Replication is configured via _rules_. There is no rule for bi-directional replication. You will however setup a rule to replicate from the S3 bucket in the east AWS region to the west bucket, and you will setup a second rule to replicate going the opposite direction. These two rules will enable bi-directional replication across AWS regions.

![TwoReplicationRules](/Reliability/200_Bidirectional_Replication_for_S3/Images/TwoReplicationRules.png)

### 2.1 Setup rule #1 to replicate objects from _east_ bucket to _west_ bucket

1. Go to the [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home)
1. Click on the name of the _east_ bucket
      * if you used **Ohio** the name will be `<your_naming_prefix>-crrlab-us-east-2`
1. Click on the **Management** tab (Step A in screenshot)
1. Click **Create replication rule** (Step B in screenshot)

      ![AddRule](/Reliability/200_Bidirectional_Replication_for_S3/Images/AddRule.png)

1. For **Replication rule name** enter `east to west`
1. Leave **Status** set to **enabled**
1. For **Choose a rule scope** select **Apply to all objects in the bucket**
1. For **Destination** leave **Choose a bucket in this account** selected, click **Browse S3** and select the name of the _west_ bucket from the drop-down
      * If you used **Oregon** the name will be `<your_naming_prefix>-crrlab-us-west-2`
      * **Troubleshooting**: If you get an error saying _The bucket doesn’t have versioning enabled_ then you have chosen the wrong bucket. Double check the bucket name.
1. For **IAM Role** leave **Choose from existing IAM roles** selected, and select **\<your-naming-prefix\>-S3-Replication-Role-us-east-2** from the search results box
      * (If you chose a different region as your _east_ region, then look for that region at the end of the IAM role name)
1. For **Encryption**, select **Replicate objects encrypted with AWS KMS** and leave **AWS managed key (aws/s3)** selected.
1. Click **Save**

The screen will ask **Replicate existing objects?**, leave **No, do not replicate existing objects** selected and click **Submit**

The screen should now display Replication Rules with the Replication Rule Name, Status, Destination bucket and Region, and other configuration of your replication rule

![RuleOneCreated](/Reliability/200_Bidirectional_Replication_for_S3/Images/RuleOneCreated.png)

### 2.2 Test replication rule #1 - replicate object from east bucket to west bucket

To test this rule you will upload an object into the east bucket and observe that it is replicated into the west bucket. For this step you will need a _test object_:

* This is a file that you will upload into the east S3 bucket.
* It should not be too big, as this will increase the time to upload it from your computer.
* If you do not have a file to use, you can [download this file](/Reliability/200_Bidirectional_Replication_for_S3/Images/TestObject_AmazonRufus.gif).

Right-click and **Save image as...** ![AmazonRufus](/Reliability/200_Bidirectional_Replication_for_S3/Images/TestObject_AmazonRufus.gif)

1. Go to the [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home), or if you are already there click on **Amazon S3** in the upper left corner
1. Click on the name of the _east_ bucket
      * if you used **Ohio** the name will be `<your_naming_prefix>-crrlab-us-east-2`
1. Click on **⬆ Upload**
1. Upload the file you will use as an object
      * Drag and drop the file or click **Add files**
      * Click **Upload** (note there is a **Next** button, but you do _not_ need to click it)
1. When the file is finished uploading, click on the filename
      * It will look like the _left_ side of the screenshot below
      * If **Replication status** is **PENDING**, wait and refresh until it says **COMPLETED** which should be just a few seconds.
1. At the top of the console click on **Amazon S3** and then click on the name of the _west_ bucket
      * If you used **Oregon** the name will be `<your_naming_prefix>-crrlab-us-west-2`
1. Click on the filename of the file that you just uploaded to the _other_ bucket (yes, it is here now too!)
      * It will look like the _right_ side of the screenshot below

      ![ReplicatedObject](/Reliability/200_Bidirectional_Replication_for_S3/Images/ReplicatedObject.png)

1. Note the following in from the object details:
      * **Replication status**: Note the different values for the source (east) and destination (west) S3 buckets. The value **REPLICA** in the west bucket is part of the solution how the system recognizes it should not replicate this object back again to the east bucket, which would cause an infinite loop.
      * **Server-side encryption**: The object was encrypted in the source (east) bucket, and remains encrypted in the destination (west) bucket.

### 2.3 Setup rule #2 to replicate objects from _west_ bucket to _east_ bucket

After setting up the second rule, you will have completed configuration of bi-directional replication between our two Amazon S3 buckets.

1. Go to the [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home), or if you are already there click on **Amazon S3** in the upper left corner
1. Click on the name of the _west_ bucket
      * if you used **Oregon** the name will be `<your_naming_prefix>-crrlab-us-west-2`
1. Click on the **Management** tab
1. Click **Create replication rule**
1. For **Rule name** enter `west to east`
1. For **Choose a rule scope** select **Apply to all objects in the bucket**
1. For **Destination** leave **Choose a bucket in this account** selected, and select the name of the _east_ bucket from the drop-down
      * If you used **Ohio** the name will be `<your_naming_prefix>-crrlab-us-east-2`
      * **Troubleshooting**: If you get an error saying _The bucket doesn’t have versioning enabled_ then you have chosen the wrong bucket. Double check the bucket name.
1. For **IAM Role** leave **Choose from existing IAM roles** selected, and select **\<your-naming-prefix\>-S3-Replication-Role-us-west-2** from the search results box
      * (If you chose a different region as your _west_ region, then look for that region at the end of the IAM role name)
1. For **Encryption**, select **Replicate objects encrypted with AWS KMS** and leave **AWS managed key (aws/s3)** selected.
1. Click **Save**

The screen will ask **Replicate existing objects?**, leave **No, do not replicate existing objects** selected and click **Submit**

The screen should say **Replication configuration successfully updated.** and display the Source, Destination, and Permissions of your replication rule (you may need to refresh)

![RuleTwoCreated](/Reliability/200_Bidirectional_Replication_for_S3/Images/RuleTwoCreated.png)

{{< prev_next_button link_prev_url="../1_deploy_infra/" link_next_url="../3_test_replication/" />}}