---
title: "Grant permissions to your accounts in your AWS Organization"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### Permissions

To ensure Data Collection account can collect information across all accounts in the AWS Organization you must deploy  **2 IAM roles for each Management account** you wish to collect data from. (if you want to collect data from multiple payers, follow steps for each one)

The rest of this page is broken into two sets of instructions: 
1. **Role for Management Account**  - A Read Only Role WA-Lambda-Assume-Role-Management-Account must be deployed into any Management account you wish to collect data from. This allows access from your Data Collection Account to the Management account. 
2. **Read Only roles for Data Collector modules** - A second read only role WA-Optimization-Data-Multi-Account-Role must be deployed in each Linked account of the Organization via a StackSets.

### 1/2 Role for Management Account 

Some of the data needed for the modules is in the **Management account** we will now create a read only role for the Data Collector Account to assume. 

1.  Log into your **Management account** then click [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/Management.yaml)

2. Call the Stack **OptimizationManagementDataRoleStack**

3. In the Parameters section set **CostAccountID** as the ID of Data Collection Account ( where you plan to deploy the OptimizationDataCollectionStack)  

4. Scroll to the bottom and click **Next**

5. Tick the acknowledge boxes and click **Create stack**.

6. You can see the role that was collected by clicking on **Resources** and clicking on the hyperlink under **Physical ID**.
![Images/Managment_CF_deployed.png](/Cost/300_Optimization_Data_Collection/Images/Managment_CF_deployed.png)


### 2/2 Read Only roles for Data Collector modules

We will use a CloudFormation StackSet to deploy a single read only role to all accounts. Modules that we will deploy later **OptimizationDataCollectionStack** allow to collect data from all of the accounts in an AWS Organization. 

1. Login to your Management account and search for **Cloud Formation**
![Images/cloudformation.png](/Cost/300_Organization_Data_CUR_Connection/Images/cloudformation.png)

2. Click on the hamburger icon on the side panel on the left hand side of the screen and select **StackSets**. If you have not enabled this Click the button **Enable trusted access**. 
![Images/Enable_trusted_accessed.png](/Cost/300_Optimization_Data_Collection/Images/Enable_trusted_accessed.png)

3. Once Successful or if you have it enabled already click **Create StackSet**.  

4. Keep all ticked boxes as default and past he following URL in **Amazon S3 URL**. Click **Next**.

https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/optimisation_read_only_role.yaml

![Images/ods_stackset_link.png](/Cost/300_Optimization_Data_Collection/Images/ods_stackset_link.png)


5. Call the Stack **OptimizationDataRoleStack**. 
![Images/ods_stackset_name.png](/Cost/300_Optimization_Data_Collection/Images/ods_stackset_name.png)


6. In the Parameters section for **CostAccountID** use the  Account ID that where you will deploy the OptimizationDataCollectionStack. Under available modules section select modules that you need. This CloudFormation StackSet will provision required roles for modules in linked accounts. Detailed description of each module can be found [here](../3_data_collection_modules)

![Images/SS_param.png](/Cost/300_Optimization_Data_Collection/Images/SS_param.png)

7. Leave all as default and Click **Next**.

![Images/ods_stackset_config.png](/Cost/300_Optimization_Data_Collection/Images/ods_stackset_config.png)

8. Select the **region** you are currently deploying to.

![Images/ods_stackset_region.png](/Cost/300_Optimization_Data_Collection/Images/ods_stackset_region.png)

9. Tick the boxes and click **Create stack**.
![Images/Tick_Box.png](/Cost/300_Optimization_Data_Collection/Images/Tick_Box.png)

10. This role will now be deployed to all linked accounts. 


### (Optional) Read Only roles in Management Account

If you wish to also access data in your management account, deploy the same CloudFormation stack as a normal stack in your management account as you did in the **Role for Management Account** step above. 

{{%expand "To do this follow these instructions" %}}

1.  Log into your **Management account** then click [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/optimisation_read_only_role.yaml)

2. Call the Stack **OptimizationDataRoleStack**. In the Parameters section use the Cost Optimization Account ID that you deployed the OptimizationDataCollectionStack into for **CostAccountID**. Under available modules section select modules which you you selected in **OptimizationDataCollectionStack** deployment step. This CloudFormation StackSet will provision required roles for modules in linked accounts. Detailed description of each module can be found [here](../3_data_collection_modules)

4. Scroll to the bottom and click **Next**

5. Tick the box **'I acknowledge that AWS CloudFormation might create IAM resources with custom names.'** and click **Create stack**.
![Images/Tick_Box.png](/Cost/300_Optimization_Data_Collection/Images/Tick_Box.png)


{{% /expand%}}

{{< prev_next_button link_prev_url="../" link_next_url="../2_deploy_main_resources" />}}