---
title: "Create S3 bucket"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

Create an Amazon S3 bucket to host static content using the Amazon S3 console.
For more information about Amazon S3, see [Introduction to Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/dev/Introduction.html).

1. Open the Amazon S3 console at [https://console.aws.amazon.com/s3/](https://console.aws.amazon.com/s3/).
2. From the console dashboard, choose **Create bucket**.

![s3-create-bucket-1](/Security/100_CloudFront_with_S3_Bucket_Origin/Images/s3-create-bucket-1.png)

3. Enter a name for your bucket, type a unique DNS-compliant name for your new bucket. Follow these naming guidelines:

  * The name must be unique across all existing bucket names in Amazon S3.
  * The name must not contain uppercase characters.
  * The name must start with a lowercase letter or number.
  * The name must be between 3 and 63 characters long.

![s3-create-bucket-2](/Security/100_CloudFront_with_S3_Bucket_Origin/Images/s3-create-bucket-2.png)

4. Choose an AWS Region where you want the bucket to reside. Choose a Region close to you to minimize latency and costs, or to address regulatory requirements.
  Note that for this example we will accept the default settings and this bucket is secure by default. Consider enabling additional security options such as logging and encryption, the S3 documentation has additional information such as [Protecting Data in Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/dev/DataDurability.html).
5. Click **Create**.
