---
title: "Visualize in Cost Explorer"
date: 2023-02-12T11:16:09-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

## Overview

In Cost Explorer and AWS Budgets, a cost category appears as an
additional billing dimension. You can use this to filter for the
specific cost category value, or group by the cost category. In AWS CUR,
the cost category appears as a new column with the cost category value
in each row. In Cost Anomaly Detection, you can use cost category as a
monitor type to monitor your total costs across specified cost category
values.

This is an administrative feature, and it can only be customized by the management account or member accounts in AWS Organizations. For more information about controlling access for Cost Explorer, see [AWS Cost Management policy.](https://docs.aws.amazon.com/cost-management/latest/userguide/billing-example-policies.html)


{{% notice note %}}
**Note** - You must have Cost Explorer enabled for this account to allow billing data access. Once Cost Explorer is enabled, it can take up to 24 hours for changes to take effect.
{{% /notice %}}

#### Console:

1. Log into **Management Account** created in [AWS Account Setup.]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}})

2. Search for **cost explorer** in AWS console, choose **AWS Cost Explorer**.
 ![Section5 CostExplorer](/Cost/200_Cost_Category/Images/section5/costExplorer.png)

3. In the navigation pane on the left, choose **Cost Explorer**.
 ![Section5 NavigateCostExplorer](/Cost/200_Cost_Category/Images/section5/navigateCostExplorer.png)

4. Under **Report parameters**, click on **Date Range** selected value under **Time**. Choose **the Date Range** as **Month to Date** and click **Apply**.
 ![Section5 SelectDateRange](/Cost/200_Cost_Category/Images/section5/costAndUsageMonthToDate.png)

5. Under **Group by** choose **Cost category** as **Dimension** and choose **cost by team** as **Cost category**.
 ![Section5 GroupByCostCategoryDimensionByTeam](/Cost/200_Cost_Category/Images/section5/groupByCostCategoryDimensionByTeam.png)

6. Under **Filters** choose **cost by team** as **Cost category**.
 ![Section5 FilterCostCategoryAsCostByTeam](/Cost/200_Cost_Category/Images/section5/filterCostCategoryAsCostByTeam.png)

7. Click on the **Excludes** radio button under cost by team, select **No
    cost category: cost by team** and click **Apply**.
 ![Section5 ExcludeNoCostCategoryAsCostByTeam](/Cost/200_Cost_Category/Images/section5/excludeNoCostCategoryAsCostByTeam.png)

8. Now you will be able to visualize the cost for teams Alpha and Beta.
    Click on **Save to report library** to view it later.
 ![Section5 VisualizeTeamsCosts](/Cost/200_Cost_Category/Images/section5/visualizeTeamsCosts.png)

9. Give the name as **cost report by teams** and click on save report.
 ![Section5 CreateTeamsReport](/Cost/200_Cost_Category/Images/section5/createTeamsReport.png)

10. Repeat step-3 and step-4 for creating **cost by department** report.

11. Under **Group by** choose **Cost Category** as **Dimension** and
    choose **cost by department** as **Cost category**.
 ![Section5 GroupByCostCategoryDimensionByDept](/Cost/200_Cost_Category/Images/section5/groupByCostCategoryDimensionByDept.png)

12. Under Filter choose **cost by department** as **Cost Category**.
 ![Section5 FilterCostCategoryAsCostByDept](/Cost/200_Cost_Category/Images/section5/filterCostCategoryAsCostByDept.png)

13. Click on the **Excludes** radio button under **cost by department** and select **No cost category: cost by department**.
 ![Section5 ExcludeNoCostCategoryAsCostByDept](/Cost/200_Cost_Category/Images/section5/excludeNoCostCategoryAsCostByDept.png)

14. Now you will be able to visualize the cost for digital department.
    Click on **Save to report library** to view it later.
 ![Section5 VisualizeDeptCosts](/Cost/200_Cost_Category/Images/section5/visualizeDeptCosts.png)

15. Give the name as **cost report by department** and click on **Save report**.
 ![Section5 CreateDeptReport](/Cost/200_Cost_Category/Images/section5/createDeptReport.png)

16. Repeat step-3 and step-4 for creating **cost by Service** report for team **Alpha**.

17. Under **Group by** choose **Service** as **Dimension**.
 ![Section5 GroupByDimensionAsService](/Cost/200_Cost_Category/Images/section5/groupByDimensionAsService.png)

18. Under Filter choose **TeamName** as **Tag**.
 ![Section5 FilterTeamNameAsTag](/Cost/200_Cost_Category/Images/section5/filterTeamNameAsTag.png)

19. Under **TeamName** select **Alpha**.
 ![Section5 FilterTeamAlpha](/Cost/200_Cost_Category/Images/section5/filterTeamAlpha.png)

20. Now you will be able to visualize the cost for Services created by
    team **Alpha**. Click on **Save to report library** to view it later.
 ![Section5 VisualizeTeamsAlphaCosts](/Cost/200_Cost_Category/Images/section5/visualizeTeamsAlphaCosts.png)

21. Give the name as **cost report by service for team alpha** and click on **Save report**.
 ![Section5 CreateAlphaTeamsReport](/Cost/200_Cost_Category/Images/section5/createAlphaTeamsReport.png)

22. At the end of this section you will be able to see **three** cost
    reports under Reports section by the names **cost report by teams**,
    **cost report by department** and **cost report by team alpha**.
 ![Section5 ValidateCostReports](/Cost/200_Cost_Category/Images/section5/validateCostReports.png)

### Congratulations!

You have completed this section of the lab. In this section you created
two cost reports using cost categories as the filter using **AWS Cost Explorer** service.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../4_create_cost_categories/" link_next_url="../6_tear_down/" />}}

