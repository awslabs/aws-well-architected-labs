---
title: "Test Resiliency Using Failure Injection - Optional steps"
menutitle: "Failure Injection - optional"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>7. </b>"
weight: 7
---

_The following are optional lab steps you may run to further explore failure injection_

### 7.1 S3 failure injection

1. Failure of S3 means that the image will not be available
1. You may ONLY do this testing if you supplied your own `websiteimage` reference to an S3 bucket you control

#### 7.1.1 Bucket name

You will need to know the bucket name where your image is. For example if the `websiteimage` value you supplied was `"https://s3.us-east-2.amazonaws.com/my-awesome-bucketname/my_image.jpg"`, then the bucket name is `my-awesome-bucketname`

For this failure simulation it is most straightforward to use the AWS Console as follows.  (If you are interested in doing this [using the AWS CLI then see here]({{< ref "Documentation/S3_with_AWS_CLI.md" >}}) - choose _either_ AWS Console or AWS CLI)

##### 7.1.2 AWS Console

  1. Navigate to the S3 console: <https://console.aws.amazon.com/s3>
  1. Select the bucket name where the image is located
  1. Select the object, then select the "Permissions" tab
  1. Select the "Public Access" radio button, and deselect the "Read object" checkbox and Save
  1. To re-enable access (after testing), do the same steps, tick the "Read object" checkbox and Save

#### 7.1.3 System response to S3 failure {#s3response}

What is the expected effect? How long does it take to take effect?

* Note that due to browser caching you may still see the image on refreshing the site. On most systems Shift-F5 does a clean refresh with no cache

How would you diagnose if this is a larger problem than permissions?

### 7.2 More testing you can do

You can use drift detection in the CloudFormation console to see what had changed, or work on code to heal the failure modes.
