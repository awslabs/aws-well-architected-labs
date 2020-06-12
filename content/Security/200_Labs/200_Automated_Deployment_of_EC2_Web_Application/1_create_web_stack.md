---
title: "Create Web Stack"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>1. </b>"
---

Please note a prerequisite to this lab is that you have deployed the CloudFormation VPC stack in the lab [Automated Deployment of VPC](/Security/200_Automated_Deployment_of_VPC/) with the default parameters and recommended stack name.

1. Choose the version of the CloudFormation template and download to your computer, or by [cloning](https://help.github.com/en/articles/cloning-a-repository) this repository:
   * [wordpress.yaml](/Security/200_Automated_Deployment_of_EC2_Web_Application/Code/wordpress.yaml) to create a WordPress site, including an RDS database.
   * [staticwebapp.yaml](/Security/200_Automated_Deployment_of_EC2_Web_Application/Code/staticwebapp.yaml) to create a static web application that simply displays the instance ID for the instance it is running upon.
2. Sign in to the AWS Management Console, select your preferred region, and open the CloudFormation console at [https://console.aws.amazon.com/cloudformation/](https://console.aws.amazon.com/cloudformation/). Note if your CloudFormation console does not look the same, you can enable the redesigned console by clicking **New Console** in the **CloudFormation** menu.
3. Click **Create Stack**, then **With new resources (standard)**.

![cloudformation-createstack-1](/Security/200_Automated_Deployment_of_EC2_Web_Application/Images/cloudformation-createstack-1.png)

4. Click **Upload a template file** and then click **Choose file**.

![cloudformation-createstack-2](/Security/200_Automated_Deployment_of_EC2_Web_Application/Images/cloudformation-createstack-2.png)

5. Choose the CloudFormation template you downloaded in step 1, return to the CloudFormation console page and click **Next**.
6. Enter the following details:
  * Stack name: The name of this stack. For this lab, for the WordPress stack use *WebApp1-WordPress* or for the static web stack use *WebApp1-Static* and match the case.
  ![cloudformation-wp-params](/Security/200_Automated_Deployment_of_EC2_Web_Application/Images/cloudformation-wp-params.png)
  * ALBSGSource: Your current IP address in CIDR notation which will be allowed to connect to the application load balancer, this secures your web application from the public while you are configuring and testing.
  ![cloudformation-wp-params-2](/Security/200_Automated_Deployment_of_EC2_Web_Application/Images/cloudformation-wp-params-2.png)
  The remaining parameters may be left as defaults, you can find out more in the description for each.
7. At the bottom of the page click **Next**.
8. In this lab, we won't add any tags, permissions or advanced options. Click **Next**. Tags, which are key-value pairs, can help you identify your stacks. For more information, see [Adding Tags to Your AWS CloudFormation Stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-add-tags.html).
9. Review the information for the stack. When you're satisfied with the configuration, check **I acknowledge that AWS CloudFormation might create IAM resources with custom names** then click **Create stack**.

![cloudformation-wp-createstack-final](/Security/200_Automated_Deployment_of_EC2_Web_Application/Images/cloudformation-wp-createstack-final.png)

10. After a number of minutes the final stack status should change from *CREATE_IN_PROGRESS* to *CREATE_COMPLETE*.

 ![cloudformation-wp-createstack-complete](/Security/200_Automated_Deployment_of_EC2_Web_Application/Images/cloudformation-wp-createstack-complete.png)

You have now created the WordPress stack (well actually CloudFormation did it for you).

11. In the stack click the **Outputs** tab, and open the *WebsiteURL* value in your web browser, this is how to access what you just created.
12. After you have played and explored with your web application, don't forget to tear it down to save cost.

## Further Considerations

* Enable TLS (SSL) on application load balancer to encrypt communications, using Amazon Certificate Manager.
* WordPress that is deployed stores the database password in clear text in a configuration file and is not rotated, best practice (that is supported by WordPress) would be to encrypt and automatically rotate preferably accessing the Secrets Manager API.
* Use [EBS encryption](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSEncryption.html#encryption-by-default) by default to encrypting the EBS volumes for the web instances.
* Implementing a Web Application Firewall such as AWS WAF, and a content delivery service such as Amazon CloudFront to help protect the application.
* Create an automated process for patching the AMI's and scanning for vulnerabilities before updating in production.
* Create a pipeline that verifies the CloudFormation template for misconfigurations before creating or updating the stack.
