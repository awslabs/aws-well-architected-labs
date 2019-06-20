# Level 100: Cost and Usage Governance

## Authors
- Nathan Besh, Cost Lead Well-Architected
 
## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com


# Table of Contents
1. [Create an AWS Budget - monthly forecast](#budget_forecast)
2. [Create an AWS Budget - EC2 actual](#budget_ec2actual)
3. [Create an AWS Budget - RI Coverage](#budget_ricoverage)
4. [Tear down](#tear_down)
5. [Rate this Lab](#rate_lab)  


## 1. Create and implement an AWS Budget for monthly forecasted usage<a name="budget_forecast"></a> 
Budgets allow you to manage cost and usage by providing notifications when usage or cost are outside of configured amounts. They cannot be used to restrict actions, only notify on usage after it has occurred.

**NOTE**: You may not receive an alarm for a forecasted budget if your account is new. Forecasting requires existing usage within the account.

### Create a monthly cost budget for your account 
We will create a monthly cost budget which will notify if the forecasted amount exceeds the budget.

1. Go to the **Billing console**:
![Images/AWSBudget1.png](Images/AWSBudget1.png)

2. Select **Budgets** from the left menu:
![Images/AWSBudget2.png](Images/AWSBudget2.png)

3. Click on **Create a budget**:
![Images/AWSBudget3.png](Images/AWSBudget3.png)

4. Ensure **Cost Budget** is selected, and click **Set your budget >**:
![Images/AWSBudget4.png](Images/AWSBudget4.png)

5. Create a cost budget, enter the following details:
- **Name**: (enter a name), 
- **Budgeted amount**: (enter an amount a lot LESS than last months cost), 
- **Budget effective dates**: Select **Recurring Budget** and start month is the current month, 
- Other fields: leave as defaults:
![Images/AWSBudget5.png](Images/AWSBudget5.png)

6. Scroll down and click **Configure alerts >**:
![Images/AWSBudget6.png](Images/AWSBudget6.png)

7. Select:
- **Send alert based on**: Forecasted Costs
- **Alert threshold**: 100% of budgeted amount
- **Email contacts**: (your email address)
- Click on **Confirm budget >**:
![Images/AWSBudget7.png](Images/AWSBudget7.png)

8. Review the configuration, and click **Create**:
![Images/AWSBudget8.png](Images/AWSBudget8.png)

9. You can see the current forecast will exceed the budget (it is red, you may need to refresh your browser):
![Images/AWSBudget9.png](Images/AWSBudget9.png) 

10: You will receive an email similar to this within a few minutes:
![Images/AWSBudget10.png](Images/AWSBudget10.png)


You have created a forecasted budget, when your forecasted costs for the entire account are predicted to exceed the forecast, you will receive a notification. You can also create an actual budget, for when your current costs actually exceed a defined amount.



## 2. Create and implement an AWS Budget for EC2 actual cost<a name="budget_ec2actual"></a>
We will create a monthly EC2 actual cost budget, which will notify if the actual costs of EC2 instances exceeds the specified amount.

1. Click **Create budget**:
![Images/AWSBudget11.png](Images/AWSBudget11.png)

2. Select **Cost budget**, and click **Set your budget >**:
![Images/AWSLab0.png](Images/AWSLab0.png)

3. Create a cost budget, enter the following details:
- **Name**: (enter a name), 
- **Budgeted amount**: (enter an amount a lot LESS than last months cost), 
- **Budget effective dates**: Select **Recurring Budget** and start month is the current month, 
- Other fields: leave a defaults
- Under **FILTERING** click on Service:
![Images/AWSLab1.png](Images/AWSLab1.png)

4. Type **Elastic** in the search field, then select the checkbox next to **EC2-Instances(Elastic Compute Cloud - Compute)** and Click **Apply filters**:
![Images/AWSLab2.png](Images/AWSLab2.png)

5. De-select **Upfront reservation fees**, and click **Configure alerts >**:
![Images/AWSLab3.png](Images/AWSLab3.png) 

6. Select:
- **Send alert based on**: Actual Costs
- **Alert threshold**: 100% of budgeted amount
- **Email contacts**: (your email address)
- Click on **Confirm budget >**:
![Images/AWSLab4.png](Images/AWSLab4.png)

7. Review the configuration, and click **Create**:
![Images/AWSLab5.png](Images/AWSLab5.png)

8. You can see the current amount exceeds the budget (it is red, you may need to refresh your browser):
![Images/AWSLab6.png](Images/AWSLab6.png) 

9. You will receive an email similar to the previous budget within a few minutes.

You have created an actual cost budget for EC2 usage. You can extend this budget by adding specific filters such as linked accounts, tags or instance types. You can also create budgets for other services than EC2.


## 3. Create and implement an AWS Budget for EC2 Instance RI coverage<a name="budget_ricoverage"></a>
We will create a monthly RI coverage budget which will notify if the coverage of Reserved Instances for EC2 is below the specified amount.

1. Click **Create budget**:
![Images/AWSLab7.png](Images/AWSLab7.png)

2. Select **Reservation budget**, and click **Set your budget >**:
![Images/AWSLab8.png](Images/AWSLab8.png)

3. For **Reservation budget type** Select **RI Coverage**, enter a **Name**, select **EC2-Instances** as the **Service**, enter a **Coverage threshold** of **80%** and click **Configure alerts >**:
![Images/AWSLab9.png](Images/AWSLab9.png) 

4. Enter an address for **Email contacts** and click **Confirm budget >**:
![Images/AWSLab10.png](Images/AWSLab10.png)

5. Review the configuration, and click **Create** in the lower right:
![Images/AWSLab11.png](Images/AWSLab11.png)

6. You have created an RI Coverage budget. High coverage is critical for cost optimization, as it ensures you are paying the lowest price for your resources.
![Images/AWSLab12.png](Images/AWSLab12.png)
     
7. You will receive an email similar to this within a few minutes:
![Images/AWSLab13.png](Images/AWSLab13.png)
 
        

## 4. Tear down <a name="tear_down"></a>

### Delete a budget
We will delete all three budgets that were configured in sections 2,3 and 4.

1. From the budgets homepage, click on the budget name **CostBudget1**:
![Images/AWSTeardown15.png](Images/AWSTeardown15.png)

2. Click on the **3 dot menu** in the top right, select **Delete**:
![Images/AWSTeardown16.png](Images/AWSTeardown16.png)

3. Click on the other budget name **EC2_actual**:
![Images/AWSTeardown17.png](Images/AWSTeardown17.png)

4. Click on the **3 dot menu** in the top right, select **Delete**:
![Images/AWSTeardown18.png](Images/AWSTeardown18.png)

5. Click on the other budget name **EC2_RI_Coverage**:
![Images/AWSTeardown19.png](Images/AWSTeardown19.png)

6. Click on the **3 dot menu** in the top right, select **Delete**:
![Images/AWSTeardown20.png](Images/AWSTeardown20.png)

7. ALl budgets should be deleted that were created in this workshop:
![Images/AWSTeardown21.png](Images/AWSTeardown21.png)


## 5. Rate this lab<a name="rate_lab"></a> 
[![1 Star](Images/star.png)](https://wellarchitectedlabs.com/Cost_100_2_1star) [![2 star](Images/star.png)](https://wellarchitectedlabs.com/Cost_100_2_2star) [![3 star](Images/star.png)](https://wellarchitectedlabs.com/Cost_100_2_3star) [![4 star](Images/star.png)](https://wellarchitectedlabs.com/Cost_100_2_4star) [![5 star](Images/star.png)](https://wellarchitectedlabs.com/Cost_100_2_5star) 



