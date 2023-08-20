---
title: "Modules"
#menutitle: "Modules"
date: 2020-09-07T11:16:08-04:00
chapter: false
weight: 8
hidden: false
---
#### Last Updated
October 2022

If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email:  costoptimization@amazon.com

## Data Collection Modules 


Below are the modules we have available in this lab. You can read more about them by expanding the sections. You have selected your chosen modules in the Deploy Main Resources section so no action is needed. 

{{%expand "AWS Organization Data Export" %}}

## AWS Organization Data
This module will extract the data from AWS Organizations, such as account ID, account name, organization parent and all tags. This data can be connected to your AWS Cost & Usage Report to enrich it or other modules in this lab. It is not partitioned. 

* [Test your Lambda](#testing-your-deployment) 
{{% /expand%}}

{{%expand "AWS Budgets Export" %}}
## AWS Budgets

AWS Budgets allows you to set custom budgets to track your cost and usage from the simplest to the most complex use cases. This module will export the data from all budgets so you can group together reports and combine with dashboards. This Data will be separated by type service and partitioned by year, month. This also has a saved query to create a view. 

* [Test your Lambda](#testing-your-deployment) 
{{% /expand%}}



{{%expand "Trusted Advisor" %}}

###  Trusted Advisor
This module will retrieve all AWS Trusted Advisor recommendations from all your linked account. See the **Utilize Data Section** for more information on how to use this data.
This Data will be partitioned by year, month, day. 

Once this module is deployed and TA data is collected you can visualize it with [TAO Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/). To deploy [TAO Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/) please follow either [automated](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/dashboards/3_auto_deployment/) or [manual](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/dashboards/4_manual-deployment-prepare/) deployment steps and specify organizational data collection bucket created in this lab as a source.


* [Test your Lambda](#testing-your-deployment) 

{{% notice note %}}
The AccountCollector module is reusable and only needs to be added once but multiple queues can be added too TaskQueuesUrl
{{% /notice %}}

{{% /expand%}}


{{%expand "Compute Optimizer Collector" %}}

## Compute Optimizer

The Compute Optimizer Service by default only shows current point in time recommendations looking at the past 14 days of usage. In this module, the data will be collected together so you will access to all accounts and regions recommendations in one place. This can be accessed through the Management Account. You can use the saved Athena queries as a view to query these results and track your recommendations. Also we recommend to install [Compute Optimizer Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/#comute-optimizer-dashboard) for visualizing. 

Compute Optimizer Data will be separated by type service and partitioned by year, month. 
Please make sure you enable Compute Optimizer following this [guide.](https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-compute-optimizer.html)

Compute Optimizer is regional service and the Compute Optimizer Collector will deploy one bucket for each region. The user must specify **DeployRegions** - a comma separated list of regions with EC2, EBS, ASG and Lambda workloads. If blank, the current region will be used.

![Images/Arc_compute_optimizer_data_collection.png](/Cost/300_Optimization_Data_Collection/Images/Arc_compute_optimizer_data_collection.png) 

* [Test your Lambda](#testing-your-deployment)                       
{{% notice note %}}
The AccountCollector module is reusable and only needs to be added once but multiple ques can be added too TaskQueuesUrl
{{% /notice %}}

{{% /expand%}}

{{%expand "Inventory Collector" %}}

### Inventory Collector
This module is designed to loop through your AWS Organizations account and collect data that could be used to find optimization data. It has two components, firstly the AWS accounts collector which used the management role built before. This then passes the account id into an SQS queue which then is used as an event in the next component. This section assumes a role into the account the reads the data and places into an Amazon S3 bucket in the Cost Account.  See the **Utilize Data Section** for more information on how to use this data.
This Data will be partitioned by year, month. 

* [Test your Lambda](#testing-your-deployment) 

{{% notice note %}}
The AccountCollector module is reusable and only needs to be added once but multiple queues can be added too TaskQueuesUrl
{{% /notice %}}

{{% /expand%}}

{{%expand "ECS Chargeback Data" %}}

## ECS Chargeback

This module will enable you too automated report to show costs associated with ECS Tasks leveraging EC2 instances within a Cluster. Instructions on how to use this data can be found [here.](https://github.com/aws-samples/ecs-chargeback-cloudformation) This Data will be partitioned by year, month, day. 

### Pre-Requisites  

* Completion of  Well-Architected Lab: [100_1_aws_account_setup](https://wellarchitectedlabs.com/cost/100_labs/100_1_aws_account_setup/) or similar setup of the Cost and Usage Report (CUR) with resource Id enabled
* A CUR file has been established for the existing Management/Payer account within the Billing Console
* The ECS Cluster leveraging EC2 instances for compute resides in a Linked Account connected to the Management Account through the "Consolidated Billing" option within the Billing Console
* AWS generated tag is active in Cost Allocation Tags **aws:ecs:serviceName**  this will appear in the CUR as resource_tags_aws_ecs_service_Name
* User-defined Cost Allocation Tags **Name** is active
* You will need an S3 bucket in your Analytics account to upload source files into
* Your Tasks **MUST** have the Name of the Service as a tag **Name**. This is best done with [Tag propagation](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-using-tags.html) on service **creation**, see below:

![Images/Example_output.png](/Cost/300_Optimization_Data_Collection/Images/Example_output.png)
	- Note: If you cannot re-create your task using this the see the [source/tag.py](https://github.com/aws-samples/ecs-chargeback-cloudformation/blob/main/source/tag.py)

* [Test your Lambda](#testing-your-deployment) 



{{% /expand%}}


{{%expand "RDS Utilization Data" %}}

## RDS Utilization
The module will collect RDS CloudWatch metrics from your accounts. Using this data you can identify possible underutilized instances. You can use the saved Athena query as a view to query these results and track your recommendations.
This is partitioned by TBC. 

* [Test your Lambda](#testing-your-deployment) 


{{% /expand%}}

{{%expand "Cost Explorer Rightsizing Recommendations" %}}

### Cost Explorer Rightsizing Recommendations
This module will collect rightsizing recommendations from AWS Cost Explorer in your management account. You can use the saved Athena query as a view to query these results and track your recommendations. Find out more about the recommendations [here.](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/ce-rightsizing.html)
This Data will be partitioned by year, month, day. 
* [Test your Lambda](#testing-your-deployment) 
{{% /expand%}}



{{%expand "AWS Transit Gateway Chargeback" %}}
## AWS Transit Gateway

AWS Transit Gateway allows you to connect Cloud Watch data and Cost and Usage Report data to chargeback AWS Transit Gateway charges to the usage accounts. allocating cost from central networking account. This module will get AWS Transit Gateway data transfer bytes in and bytes out for all the regions and calculate proportion of the data usage. The proportion is used to chargeback the total cost calculated at networking account level. Data will be separated by AWS Transit Gateway attachment, and partitioned by year, month. Saved queries are available to create views for dashboard. 

* [Test your Lambda](#testing-your-deployment) 
{{% /expand%}}


{{%expand "Cost Explorer Cost Anomalies Findings" %}}
### Cost Explorer Cost Anomalies Findings
This module will collect Cost Anomolies findings from AWS Cost Explorer in your management account. You can use the saved Athena query as a view to query these results and track your recommendations. Find out more about the recommendations [here.](https://docs.aws.amazon.com/cost-management/latest/userguide/manage-ad.html)
This Data will be partitioned by year, month, day. 
* [Test your Lambda](#testing-your-deployment) 
{{% /expand%}}
