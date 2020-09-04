---
title: "Deploy the CloudFormation Stack"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

This portion of the lab shows you how to deploy an EC2 instance using a CloudFormation template. The CloudFormation template will deploy the following:

* **Lab VPC**: The VPC used in this lab. This VPC contains a single public subnet, each with its own route table. An Internet Gateway and is used to route traffic to the public subnet.
* **EC2 Instance:** This is the EC2 instance that hosts the simple Apache web application. You will also be configuring the CloudWatch Logs Agent to work on this instance.
* **IAM Role:** An IAM role that allows the instance to send logs and metrics to CloudWatch and allows SSM actions to be performed on the instance.
* **S3 Bucket**: The S3 bucket to store log files generated in this lab.

1. [Download the CloudFormation template provided in this lab](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/code/security-lab-stack.yaml).
2. **OPTIONAL**: Look through the CloudFormation template and comments to see the resources deployed. More information on templates can be found [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-whatis-concepts.html#w2ab1b5c15b7).
3. Go to [CloudFormation console](https://console.aws.amazon.com/cloudformation/), click **Create Stack**, and select **With new resources (standard)**.
4. In the **Specify Template** menu, choose **Upload a template file**, then **Choose file**, and select the `security-lab-stack.yaml` template you downloaded.

![cfn-create-stack-1](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/cfn-create-stack-1.png)

5. In the **Specify Stack Details** menu:
   1. Enter a stack name, such as `security-cw-lab`. Note the name down, as you will need to re-visit this stack for Outputs later on.
   2. Enter your name in the `DisplayedName` field, this will be the name that appears on your sample website!
   3. Enter an S3 bucket name in the `BucketName` field. Amazon S3 bucket names are globally unique, and the namespace is shared by all AWS accounts, so make sure your bucket is names as uniquely as possible. For example: `wa-lab-<your-account-id>-<date>`.
   4. Do not modify the `LatestAmiId` field. This uses a public parameter stored in Systems Manager Parameter Store that will automatically use the latest Amazon Machine Image (AMI) for the EC2 instance.

![cfn-create-stack-2](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/cfn-create-stack-2.png)

6. No changes are needed on the **Configure Stack Options** page. Click through **Next.**

7. On the **Review** page, check the box in the **Capabilities** section to allow the creation of an IAM role. This selection gives the CloudFormation template permission to create IAM roles - in particular, the role used to allow the EC2 instance to interact with SSM and CloudWatch. Click **Create Stack**. You will be taken back to the CloudFormation console, where your stack will be launched.

![cfn-create-stack-3](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/cfn-create-stack-3.png)

8. Once the stack shows `CREATE COMPLETE`, click on the **Outputs** tab and click on the `WebsiteURL`, you will be brought to your sample web server.

**Recap:** In this portion of the lab, you deployed a CloudFormation stack to create the base resources needed for this lab.

{{< prev_next_button link_prev_url="../" link_next_url="../2_install_cw_agent/" />}}
