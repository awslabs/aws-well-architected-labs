---
title: "Configure workload updates"
menutitle: "Configure workload updates"
date: 2021-08-31T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

### Updating workloads

The AWS WA Tool should be the source of truth for information related to workload risks. After new best practices are implemented for a workload, it is important to reflect this by updating the workload on the AWS WA Tool. In this section, you will expand the solution to include automated updates to the workload when best practices are implemented.

### 2.1 Create and configure Lambda function

You will create a Lambda function that will be invoked using SNS whenever a Well-Architected OpsItem is resolved. The function will update the workload on the AWS WA Tool to reflect the implementation of the best practice and also update the workload state in the DynamoDB table. Click here to view the [Lambda function code](/watool/200_Manage_Workload_Risks_with_OpsCenter/Code/update_workload.py) for automating workload updates.

1. Download the [update_workload.zip](/watool/200_Manage_Workload_Risks_with_OpsCenter/Code/update_workload.zip) Lambda function package
1. Navigate to the [AWS Lambda console](https://console.aws.amazon.com/lambda/home#/functions) and select **Create function**.
1. Choose the option to **Author from scratch** and enter `wa-update-workload` for the function name. Select **Python 3.9** as the runtime.
1. Under **Permissions**, expand **Change default execution role**. Choose **Use an existing role** and select `wa-risk-tracking-lambda-role` from the dropdown. This is the IAM role that was created as part of the CloudFormation stack in the previous section.
  ![CreateFunction](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/CreateFunction2.png?classes=lab_picture_auto)
1. Click **Create function**. Lambda provisions a new function which uses the IAM role that was specified.
1. After the function has been created, scroll down to the **Code source** section and select **Upload from** and then **.zip file**. Upload the function package that you selected at the beginning of this section: *update_workload.zip*
  ![UploadPackage](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/UploadPackage2.png?classes=lab_picture_auto)
1. Scroll down to **Runtime settings**, click **Edit** and replace the value for **Handler** with `update_workload.lambda_handler`. Click **Save**.
  ![UpdateHandler](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/UpdateHandler2.png?classes=lab_picture_auto)
1. On the function overview page, click **Add Trigger** to configure a trigger for the Lambda function.
  ![AddTrigger](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/AddTrigger.png?classes=lab_picture_auto)
  * Select **SNS** under **Trigger configuration**
  ![SelectSNS](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/SelectSNS.png?classes=lab_picture_auto)
  * Select **wa-risk-tracking** under **SNS Topic** and click **Add**.
  ![SelectTopic](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/SelectTopic.png?classes=lab_picture_auto)

### 2.2 Test workload updates

To test workload updates, navigate to the [Systems Manager console](https://console.aws.amazon.com/systems-manager/) and click on **OpsCenter** under **Operations Management**. Select an OpsItems with **Well-Architected** as the **Source**.

![SelectOpsItem](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/SelectOpsItem.png?classes=lab_picture_auto)

Scroll down to the **Operational data** section and expand it. Note down values for the **WorkloadName**, **Pillar**, **Question**, and **Best practice missing**.

![NoteOpsData](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/NoteOpsData.png?classes=lab_picture_auto)

Open a new tab on your browser and navigate to the [AWS WA Tool console](https://console.aws.amazon.com/systems-manager/). Click on the workload listed in the OpsItem in the previous step to view its details. Scroll down to the **Lenses** section and click on **AWS Well-Architected Framework** to see pillar level risk data for the workload.

![Lenses](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/Lenses.png?classes=lab_picture_auto)

Scroll down to the **Pillars** section, click on the pillar listed in the OpsItem from the previous step.

![SelectPillar](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/SelectPillar.png?classes=lab_picture_auto)

Scroll down to **Questions** and expand the **Answer details** for the question that is listed in the OpsItem from the previous step. Note that the best practice listed in the OpsItem does not appear under **Selected choice(s)** for this question.

![BPMissing](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/BPMissing.png?classes=lab_picture_auto)

Switch back to the browser tab that has the OpsItem open. Assume that you have used the **Improvement Plan** and implemented the best practice listed in the OpsItem for your workload. After this implementation is complete, you can set the status of the OpsItem to **Resolved** to reflect completion.

![ResolveOpsItem](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/ResolveOpsItem.png?classes=lab_picture_auto)

Switch back to the browser tab with the AWS WA Tool console. Refresh the page and then scroll down to **Questions** and expland **Answer details** for the question that was listed in the OpsItem you resolved. You should see that the best practice listed in the OpsItem now appears under **Selected choice(s)**.

![WorkloadUpdated](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/WorkloadUpdated.png?classes=lab_picture_auto)

When the OpsItem was resolved, a notification was sent to the ***wa-risk-tracking*** SNS topic which then invoked the ***wa-update-workload*** Lambda function. The function updated the workload on the AWS WA Tool to reflect the best practice specified in the OpsItem as being implemented. With this approach, workloads on the AWS WA Tool will always be a single source of truth for you to be aware of workload risks.

{{< prev_next_button link_prev_url="../2_risk_tracking" link_next_url="../4_cleanup/" />}}
