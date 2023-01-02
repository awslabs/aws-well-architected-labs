---
title: "Create Systems Manager Change Template"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

The [Change Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/change-manager.html) is a capability of AWS Systems Manager. It is an enterprise change management framework for requesting, approving, implementing, and reporting on operational changes to your application configuration and infrastructure. 

In this section of the lab, you will use the Change Manager to define the change process with the AWS Health Awareness. More specifically, In the Change Manager you will create a change template, upon which you can raise the change request to execute the [Automation runbook](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-documents.html) that's been created by the CloudFormation stack.

The following diagram shows the workflow defined by the Change Template.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_workflow_diagram.png)

#### Workflow Walkthrough

* *1 - The first step is to kickoff the change opeartion pipeline.* 
* *2 - The change request got approved, as we've configured the auto  approve in the Automation runbook created by the CloudFormation template.*
* *3 - Systems Manager runbook starts the execution.*
* *4 - Automation runbook calls AWS Health API to retrieve service health status.*
* *5a - If there's no active AWS service events, the Automation runbook will execute the planned action (In this lab it'll stop the EC2 instance created by the CloudFormation stack, which with the **SSMFleetEnv** tag value to be **test**).*
* *5b - If there's active AWS service events, the Automation runbook will send email notification with a list of services that're impacted.*  

### 2.1 Configure the Change Template

Click [this link](https://us-east-1.console.aws.amazon.com/systems-manager/change-manager?region=us-east-1#/) to go to Systems Manager Change Manager. If the right hand side of the page shows **Get started with Change Manager**, then follow the instructions in **2.1.1 Set up Change Manager**. Otherwise, you may skip **2.1.1**, and jump straight to **2.1.2** to Create the **Change Template**.

(Follow instructions in **2.1.1** to set up Change Manager if you haven't done so as shown below):
![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_setup_change_manager.png)

#### 2.1.1 Set up Change Manager (Optional - Depending on whether you've already set up Change Manager)

1. Click [this link](https://us-east-1.console.aws.amazon.com/systems-manager/change-manager?region=us-east-1#/) to go to Systems Manager Change Manager. Then click the **Set up Change Manager** button.
![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_setup_change_manager_step1.png)




#### 2.1.2 Configure the Change Template

1. Sign in to the AWS **Systems Manager Change Manager** console via [this link](https://us-east-1.console.aws.amazon.com/systems-manager/change-manager?region=us-east-1#)

2. Choose the **Template** tab, and click the **Create template** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_create_change_template.png)

3. In the "Create change template" page - Give it a name to the change template, e.g. **wa-ssm-health-aware-lab-template**, alongside the Description, e.g. **Test SSM change template for AWS health aware operation process**. 
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_change_template_name_description.png)

4. Scroll down in the "Create change template" page, keep the "Change template type" as default, and select **Define a set of runbooks that can be used** in the **Runbook options**.

* Then under the Runbook dropdown box, input **AWS_health_aware_normal_operation_runbook** and click the pop-up runbook with this name, and click **Add** button.

* Likewise, input **AWS_health_aware_event_simulated_runbook** in the Runbook dropdown box and click the pop-up runbook with this name, then click **Add** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_configure_runbook_templates.png)

5. Leave the **Timeout** and **Template information** as default.

6. Click the **Enable auto-approval** check box under the **Approval workflow options**. This will allow the Change Request be automatically approved, while the Change Template will still need approval.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_enable_auto_approval.png)

7. In the **First-level approvals**, click the **Add approver** dropdown box and select **Template specified approvers**.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_template_specified_approvers.png)

8. In the **Users** tab of the pop-up window, check the box left to **walab-approval-user**, and click the **Add approvers** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_select_iam_approver.png)

9. In the ****Amazon SNS topic for approval notifications**, keep the default option **Select an existing Amazon SNS topic**, and search the SNS Topic created by the CloudFormation with Topic name as **ssms-change-process-interruption-notification-sns-topic**, then click **Add notification** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_select_sns_topic_for_approval.png)

10. Leave the **Mornitoring** as default.

11. In the **Notifications**, select the **Select an existing Amazon SNS topic**, and search the SNS Topic created by the CloudFormation with Topic name as **ssms-change-process-interruption-notification-sns-topic**, then click **Add notification** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_notifications_sns_topic.png)

12. Leave the **Tags** as default, and click the **Save and preview** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_change_template_save_review.png)

13. In the **Template details** page, review all the settings, and then click the **Submit for review** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_change_template_submit_for_review.png)

14. After the Change Template has been submitted, please click [this link](https://us-east-1.console.aws.amazon.com/systems-manager/change-manager?region=us-east-1#/dashboard/settings) to go to Change Manager Settings, and click the **Edit** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_change_manager_settings_edit.png)

15. Scroll down to the **Template reviewers**, and click the **Add** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_template_reviewer_add.png)

16. In the pop-up window, check the box left to the IAM user **walab-approval-user**, then click the **Add approvers** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_template_approver_select_iam_user.png)

17. You will find the **walab-approval-user** has been added as a Template reviewer as below. 
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_verify_template_reviewer_iam_user.png)

18. Scroll to the bottom of the Change Manager Settings page and click the **Save** button. Once you've seen the green banner with **Successfully updated service settings** message, you can proceed to the next step - Approve the Change Template.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_successfully_updated_service_settings.png)


### 2.2 Approve the Change Template

To approve the Change Template, you have to use another user with the SSM Full Access permissions to complete it. This step will use the IAM user **walab-approval-user** created by the CloudFormation to accomplish the approval process.

1. Log out in the AWS Console - click your username in top right corner, and click the **Sign out** button to sign out from your console.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_signout_account.png)

2. Click the **Sign In to the Console** button in the top right corner.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_sign_in_the_console.png)

3. Input your **Account ID**, and use **walab-approval-user** as IAM user name, with initial password **walab123@**, then click the **Sign in** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_sign_in_page.png)

4. The console will ask you to change your password. Please input **walab123@** as Old password, and choose a new password that you prefer, then click **Confirm password change** button to enter the AWS console. 

5. Click [this link](https://us-east-1.console.aws.amazon.com/systems-manager/change-manager?region=us-east-1#) to go to System Manager Change Manager page. Click the **Templates** tab, and then click the **wa-ssm-health-aware-lab-template** Change Template to view it.

![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_change_manager_template_overview_page.png)

{{% notice note %}}
NOTE: You can ignore the "Failed to load IAM users" related red banner in the page if you see it, as it's caused by the fact that **walab-approval-user** doesn't have all the required permissions to view Systems Managers options. But you still can use this user to approve the Change Template.
{{% /notice %}}

6. Click the **Approve** button in the Change Template detail page.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_approve_change_template.png)

7. Click the **Approve** button in the pop-up window.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_pop_up_approve_change_template.png)

You have now completed the second section of the lab.

You have created the Change Template in the Change Manager, and have it approved through IAM user **walab-approval-user**. 

This concludes **Section 2** of this lab. Click 'Next step' to continue to the next section of the lab where we will create a [Change Request](https://docs.aws.amazon.com/systems-manager/latest/userguide/change-requests-create.html) to execute the AWS Health Aware change process.

{{< prev_next_button link_prev_url="../1_deploy_ssm_application_environment/" link_next_url="../3_test_change_process/" />}}

