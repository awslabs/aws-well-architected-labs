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

7. Click the **Add approval level** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_add_approver.png)

8. In the **First-level approvals** section, click the **Add approver** dropdown box and select **Template specified approvers**.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_add_approver_button.png)

9. In the **Roles** tab of the pop-up window, search role name **SSMChangeTemplateApprovalRole**, then check the box left to the role, and click the **Add approvers** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_IAM_approval_role_add.png)

10. In the ****Amazon SNS topic for approval notifications**, keep the default option **Select an existing Amazon SNS topic**, and search the SNS Topic created by the CloudFormation with Topic name as **ssms-change-process-interruption-notification-sns-topic**, then click **Add notification** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_select_sns_topic_for_approval.png)

11. Leave the **Mornitoring** as default.

12. In the **Notifications**, select the **Select an existing Amazon SNS topic**, and search the SNS Topic created by the CloudFormation with Topic name as **ssms-change-process-interruption-notification-sns-topic**, then click **Add notification** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_notifications_sns_topic.png)

13. Leave the **Tags** as default, and click the **Save and preview** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_change_template_save_review.png)

14. In the **Template details** page, review all the settings, and then click the **Submit for review** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_change_template_submit_for_review.png)

15. After the Change Template has been submitted, please click [this link](https://us-east-1.console.aws.amazon.com/systems-manager/change-manager?region=us-east-1#/dashboard/settings) to go to Change Manager Settings, and click the **Edit** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_change_manager_settings_edit.png)

16. Scroll down to the **Template reviewers**, and click the **Add** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_template_reviewer_add.png)

17. In the pop-up window, search role name **SSMChangeTemplateApprovalRole**, then check the box left to the role, and click the **Add approvers** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_select_approver.png)

18. You will find the **SSMChangeTemplateApprovalRole** has been added as a Template reviewer as below. 
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_role_added_as_reviewer.png)

19. Scroll to the bottom of the Change Manager Settings page and click the **Save** button. Once you've seen the green banner with **Successfully updated service settings** message, you can proceed to the next step - Approve the Change Template.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_successfully_updated_service_settings.png)


### 2.2 Approve the Change Template

To approve the Change Template, you have to switch to the **SSMChangeTemplateApprovalRole** to complete it, because we need to use an IAM role or user different from the user who created the change template to approve it.


1. Click the user name dropdown box at the top right corner, copy your Account ID, and then click the **Switch role** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_click_switch_role_button.png)

2. In the Switch Role page, paste your **Account ID** into the **Account**, and type in **SSMChangeTemplateApprovalRole** in the **Role** and **Display Name** accordingly, then click **Switch Role** button.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_switch_role_page.png)

3. You will be redirected back to the AWS console page. Then you can see you have assumed the **SSMChangeTemplateApprovalRole**. You can skip the warning, as it won't impact the lab process.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_switched_role.png)

4. Click [this link](https://us-east-1.console.aws.amazon.com/systems-manager/change-manager?region=us-east-1#/dashboard/templates) to go to System Manager Change Manager **Templates** page, and then click the **wa-ssm-health-aware-lab-template** Change Template to view it.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_change_template_review_page1.png)

5. Click the **Approve** button in the Change Template detail page.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_approve_change_template.png)

6. Click the **Approve** button in the pop-up window.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_approve_change_template_role.png)

7. Type in a comment in the **Approve change template** pop-up window, then click the **Approve** button to complete the change template approval.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_type_approve_button.png)

8. Click the user name dropdown box at the top right corner, and click the **Switch back** button to switch back to your original role for the rest part of the lab.
![Section2 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section2_switch_back_role.png)

You have now completed the second section of the lab.

You have created the Change Template in the Change Manager, and have it approved with an IAM role **SSMChangeTemplateApprovalRole**. 

This concludes **Section 2** of this lab. Click 'Next step' to continue to the next section of the lab where we will create a [Change Request](https://docs.aws.amazon.com/systems-manager/latest/userguide/change-requests-create.html) to execute the AWS Health Aware change process.

{{< prev_next_button link_prev_url="../1_deploy_ssm_application_environment/" link_next_url="../3_test_change_process/" />}}

