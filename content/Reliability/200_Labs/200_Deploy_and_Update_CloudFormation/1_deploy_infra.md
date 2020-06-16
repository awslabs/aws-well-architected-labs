---
title: "Deploy Infrastructure using a CloudFormation Stack"
menutitle: "Deploy Infrastructure"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

This lab illustrates best practices for reliability as described in the [AWS Well-Architected](https://aws.amazon.com/architecture/well-architected/) Reliability pillar.

How do you implement change?

* Best practice: **Deploy changes with automation**: Deployments and patching are automated to eliminate negative impact.
* Design principle: **Manage change in automation**: Changes to your infrastructure should be made using automation. The changes that need to be managed include changes to the automation, which then can be tracked and reviewed.

When this lab is completed, you will have deployed and edited a CloudFormation template. Using this template you will deploy a VPC, an S3 bucket and an EC2 instance running a simple web server.

### 1.1 Log into the AWS console {#awslogin}

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

{{%expand "Click here for instructions to access your assigned AWS account:" %}} {{% common/Workshop_AWS_Account %}} {{% /expand%}}

**If you are using your own AWS account**:
{{%expand "Click here for instructions to use your own AWS account:" %}}
* Sign in to the AWS Management Console as an IAM user who has PowerUserAccess or AdministratorAccess permissions, to ensure successful execution of this lab.
{{% /expand%}}

### 1.2 The CloudFormation template

You will begin by deploying a CloudFormation stack that creates a simple VPC as shown in this diagram:

![SimpleVpcOnly](/Reliability/200_Deploy_and_Update_CloudFormation/Images/SimpleVpcOnly.png)

1. Download the [simple_stack.yaml](/Reliability/200_Deploy_and_Update_CloudFormation/Code/CloudFormation/simple_stack.yaml) CloudFormation template
1. Open this file in a Text Editor
      * Preferably use an editor that is [YAML](https://yaml.org/) aware like vi/vim, VS Code, or Notepad++
      * Do NOT use a Word Processor

The template is written in a format called [YAML](https://yaml.org/), which is commonly used for configuration files. The format of the file is important, especially indents and hyphens. CloudFormation templates can also be written in JSON.

Look through the file. You will notice several sections:

* The [Parameters section](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html) is used to prompt for inputs that can be used elsewhere in the template. The template is asking for several inputs, but also provides default values for each one. Look through these and start to reason about what each one is.

* The [Conditions section](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/conditions-section-structure.html) is where you can setup _if/then_-like control of what happens during template deployment. It defines the circumstances under which entities are created or configured.

* The [Resources section](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/resources-section-structure.html) is the "heart" of the template. It is where you define the infrastructure to be deployed. Look at the _first_ resource defined.
    * It is the VPC (Amazon Virtual Private Cloud)
    * It has a _logical ID_ which in this case is `SimpleVPC`. This logical ID is how we refer to the VPC resource within the CloudFormation template.
    * It has a `Type` which tells CloudFormation which type of resource to create
    * And it has `Properties` that define the values used to create the VPC

* The [Outputs section](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html) is used to display selective information about resources in the stack.

* The [Metadata section](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/metadata-section-structure.html) here is used to group and order how the CloudFormation parameters are displayed when you deploy the template using the AWS Console

|CloudFormation tip|
|:---:|
|When editing CloudFormation templates written in YAML, be extra cautious that you maintain the correct number of spaces for each indentation|
|Indents are always in increments of two spaces|

You will now use this **template** to launch a **CloudFormation stack** that will deploy AWS resources in your AWS account.

### 1.3 Deploying an AWS CloudFormation stack to create a simple VPC

{{% common/CreateNewCloudFormationStack stackname="CloudFormationLab" templatename="simple_stack.yaml" /%}}

1. Deployment will take approximately 30 seconds to deploy.
