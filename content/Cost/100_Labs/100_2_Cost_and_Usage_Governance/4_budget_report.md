---
title: "Create and implement an AWS Budget Report"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

AWS Budgets Reports allow you to create and send daily, weekly, or monthly reports to monitor the performance of your AWS Budgets.

1. From the Budgets dashboard, Click on **Budgets Reports**:
![Images/BudgetReports1.png](/Cost/100_2_Cost_and_Usage_Governance/Images/BudgetReports1.png?classes=lab_picture_small)

2. Click **Create budget report**:
![Images/BudgetReports2.png](/Cost/100_2_Cost_and_Usage_Governance/Images/BudgetReports2.png?classes=lab_picture_small)

3. Create a report with the following details:
    - **Select all budgets**
    - **Report frequency**: Weekly
    - **Day of week**: Monday
    - **Email recipients**: Input your email address
    - **Report name**: WeeklyBudgets
    - Select the **Create budget report** button when finished:
![Images/BudgetReports3.png](/Cost/100_2_Cost_and_Usage_Governance/Images/BudgetReports3.png?classes=lab_picture_small)

4. Your budget report should now be complete:
![Images/BudgetReports4.png](/Cost/100_2_Cost_and_Usage_Governance/Images/BudgetReports4.png?classes=lab_picture_small)

5. You should receive an email similar to the one below:
![Images/BudgetReports5.png](/Cost/100_2_Cost_and_Usage_Governance/Images/BudgetReports5.png?classes=lab_picture_small)

{{% notice tip %}}
You have created a budget report. Use reports to regularly track your progress against defined budgets.
{{% /notice %}}

{{< prev_next_button link_prev_url="../3_budget_spcoverage/" link_next_url="../5_tear_down/" />}}
