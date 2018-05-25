# Level 100: EC2 Web Infrastructure Protection: Lab Guide

## 1. Launch First Instance
For launching your first instance, we are going to use the launch wizard in the Amazon EC2 console.

### 1.1 Launch Single Instance
You can launch a Linux instance using the AWS Management Console. This tutorial is intended to help you launch your first instance quickly, so it doesn't cover all possible options. For more information about the advanced options, see [Launching an Instance](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/launching-instance.html).
Launch an instance:
1. Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.
2. From the console dashboard, choose Launch Instance.
![ec2-launch-wizard](Images/ec2-launch-wizard-button.png)
3. The choose an Amazon Machine Image (AMI) page displays a list of basic configurations, called Amazon Machine Images (AMIs), that serve as templates for your instance. Select the HVM edition of the Amazon Linux AMI.
![ec2-launch-wizard](Images/ec2-launch-wizard-ami.png)
4. On the Choose an Instance Type page, you can select the hardware configuration of your instance. Select the t2.micro type, which is selected by default. Notice that this instance type is eligible for the free tier. Then select Next: Configure Instance Details.
![ec2-launch-wizard](Images/ec2-launch-wizard-type.png)
5. On the Configure Instance Details page, make the following changes:
  5.1 Select Create new IAM role.
  ![ec2-launch-wizard](Images/ec2-launch-wizard-role.png)
  5.2	In the new tab that opens, select Create role.
  	![ec2-launch-wizard](Images/ec2-launch-wizard-create-role.png)
  5.3	With AWS service pre-selected, select EC2 from the top of the list, then click Next: Permissions.

  	![ec2-launch-wizard](Images/ec2-launch-wizard-create-role-start.png)
  5.4	Enter `s3` in the search and select AmazonS3ReadOnlyAccess from the list of policies, then click
  Next: Review. This policy will give this EC2 instance access to read and list any objects in Amazon
  S3 within your AWS account.
  	![ec2-launch-wizard](Images/ec2-launch-wizard-create-role-policy.png)
  5.5	Enter a role name, such as `ec2-s3-read-only-role`, and then click Create role.
  	![ec2-launch-wizard](Images/ec2-launch-wizard-create-role-name.png)
  5.6	Back on the EC2 launch web browser tab, select the refresh button next to Create new IAM role,
  and click the role you just created.
  	![ec2-launch-wizard](Images/ec2-launch-wizard-create-role-final.png)
  5.7 Scroll down and expand the Advanced Details section. Enter the following in the User Data test box to automatically install Apache web server and apply basic configuration when the instance is launched:
  	```
	#!/bin/bash
	yum update -y
	yum install -y httpd24
	service httpd start
	chkconfig httpd on
	groupadd www
	usermod -a -G www ec2-user
	chown -R root:www /var/www
	chmod 2775 /var/www
	find /var/www -type d -exec chmod 2775 {} +
	find /var/www -type f -exec chmod 0664 {} +
   	```
6. Accept defaults and Choose Next: Add tags.
7. Click Next: Configure Security Group.
	7.1 On type SSH, select Source as `My IP`
	7.2 Click Add Rule, select Type as HTTP and source as `Anywhere`
	Note that best practice is to have an Elastic Load Balancer inline or the EC2 instance not directly
  exposed. However, for simplicity in this lab, we are opening the access to anywhere. Later modules will
  secure access with Elastic Load Balancer.
	7.2 Select Add Rule to add both SSH and HTTP, and on source, select `My IP`.
	![Security Group](Images/ec2-launch-wizard-security-group.png)
	7.3 Click Review and Launch.
	![ec2-launch-wizard](Images/ec2-launch-wizard-launch.png)
8. On the Review Instance Launch page, check the details, and then click Launch.
9. If you do not have an existing key pair for access instances, a prompt will appear. Click Create New,
then type a name such as `lab`, click Download Key Pair, and then click Launch Instances.
![ec2-launch-wizard](Images/ec2-launch-wizard-keys.png)
    **Important**

    This is the only chance to save the private key file. You'll need to provide the name of your key
    pair when you launch an instance, and you'll provide the corresponding private key each time you connect
    to the instance.

10. Click View Instances.
11. When your instance is launched, its status will change to running, and it will need a few minutes to apply patches and install Apache web server.
![ec2-status](Images/ec2-status.png)
12. You can connect to the Apache test page by entering the public DNS, which you can find on the description
tab or instances list. Take note of this public DNS value.


***


## 2. Configure Amazon CloudFront with AWS WAF

