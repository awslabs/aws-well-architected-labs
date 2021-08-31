---
title: "Deploy infrastructure"
menutitle: "Deploy infrastructure"
date: 2021-08-31T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

The AWS WA Tool API provides programmatic access to the AWS WA Tool and can be used to manage workloads, retrieve risk information and improvement plans. AWS WA Tool API calls are made from a Lambda function that is invoked periodically using [Amazon EventBridge](https://aws.amazon.com/eventbridge/). The API calls retrieve workload details such as number of [High Risk Issues (HRIs) and Medium Risk Issues (MRIs)](https://docs.aws.amazon.com/wellarchitected/latest/userguide/workloads.html#wat-hri-mri), best practices missing, and improvement plans. Using this information, the Lambda function creates OpsItems within OpsCenter for best practices missing from all workloads in the AWS Region the solution is deployed in. An Amazon DynamoDB table is used to maintain state and ensure duplicate OpsItems are not being created for the same missing best practice within a workload. Setting the status of an OpsItem to **Resolved** will trigger a notification to an [Amazon Simple Notification Service (SNS)](https://aws.amazon.com/sns/) topic. SNS invokes a second Lambda function which updates the workload on the AWS WA Tool with the best practice specified in the OpsItem that was resolved. This second function then updates the workload state in DynamoDB.

![Architecture](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/Architecture.png?classes=lab_picture_auto)

You will use AWS CloudFormation to deploy some of the infrastructure for this lab. The CloudFormation stack that you provision will create the following resources:

* An AWS Identity and Access Management (IAM) role
* An SNS Topic
* An SNS Topic policy
* A DynamoDB table

### 1.1 Log into the AWS console {#awslogin}

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

{{%expand "Click here for instructions to access your assigned AWS account:" %}} {{% common/Workshop_AWS_Account %}} {{% /expand%}}

**If you are using your own AWS account**:
{{%expand "Click here for instructions to use your own AWS account:" %}}
* Sign in to the AWS Management Console as an IAM user who has PowerUserAccess or AdministratorAccess permissions, to ensure successful execution of this lab.
{{% /expand%}}

### 1.2 Deploy the workload using AWS CloudFormation

1. Download the [risk_management.yaml](/watool/200_Manage_Workload_Risks_with_OpsCenter/Code/risk_management.yaml) CloudFormation template
1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation> and click **Create Stack** > **With new resources (standard)**

    ![CFNCreateStackButton](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/CFNCreateStackButton.png)

1. For **Prepare template** select **Template is ready**

    * For **Template source** select **Upload a template file**
    * Click **Choose file** and select the CloudFormation template you downloaded in the previous step: *risk_management.yaml*

    ![CFNSpecifyTemplate](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/CFNUploadTemplateFile.png)

1. Click **Next**
1. For **Stack name** use `WA-risk-management` and click **Next**
1. For **Configure stack options** click **Next**
1. On the **Review** page:
    * Scroll to the end of the page and select **I acknowledge that AWS CloudFormation might create IAM resources with custom names.** This ensures CloudFormation has permission to create resources related to IAM. Additional information can be found [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html).

    **Note:** The template creates an IAM role for the Lambda function. These are the minimum permissions necessary for the function to make API calls to AWS services such as DynamoDB, Systems Manager, and the Well-Architected Tool. These permissions can be reviewed in the CloudFormation template under the "Resources" section - **LambdaRole**.

    * Click **Create stack**

    ![CFNIamCapabilities](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/CFNIamCapabilities.png)

This will take you to the CloudFormation stack status page, showing the stack creation in progress.

  * Click on the **Events** tab
  * Scroll through the listing. It shows (in reverse order) the activities performed by CloudFormation, such as starting to create a resource and then completing the resource creation.
  * Any errors encountered during the creation of the stack will be listed in this tab.

The stack takes about 2 mins to create all the resources. Periodically refresh the page until you see that the **Stack Status** is in **CREATE_COMPLETE**.

Once the stack is in **CREATE_COMPLETE**, visit the **Outputs** section for the stack and note down the **Key** and **Value** for each of the outputs. This information will be used in the lab.

### 1.3 Define and document workload state

To observe the behavior of this solution, you need one or more workloads defined and documented in the AWS Well-Architected Tool. Refer to the [Walkthrough of the Well-Architected Tool](https://wellarchitectedlabs.com/well-architectedtool/100_labs/100_walkthrough_of_the_well-architected_tool/) to learn how to do this.

**NOTE:** Workloads must be defined and documented in the same AWS Region where you are running this lab.

{{< prev_next_button link_prev_url="../" link_next_url="../2_risk_tracking/" />}}
