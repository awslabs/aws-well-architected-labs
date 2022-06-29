---
title: "Compute Optimizer Dashboard (COD)"
#menutitle: "Lab #2"
date: 2020-09-07T11:16:08-04:00
chapter: false
weight: 3
hidden: false
pre: "<b> </b>"
---
## Last Updated

May 2022

## Authors

+ Iakov Gan, Senior Technical Account Manager, EMEA
+ Yuriy Prykhodko, Senior Technical Account Manager, EMEA
+ Timur Tulyaganov, Principal Technical Account Manager, EMEA


## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: cloud-intelligence-dashboards@amazon.com

## Get Help
[Ask your questions](https://0s62bmu3aj.execute-api.us-east-1.amazonaws.com/PROD/link/tracker?LinkID=270894ed-12b6-27bc-74f3-124130ceb403&URL=https%3A%2F%2Frepost.aws%2Ftags%2FTANKNkVH-tSUa2jYNx4F159g%2Fcloud-intelligence-dashboards) on re:Post and get answers from our team, other AWS experts, and other customers using the dashboards. 

[Subscribe to our YouTube channel](https://www.youtube.com/channel/UCl0O3ASMCwA_gw0QIKzoU3Q/) to see guides, tutorials, and walkthroughs on all things Cloud Intelligence Dashboards. 


## Introduction
AWS Compute Optimizer recommends optimal AWS resources for your workloads to reduce costs and improve performance by using machine learning to analyze historical utilization metrics. Compute Optimizer Dashboard lets you view cost optimization and risk reduction opportunities for all accounts in your AWS Organizations across all AWS Regions. Out-of-the-box benefits of the COD include (but are not limited to):

* Find over and underutilized resources (EC2, AutoScaling Groups, EBS, Lambda).
* Get right-sizing recommendations.
* Identify potential savings across all payer accounts and regions.
* Track optimization progress over time by AWS Account team or business unit.

See also:
- A basics of Compute Optimizer Right Sizing in a lab [200 Rightsizing with Compute Optimizer](/Cost/200_labs/200_aws_resource_optimization)
- [AWS Compute Optimizer FAQ](https://aws.amazon.com/compute-optimizer/faqs/)


## Demo Dashboard


![Images](/Cost/200_Cloud_Intelligence/Images/cod/demo.png)

Get more familiar with Dashboard using the live, interactive demo dashboard following this [link](https://d1s0yx3p3y3rah.cloudfront.net/anonymous-embed?dashboard=compute-optimizer-dashboard)


{{% notice note %}}
These dashboards and their content: (a) are for informational purposes only, (b) represents current AWS product offerings and practices, which are subject to change without notice, and (c) does not create any commitments or assurances from AWS and its affiliates, suppliers or licensors. AWS content, products or services are provided “as is” without warranties, representations, or conditions of any kind, whether express or implied. The responsibilities and liabilities of AWS to its customers are controlled by AWS agreements, and this document is not part of, nor does it modify, any agreement between AWS and its customers.
{{% /notice %}}

## Goals

- Create Compute Optimization Dashboard
- Share the dashboard in your organization

## Permissions

This workshop can be deployed by any user who has permission to access the **AWS Compute Optimizer, S3, Athena, Glue and QuickSight**.

## Costs 

- A QuickSight Enterprise license starts at $18 per month. 
- Incremental costs associated with AWS Glue, Amazon Athena, and Amazon S3. 
- Estimated total cost for all Dashboards together in a large AWS deployment is $54 per month. 



## Time to Complete

+ **Pre-requisites**: Should take approximately 15 minutes to complete
+ **Installation**: Should take approximately 60 minutes to complete

## Steps:
{{% children  /%}}

{{< prev_next_button link_next_url="./dashboards/1_prerequisites/" button_next_text="Start Lab" first_step="true" />}}
