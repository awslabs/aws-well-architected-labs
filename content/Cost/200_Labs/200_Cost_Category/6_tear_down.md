---
title: "Teardown"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

## Overview

It is recommended to delete all the resources those are not in use
anymore to save the cost.

### Delete resources created by CloudFormation template

#### Console:

1. Log into the **Cost Optimization Member Account** created in [AWS Account Setup.]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}}) 

2. Search for **cloud formation** in AWS console and select **CloudFormation** from Services.
   ![Section6 CloudFormation](/Cost/200_Cost_Category/Images/section6/cloudFormationService.png)

3. Select **Alpha-Team-Resources** (or the Stack name you have chosen while deplying resources for team **Alpha**) and click on **Delete**.
    ![Section6 DeleteAlphaTeamResources](/Cost/200_Cost_Category/Images/section6/selectStackTeamAlpha.png)

4. Click on **Delete stack**.
    ![Section6 DeleteAlphaTeamStack](/Cost/200_Cost_Category/Images/section6/deleteStackTeamAlpha.png)

5. Similarly select **Beta-Team-Resources** (or the Stack name you have chosen while deplying resources for team **Beta**) and click on **Delete**.
   ![Section6 DeleteAlphaTeamStack](/Cost/200_Cost_Category/Images/section6/selectStackTeamBeta.png)

6. Click on **Delete stack**.
 ![Section6 DeleteAlphaTeamStack](/Cost/200_Cost_Category/Images/section6/deleteStackTeamBeta.png)

   {{% notice note %}}
   **Note** - This will delete all the resources created as part CloudFormation template
   and will take up to 15 mins to complete.
   {{% /notice %}}


### Delete cost category

#### Console:

1. Log into **Management Account** created in [AWS Account Setup.]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}})

2. Search for **billing** in AWS console and select **Billing** from Services or open the AWS Billing console at
   [https://console.aws.amazon.com/billing/](https://console.aws.amazon.com/billing/)
 ![Section6 DeleteAlphaTeamStack](/Cost/200_Cost_Category/Images/section6/billingService.png)

3. In the navigation pane, choose **Cost categories**.
 ![Section6 DeleteAlphaTeamStack](/Cost/200_Cost_Category/Images/section6/costCategoriesFeature.png)

4. Choose **cost by department** and click on **Delete** to delete the category.
 ![Section6 DeleteAlphaTeamStack](/Cost/200_Cost_Category/Images/section6/deleteCostCategoriesDept.png)

5. Similarly choose **cost by team** and click on **Delete**.
 ![Section6 DeleteAlphaTeamStack](/Cost/200_Cost_Category/Images/section6/deleteCostCategoriesTeam.png)

### Deactivate user defined tags

#### Console:

1. In the navigation pane, choose **Cost allocation tags**.
 ![Section6 DeleteAlphaTeamStack](/Cost/200_Cost_Category/Images/section6/costAllocationTagsService.png)

2. Under **User-defined cost allocation tags** select **CostCentre**,
    **Department**, **ProjectName** and **TeamName** as Tag key values to de-activate the tags. Click **Deactivate**.
 ![Section6 DeleteAlphaTeamStack](/Cost/200_Cost_Category/Images/section6/costAllocationTagDeactivate.png)

### Delete cost reports

#### Console:

1. Search for **cost explorer** in AWS console, choose **AWS Cost Explorer**.
 ![Section6 CostExplorer](/Cost/200_Cost_Category/Images/section6/costExplorerService.png)

2. In the navigation pane on the left, choose **Reports**.
   ![Section6 NavigateReports](/Cost/200_Cost_Category/Images/section6/reportsFeature.png)

3. Select three cost reports under **Reports** section by the names **cost report by teams**, **cost report by department** and **cost report by team alpha** & click on **Delete** to delete the reports.
 ![Section6 DeleteAlphaTeamStack](/Cost/200_Cost_Category/Images/section6/deleteCostReport.png)


{{< prev_next_button link_prev_url="../5_visualize_in_cost_explorer/"  title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST03-BP05 - “Add organization information to cost and usage”](https://docs.aws.amazon.com/wellarchitected/latest/framework/cost_monitor_usage_org_information.html)
{{< /prev_next_button >}}


