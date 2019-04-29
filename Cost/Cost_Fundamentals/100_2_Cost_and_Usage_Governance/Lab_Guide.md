# Level 100: Cost and Usage Governance

## Authors
- Nathan Besh, Cost Lead Well-Architected
 
## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com


# Table of Contents
1. [Create a cost optimization team](#create_team)
2. [Create an AWS Budget - monthly forecast](#budget_forecast)
3. [Create an AWS Budget - EC2 actual](#budget_ec2actual)
4. [Create an AWS Budget - RI Coverage](#budget_ricoverage)
5. [Tear down](#tear_down)
6. [Rate this Lab](#rate_lab)  
7. [Feedback survey](#survey)  

## 1. Create a cost optimization team <a name="create_team"></a>
We are going to create a cost optimization team. Within your organization there needs to be a team of people that are focused around costs and usage. This exercise will create the users and the group, then assign all the access they need.
This team will then be able to manage the organizations cost and usage, and start to implement optimization mechanisms.

Log into the console as an IAM user with the required permissions, as per:
- [./Code/IAM_policy](./Code/IAM_policy.md) IAM policy required for this lab
      
### 1.1 Create an IAM policy for the team
This provides access to allow the cost optimization team to perform their work, namely the Labs in the 100 level fundamental series. This is the minimum access the team requires.

1. Log in and go to the **IAM** Service page:
![Images/AWSIAM1.png](Images/AWSIAM1.png)

2. Select **Policies** from the left menu:
![Images/AWSIAM2.png](Images/AWSIAM2.png)

3. Select **Create Policy**:
![Images/AWSIAM3.png](Images/AWSIAM3.png)
  
4. Select the **JSON** tab:
![Images/AWSIAM4.png](Images/AWSIAM4.png)
  
5. Copy & paste the following policy into the the field:
**NOTE**: Ensure you copy the entire policy, everything including the first '{' and last '}'
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "aws-portal:ViewUsage",
                "aws-portal:ModifyBilling",
                "aws-portal:ViewBilling",
                "aws-portal:ViewAccount",
                "budgets:*"
            ],
            "Resource": "*"
        }
    ]
}
```
6. Click **Review policy**: 
![Images/AWSIAM5.png](Images/AWSIAM5.png)

7. Enter a **Name** and **Description** for the policy and click **Create policy**:
![Images/AWSIAM6.png](Images/AWSIAM6.png)

You have successfully created the cost optimization teams policy.
  
    
### 1.2 Create an IAM Group
This group will bring together IAM users and apply the required policies.

1. While in the IAM console, select **Groups** from the left menu:
![Images/AWSIAM7.png](Images/AWSIAM7.png)

2. Click on **Create New Group**:
![Images/AWSIAM8.png](Images/AWSIAM8.png)

3. Enter a **Group Name** and click **Next Step**:
![Images/AWSIAM9.png](Images/AWSIAM9.png)

4. Click **Policy Type** and select **Customer Managed**:
![Images/AWSIAM10.png](Images/AWSIAM10.png)

5. Select the **CostOptimization_Summit** policy (created previously):
![Images/AWSIAM11.png](Images/AWSIAM11.png)

6. Click **Create Group**:
![Images/AWSIAM14.png](Images/AWSIAM14.png)


You have now successfully created the cost optimization group, and attached the required policies.


### 1.3 Create an IAM User
For this lab we will create a user and join them to the group above.

1. In the IAM console, select **Users** from the left menu:
![Images/AWSIAM15.png](Images/AWSIAM15.png)

2. Click **Add user**:
![Images/AWSIAM16.png](Images/AWSIAM16.png)

3. Enter a **User name**, select **AWS Management Console access**, choose **Custom Password**, type a suitable password, deselect **Require password reset**, and click **Next: Permissions**:
![Images/AWSIAM17.png](Images/AWSIAM17.png)

4. Select the **CostOptimization** group (created previously), and click **Next: Tags**:
![Images/AWSIAM18.png](Images/AWSIAM18.png)

5. Click **Next Review**:
![Images/AWSIAM19.png](Images/AWSIAM19.png)

6. Click **Create user**:
![Images/AWSIAM20.png](Images/AWSIAM20.png)

7. Copy the link provided, and logout by clicking on your username in the top right, and selecting **Sign Out**::
![Images/AWSIAM21.png](Images/AWSIAM21.png)

8. Log back in as the username you just created, with the link you copied for the remainder of the Lab.


You have successfully create a user, placed them in the cost optimization group and have applied policies.
You can continue to expand this group by adding additional users from your organization.


## 2. Create and implement an AWS Budget for monthly forecasted usage<a name="budget_forecast"></a> 
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



## 3. Create and implement an AWS Budget for EC2 actual cost<a name="budget_ec2actual"></a>
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


## 4. Create and implement an AWS Budget for EC2 Instance RI coverage<a name="budget_ricoverage"></a>
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
 
        

## 5. Tear down <a name="tear_down"></a>
NOTE: The cost optimization user, group and policies are required for the completion of the fundamental labs. If you remove these resources you will not be able to complete the labs. There is no tear down for this component as it is best practices to have this group created in all organizations.


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


## 6. Rate this lab<a name="rate_lab"></a> 
[![1 Star](Images/star.png)](http://dx1572sre29wk.cloudfront.net/Cost_100_2_1star) [![2 star](Images/star.png)](http://dx1572sre29wk.cloudfront.net/Cost_100_2_2star) [![3 star](Images/star.png)](http://dx1572sre29wk.cloudfront.net/Cost_100_2_3star) [![4 star](Images/star.png)](http://dx1572sre29wk.cloudfront.net/Cost_100_2_4star) [![5 star](Images/star.png)](http://dx1572sre29wk.cloudfront.net/Cost_100_2_5star) 


## 7. Survey <a name="survey"></a>
Thanks for taking the lab, We hope that you can take this short survey (<2 minutes), to share your insights and help us improve our content.

[![Survey](Images/survey.png)](https://amazonmr.au1.qualtrics.com/jfe/form/SV_9M48P1ZocaP940d)


This survey is hosted by an external company (Qualtrics) , so the link above does not lead to our website.  Please note that AWS will own the data gathered via this survey and will not share the information/results collected with survey respondents.  Your responses to this survey will be subject to Amazons Privacy Policy.
 

