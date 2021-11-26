---
title: "Deploy core infrastructure for data retrieval"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### Create Reusable Resource

The first step is to create a set of reusable resources and respective data collection modules. 


1.  Click [Launch CloudFormation template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/Optimization_Data_Collector.yaml) if you are deploying to your Cost Optimization linked account (recommended)

Or if you wish to keep this on your local machine please copy [CloudFormation template](https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/Optimization_Data_Collector.yaml) locally and deploy with your preferred method of choice:

{{% notice note %}}
For the CodeBucket Parameter, if deploying in Oregon leave as CodeBucket: aws-well-architected-labs
{{% /notice %}}

2. Click **Next**.
![Images/upload_templates3.png](/Cost/300_Optimization_Data_Collection/Images/upload_templates3.png)

3. Call the stack **OptimizationDataCollectionStack** and fill Deployment parameters. The Role mentioned in **Multi Account Role Name** parameter will be deployed in the next step.
 Select the **Code bucket** for the region you are deploying in and fill **Management account Id**. You have the option to change the name of your access roles, if you do please make the same changes in the other deployments.
 Under available modules section select modules which you would like to deploy. Detailed description of each module can be found [here](../3_data_collection_modules)
 Click **Next** and **Next again**
![Images/Main_CF_Parameters.png](/Cost/300_Optimization_Data_Collection/Images/Main_CF_Parameters.png)

4. Tick the box **'I acknowledge that AWS CloudFormation might create IAM resources with custom names.'** and click **Create stack**.
![Images/Tick_Box.png](/Cost/300_Optimization_Data_Collection/Images/Tick_Box.png)

5. Wait until your CloudFormation has a status of **CREATE_COMPLETE**.
![Images/Main_CF_Deployed.png](/Cost/300_Optimization_Data_Collection/Images/Main_CF_Deployed.png)

{{< prev_next_button link_prev_url="../" link_next_url="../2_deploy_additional_roles" />}}