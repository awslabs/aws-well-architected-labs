---
title: "Deploy core infrastructure for data retrieval"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

### Create Main Resources

The first step is to create a set of reusable resources and respective data collection modules. 


1.  Click [Launch CloudFormation template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/Optimization_Data_Collector.yaml) if you are deploying to your Cost Optimization linked account (recommended)

Or if you wish to keep this on your local machine please copy [CloudFormation template](https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/Optimization_Data_Collector.yaml) locally and deploy with your preferred method of choice:

2. Click **Next**.
![Images/upload_templates3.png](/Cost/300_Optimization_Data_Collection/Images/upload_templates3.png)

3. Call the stack **OptimizationDataCollectionStack** and fill Deployment parameters. The Role mentioned in **Multi Account Role Name** parameter will be deployed in the next step.
 Select the **Code bucket** for the region you are deploying in and fill **Management Account Id**. You have the option to change the name of your access roles, if you do please make the same changes in the **Role for Management Account** and the  **Read Only roles for Data Collector** deployments.
 
 Under available modules section select modules which you would like to deploy. Detailed description of each module can be found [here](../3_data_collection_modules)
 Click **Next** and **Next again**
![Images/Main_CF_Parameters.png](/Cost/300_Optimization_Data_Collection/Images/Main_CF_Parameters.png)

When selecting Compute Optimizer module provide additionally a comma separted list of regions where need to collect Compute Optimizer data. Make sure you have a right to deploy S3 buckets in these regions.

4. Tick the boxes and click **Create stack**.
![Images/Tick_Box.png](/Cost/300_Optimization_Data_Collection/Images/Tick_Box.png)

5. Wait until your CloudFormation has a status of **CREATE_COMPLETE**.
![Images/Main_CF_Deployed.png](/Cost/300_Optimization_Data_Collection/Images/Main_CF_Deployed.png)

{{%expand "Troubleshooting" %}}

### Troubleshooting

If you see the an issue with stack creation please check the status of nested stacks, including StackSets created by Compute Optimizer module. In case of rollback these StackSets will disappear. 

{{% /expand%}}

{{< prev_next_button link_prev_url="../1_grant_permissions/" link_next_url="../3_data_collection_modules" />}}
