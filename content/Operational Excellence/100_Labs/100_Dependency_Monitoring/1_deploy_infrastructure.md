---
title: "Deploy the Infrastructure"
menutitle: "Deploy Infrastructure"
date: 2020-09-15T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

Many workloads depend on external resources or services for data or additional capabilities such as 3rd party data providers or service providers, DNS providers, etc. Functionality or outcomes of the workload may be at risk when dependent resources or services become degraded or unreachable.

Monitoring these dependencies will enable quick action to ensure business continuity is not affected. Setting up alerting and notifications will ensure that appropriate team members are aware of issues and can take action to address the situation.

This lab provides examples of how to implement Well-Architected Operational Excellence best practices such as “Implement dependency telemetry”, “Alert when workload outcomes are at risk”, and “Enable push notifications”.

In this lab there is an external service (3rd party data provider) that provides data which will be consumed by the workload. This has been emulated in this lab by using an EC2 instance which acts as the 3rd party data provider, and it writes data to an S3 bucket at 50 second intervals. [Amazon S3 notification](https://docs.aws.amazon.com/AmazonS3/latest/dev/NotificationHowTo.html) feature enables you to receive notifications when certain events happen in your bucket.

For this use-case the notification has been configured on the S3 bucket to invoke a lambda function after every write to the bucket, using the S3 PutObject API. The objective of this lab is to create awareness when an external service is experiencing downtime or is otherwise impaired. For this example the assumption is that the 3rd party data provider is experiencing downtime when data is no longer being written to the S3 bucket.

![architecture](/Operations/100_Dependency_Monitoring/Images/ArchitectureFirst.png)

### 1.1 Log into the AWS console

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

{{%expand "Click here for instructions to access your assigned AWS account:" %}} {{% common/Workshop_AWS_Account %}} {{% /expand%}}

**If you are using your own AWS account**:
{{%expand "Click here for instructions to use your own AWS account:" %}}
* Sign in to the AWS Management Console as an IAM user who has PowerUserAccess or AdministratorAccess permissions, to ensure successful execution of this lab.
{{% /expand%}}

### 1.2 Deploy the infrastructure using AWS CloudFormation

You will use AWS CloudFormation to provision resources that will emulate the workload described in the use-case. AWS CloudFormation provides you a common language to model and provision AWS and third party application resources by applying Infrastructure as Code in your cloud environment.

1. Download the [dependency_monitoring.yaml](/Operations/100_Dependency_Monitoring/Code/dependency_monitoring.yaml) CloudFormation template (right-click on the link and select "Save Link As...")
1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation> and click **Create Stack** > **With new resources (standard)**

    ![CFNCreateStackButton](/Operations/100_Dependency_Monitoring/Images/CFNCreateStackButton.png)

1. Leave **Prepare template** setting as-is since you already have a template ready (dependency_monitoring.yaml)

    * For **Template source** select **Upload a template file**
    * Click **Choose file** and supply the CloudFormation template you downloaded: dependency_monitoring.yaml

    ![CFNUploadTemplateFile](/Operations/100_Dependency_Monitoring/Images/CFNUploadTemplateFile.png)

1. Click **Next**
1. For **Stack name** use `Dependency-Monitoring-Lab`
1. **Parameters**
    * **BucketName** - enter a name for the S3 bucket that will be created as part of the lab. Amazon S3 bucket names are globally unique, and the namespace is shared by all AWS accounts, so make sure you name the bucket as uniquely as possible. For example - `wa-lab-<your last name>-<date><time>`.
    * **LatestAmiId** - leave the default value here. This will ensure that CloudFormation will retrieve the latest Amazon Linux AMI for the region you are launching the stack in.
    * **NotificationEmail** - specify an email address that you have access to. This is the email address that notifications related to the dependent service will be sent to.
    * Click **Next**
1. For **Configure stack options** click **Next**
1. On the **Review** page:
    * Scroll to the end of the page and select **I acknowledge that AWS CloudFormation might create IAM resources with custom names.** This ensures CloudFormation has permission to create resources related to IAM. Additional information can be found [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html).

    **Note:** The template creates 2 roles for Lambda as well as a role and instance profile for an EC2 instance. They are the minimum permissions necessary to read and write from an S3 bucket created as part of this lab and create an OpsItem in OpsCenter. These permissions can be reviewed in the CloudFormation template under "Resources" section - *DataReadLambdaRole*, *OpsItemLambdaRole*, and *InstanceRole*.

    * Click **Create stack**

    ![CFNIamCapabilities](/Operations/100_Dependency_Monitoring/Images/CFNIamCapabilities.png)

1. This will take you to the CloudFormation stack status page, showing the stack creation in progress.
    * Click on the **Events** tab
    * Scroll through the listing. It shows (in reverse order) the activities performed by CloudFormation, such as starting to create a resource and then completing the resource creation.
    * Any errors encountered during the creation of the stack will be listed in this tab.
1. Once stack creation starts, monitor the email address you entered. You should receive an email from SNS with the subject **AWS Notification - Subscription Confirmation.** Click on the link **Confirm subscription** to confirm the subscription of your email to the SNS Topic. This will allow SNS to send email notifications to the email address specified.

The stack takes about 3 mins to create all the resources. Periodically refresh the page until you see that the **Stack Status** is in **CREATE_COMPLETE**. The stack creates the following resources:

* A new VPC, subnets, Internet Gateway, Route tables to host the workload in
* An EC2 instance that acts as the 3rd party data provider
* An S3 bucket and Lambda function that act as the workload
* IAM resources (roles, policies) that allow different services to access each other
* An SNS Topic for notifications

Once the stack is in **CREATE_COMPLETE**, visit the **Outputs** section for the stack and note down the **Key** and **Value** for each of the outputs. This information will be used later in the lab.

{{< prev_next_button link_prev_url="../" link_next_url="../2_understand_metrics/" />}}
