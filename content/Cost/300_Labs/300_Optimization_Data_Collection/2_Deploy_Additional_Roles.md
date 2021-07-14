---
title: "Grant permissions to your accounts in your AWS Organization"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

### Role for Management Account

As some of the data needed for these module is in the **Management account** we need a read only role to assume into that account. 

1.  Log into your Management account then click [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/Management.yaml)

2. Call the Stack **OptimizationManagementDataRoleStack**

3. In the Parameters section use the Cost Optimization Account ID that you deployed the main template into for **CostAccountID** 

4. Scroll to the bottom and click **Next**

5. Tick the box **'I acknowledge that AWS CloudFormation might create IAM resources with custom names.'** and click **Create stack**.
![Images/Tick_Box.png](/Cost/300_Optimization_Data_Collection/Images/Tick_Box.png)

6. Make a note of the IAM role ARN as we will use this in the next step by clicking on **Resources** and clicking on the hyperlink under **Physical ID**.
![Images/Managment_CF_deployed.png](/Cost/300_Optimization_Data_Collection/Images/Managment_CF_deployed.png)



### Role for Read Only Data Collector

As some of the data needed for these module is in all of the accounts in an AWS Organization we will use a CloudFormation StackSet to deploy a single read only role to all account which we can use. 
If you already have a role which can read into your accounts then please skip this section and use this as your **MultiAccountRoleName** parameter later. 

1. **Download CloudFormation** by clicking [here.](/Cost/300_Optimization_Data_Collection/Code/optimisation_read_only_role.yaml) This will be the foundation of the rest of the lab and we will add to this to build out the modules so please **store somewhere safely**.

2. Login via SSO in your Management account and search for **Cloud Formation**
![Images/cloudformation.png](/Cost/300_Organization_Data_CUR_Connection/Images/cloudformation.png)

3. Click on the hamburger icon on the side panel on the left hand side of the screen and select **StackSets**. If you have not enabled this Click the button **Enable trusted access**. 
![Images/Enable_trusted_accessed.png](/Cost/300_Optimization_Data_Collection/Images/Enable_trusted_accessed.png)

4. Once Successful or if you have it enabled already click **Create StackSet**.  

5. Choose **Template is ready** and **Upload a template file** and upload the optimisation_read_only_role.yaml file you downloaded from above. Click **Next**.

6. Call the Stack **OptimizationDataRoleStack**. In the Parameters section use the Cost Optimization Account ID that you deployed the main template into for **CostAccountID**
![Images/SS_param.png](/Cost/300_Optimization_Data_Collection/Images/SS_param.png)

7. Leave all as default and Click **Next**.

![Images/SS_permission.png](/Cost/300_Optimization_Data_Collection/Images/SS_permission.png)

8. Select **Deploy to accounts** into then scroll down and Click **Next**.
![Images/SS_account.png](/Cost/300_Optimization_Data_Collection/Images/SS_account.png)

9. Tick the box **'I acknowledge that AWS CloudFormation might create IAM resources with custom names.'** and click **Create stack**.
![Images/Tick_Box.png](/Cost/300_Optimization_Data_Collection/Images/Tick_Box.png)

10. This role will now be deployed to all linked accounts. If you wish to also access data in your management account. Deploy the same CloudFormation stack as a normal stack in your management account as you did in the **Role for Management Account** step above. 

{{% notice tip %}}
Note this role will not be deployed into the management account so if you wish to read data from this account too, deploy as a normal cloudformation stack. 
{{% /notice %}}


{{< prev_next_button link_prev_url="../1_Main_Resources/" link_next_url="../3_Data_Collection_Cloud_Formation_Modules/" />}}
