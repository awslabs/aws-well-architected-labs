---
title: "Test the Change Process with Simulated Service Event"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

In most of cases there's no active AWS service events when you executed the Change Request. In this section, we will simulate AWS service events by retrieving the **closed service events** through calling the [AWS Health API](https://docs.aws.amazon.com/health/latest/ug/health-api.html). This action has been defined in the Automation runbook **AWS_health_aware_event_simulated_runbook**. 

With this simulation, you can observe the Change Request process will automatically check the AWS service health status, and suspend the operation change process when there's active service event. You can also find an email will be sent out with the impacted service information.

#### Create the Change Request that Simulates AWS Service Events

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

5. In the **Basic change request details**, type in a name for this request, e.g. **wa-lab-change-request-simulated-events**. Then select the **AWS_health_aware_event_simulated_runbook (Default)** in the dropdown box under the Runbook.
![Section4 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section4_change_request_name_runbook.png)

6. Keep the other configurations as default, then scroll down to the bottom of the page and click the **Next** button.
![Section4 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section4_change_request_details_next_page.png)

7. Leave all parameter in the **Specify parameters** page as default, and click the **Next** button.
![Section4 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section4_specify_parameters_next_button.png)

8. Review the configuration information in the **Review and submit** page, scroll down to the bottom of the page and click the **Submit for approval** button. Then the request has been successfully submitted when you see there's a green banner shows up at the top of the page. 
![Section3 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section3_submit_for_approval_button_normal.png)

9. Click [this link](https://us-east-1.console.aws.amazon.com/systems-manager/change-manager?region=us-east-1#/dashboard/requests) to go to the Requests tab in the Change Manager. You will find the Status of the change request will change from **Scheduled**, to **Run in progress**, and finally to **Success**.
![Section4 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section4_change_request_executed_successfully.png)

10. Click on the Change Request **wa-lab-change-request-simulated-events**.
![Section4 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section4_click_on_change_request_link.png)

11. Click on the **Timeline** tab in the Change Request detail page, where you can see the **option1_suspend_the_change_workflow** defined in the runbook **AWS_health_aware_event_simulated_runbook** has been executed, as we've simulated active service events.
![Section4 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section4_operation_runbook_executed_normally.png)

12. You will also receive email notification with the impacted service information. 
![Section4 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section4_service_impacted_email.png)

13. Click [this link](https://health.aws.amazon.com/health/home#/account/event-log) to view the **AWS Health Event log**. Please note that we simulated the AWS service events using the historical event data in this case.You can also correlate that the impacted events are aligned with the impacted service in the above email notification, e.g. QUICKSIGHT, EC2, etc.
![Section4 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section4_health_event_log.png)

14. **(Optional)** Click [this link](https://us-east-1.console.aws.amazon.com/systems-manager/documents?region=us-east-1) to go to **Documents** in Systems Manager, click the **Owned by me** tab, and click the **AWS_health_aware_event_simulated_runbook** Automation runbook.
![Section3 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section4_document_normal_operation_runbook_clickin.png)

15. **(Optional)** Click the **Content** tab and review the automation runbook content. Please note that the current runbook is to monitor those AWS health events which status are **"open"**.
![Section3 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section4_automation_runbook_closed_health_events.png)

     You have completed the simulation of the service events, and tested the AWS Health Awareness capability of the Systems Manager operation change process.

#### Congratulations ! 
You have now completed the **Build AWS Health Aware Operation Change Process** lab, click on the link below to cleanup the lab resources.

{{< prev_next_button link_prev_url="../3_test_change_process/" link_next_url="../5_cleanup/" />}}
