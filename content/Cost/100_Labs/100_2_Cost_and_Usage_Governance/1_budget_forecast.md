---
title: "Create and implement an AWS Budget for monthly forecasted cost "
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

Budgets allow you to manage cost and usage by providing notifications when cost or usage are outside of configured amounts. They cannot be used to restrict actions, only notify on usage after it has occurred.

Budgets and notifications are updated when your billing data is updated, which is at least once per day.

**NOTE**: You may not receive an alarm for a forecasted budget if your account is new. Forecasting requires existing usage within the account.

### Create a monthly cost budget for your account
We will create a monthly cost budget which will notify if the forecasted amount exceeds the budget.

1. Log into the console via SSO, go to the **Billing console**:
![Images/AWSBudget1.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSBudget1.png)

2. Select **Budgets** from the left menu:
![Images/AWSBudget2.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSBudget2.png)

3. Click on **Create a budget**:
![Images/AWSBudget3.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSBudget3.png)

4. Ensure **Cost Budget** is selected, and click **Set your budget >**:
![Images/AWSBudget4.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSBudget4.png)

5. Create a cost budget, enter the following details:
    - **Name**: CostBudget1
    - **Period**: Monthly
    - **Budget effective dates**: Recurring Budget
    - **Start Month**: (select current month)
    - **Budget amount**: Fixed
    - **Budgeted amount**: $1 (enter an amount a lot LESS than last months cost),
    -  Other fields: leave as defaults:
![Images/AWSBudget5.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSBudget5.png)

6. Scroll down and click **Configure alerts >**:
![Images/AWSBudget6.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSBudget6.png)

7. Select:
    - **Send alert based on**: Forecasted Costs
    - **Alert threshold**: 100% of budgeted amount
    - **Email contacts**: (your email address)
    - Click on **Confirm budget >**:
![Images/AWSBudget7.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSBudget7.png)

8. Review the configuration, and click **Create**:
![Images/AWSBudget8.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSBudget8.png)

9. You should see the current forecast will exceed the budget (it should be red, you may need to refresh your browser):
![Images/AWSBudget9.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSBudget9.png)

10: You will receive an email similar to this within a few minutes:
![Images/AWSBudget10.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSBudget10.png)


{{% notice tip %}}
You have created a forecasted budget, when your forecasted costs for the entire account are predicted to exceed the forecast, you will receive a notification.
{{% /notice %}}
