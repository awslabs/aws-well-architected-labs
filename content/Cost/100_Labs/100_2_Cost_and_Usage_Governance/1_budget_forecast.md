---
title: "Create and implement an AWS Budget for monthly forecasted cost "
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

Budgets allow you to manage cost and usage by providing notifications or restricting actions when a budget exceeds its threshold (actual or forecasted amounts).

Budgets and notifications are updated when your billing data is updated, which is at least once per day.

**NOTE**: You may not receive an alarm for a forecasted budget if your account is new. Forecasting requires existing usage within the account.

### Create a monthly cost budget for your account
We will create a monthly cost budget which will notify if the forecasted amount exceeds the budget.

1. Log into the console via SSO and open the **Billing console**. This can be achieved by using the **search bar** or by selecting **My Billing Dashboard** from your account dropdown menu.
![Images/Budget1.png](/Cost/100_2_Cost_and_Usage_Governance/Images/Budget1.png?classes=lab_picture_small)

2. Select **Budgets** from the left hand menu:
![Images/Budget2.png](/Cost/100_2_Cost_and_Usage_Governance/Images/Budget2.png?classes=lab_picture_small)

3. Click on **Create budget**:
![Images/Budget3.png](/Cost/100_2_Cost_and_Usage_Governance/Images/Budget3.png?classes=lab_picture_small)

4. Ensure **Cost budget** is selected, and click on **Next**:
![Images/Budget4.png](/Cost/100_2_Cost_and_Usage_Governance/Images/Budget4.png?classes=lab_picture_small)

5. To create a cost budget, enter the following details:
    - **Period**: Monthly
    - **Budget effective date**: Recurring Budget
    - **Start month**: (select current month)
    - **Choose how to budget**: Fixed
    - **Budgeted amount**: 1.00 (enter a dollar amount a lot LESS than last months cost)
    - **Name**: CostBudget1
    -  Other fields: leave as defaults:

Once you have entered all the details select **Next**:
![Images/Budget5.png](/Cost/100_2_Cost_and_Usage_Governance/Images/Budget5.png?classes=lab_picture_small)

6. To create an alert for our budget select **Add an alert threshold**:
![Images/Budget6.png](/Cost/100_2_Cost_and_Usage_Governance/Images/Budget6.png?classes=lab_picture_small)

7. For Alert #1 select:
    - **Threshold**: 100% of budgeted amount
    - **Trigger**: Forecasted
    - **Notification preferences**: Input your email address in the **Email recipients** field
    - Click on **Next**:
![Images/Budget7.png](/Cost/100_2_Cost_and_Usage_Governance/Images/Budget7.png?classes=lab_picture_small)

8. Here you can attach actions that can be taken when you budget exceeds its threshold. We will not be attaching any actions for this lab. Select **Next** to move to the next page:
![Images/Budget8.png](/Cost/100_2_Cost_and_Usage_Governance/Images/Budget8.png?classes=lab_picture_small)

9. Review the configuration, and click **Create budget**:
![Images/Budget9.png](/Cost/100_2_Cost_and_Usage_Governance/Images/Budget9.png?classes=lab_picture_small)

10. You should see the current forecast will exceed the budget (you may need to refresh your browser):
![Images/Budget10.png](/Cost/100_2_Cost_and_Usage_Governance/Images/Budget10.png?classes=lab_picture_small)

11. You will receive an email similar to this within a few minutes:
![Images/Budget11.png](/Cost/100_2_Cost_and_Usage_Governance/Images/Budget11.png?classes=lab_picture_small)

{{% notice tip %}}
You have created a forecasted budget, when your forecasted costs for the entire account are predicted to exceed the forecast, you will receive a notification.
{{% /notice %}}

{{< prev_next_button link_prev_url="../" link_next_url="../2_budget_ec2actual/" />}}
