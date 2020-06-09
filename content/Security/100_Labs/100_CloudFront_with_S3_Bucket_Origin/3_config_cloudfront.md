---
title: "Configure Amazon CloudFront"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

Using the AWS Management Console, we will create a CloudFront distribution, and configure it to serve the S3 bucket we previously created.

1. Open the Amazon CloudFront console at [https://console.aws.amazon.com/cloudfront/home](https://console.aws.amazon.com/cloudfront/home).
2. From the console dashboard, click **Create Distribution**.

![cloudfront-create](/Security/100_CloudFront_with_S3_Bucket_Origin/Images/cloudfront-create-button.png)

3. Click **Get Started** in the Web section.

![cloudfront-getstarted](/Security/100_CloudFront_with_S3_Bucket_Origin/Images/cloudfront-get-started.png)

4. Specify the following settings for the distribution:
  * In the **Origin Domain Name** field Select the S3 bucket you created previously.
  * In **Restrict Bucket Access** click the **Yes** radio then click **Create a New Identity**.
  * Click the **Yes, Update Bucket Policy Button**.

  ![cloudfront-create-distribution-s3-1](/Security/100_CloudFront_with_S3_Bucket_Origin/Images/cloudfront-create-distribution-s3-1.png)

  * Scroll down to the **Distribution Settings** section, in the **Default Root Object** field enter *index.html*
  * Click Create Distribution.
  * To return to the main CloudFront page click **Distributions** from the left navigation menu.
  * For more information on the other configuration options, see [Values That You Specify When You Create or Update a Web Distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html) in the CloudFront documentation.
5. After CloudFront creates your distribution which may take approximately 10 minutes, the value of the Status column for your distribution will change from **In Progress** to **Deployed**.

![cloudfront-deployed](/Security/100_CloudFront_with_S3_Bucket_Origin/Images/cloudfront-deployed.png)

6. When your distribution is deployed, confirm that you can access your content using your new CloudFront **Domain Name** which you can see in the console. Copy the Domain Name into a web browser to test.

![cloudfront-test-s3](/Security/100_CloudFront_with_S3_Bucket_Origin/Images/cloudfront-test-s3.png)

For more information, see [Testing a Web Distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-testing.html) in the CloudFront documentation.
7. You now have content in a private S3 bucket, that only CloudFront has secure access to. CloudFront then serves the requests, effectively becoming a secure, reliable static hosting service with additional features available such as [custom certificates](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-https.html) and alternate [domain names](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/CNAMEs.html).

For more information on configuring CloudFront, see [Viewing and Updating CloudFront Distributions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/HowToUpdateDistribution.html) in the CloudFront documentation.
