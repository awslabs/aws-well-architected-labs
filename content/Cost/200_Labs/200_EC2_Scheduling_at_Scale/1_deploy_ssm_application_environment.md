---
title: "Deploy the lab environment"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

In this section, you will deploy the lab environment. Once the solution has been implemented, you will be able to embed AWS Health API insights into the test operational change process to automatically suspend operational changes whenever an AWS Health event is reported in a Region that you’re operating in.

### Architecture Overview

The solution leverages the following AWS Services and features in your AWS Account:

* [AWS Systems Manager Change Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/change-manager.html) which is an enterprise change management framework for requesting, approving, implementing, and reporting on operational changes to your application configuration and infrastructure. 
* AWS Systems Manager [automation runbook](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-documents.html) helps you to build automated solutions to deploy, configure, and manage AWS resources at scale.
* AWS Health provides ongoing visibility into the availability of your AWS services, where you can programmatically retrieve those availability data via [AWS Health API](https://docs.aws.amazon.com/health/latest/ug/health-api.html).

![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_solution_architect.png)

You will use AWS CloudFormation to provision some resources needed for this lab. As part of this lab, the CloudFormation stack that you provision will create a Systems Manager automation runbook, a SNS notification topic, a test EC2 instance, an IAM user to approve the SSM Change Template, and other relevant IAM roles and permissions. You can view the CloudFormation template [here](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Code/cfn_health_aware_ssm_stack.yaml) for a complete list of all resources that are provisioned. This lab will only work in us-east-1.

### 1.1 Log into the AWS console

{{% notice note %}}
This Lab only works in AWS **N.Virginia region (us-east-1)**, while the following instructions assume that you are using **your own AWS account**. If you are attending an in-person workshop and were provided with an AWS account, please follow the instructions from the lab coordinator.
{{% /notice %}}



**Sign in to the [AWS Management Console](https://us-east-1.console.aws.amazon.com/console) as an IAM user who has either AdministratorAccess or PowerUserAccess (with full IAM access) permissions to ensure successful execution of this lab.**

### 1.2 Deploy the infrastructure using AWS CloudFormation

1. Click the following button to deploy the stack. (Use [this link](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/quickcreate?stackName=well-architected-lab-health-aware-operation-change&templateURL=https://aws-walab-build-health-aware-operation-change-process.s3.amazonaws.com/cfn_health_aware_ssm_stack.yaml) if the following button doesn't work. )

[\
![](https://d2908q01vomqb2.cloudfront.net/f1f836cb4ea6efb2a0b1b99f41ad8b103eff4b59/2019/10/30/LaunchCFN.png)](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/quickcreate?stackName=well-architected-lab-health-aware-operation-change&templateURL=https://aws-walab-build-health-aware-operation-change-process.s3.amazonaws.com/cfn_health_aware_ssm_stack.yaml)

You need to provide a stack name (e.g. **well-architected-lab-health-aware-operation-change** that's been prepopulated), and also provide a valid email address to receive the Amazon SNS notification emails.

![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_cfn_implementation.png)

2. Scroll down to click the **checkbox** to acknowledge that the CloudFormation template might create IAM resources with custom names, and then click the **Create stack** button to proceed the stack creation.
![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_cfn_acknowledgement_create_stack.png)

The stack takes about 2 minutes to create all the resources. Periodically refresh the page until you see that the **STACK STATUS** is in **CREATE_COMPLETE**. Once the stack is in **CREATE_COMPLETE**, you may proceed to the next step to create the **Change Template** in the Systems Manager Change Manager, alongside the **Inventory**.


### 1.3 Set up a Systems Manager Inventory

This step is mainly used to create the [Systems Manager service-linked role](https://docs.aws.amazon.com/systems-manager/latest/userguide/using-service-linked-roles.html) (**"AWSServiceRoleforAmazonSSM"**). This service linked role is a unique type of IAM role that is linked directly to Systems Manager. Service-linked roles are predefined by Systems Manager and include all the permissions that the service requires to call other AWS services on your behalf. 

<br />

#### 1.3.1 Go to Systems Manager Inventory

Click [this link](https://us-east-1.console.aws.amazon.com/systems-manager/inventory?region=us-east-1) to go to Systems Manager Inventory in the console service. Or you may click the **Inventory** in the left navigation pane of the Systems Manager service page. 

#### 1.3.2 Create a new Inventory

This will allow Systems Manager service-linked role to be created, which is needed for the rest of this lab.

**Step 1:** Click the **Setup Inventory** button to create the Inventory.

![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_click_create_inventory.png)

**Step 2:** In the "Setup Inventory" page, give it a name (e.g. **WA-LAB-Inventory**), leave other options as default, then scroll down to the bottom of the page and click **Setup Inventory** button.
![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_inventory_name.png)
![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_setup_inventory_confirm.png)

Once you've been redirected to a page shows "**Setup inventory request succeeded**", that means the Inventory has been created successfully.
![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_inventory_created.png)

**Step 3:** Click [this link](https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/roles) to go to IAM/Roles page, and input **AWSServiceRoleForAmazonSSM** in the search bar. If you can see it pop up in the search result, that means the service-linked role has been created properly.
![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_service_linked_role_validation.png)

#### 1.3.3 Subscribe to the SNS Topic

When you created the CloudFormation stack in the previous step, it's provisioned a SNS Topic **ssms-change-process-interruption-notification-sns-topic** to be used in this lab. To be able to receive notifications properly, you need to subscribe to the SNS Topic.

To complete the email subscription to the SNS Topic, you can take either one of the following approaches:

**Option 1**

You should have received an email sent from **no-reply@sns.amazonaws.com**. Click the **Confirm subscription** link, then you've completed the subscription when seeing the **Subscription confirmed!** page.
![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_email_confirm_subscription.png)
![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_sns_subscription_confirmed_page.png)

**Option 2**

If you haven't received the email sent from **no-reply@sns.amazonaws.com**, you can follow these steps to complete the subscription:

**Step 1:** Go to [SNS Topic page](https://us-east-1.console.aws.amazon.com/sns/v3/home?region=us-east-1#/topics), where there's a SNS Topic named **ssms-change-process-interruption-notification-sns-topic** that's been created. Click on that topic link to see the details.
![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_sns_topic_page.png)

**Step 2:** In the SNS Topic detail page, click the **Create subscription** button.
![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_sns_topic_detail_page.png)

**Step 3:** In the Create subscription page, select **Email** as the Protocol, and input **your email address** under the Endpoint blank, then click **Create subscription** button to create the subscription.
![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_sns_topic_page_create_subscription.png)

**Step 4:** Repeat the **Option 1** step to check your email, and click on the **Confirm subscription** link in that email, so to complete the email subscription process.

### Congratulations! 

You have now completed the first section of the Lab.

You should have a working lab environment which we will use for the remainder of the lab.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="..//" link_next_url="../2_ec2_scheduling_at_scale/" />}}


