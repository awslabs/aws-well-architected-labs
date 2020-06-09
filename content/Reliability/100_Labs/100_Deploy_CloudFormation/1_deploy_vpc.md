---
title: "Deploy VPC using CloudFormation"
menutitle: "Deploy Infrastructure"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### 1.1 Log into the AWS console {#awslogin}

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

{{%expand "Click here for instructions to access your assigned AWS account:" %}} {{% common/Workshop_AWS_Account %}} {{% /expand%}}

**If you are using your own AWS account**:
{{%expand "Click here for instructions to use your own AWS account:" %}}
* Sign in to the AWS Management Console as an IAM user who has PowerUserAccess or AdministratorAccess permissions, to ensure successful execution of this lab.
{{% /expand%}}

### 1.2 Configure your AWS Region

1. Select the **Ohio** region.  This region is also known as **us-east-2**, which you will see referenced throughout this lab.
![SelectOhio](/Reliability/100_Deploy_CloudFormation/Images/SelectOhio.png)
      * AWS offers you the ability to deploy to over 20 regions located across the globe
      * Each region is fully isolated from the others to isolate any issues and achieve high availability,
      * Each region is comprised of multiple Availability Zones, which are fully isolated partitions of our infrastructure (more on this later)

#### 1.3 Deploy the VPC infrastructure

{{% common/Create_VPC_Stack stackname="WebApp1-VPC" %}}

1. When the stack status is _CREATE_COMPLETE_, you can continue to the next step.
