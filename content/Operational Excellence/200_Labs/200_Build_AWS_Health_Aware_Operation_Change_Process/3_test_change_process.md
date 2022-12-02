---
title: "Test the Change Process"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---


As we mentioned, checking the AWS service health status before triggering the Systems Manager production change process will allow you to avoid your operational change pipeline being held up by active service events, so to proactively remediate the operational risks. With this AWS Health Aware capability, you can use [Systems Manager](https://aws.amazon.com/systems-manager/) to integrate this feature into your existing [Automation Runbooks](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-documents.html) to enhance the resiliency of your operation change process. 

In this lab you will take the following actions on the [Change Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/change-manager.html):
* Create a first change request through Change Manager (in the current section) to test the AWS Health Aware capability of your Change Process. In most cases there's no active AWS service events when you run the change request, hence the planned opeartion activity will be proceed (In this case is to install windows updates against the lab EC2 instance).
* Create a second change request through Change Manager (in the next section) to simulate when there're active AWS service events, the change process will be suspended, where a notification email will be sent with the impacted service information, so you'd be able to make informed decision to that situation, e.g. execute the change process when the service events have been recovered.

**The solution works as follows:**

1. Operation Administrators will create a change request in the AWS Systems Manager Change Manager. Actions are defined in an AWS Systems Manager [runbook](https://docs.aws.amazon.com/systems-manager/latest/userguide/runbook-scripts.html).
2. In AWS Systems Manager runbook with dynamic automation using **aws:branch** action to evaluate different choices in a single step and then jump to a different step in the runbook based on the AWS Health Status. The logic has several steps as follows: 

* Step 1. Poll [AWS Health API](https://docs.aws.amazon.com/health/latest/ug/health-api.html) - The script in this step will call AWS Health [DescribeEvents API](https://docs.aws.amazon.com/health/latest/APIReference/API_DescribeEvents.html) to retrieve the list of active health incidents. Then, the function will complete the event analysis and decide whether or not it may impact the running deployment. 
* Step 2. If there's active AWS Service events, then suspend the workflow, and send SNS notification to admins.
* Step 3. If there's no active service events, proceed the operation as planned, e.g. Windows EC2 upgrades.

#### Create the Change Request

1. **Sign in to the [AWS Management Console](https://us-east-1.console.aws.amazon.com/console) with the previous IAM user who has the following permissions to ensure successful execution of this lab:**
* Full access to [CloudFormation](https://aws.amazon.com/cloudformation/)
* Full access to [Amazon EC2](https://aws.amazon.com/ec2/) 
* Full access to [Amazon Systems Manager](https://aws.amazon.com/systems-manager/) 
* Full access to [Amazon Simple Notification Service(SNS)](https://aws.amazon.com/sns/) 
* Full access to [AWS Identity and Access Management (IAM)](https://aws.amazon.com/iam/) 
* Full access to [Amazon S3](https://aws.amazon.com/s3/)

2. Click [this link](https://us-east-1.console.aws.amazon.com/systems-manager/change-manager?region=us-east-1#/dashboard/templates) to go to Templates tab in the Change Manager.

3. Select the Change Template **wa-ssm-health-aware-lab-template**.
![Section3 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section3_click_change_template.png)

4. Click the **Create request** button.
![Section3 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section3_click_change_request_button.png)

5. In the **Basic change request details**, type in a name for this request, e.g. **wa-lab-change-request-normal**. Then select the **AWS_health_aware_normal_operation_runbook (Default)** in the dropdown box under the Runbook.
![Section3 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section3_basic_change_request_details_normal.png)

6. Keep the other configurations as default, then scroll down to the bottom of the page and click the **Next** button.
![Section4 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section4_change_request_details_next_page.png)

7. Leave all parameter in the **Specify parameters** page as default, and click the **Next** button.
![Section4 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section4_specify_parameters_next_button.png)

8. Review the configuration information in the **Review and submit** page, scroll down to the bottom of the page and click the **Submit for approval** button. Then the request has been successfully submitted when you see there's a green banner shows up at the top of the page. 
![Section3 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section3_submit_for_approval_button_normal.png)

You will also receive an SNS email notification regarding the successful submission of the change request.
![Section3 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section3_email_sns_change_request_submitted_succesfully.png)

9. Click [this link](https://us-east-1.console.aws.amazon.com/systems-manager/change-manager?region=us-east-1#/dashboard/requests) to go to the Requests tab in the Change Manager. You will find the Status of the change request will change from **Scheduled**, to **Run in progress**, and finally to **Success**.
![Section3 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section3_change_request_executed_successfully.png)

10. Click on the Change Request **wa-lab-change-request-normal**.
![Section3 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section3_click_on_change_request_link.png)

11. Click on the **Timeline** tab in the Change Request detail page, where you can see the planned operation defined in the runbook **AWS_health_aware_normal_operation_runbook** has been executed, as there's no active service events.
![Section3 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section3_operation_runbook_executed_normally.png)

{{% notice note %}}
In case there's active AWS service event(s) when you executed the Change Request, then you will find the operation change will be suspended, which is as expected for this AWS Health Aware operation change process. You can also visit the [AWS Health Dashboard](https://health.aws.amazon.com/health/home) in your AWS Console to verify if there's any active service event in that case.
{{% /notice %}}

12. **(Optional)** Click [this link](https://us-east-1.console.aws.amazon.com/systems-manager/documents?region=us-east-1) to go to **Documents** in Systems Manager, click the **Owned by me** tab, and click the **AWS_health_aware_normal_operation_runbook** Automation runbook.
![Section3 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section3_document_normal_operation_runbook_clickin.png)

13. **(Optional)** Click the **Content** tab and review the automation runbook content. Please note that the current runbook is to monitor those AWS health events which status are **"open"**.
![Section3 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section3_automation_runbook_open_health_events.png)

Now you have successfully created the change request, and completed the runbook executions.

This concludes **Section 3** of this lab, click on the link below to move on to the next section to simulate the occurence of AWS service events.

{{< prev_next_button link_prev_url="../2_create_ssm_change_template/" link_next_url="../4_test_change_process_with_simulated_service_event/" />}}
