# Level 200: CloudFront for Web Application: Lab Guide

## Authors
- Ben Potter, Security Lead, Well-Architected

## Table of Contents
1. [Configure CloudFront - EC2 or Load Balancer](#cloudfront1)
2. [Tear Down](#tear_down)

## 1. Configure Amazon CloudFront for EC2 or Elastic Load Balancer<a name="cloudfront1"></a>
Using the AWS Management Console, we will create a CloudFront distribution, and link it to the AWS WAF
ACL
we previously created.
1. Open the Amazon CloudFront console at https://console.aws.amazon.com/cloudfront/home.
2. From the console dashboard, choose Create Distribution.  
![cloudfront-create](Images/cloudfront-create-button.png)  
3. Click Get Started in the Web section.  
![cloudfront-getstarted](Images/cloudfront-get-started.png)  
4. Specify the following settings for the distribution:
  * In **Origin Domain Name** enter the DNS or domain name from your elastic load balancer or EC2 instance.
  ![cloudfront-create-distribution](Images/cloudfront-create-distribution.png)
  * Click Create Distrubution.
  * For more information on the other configuration options, see [Values That You Specify When You Create or Update a Web Distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html) in the CloudFront documentation.
5. After CloudFront creates your distribution, the value of the Status column for your distribution will change from In Progress to Deployed.  
![cloudfront-deployed](Images/cloudfront-deployed.png)  
6. When your distribution is deployed, confirm that you can access your content using your new CloudFront URL or CNAME. Copy the Domain Name into a web browser to test.  
![cloudfront-test](Images/cloudfront-test.png)  
For more information, see [Testing a Web Distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-testing.html) in the CloudFront documentation.
7. You have now configured Amazon CloudFront with basic settings.  

For more information on configuring CloudFront, see [Viewing and Updating CloudFront Distributions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/HowToUpdateDistribution.html) in the CloudFront documentation.

***

### 2. Tear down this lab <a name="tear_down"></a>
The following instructions will remove the resources that have a cost for running them. Please note that
Security Groups and SSH key will exist. You may remove these also or leave for future use.

Delete the CloudFront distribution:
1. Open the Amazon CloudFront console at https://console.aws.amazon.com/cloudfront/home.
2. From the console dashboard, select the distribution you created earlier and click the Disable button.
To confirm, click the Yes, Disable button.
3. After approximately 15 minutes when the status is Deployed, select the distribution and click the Delete
button, and then to confirm click the Yes, Delete button.

***

## References & useful resources:
[Amazon CloudFront Developer Guide](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)  
[AWS WAF, AWS Firewall Manager, and AWS Shield Advanced Developer Guide](https://docs.aws.amazon.com/waf/latest/developerguide/waf-chapter.html)  

***

## License
Licensed under the Apache 2.0 and MITnoAttr License. 

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


