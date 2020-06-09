---
title: "Test bi-directional cross-region replication (CRR)"
menutitle: "Test CRR"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

To test bi-directional replication using the two rules your created, you will upload another object into each of the east and west S3 buckets and observe it is replicated across to the other bucket. For this step you will need two more _test objects_:

* These are files that you will upload into each S3 bucket.
* They should not be too big, as this will increase the time to upload it from your computer.
* If you do not have files to use, you can [download file #1](/Reliability/200_Bidirectional_Replication_for_S3/Images/TestObject_OhioAwsEast.png) and [download file #2](/Reliability/200_Bidirectional_Replication_for_S3/Images/TestObject_OregonAwsWest.png)

| File #1 | File #2 |
|:---:|:---:|
|![OhioAwsEast](/Reliability/200_Bidirectional_Replication_for_S3/Images/TestObject_OhioAwsEast.png)|![OregonAwsWest](/Reliability/200_Bidirectional_Replication_for_S3/Images/TestObject_OregonAwsWest.png)|

### 3.1 Upload objects to their respective Amazon S3 buckets

#### 3.1.1 Upload object #1 to the _east_ S3 bucket

1. Go to the [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home), or if you are already there click on **Amazon S3** in the upper left corner
1. Click on the name of the _east_ bucket
      * if you used **Ohio** the name will be `<your_naming_prefix>-crrlab-us-east-2`
1. Click on **⬆ Upload**
1. Upload the file you will use as object #1
      * Drag and drop the file or click **Add files**
      * Click **Upload** (note there is a **Next** button, but you do _not_ need to click it)

#### 3.1.2 Upload object #2 to the _west_ S3 bucket

1. Click on **Amazon S3** in the upper left corner of the Amazon S3 console
1. Click on the name of the _west_ bucket
      * if you used **Oregon** the name will be `<your_naming_prefix>-crrlab-us-west-2`
1. Click on **⬆ Upload**
1. Upload the file you will use as object #2
      * Drag and drop the file or click **Add files**
      * Click **Upload** (note there is a **Next** button, but you do _not_ need to click it)

### 3.2 Verify bi-directional replication

1. You are already looking at the objects in the _west_ bucket
      * Verify that object #1, that you uploaded to the _east_ bucket is present here also
      * Note the **Replication status** is **REPLICA**
1. Click on **Amazon S3** in the upper left corner
1. Click on the name of the _east_ bucket
      * Verify that object #2, that you uploaded to the _west_ bucket is present here also
      * Note the **Replication status** is **REPLICA**

### 3.3 Explore which Amazon S3 events trigger replication and which do not

#### 3.3.1 Use CloudWatch Logs Insights to query the CloudTrail logs

AWS CloudTrail is a service that provides event history of your AWS account activity, including actions taken through the AWS Management Console, AWS SDKs, command line tools, and other AWS services. You will use AWS CloudTrail to explore which Amazon S3 events trigger replication to occur.

1. Change back to the _east_ AWS region
      * If you used the directions in this lab, then this is **Ohio (us-east-2)**
1. The CloudFormation template you deployed configured CloudTrail to deliver a trail to CloudWatch Logs. Therefore:
      * Go to the [CloudWatch console](https://console.aws.amazon.com/cloudwatch)
      * Click on **Insights** (under **Logs**) on the left
1. Where it says **Select log group(s)** select the one named _CloudTrail/logs/\<your_prefix_name\>_
1. Right below that is where you can enter a query
      * Delete the query that is there
      * and enter the following query. It returns all `PutObject` requests on S3 buckets

                  fields @timestamp, requestParameters.key AS key,
                  | requestParameters.bucketName AS bucket,
                  | userIdentity.invokedBy AS invokedBy,
                  | userIdentity.arn AS arn,
                  | userIdentity.sessionContext.sessionIssuer.userName AS UserName
                  | filter eventName ='PutObject'
                  | sort @timestamp desc
                  | limit 20

1. Click **Run query**
1. Look at the results at the bottom of the screen

#### 3.3.2 Difference between uploaded and replicated objects in S3 bucket {#putobject_events}

You are looking for three results, one for each of the test objects you uploaded.  Use the _key_ field to see the test object names.

* Troubleshooting: If your query returned less or more than three results then consult this [guide to tuning your Insights query](../documentation/tuneinsightsquery/)

* For these events look at the _tabular_ attributes returned by the query at the bottom of the page
     * However, if you want to see _all_ the attributes, you can click to the left of each event
* The three events correspond to each of the objects you put into the S3 buckets
     * The object you put into the _east_ bucket testing rule #1
     * The object you put into the _east_ bucket testing bi-directional replication
     * The object you put into the _west_ bucket testing bi-directional replication
          * Look at the bucket for this event. This event is for the _east_ bucket
          * This is actually the _replication_ event for the object you put into the _west_ bucket
* {{%expand "What is different between events where you uploaded the object into the bucket and events where the object was put into the bucket by replication?" %}}
Replicated objects have a userIdentity.invokedBy value of "AWS Internal"

The userIdentity is different - see the arn and username
{{% /expand%}}


The CloudWatch Logs Insights page should look like this:

![CloudTrailForS3](/Reliability/200_Bidirectional_Replication_for_S3/Images/CloudTrailForS3.png)

The result is:

* For an object uploaded by you
     * Amazon S3 triggers the rule you configured to replicate it to another bucket
     * And sets **Replication status** to **COMPLETED**
* For an object replicated from another bucket
     * Amazon S3 knows _not_ to re-replicate the object
     * And sets **Replication status** to **REPLICA**

### 3.4 Additional exercises

These are _optional_. They help you to explore and understand bi-direction cross-region replication on Amazon S3.

* Look at the **Permissions** on the **\<your-naming-prefix\>-S3-Replication-Role-...** IAM Roles
     * Why do they have the policies that they do?

* What happens when you rename an object in one of the buckets?
     * Hint: if you cannot figure it out consider that versioning is enabled (and must be enabled for replication to work)

* Switch to the _west_ AWS region and run the same CloudWatch Insights Query there.
     * What do you expect?

### 3.5 Summary

You created two S3 buckets in two different AWS regions. You then setup bi-directional cross-region replication (CRR) between the two Amazon S3 buckets. Putting an object in either bucket resulted in the object asynchronously being backed up to the _other_ bucket. Objects encrypted in their original bucket are also encrypted in their replication bucket. Objects are replicated once -- replication "looping" is prevented.
