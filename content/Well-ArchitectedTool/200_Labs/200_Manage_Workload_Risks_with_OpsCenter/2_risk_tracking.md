---
title: "Configure risk tracking"
menutitle: "Configure risk tracking"
date: 2021-08-31T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

### Tracking workload risks

After reviewing a workload, the Well-Architected Tool provides information on the number of High Risk Issues (HRI) and Medium Risk Issues (MRI) for the workload. The Well-Architected Tool also provides improvement guidance that can be used to implement Well-Architected best practices and mitigate risks. In this section, you will configure a solution to convert these identified risks into actionable tasks using Systems Manager OpsCenter.

### 2.1 Create and configure Lambda function

You will create a Lambda function that will iterate over all the workloads defined in the AWS WA Tool in the AWS Region you are using for this lab. The function retrieves best practices missing for each workload and creates OpsItems. The function also maintains workload state in a DynamoDB table to prevent duplicate OpsItems. OpsItems are configured to send notifications to an SNS topic that was created as part of the CloudFormation stack created in the previous section. Click here to view the [Lambda function code](/watool/200_Manage_Workload_Risks_with_OpsCenter/Code/risk_tracking.py) used for this solution.

1. Download the [risk_tracking.zip](/watool/200_Manage_Workload_Risks_with_OpsCenter/Code/risk_tracking.zip) Lambda function package
1. Navigate to the [AWS Lambda console](https://console.aws.amazon.com/lambda/home#/functions) and select **Create function**.
1. Choose the option to **Author from scratch** and enter `wa-risk-tracking` for the function name. Select **Python 3.9** as the runtime.
1. Under **Permissions**, expand **Change default execution role**. Choose **Use an existing role** and select `wa-risk-tracking-lambda-role` from the dropdown. This is the IAM role that was created as part of the CloudFormation stack in the previous section.
  ![CreateFunction](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/CreateFunction1.png?classes=lab_picture_auto)
1. Click **Create function**. Lambda provisions a new function which uses the IAM role that was specified.
1. After the function has been created, scroll down to the **Code source** section and select **Upload from** and then **.zip file**. Upload the function package that you selected at the beginning of this section - *risk_tracking.zip*
  ![UploadPackage](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/UploadPackage1.png?classes=lab_picture_auto)
1. Scroll down to **Runtime settings**, click **Edit** and replace the value for **Handler** with `risk_tracking.lambda_handler`. Click **Save**.
  ![UpdateHandler](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/UpdateHandler1.png?classes=lab_picture_auto)
1. On the function overview page, navigate to the **Configuration** tab and select **Environment variables**.
    * Click **Edit** and then click **Add** to add a new environment variable.
    * For the **Key** enter `sns_topic_arn`
    * For the **Value** enter the value of the SNS Topic obtained from the Outputs section of the CloudFormation stack as described in the [Deploy infrastructure](/Previouspage) section.
    * Click **Save**
    ![UpdateHandler](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/AddEnvVar.png?classes=lab_picture_auto)
1. Under the **Configuration** tab, select **General configuration** and click **Edit**.
    * Increase the value for **Timeout** to **1 min** and **Save**
    * During testing, the function was able to create 48 OpsItems in 39 seconds. [Adjust the function Memory and Timeout](https://docs.aws.amazon.com/lambda/latest/dg/configuration-memory.html) based on the number of risks (HRIs and MRIs), number of best practices missing, and the number of workloads defined in the Well-Architected Tool in the AWS Region you are using for this lab.
    ![UpdateTimeout](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/UpdateTimeout.png?classes=lab_picture_auto)    

### 2.2 Test risk tracking

To test the solution, you can invoke the `wa-risk-tracking` Lambda function from the Lambda console. On the function details page, click on the **Test** tab and select **New event**. Choose **hello-world** for the template and click **Test**. This will invoke the Lambda function and the function code will be executed. This can take up to a minute. Wait for the function to finish execution before moving on.

{{%expand "Click here if your Lambda function failed to execute successfully" %}}
If the function timed out before completing execution, [adjust the function Memory and Timeout](https://docs.aws.amazon.com/lambda/latest/dg/configuration-memory.html) based on the number of risks (HRIs and MRIs), number of best practices missing, and the number of workloads defined in the Well-Architected Tool in the AWS Region you are using for this lab.
{{% /expand%}}

![TestTracking](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/TestTracking.png?classes=lab_picture_auto)    

Navigate to the [Systems Manager console](https://console.aws.amazon.com/systems-manager/) and click on **OpsCenter** under **Operations Management**. On the summary page, you will see OpsItems grouped by their source. Under **Grouped by source** locate **Well-Architected** and click on the value for **Count** next to it.

![OpsCenter](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/OpsCenter.png?classes=lab_picture_auto)    

You will see a list of OpsItems that have been created based on best practices missing from your workloads. OpsItems have been created with the naming convention - **High Risk/Medium Risk - \<your workload name from the AWS WA Tool\> - \<best practice missing\>**. You might not see OpsItems immediately due to eventual consistency. If the `wa-risk-tracking` Lambda function executed successfully, wait a few minutes and refresh the console.

![OpsItems](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/OpsItems.png?classes=lab_picture_auto)    

Click on one of the OpsItems to view its details. Under **Related resources** you will see the ARN of the workload from the AWS WA Tool for which this OpsItem has been created.

![RelatedResources](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/RelatedResources.png?classes=lab_picture_auto)    

Scroll down to the **Operational data** section and expand it. You will see a variety of information such as the missing best practice, the pillar it is missing from, and the link to the improvement plan for the missing best practice. Copy the link under **Improvement Plan** and open it in a new browser to see the guidance for implementing this missing best practice in your workload.

![OperationalData](/watool/200_Manage_Workload_Risks_with_OpsCenter/Images/OperationalData.png?classes=lab_picture_auto)    

With this approach you can use information from the AWS WA Tool to turn missing best practices into actionable tasks enabling better co-ordination and tracking of risks across your teams. Individuals working on an OpsItem can set its status to **In Progress**, or set it to **Resolved** if that best practice has been implemented.

{{< prev_next_button link_prev_url="../1_deploy_infrastructure" link_next_url="../3_update_workload/" />}}
