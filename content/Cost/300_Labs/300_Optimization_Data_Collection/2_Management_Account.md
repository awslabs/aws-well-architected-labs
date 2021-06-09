---
title: "Management Account"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2 </b>"
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

7. Tick the box **'I acknowledge that AWS CloudFormation might create IAM resources with custom names.'** and click **Create stack**.
![Images/Tick_Box.png](/Cost/300_Optimization_Data_Collection/Images/Tick_Box.png)

8. Make a note of the IAM role ARN as we will use this in the next step by clicking on **Resources** and clicking on the hyperlink under **Physical ID**.
![Images/Managment_CF_deployed.png](/Cost/300_Optimization_Data_Collection/Images/Managment_CF_deployed.png)


{{% notice note %}}
You have now deployed the cloudformation template to build an IAM Role to allow the lambda to pull data into the Cost Optimization account. You can now test your lambda functions. 
{{% /notice %}}


{{< prev_next_button link_prev_url="../1_Main_Resources/" link_next_url="../3_Data_Collection_Template/" />}}
