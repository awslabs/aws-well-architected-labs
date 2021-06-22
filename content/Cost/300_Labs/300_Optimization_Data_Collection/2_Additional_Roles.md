---
title: "Additional Roles"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2 </b>"
---

### Role for Management Account

As some of the data needed for these module is in the Management account we need a role to assume into that account. 


1. Login via SSO in your Management account
![Images/cloudformation.png](/Cost/300_Organization_Data_CUR_Connection/Images/cloudformation.png)

2. **Download CloudFormation** by clicking [here.](/Cost/300_Optimization_Data_Collection/Code/Management.yaml) This will be added to when you require additional permissions to your Management account so please **store somewhere safely**.

3. Call the Stack **OptimizationManagementDataRoleStack**

4. In the Parameters section use the Cost Optimization Account ID that you deployed the main.yaml file into for **CostAccountID** 

5. Scroll to the bottom and click **Next**

6. Tick the box **'I acknowledge that AWS CloudFormation might create IAM resources with custom names.'** and click **Create stack**.
![Images/Tick_Box.png](/Cost/300_Optimization_Data_Collection/Images/Tick_Box.png)

7. Make a note of the IAM role ARN as we will use this in the next step by clicking on **Resources** and clicking on the hyperlink under **Physical ID**.
![Images/Managment_CF_deployed.png](/Cost/300_Optimization_Data_Collection/Images/Managment_CF_deployed.png)

{{% notice note %}}
You will need to keep your Management.yaml file to add permissions to later so please store somewhere safely
{{% /notice %}}



### Role for Read Only Data Collector

As some of the data needed for these module is in all of the accounts in an AWS Organization we will use a CloudFormation StackSet to deploy a single role to all account which we can use. 
If you already have a role which can read into your accounts then please skip this section and use this as your **MultiAccountRoleName** parameter later. 

1. **Download CloudFormation** by clicking [here.](/Cost/300_Optimization_Data_Collection/Code/optimisation_read_only_role.yaml) This will be the foundation of the rest of the lab and we will add to this to build out the modules so please **store somewhere safely**.

2. Login via SSO in your Management account and search for **Cloud Formation**
![Images/cloudformation.png](/Cost/300_Organization_Data_CUR_Connection/Images/cloudformation.png)

3. Click on the hamburger icon on the side panel on the left hand side of the screen and select **StackSets**. If you have not enabled this Click the button **Enable trusted access**. 
![Images/Enable_trusted_accessed.png](/Cost/300_Optimization_Data_Collection/Images/Enable_trusted_accessed.png)

4. Once Successful or if you have it enabled already click **Create StackSet**.  

5. Choose **Template is ready** and **Upload a template file** and upload the optimisation_read_only_role.yaml file you downloaded from above. Click **Next**.

6. Call the Stack **OptimizationDataRoleStack**. In the Parameters section use the Cost Optimization Account ID that you deployed the main.yaml file into for **CostAccountID**
![Images/SS_param.png](/Cost/300_Optimization_Data_Collection/Images/SS_param.png)

7. Leave all as default and Click **Next**.

![Images/SS_permission.png](/Cost/300_Optimization_Data_Collection/Images/SS_permission.png)

8. Select **Deploy to accounts** into then scroll down and Click **Next**.
![Images/SS_account.png](/Cost/300_Optimization_Data_Collection/Images/SS_account.png)

9. Tick the box **'I acknowledge that AWS CloudFormation might create IAM resources with custom names.'** and click **Create stack**.
![Images/Tick_Box.png](/Cost/300_Optimization_Data_Collection/Images/Tick_Box.png)

{{% notice note %}}
You will need to keep your optimisation_read_only_role.yaml file to add permissions to later so please store somewhere safely
{{% /notice %}}


{{< prev_next_button link_prev_url="../1_Main_Resources/" link_next_url="../3_Data_Collection_Cloud_Formation_Modules/" />}}
