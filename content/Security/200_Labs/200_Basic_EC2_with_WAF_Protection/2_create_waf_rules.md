---
title: "Create AWS WAF Rules"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

### 2.1 AWS CloudFormation to create AWS WAF ACL for Application Load Balancer

Using [AWS CloudFormation](https://aws.amazon.com/cloudformation/), we are going to deploy a basic example
AWS WAF configuration for use with Application Load Balancer.

1. Sign in to the AWS Management Console, select your preferred region, and open the CloudFormation console at https://console.aws.amazon.com/cloudformation/. Note if your CloudFormation console does not look the same, you can enable the redesigned console by clicking **New Console** in the **CloudFormation** menu.
2. Click Create New Stack.
3. Select Specify an Amazon S3 template URL and enter the following URL for the template: `https://s3-us-west-2.amazonaws.com/aws-well-architected-labs/Security/Code/waf-regional.yaml` and click Next.
4. Enter the following details:
  * Stack name: The name of this stack. For this lab, use `lab-waf-regional`.
  * WAFName: Enter the base name to be used for resource and export names for this stack. For this lab, you can use `WAFLabReg`.
  * WAFCloudWatchPrefix: Enter the name of the CloudWatch prefix to use for each rule using alphanumeric
  characters only. For this lab, you can use `WAFLabReg`.
  The remainder of the parameters can be left as defaults.

  ![waf-create-stack](/Security/200_Basic_EC2_with_WAF_Protection/Images/waf-regional-create-stack.png)

5. Click Next.
6. In this scenario, we won't add any tags or other options. Click Next.
7. Review the information for the stack. When you're satisfied with the settings, click Create.
8. After a few minutes, the stack status should change from CREATE_IN_PROGRESS to CREATE_COMPLETE.
9. You have now set up a basic AWS WAF configuration ready for Application Load Balancer to use!
