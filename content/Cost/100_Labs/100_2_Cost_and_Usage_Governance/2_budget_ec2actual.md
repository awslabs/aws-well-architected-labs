---
title: "Create and implement an AWS Budget for EC2 actual cost"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

We will create a monthly EC2 actual cost budget, which will notify if the actual costs of EC2 instances exceeds the specified amount.

1. Click **Create budget**:
![Images/AWSBudget11.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSBudget11.png?classes=lab_picture_small)

2. Select **Cost budget**, and click **Set your budget >**:
![Images/AWSLab0.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSBudget4.png?classes=lab_picture_small)

3. Create a cost budget, enter the following details:
    - **Name**: EC2_actual
    - **Period**: Monthly
    - **Budget effective dates**: Recurring Budget
    - **Start Month**: (current month)
    - **Budget amount**: Fixed
    - **Budgeted amount**: $1 (enter an amount a lot LESS than last months cost),
    - Other fields: leave a defaults
![Images/AWSLab0.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab0.png?classes=lab_picture_small)

4. Create a filter to only include EC2 instances in the budget:
    - Under **FILTERING** click on Service:
![Images/AWSLab1.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab1.png?classes=lab_picture_small)

5. Type **Elastic** in the search field, then select the checkbox next to **EC2-Instances(Elastic Compute Cloud - Compute)** and Click **Apply filters**:
![Images/AWSLab2.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab2.png)

6. De-select **Upfront reservation fees**, and click **Configure thresholds >**:
![Images/AWSLab3.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab3.png?classes=lab_picture_small)

7. Select:
    - **Send threshold based on**: Actual Costs
    - **Alert threshold**: 100% of budgeted amount
    - **Set up your notifications**: Input your email address in the **Email recipients** field
    - Click on **Confirm budget >**:
![Images/AWSLab4.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab4.png?classes=lab_picture_small)

8. Review the configuration, and click **Create**:
![Images/AWSLab5.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab5.png?classes=lab_picture_small)

9. You can see the current amount exceeds the budget (you may need to refresh your browser):
![Images/AWSLab6.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab6.png?classes=lab_picture_small)

10. You will receive an email similar to the previous budget within a few minutes.
![Images/AWSLab15.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab15.png?classes=lab_picture_small)


{{% notice tip %}}
You have created an actual cost budget for EC2 usage. You can extend this budget by adding specific filters such as linked accounts, tags or instance types. You can also create budgets for services other than EC2.
{{% /notice %}}

{{< prev_next_button link_prev_url="../1_budget_forecast/" link_next_url="../3_budget_spcoverage/" />}}
