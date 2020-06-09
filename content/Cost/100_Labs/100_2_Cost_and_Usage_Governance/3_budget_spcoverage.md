---
title: "Create and implement an AWS Budget for EC2 Savings Plan coverage"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---
We will create a monthly savings plan coverage budget which will notify if the coverage of Savings Plan for EC2 is below the specified amount. 

You should **not** set an arbitrary limit to alarm on (i.e. alarm if coverage is less than 80%) instead select your current level of coverage - so if coverage reduces, you can act and increase coverage if required.

1. From the **AWS Budgets** dashboard in the console, click **Create budget**:
![Images/AWSLab7.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab7.png)

2. Select **Savings Plans budget**, and click **Set your budget >**:
![Images/AWSLab8.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab8.png)

3. Create a cost budget, enter the following details:
    - **Name**: SP_Coverage
    - **Period**: Monthly
    - **Savings Plans budget type**: Savings Plans Coverage
    - **Coverage threshold**: 90%
    - Leave all other fields as defaults
![Images/AWSLab9.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab9.png)
<BR><BR>
**NOTE**: **NEVER** create a utilization budget, unless you are doing it for a **single** and specific discount rate by using filters. For example you want to track the utilization of m5.large Linux discount. A utilization budget across different discounts will most likely lead to confusion and unnecessary work.

4. Scroll down and click **Configure alerts >**:
![Images/AWSLab14.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab14.png)

5. Enter an address for **Email contacts** and click **Confirm budget >**:
![Images/AWSLab10.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab10.png)

6. Review the configuration, and click **Create** in the lower right:
![Images/AWSLab11.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab11.png)

7. You have created an Savings Plans Coverage budget:
![Images/AWSLab12.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab12.png)

8. You will receive an email similar to this within a few minutes:
![Images/AWSLab13.png](/Cost/100_2_Cost_and_Usage_Governance/Images/AWSLab13.png)

{{% notice tip %}}
You have created a Savings Plan budget. Use this type of budget to notify you if a change in a workload has reduced coverage, a Savings Plan has expired, or additional usage has been created and a new Savings Plan purchase may be required.
{{% /notice %}}
