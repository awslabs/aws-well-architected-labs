---
title: "Configure AWS WAF"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

Using [AWS CloudFormation](https://aws.amazon.com/cloudformation/), we are going to deploy a basic example
AWS WAF configuration for use with CloudFront.

1. Sign in to the AWS Management Console, select your preferred region, and open the CloudFormation console at https://console.aws.amazon.com/cloudformation/. Note if your CloudFormation console does not look the same, you can enable the redesigned console by clicking **New Console** in the **CloudFormation** menu.
2. Click **Create stack**.

![cloudformation-createstack-1](/Security/200_Automated_Deployment_of_Web_Application_Firewall/Images/cloudformation-createstack-1.png)

3. Enter the following **Amazon S3 URL**:  `https://s3-us-west-2.amazonaws.com/aws-well-architected-labs/Security/Code/waf-global.yaml` and click **Next**.

![cloudformation-createstack-s3](/Security/200_Automated_Deployment_of_Web_Application_Firewall/Images/cloudformation-createstack-s3.png)

4. Enter the following details:
  * Stack name: The name of this stack. For this lab, use `waf`.
  * WAFName: Enter the base name to be used for resource and export names for this stack. For this lab, you can use `Lab1`.
  * WAFCloudWatchPrefix: Enter the name of the CloudWatch prefix to use for each rule using alphanumeric
  characters only. For this lab, you can use `Lab1`.
  The remainder of the parameters can be left as defaults.

  ![waf-create-stack](/Security/200_Automated_Deployment_of_Web_Application_Firewall/Images/waf-create-stack.png)

5. At the bottom of the page click **Next**.
6. In this lab, we won't add any tags or other options. Click Next. Tags, which are key-value pairs, can help you identify your stacks. For more information, see [Adding Tags to Your AWS CloudFormation Stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-add-tags.html).
7. Review the information for the stack. When you're satisfied with the configuration, click **Create stack**.
8. After a few minutes the stack status should change from *CREATE_IN_PROGRESS* to *CREATE_COMPLETE*.
10. You have now set up a basic AWS WAF configuration ready for CloudFront to use!
