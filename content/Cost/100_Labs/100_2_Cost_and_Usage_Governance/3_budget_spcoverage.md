---
title: "Create and implement an AWS Budget for EC2 Savings Plan coverage"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---
We will create a monthly savings plan coverage budget, which will notify if the coverage of Savings Plan for EC2 is below the specified amount. 

You should **not** set an arbitrary limit for the alarm, (i.e. alarm if coverage is less than 80%) instead select your current level of coverage - so if coverage reduces, you can act and increase coverage if required.

1. From the **Budgets** dashboard in the console, click **Create budget**:
![Images/SPBudget1.png](/Cost/100_2_Cost_and_Usage_Governance/Images/SPBudget1.png?classes=lab_picture_small)

2. Select **Savings Plans budget**, and click **Next**:
![Images/SPBudget2.png](/Cost/100_2_Cost_and_Usage_Governance/Images/SPBudget2.png?classes=lab_picture_small)

3. Create a cost budget, enter the following details:
    - **Period**: Monthly
    - **Monitor my spend against**: Coverage of Savings Plans
    - **Coverage threshold**: 90%
    - **Budget name**: SP_Coverage
    - Leave all other fields as defaults
    - Click on the **Next** button to continue:
![Images/SPBudget3.png](/Cost/100_2_Cost_and_Usage_Governance/Images/SPBudget3.png?classes=lab_picture_small)
<BR><BR>
**NOTE**: **NEVER** create a utilization budget, unless you are doing it for a **single** and specific discount rate by using filters. For example you want to track the utilization of m5.large Linux discount. A utilization budget across different discounts will most likely lead to confusion and unnecessary work.

4. For the budget alert settings, input your email address in the **Email recipients** field and click on **Next**:
![Images/SPBudget4.png](/Cost/100_2_Cost_and_Usage_Governance/Images/SPBudget4.png?classes=lab_picture_small)

5. Review the configuration, and click the **Create budget** button:
![Images/SPBudget5.png](/Cost/100_2_Cost_and_Usage_Governance/Images/SPBudget5.png?classes=lab_picture_small)

6. You have created an Savings Plans Coverage budget:
![Images/SPBudget6.png](/Cost/100_2_Cost_and_Usage_Governance/Images/SPBudget6.png?classes=lab_picture_small)

7. You will receive an email similar to below within a few minutes:
![Images/SPBudget7.png](/Cost/100_2_Cost_and_Usage_Governance/Images/SPBudget7.png?classes=lab_picture_small)

{{% notice tip %}}
You have created a Savings Plan budget. Use this type of budget to notify you if a change in a workload has reduced coverage, a Savings Plan has expired, or additional usage has been created and a new Savings Plan purchase may be required.
{{% /notice %}}

{{< prev_next_button link_prev_url="../2_budget_ec2actual/" link_next_url="../4_budget_report/" />}}
