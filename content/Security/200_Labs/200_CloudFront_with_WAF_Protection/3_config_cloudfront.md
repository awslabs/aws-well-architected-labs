---
title: "Configure Amazon CloudFront"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

Using the AWS Management Console, we will create a CloudFront distribution, and link it to the AWS WAF ACL we previously created.

1. Open the Amazon CloudFront console at https://console.aws.amazon.com/cloudfront/home.
2. From the console dashboard, choose Create Distribution.

![cloudfront-create](/Security/200_CloudFront_with_WAF_Protection/Images/cloudfront-create-button.png)

3. Click Get Started in the Web section.

![cloudfront-getstarted](/Security/200_CloudFront_with_WAF_Protection/Images/cloudfront-get-started.png)

4. Specify the following settings for the distribution:
  * In **Origin Domain Name** enter the EC2 public DNS name you recorded from your instance launch.

  ![cloudfront-create-distribution](/Security/200_CloudFront_with_WAF_Protection/Images/cloudfront-create-distribution.png)

  * In the distribution Settings section, click AWS WAF Web ACL, and select the one you created previously.

  ![cloudfront-distribution-settings](/Security/200_CloudFront_with_WAF_Protection/Images/cloudfront-distribution-settings.png)

  * Click Create Distrubution.
  * For more information on the other configuration options, see [Values That You Specify When You Create or Update a Web Distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html) in the CloudFront documentation.
5. After CloudFront creates your distribution, the value of the Status column for your distribution will change from In Progress to Deployed.

![cloudfront-deployed](/Security/200_CloudFront_with_WAF_Protection/Images/cloudfront-deployed.png)

6. When your distribution is deployed, confirm that you can access your content using your new CloudFront URL or CNAME. Copy the Domain Name into a web browser to test.

![cloudfront-test](/Security/200_CloudFront_with_WAF_Protection/Images/cloudfront-test.png)

For more information, see [Testing a Web Distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-testing.html) in the CloudFront documentation.
7. You have now configured Amazon CloudFront with basic settings and AWS WAF.

For more information on configuring CloudFront, see [Viewing and Updating CloudFront Distributions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/HowToUpdateDistribution.html) in the CloudFront documentation.
