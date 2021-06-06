---
title: "Management Account"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3 </b>"
---

### Role for Management Account

As some of the data needed for these module is in the Management account we need a role to assume into that account. 


1. **Download CloudFormation** by clicking [here.](/Cost/300_Optimization_Data_Collection/Code/Management.yaml) 

2. Login via SSO in your Management account and search for **Cloud Formation**
![Images/cloudformation.png](/Cost/300_Organization_Data_CUR_Connection/Images/cloudformation.png)

3. On the right side of the screen select **Create stack** and choose **With new resources (standard)**
![Images/create_stack.png](/Cost/300_Organization_Data_CUR_Connection/Images/create_stack.png)

4. Choose **Template is ready** and **Upload a template file** and upload the main.yaml file you downloaded from above. Click **Next**.
![Images/upload_template.png](/Cost/300_Organization_Data_CUR_Connection/Images/upload_template.png)

5. In the Parameters section use the account ID you deployed the main.yaml file into for **CostAccountID**

6. Call the Stack **OptimizationDataRoleStack**



{{% notice tip %}}
You have now deployed the cloudformation template to build an IAM Role to allow the lambda to pull data into the Cost Optimization account. You can now test your lambda functions. 
{{% /notice %}}


{{< prev_next_button link_prev_url="../2_Data_Collection_Template/" link_next_url="../4_Data_Collection_Cloud_Formation_Modules/" />}}
