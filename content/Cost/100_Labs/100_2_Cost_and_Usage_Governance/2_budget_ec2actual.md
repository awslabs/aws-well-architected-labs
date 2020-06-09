---
title: "Create and implement an AWS Budget for EC2 actual cost"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

We will create a monthly EC2 actual cost budget, which will notify if the actual costs of EC2 instances exceeds the specified amount.

1. Click **Create budget**:
![Images/AWSBudget11.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSBudget11.png)

2. Select **Cost budget**, and click **Set your budget >**:
![Images/AWSLab0.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab0.png)

3. Create a cost budget, enter the following details:
    - **Name**: EC2_actual
    - **Period**: Monthly
    - **Budget effective dates**: Recurring Budget
    - **Start Month**: (current month)
    - **Budget amount**: Fixed
    - **Budgeted amount**: $1 (enter an amount a lot LESS than last months cost),
    - Other fields: leave a defaults
    - Under **FILTERING** click on Service:
![Images/AWSLab1.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab1.png)

4. Type **Elastic** in the search field, then select the checkbox next to **EC2-Instances(Elastic Compute Cloud - Compute)** and Click **Apply filters**:
![Images/AWSLab2.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab2.png)

5. De-select **Upfront reservation fees**, and click **Configure alerts >**:
![Images/AWSLab3.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab3.png)

6. Select:
    - **Send alert based on**: Actual Costs
    - **Alert threshold**: 100% of budgeted amount
    - **Email contacts**: (your email address)
    - Click on **Confirm budget >**:
![Images/AWSLab4.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab4.png)

7. Review the configuration, and click **Create**:
![Images/AWSLab5.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab5.png)

8. You can see the current amount exceeds the budget (it is red, you may need to refresh your browser):
![Images/AWSLab6.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab6.png)

9. You will receive an email similar to the previous budget within a few minutes.
![Images/AWSLab15.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab15.png)


{{% notice tip %}}
You have created an actual cost budget for EC2 usage. You can extend this budget by adding specific filters such as linked accounts, tags or instance types. You can also create budgets for services other than EC2.
{{% /notice %}}

