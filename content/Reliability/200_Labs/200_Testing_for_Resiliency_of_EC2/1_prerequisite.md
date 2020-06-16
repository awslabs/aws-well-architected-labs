---
title: "Deploy the Infrastructure and Application"
menutitle: "Deploy Application"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

The first step of this lab is to deploy the static web application stack. If you have _already_ run the following two labs (and have not torn down the resources) then you have already deployed the necessary infrastructure. Proceed to next step **Configure Execution Environment**

* [Security: Level 200: Automated Deployment of VPC]({{< ref "/Security/200_Labs/200_Automated_Deployment_of_VPC" >}})
* [Security: Level 200: Automated Deployment of EC2 Web Application]({{< ref "/Security/200_Labs/200_Automated_Deployment_of_EC2_Web_Application" >}})

If you _have not_ already deployed the necessary infrastructure, then follow these steps:

* You will first deploy an Amazon Virtual Private Cloud (VPC)
* You will then deploy a Static WebApp hosted on Amazon EC2 instances
* For each of these deployments:
  * If you are comfortable deploying a CloudFormation stack, then use the **Express Steps**
  * If you require detailed guidance in how to deploy a CloudFormation stack, then use the **Guided Steps**

### 1.1 Log into the AWS console {#awslogin}

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

{{%expand "Click here for instructions to access your assigned AWS account:" %}} {{% common/Workshop_AWS_Account %}} {{% /expand %}}

**If you are using your own AWS account**:
{{%expand "Click here for instructions to use your own AWS account:" %}}
* Sign in to the AWS Management Console as an IAM user who has PowerUserAccess or AdministratorAccess permissions, to ensure successful execution of this lab.
{{% /expand%}}

### 1.2 Deploy the VPC infrastructure

{{% notice note %}}
Choose either the Express Steps _or_ Guided Steps
{{% /notice %}}

* In the AWS Console, choose the AWS region you wish to use - if possible we recommend using **us-east-2 (Ohio)**

#### Express Steps (Deploy the VPC infrastructure)

1. Download the [vpc-alb-app-db.yaml](/Security/200_Automated_Deployment_of_VPC/Code/vpc-alb-app-db.yaml) CloudFormation template
1. Deploy the CloudFormation template
    * Name the stack **`WebApp1-VPC`** (case sensitive)
    * Leave all CloudFormation Parameters at their default values
1. When the stack status is _CREATE_COMPLETE_, you can continue to the next step

#### Guided Steps (Deploy the VPC infrastructure)
{{%expand "Click here for detailed instructions to deploy the VPC:" %}}
{{% common/Create_VPC_Stack  stackname="WebApp1-VPC"%}}
1. When the stack status is _CREATE_COMPLETE_, you can continue to the next step
{{% /expand%}}

### 1.3 Deploy the EC2s and Static WebApp infrastructure

{{% notice note %}}
Choose either the Express Steps _or_ Guided Steps
{{% /notice %}}

#### Express Steps (Deploy the EC2s and Static WebApp infrastructure)

1. Download the [staticwebapp.yaml](/Security/200_Automated_Deployment_of_EC2_Web_Application/Code/staticwebapp.yaml) CloudFormation template
1. Choose the same AWS region as you did for the VPC (if you used our recommendation, this is **us-east-2 (Ohio)**)
1. Deploy the CloudFormation template
    * Name the stack **`WebApp1-Static`** (case sensitive)
    * Leave all CloudFormation Parameters at their default values
1. When the stack status is _CREATE_COMPLETE_, you can continue to the next step

#### Guided Steps (Deploy the EC2s and Static WebApp infrastructure)
{{%expand "Click here for detailed instructions to deploy the WebApp:" %}}
1. Download the latest version of the CloudFormation template here: [staticwebapp.yaml](/Security/200_Automated_Deployment_of_EC2_Web_Application/Code/staticwebapp.yaml)
1. Choose the same AWS region as you did for the VPC (if you used our recommendation, this is **us-east-2 (Ohio)**)
{{% common/CreateNewCloudFormationStack templatename="staticwebapp.yaml" stackname="WebApp1-Static"/%}}
{{% /expand%}}

#### Website URL

1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation>.
      * Wait until **WebApp1-Static** stack **status** is _CREATE_COMPLETE_ before proceeding. This should take about four minutes
      * Click on the **WebApp1-Static** stack
      * Click on the **Outputs** tab
      * For the Key **WebsiteURL** copy the value.  This is the URL of your test web service
      * Save this URL - you will need it later
