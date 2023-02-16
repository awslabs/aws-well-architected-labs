---
title: "Configure Cost Allocation Tags"
date: 2023-02-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Overview

You can use **AWS cost allocation tags** to track your AWS costs on a detailed level. After you activate cost allocation tags, AWS uses them to organize your resource costs on your cost allocation report, making it easier for you to categorize and track your AWS costs.

AWS provides two types of cost allocation tags, an **AWS generated tags** and **user-defined tags**. AWS, or AWS Marketplace ISV defines, creates, and applies the AWS generated tags for you, and you define, create, and apply **user-defined tags**. You must activate both types of tags separately before they can appear in Cost Explorer or on a cost allocation report.

For tags to appear on your billing reports, you must activate your
applied tags in the Billing and Cost Management console.

{{% notice note %}}
**Note** - After you create and apply user-defined tags to your resources,
it can take up to 24 hours for the tags to appear on your cost
allocation tags page for activation. After you select your tags for
activation, it can take up to 24 hours for tags to activate.
{{% /notice %}}

#### Console:

1. Log in into **management account** created in [AWS Account Setup.]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}}) 

2. Search for **billing** in AWS console and select **Billing** from Services or open the AWS Billing console at
    [https://console.aws.amazon.com/billing/](https://console.aws.amazon.com/billing/)
 ![Section3 Billing](/Cost/200_Cost_Category/Images/section3/billingService.png)

3. In the navigation pane, choose **Cost allocation tags**.
 ![Section3 CostAllocationTags](/Cost/200_Cost_Category/Images/section3/costAllocationTags.png)

4. Under **User-defined cost allocation tags** select **"CostCentre"**,
    **"Department"** , **"ProjectName"** and **"TeamName"** to activate the tags

5. Choose **Activate**.
 ![Section3 ActivateCostAllocationTags](/Cost/200_Cost_Category/Images/section3/activateCostAllocationTags.png)

6. Once activated, status should show as **Active** for the above mentioned Tag keys
 ![Section3 UserDefinedCostAllocationTags](/Cost/200_Cost_Category/Images/section3/userDefinedCostAllocationTags.png)

### Congratulations!

You have completed this section of the lab. In this section you
activated user defined tags using AWS Cost Allocation Tag service.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../2_apply_tags/" link_next_url="../4_create_cost_categories/" />}}

