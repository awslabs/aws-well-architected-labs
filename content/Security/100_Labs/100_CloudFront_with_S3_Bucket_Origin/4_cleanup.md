---
title: "Tear down this lab"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

The following instructions will remove the CloudFront distribution and S3 bucket created in this lab.

Delete the CloudFront distribution:

1. Open the Amazon CloudFront console at (https://console.aws.amazon.com/cloudfront/home).
2. From the console dashboard, select the distribution you created earlier and click the Disable button.
To confirm, click the Yes, Disable button.
3. After approximately 15 minutes when the status is **Disabled**, select the distribution and click the **Delete**.
button, and then to confirm click the Yes, Delete button.

Delete the S3 bucket:

1. Open the Amazon S3 console at [https://console.aws.amazon.com/s3/](https://console.aws.amazon.com/s3/).
2. Check the box next to the bucket you created previously, then click **Empty** from the menu.
3. Confirm the bucket you are emptying.
4. Once the bucket is empty check the box next to the bucket, then click **Delete** from the menu.
5. Confirm the bucket you are deleting.

***

## References & useful resources

[Amazon S3 Developer Guide](https://docs.aws.amazon.com/AmazonS3/latest/dev/Welcome.html)
[Amazon CloudFront Developer Guide](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)
