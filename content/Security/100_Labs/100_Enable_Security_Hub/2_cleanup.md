---
title: "Tear Down"
date: 2021-02-23T10:29:10-05:00
draft: false
weight: 2
pre: "<b>2. </b>"
---

The following instructions will disable AWS Config and Security Hub. 

Disable AWS Config:

1. Open the AWS Config console at [https://console.aws.amazon.com/config/](https://console.aws.amazon.com/config/).
2. Choose **Settings** in the navigation pane.
3. Select **Edit**. 
4. Uncheck **Enable Recording**.
5. Select **Save**.
4. Additional details [here](https://docs.aws.amazon.com/config/latest/developerguide/stop-start-recorder.html)

Disable Security Hub:

1. Open the AWS Security Hub console at [https://console.aws.amazon.com/securityhub/](https://console.aws.amazon.com/securityhub/).
2. In the navigation pane, choose **Settings**.
3. On the **Settings** page, choose **General**.
4. Under **Disable AWS Security Hub**, choose **Disable AWS Security Hub**. Then choose **Disabled AWS Security Hub** again.
5. Additional details [here](https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-disable.html)

Delete the S3 bucket:

1. Open the Amazon S3 console at [https://console.aws.amazon.com/s3/](https://console.aws.amazon.com/s3/).
2. Check the box next to the bucket that was created for AWS Config (i.e. "config-bucket-12345"), then click **Empty** from the menu.
3. Confirm the bucket you are emptying.
4. Once the bucket is empty check the box next to the bucket, then click **Delete** from the menu.
5. Confirm the bucket you are deleting.

***

