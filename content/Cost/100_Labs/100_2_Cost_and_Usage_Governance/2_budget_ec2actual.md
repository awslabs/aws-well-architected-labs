---
title: "Create and Implement an AWS Budget for EC2 Actual Cost"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

We will create a monthly EC2 actual cost budget, which will notify us if/when the actual costs of EC2 instances exceeds the specified budgeted amount.

1. Click **Create budget**:
![Images/EC2Budget1.png](/Cost/100_2_Cost_and_Usage_Governance/Images/EC2Budget1.png?classes=lab_picture_small)

2. Select **Cost budget**, and click **Next**:
![Images/EC2Budget2.png](/Cost/100_2_Cost_and_Usage_Governance/Images/EC2Budget2.png?classes=lab_picture_small)

3. Enter the following details:

    - **Period**: Monthly
    - **Budget effective date**: Recurring budget
    - **Start month**: (current month)
    - **Choose how to budget**: Fixed
    - **Budgeted amount**: 1.00 (enter a dollar amount a lot LESS than last months cost)
    - Other fields: leave a defaults
![Images/EC2Budget3.png](/Cost/100_2_Cost_and_Usage_Governance/Images/EC2Budget3.png?classes=lab_picture_small)

4. Create a filter to only include EC2 instances in the budget:
    -  Scroll down and under **Budget Scope** select the **Filter Specific AWS Cost Dimensions** button:
![Images/EC2BudgetScope.png](/Cost/100_2_Cost_and_Usage_Governance/Images/EC2Budget4.png?classes=lab_picture_small)
    - Scroll down and under **Filters** select the **Add filter** button:
![Images/EC2Budget4.png](/Cost/100_2_Cost_and_Usage_Governance/Images/EC2Budget4.png?classes=lab_picture_small)

5. Select the filter options:
    - Under **Dimension** select **Service** from the dropdown
    - Under **Values** select **EC2-Instances (Elastic Compute Cloud - Compute)**
    - Select the **Apply filter** button:
![Images/EC2Budget5.png](/Cost/100_2_Cost_and_Usage_Governance/Images/EC2Budget5.png?classes=lab_picture_small)

6. Finish the budget details:
    - Remove **Upfront reservation fees** by selecting the **X** to the right of the name
    - **Budget name**: EC2_actual
    - Select the **Next** button:
![Images/EC2Budget6.png](/Cost/100_2_Cost_and_Usage_Governance/Images/EC2Budget6.png?classes=lab_picture_small)

7. To create an alert for our new EC2_actual budget select **Add an alert threshold**:
![Images/EC2Budget7.png](/Cost/100_2_Cost_and_Usage_Governance/Images/EC2Budget7.png?classes=lab_picture_small)

8. For Alert #1 select:
    - **Threshold**: 100% of budgeted amount
    - **Trigger**: Actual
    - **Notification preferences**: Input your email address in the **Email recipients** field
    - Click on **Next**:
![Images/EC2Budget8.png](/Cost/100_2_Cost_and_Usage_Governance/Images/EC2Budget8.png?classes=lab_picture_small)

9. Here you can attach actions that can be taken when you budget exceeds its threshold. We will not be attaching any actions for this lab. Select **Next** to move to the next page:
![Images/EC2Budget9.png](/Cost/100_2_Cost_and_Usage_Governance/Images/EC2Budget9.png?classes=lab_picture_small)

10. Review the configuration, and click **Create budget**:
![Images/EC2Budget10.png](/Cost/100_2_Cost_and_Usage_Governance/Images/EC2Budget10.png?classes=lab_picture_small)

11. You can see the current amount exceeds the new EC2_actual budget (you may need to refresh your browser):
![Images/EC2Budget11.png](/Cost/100_2_Cost_and_Usage_Governance/Images/EC2Budget11.png?classes=lab_picture_small)

12. You will receive an email similar to the previous budget within a few minutes.
![Images/EC2Budget12.png](/Cost/100_2_Cost_and_Usage_Governance/Images/EC2Budget12.png?classes=lab_picture_small)


{{% notice tip %}}
You have created an actual cost budget for EC2 usage. You can extend this budget by adding specific filters such as linked accounts, tags or instance types. You can also create budgets for services other than EC2.
{{% /notice %}}

{{< prev_next_button link_prev_url="../1_budget_forecast/" link_next_url="../3_budget_spcoverage/" />}}