### 2.1 AWS CloudFormation to create AWS WAF for Amazon CloudFront
Using [AWS CloudFormation](https://aws.amazon.com/cloudformation/), we are going to deploy a basic example
AWS WAF configuration for use with CloudFront.

1. Sign in to the AWS Management Console, select your preferred region, and open the CloudFormation console at https://console.aws.amazon.com/cloudformation/.
2. Click Create New Stack.
3. Select Specify an Amazon S3 template URL and enter the following URL for the template: `https://s3-us-west-2.amazonaws.com/aws-well-architected-labs/Security/Code/waf-global.yaml` and click Next.
4. Enter the following details:
  * WAFName: Enter the base name to be used for resource and export names for this stack. For this lab, you can use `Lab1`.
  * WAFCloudWatchPrefix: Enter the name of the CloudWatch prefix to use for each rule using alphanumeric
  characters only. For this lab, you can use `Lab1`.
  The remainder of the parameters can be left as defaults.
  ![waf-create-stack](Images/waf-create-stack.png)
5. Click Next.
6. In this scenario, we won't add any tags or other options. Click Next.
7. Review the information for the stack. When you're satisfied with the settings, click Next.
8. Select I acknowledge that AWS CloudFormation might create IAM resources with custom names, and click
Create.
9. After a few minutes, the stack status should change from CREATE_IN_PROGRESS to CREATE_COMPLETE.
10. You have now set up a basic AWS WAF configuration ready for CloudFront to use!


### 2.2 Configure Amazon CloudFront
Using the AWS Management Console, we will create a CloudFront distribution, and link it to the AWS WAF
ACL
we previously created.
1. Open the Amazon CloudFront console at https://console.aws.amazon.com/cloudfront/home.
2. From the console dashboard, choose Create Distribution.
![cloudfront-create](Images/cloudfront-create-button.png)
3. Click Get Started in the Web section.
![cloudfront-getstarted](Images/cloudfront-get-started.png)
4. Specify the following settings for the distribution:
  * Enter the EC2 public DNS name you recorded from your instance launch.
  ![cloudfront-create-distribution](Images/cloudfront-create-distribution.png)
  * In the distribution Settings section, click AWS WAF Web ACL, and select the one you created previously.
  ![cloudfront-distribution-settings](Images/cloudfront-distribution-settings.png)
  * Click Create Distrubution.
  * For more information on the other configuration options, see [Values That You Specify When You Create or Update a Web Distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html) in the CloudFront documentation.
5. After CloudFront creates your distribution, the value of the Status column for your distribution will change from In Progress to Deployed.
![cloudfront-deployed](Images/cloudfront-deployed.png)
6. When your distribution is deployed, confirm that you can access your content using your new CloudFront URL or CNAME. Copy the Domain Name into a web browser to test.
![cloudfront-test](Images/cloudfront-test.png)
For more information, see [Testing a Web Distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-testing.html) in the CloudFront documentation.
7. You have now configured Amazon CloudFront with basic settings and AWS WAF.

For more information on configuring CloudFront, see [Viewing and Updating CloudFront Distributions](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/HowToUpdateDistribution.html) in the CloudFront documentation.


***


### 3. Tear down this lab
The following instructions will remove the resources that have a cost for running them. Please note that
Security Groups and SSH key will exist. You may remove these also or leave for future use.
Terminate the instance:
1. Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.
2. From the left console instance menu, select Instances.
3. Select the instance you created to terminate.
4. From the Actions button (or right click) select Instance State > Terminate.
![ec2-terminate](Images/ec2-terminate.png)
5. Verify this is the instance you want terminated, then click the Yes, Terminate button.

Delete the CloudFront distribution:
1. Open the Amazon CloudFront console at https://console.aws.amazon.com/cloudfront/home.
2. From the console dashboard, select the distribution you created earlier and click the Disable button.
To confirm, click the Yes, Disable button.
3. After approximately 15 minutes when the status is Deployed, select the distribution and click the Delete
button, and then to confirm click the Yes, Delete button.

Delete the AWS WAF stack:
1. Sign in to the AWS Management Console, and open the CloudFormation console at https://console.aws.amazon.com/cloudformation/.
2. Select the `waf-cloudfront` stack.
3. Click the Actions button, and then click Delete Stack.
4. Confirm the stack, and then click the Yes, Delete button.

***

## References & useful resources:
[Amazon Elastic Compute Cloud User Guide for Linux Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)  
[Amazon CloudFront Developer Guide](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)  
[Tutorial: Configure Apache Web Server on Amazon Linux 2 to Use SSL/TLS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/SSL-on-an-instance.html)  
[AWS WAF, AWS Firewall Manager, and AWS Shield Advanced Developer Guide](https://docs.aws.amazon.com/waf/latest/developerguide/waf-chapter.html)  

***

## License
Licensed under the Apache 2.0 and MITnoAttr License. 

Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


