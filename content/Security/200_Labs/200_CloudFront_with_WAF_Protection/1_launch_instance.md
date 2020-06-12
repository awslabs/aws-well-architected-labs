---
title: "Launch Instance"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

You can launch a Linux instance using the AWS Management Console. This tutorial is intended to help you launch your first instance quickly, so it doesn't cover all possible options. For more information about the advanced options, see [Launching an Instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/launching-instance.html).
Launch an instance:

1. Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.
2. From the console dashboard, choose Launch Instance.
![ec2-launch-wizard](/Security/200_CloudFront_with_WAF_Protection/Images/ec2-launch-wizard-button.png)
3. The choose an Amazon Machine Image (AMI) page displays a list of basic configurations, called Amazon Machine Images (AMIs), that serve as templates for your instance. Select the HVM edition of the Amazon Linux AMI, either version.
![ec2-launch-wizard](/Security/200_CloudFront_with_WAF_Protection/Images/ec2-launch-wizard-ami.png)
4. On the Choose an Instance Type page, you can select the hardware configuration of your instance. Select the t2.micro type, which is selected by default. Notice that this instance type is eligible for the free tier. Then select Next: Configure Instance Details.
![ec2-launch-wizard](/Security/200_CloudFront_with_WAF_Protection/Images/ec2-launch-wizard-type.png)
5. On the Configure Instance Details page, make the following changes:

    5.1 Select Create new IAM role.

    ![ec2-launch-wizard](/Security/200_CloudFront_with_WAF_Protection/Images/ec2-launch-wizard-role.png)

    5.2	In the new tab that opens, select Create role.

    ![ec2-launch-wizard](/Security/200_CloudFront_with_WAF_Protection/Images/ec2-launch-wizard-create-role.png)

    5.3	With AWS service pre-selected, select EC2 from the top of the list, then click Next: Permissions.

    ![ec2-launch-wizard](/Security/200_CloudFront_with_WAF_Protection/Images/ec2-launch-wizard-create-role-start.png)

    5.4	Enter `s3` in the search and select AmazonS3ReadOnlyAccess from the list of policies, then click Next: Review. This policy will give this EC2 instance access to read and list any objects in Amazon S3 within your AWS account.

    ![ec2-launch-wizard](/Security/200_CloudFront_with_WAF_Protection/Images/ec2-launch-wizard-create-role-policy.png)

    5.5 Enter a role name, such as `ec2-s3-read-only-role`, and then click Create role.

    ![ec2-launch-wizard](/Security/200_CloudFront_with_WAF_Protection/Images/ec2-launch-wizard-create-role-name.png)

    5.6	Back on the EC2 launch web browser tab, select the refresh button next to Create new IAM role, and click the role you just created.

    ![ec2-launch-wizard](/Security/200_CloudFront_with_WAF_Protection/Images/ec2-launch-wizard-create-role-final.png)

    5.7 Scroll down and expand the Advanced Details section. Enter the following in the User Data test box to automatically install Apache web server and apply basic configuration when the instance is launched:

```
#!/bin/bash
yum update -y
yum install -y httpd
service httpd start
chkconfig httpd on
groupadd www
usermod -a -G www ec2-user
chown -R root:www /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} +
find /var/www -type f -exec chmod 0664 {} +
```

6. Accept defaults and click **Next: Add tags**.
7. Click **Next: Configure Security Group**.
	7.1 Accept default option **Create a new security group**.
    7.2 On the line of the first default entry *SSH*, select **Source** as *My IP*.
	7.3 Click **Add Rule**, select Type as *HTTP* and **Source** as *Anywhere*.
	Note that best practice is to have an Elastic Load Balancer inline or the EC2 instance not directly exposed to the internet. However, for simplicity in this lab, we are opening the access to anywhere. Other lab modules secure access with Elastic Load Balancer.

	![Security Group](/Security/200_CloudFront_with_WAF_Protection/Images/ec2-launch-wizard-security-group.png)

	7.5 Click Review and Launch.

	![ec2-launch-wizard](/Security/200_CloudFront_with_WAF_Protection/Images/ec2-launch-wizard-launch.png)

8. On the Review Instance Launch page, check the details, and then click Launch.
9. If you do not have an existing key pair for access instances, a prompt will appear. Click Create New,then type a name such as `lab`, click Download Key Pair, and then click Launch Instances.

![ec2-launch-wizard](/Security/200_CloudFront_with_WAF_Protection/Images/ec2-launch-wizard-keys.png)

{{% notice info %}}
This is the only chance to save the private key file. You'll need to provide the name of your key pair when you launch an instance, and you'll provide the corresponding private key each time you connect to the instance.
{{% /notice %}}


10. Click View Instances.
11. When your instance is launched, its status will change to running, and it will need a few minutes to apply patches and install Apache web server.

![ec2-status](/Security/200_CloudFront_with_WAF_Protection/Images/ec2-status.png)

12. You can connect to the Apache test page by entering the public DNS, which you can find on the description tab or instances list. Take note of this public DNS value.
