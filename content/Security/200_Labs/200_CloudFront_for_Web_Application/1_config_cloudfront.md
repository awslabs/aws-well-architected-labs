---
title: "Configure CloudFront - EC2 or Load Balancer"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

Using the AWS Management Console, we will create a CloudFront distribution, and link it to the AWS WAF
ACL we previously created.

1. Open the Amazon CloudFront console at https://console.aws.amazon.com/cloudfront/home.
2. From the console dashboard, choose Create Distribution.

![cloudfront-create](/Security/200_CloudFront_for_Web_Application/Images/cloudfront-create-button.png)

3. Click Get Started in the Web section.

![cloudfront-getstarted](/Security/200_CloudFront_for_Web_Application/Images/cloudfront-get-started.png)

4. Specify the following settings for the distribution:
  * In **Origin Domain Name** enter the DNS or domain name from your elastic load balancer or EC2 instance.

  ![cloudfront-create-distribution](/Security/200_CloudFront_for_Web_Application/Images/cloudfront-create-distribution.png)

  * Click Create Distrubution.
  * For more information on the other configuration options, see [Values That You Specify When You Create or Update a Web Distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html) in the CloudFront documentation.
5. After CloudFront creates your distribution, the value of the Status column for your distribution will change from In Progress to Deployed.

![cloudfront-deployed](/Security/200_CloudFront_for_Web_Application/Images/cloudfront-deployed.png)

6. When your distribution is deployed, confirm that you can access your content using your new CloudFront URL or CNAME. Copy the Domain Name into a web browser to test.

![cloudfront-test](/Security/200_CloudFront_for_Web_Application/Images/cloudfront-test.png)

For more information, see [Testing a Web Distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-testing.html) in the CloudFront documentation.
7. You have now configured Amazon CloudFront with basic settings.

For more information on configuring CloudFront, see [Viewing and Updating CloudFront Distributions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/HowToUpdateDistribution.html) in the CloudFront documentation.
