---
title: "Create Cost Categories"
date: 2023-02-12T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

## Overview

AWS **Cost Categories** is a feature within **AWS Cost Management** product
suite that enables you to group cost and usage information into
meaningful categories based on your needs. You can create custom
categories and map your cost and usage information into these categories
based on the rules defined by you using various dimensions such as
account, tag, service, charge type, and even other cost categories. Once
cost categories are set up and enabled, you will be able to view your
cost and usage information by these categories starting at the beginning
of the month in AWS Cost Explorer, AWS Budgets, and AWS Cost and Usage
Report (CUR).

You can create cost categories to **organize your cost and usage information**. Member account and the management account in AWS
Organizations have default access to create cost categories. Rules
are not mutually exclusive, and you can control the order that the rules
apply in.


#### Console:

1. If you are already in Billing Service, proceed to step-2, else search for **billing** in AWS console and select **Billing** from Services.
 ![Section4 Billing](/Cost/200_Cost_Category/Images/section4/billingService.png)

2. In the navigation pane on the left, choose **Cost categories**.
 ![Section4 CostCategories](/Cost/200_Cost_Category/Images/section4/costCategoriesService.png)

3. At the top of the page, choose **Create cost category**.
 ![Section4 CreateCostCategories](/Cost/200_Cost_Category/Images/section4/createCostCategory.png)

   Note: For current lab purposes, we will create two cost categories for
   simplification and better understanding of the service. Refer [here](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/create-cost-categories.html) if you
   want to create complex cost categories.

4. Under **Cost category details**, enter the name of your cost
   category as **cost by team**. Your cost category name must be unique
   within your account. Keep rest of the fields with default values and
   click **Next**
 ![Section4 NameCostCategoryTeam](/Cost/200_Cost_Category/Images/section4/nameCostCategoryTeam.png)

5. In **Define category rules**, Under **New category rule** choose **Inherited value** as **Rule type**, choose **Cost Allocation Tag** as **Dimension** and **TeamName** as **Tag Key**, click **Next**.
 ![Section4 DefineCostCategoriesRuleTeam](/Cost/200_Cost_Category/Images/section4/defineCategoryRuleTeam.png)

6. Skip **Define split charges** for this lab. Choose **Create cost category**.

   Note : For more information on **split charges** please visit
   <https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/splitcharge-cost-categories.html>
   ![Section4 DefineSplitCharges](/Cost/200_Cost_Category/Images/section4/defineSplitCharges.png)

7. Repeat step-3 for creating second cost category. Under **Cost category details**,
   enter the name of your cost category as **cost by department** and click **Next**.
 ![Section4 NameCostCategoryDept](/Cost/200_Cost_Category/Images/section4/nameCostCategoryDept.png)

8. In Define category rules, select **Inherited value** as Rule type, choose **Cost Allocation Tag** as Dimension and **Department** as Tag key,
   click on **Add rule** and select **Inherited value** as Rule type, choose **Cost Allocation Tag** as Dimension and **CostCentre** as Tag key. click on **Next**.
   ![Section4 DefineCostCategoriesRuleDept](/Cost/200_Cost_Category/Images/section4/defineCategoryRulesDept.png)

9. Skip **Define split charges** for this lab. Click on **Create cost category**.
 ![Section4 DefineSplitCharges](/Cost/200_Cost_Category/Images/section4/defineSplitCharges.png)

10. The status will be shown as **Processing** as follows and wait until it is shown as **Applied** before you start the next lab:
 ![Section4 CostCategoriesResults](/Cost/200_Cost_Category/Images/section4/costCategoriesResults.png)

{{% notice note %}}
**Note** - After you create or edit a cost category, it can take up to 24 hours before it has categorized your cost and usage information in the AWS Cost and Usage Report, Cost Explorer, and other cost management products.
{{% /notice %}}

### Congratulations!

You have completed this section of the lab. In this section you created
two cost categories using **Cost Categories** under **AWS Billing**
service.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../3_configure_cost_allocation_tags/" link_next_url="../5_visualize_in_cost_explorer/" />}}