---
title: "Level 200: Cloud Intelligence Dashboards"
#menutitle: "CID Lab"
date: 2020-10-10T11:16:08-04:00
chapter: false
weight: 10
hidden: false
---
## Last Updated
December 2022

{{% notice tip %}}
This Well Architected lab is a consolidation of labs and AWS workshops formerly called Enterprise Dashboards, CUDOS Workshop, and the TAO Workshop. 
{{% /notice %}}


## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: cloud-intelligence-dashboards@amazon.com

## Get Help
[Ask your questions](https://repost.aws/tags/TANKNkVH-tSUa2jYNx4F159g/cloud-intelligence-dashboards) on re:Post and get answers from our team, other AWS experts, and other customers using the dashboards. 

[Subscribe to our YouTube channel](https://www.youtube.com/channel/UCl0O3ASMCwA_gw0QIKzoU3Q/) to see guides, tutorials, and walkthroughs on all things Cloud Intelligence Dashboards. 

## Leadership
The Cloud Intelligence Dashboards are managed by:
- Yuriy Prykhodko, AWS Principal Technical Account Manager (founder)
- Iakov Gan, AWS Sr. Technical Account Manager

## Introduction
Do you know how much you’re spending per hour on AWS Lambda? How about per S3 bucket? How do you know buying Savings Plan or using Spot Instances is saving you money? Does your team know how much their application costs to run on AWS? Visualizing and understanding your cost and usage data is critical to good cloud financial management and accountability.

Cloud Financial Management (CFM) is the practice of bringing financial accountability to the variable spend model of cloud. CFM practitioners are pursuing business efficiency across all of their accounts by first visualizing their cost and usage, then setting goals, and finally driving accountability from their IT teams to meet or exceed these goals. 

Cloud infrastructure provides more agility and responsiveness than traditional IT environments. This requires organizations to think differently about how they design, build, and manage applications.

Cloud resources are disposable, and with a pay-per-use model it requires a strong integration between IT governance and organizational governance. Builders need to be able to operate in a cloud environment that’s agile and safe at the same time.

This Well Architected lab will walk you through implementing a series of dashboards for all of your AWS accounts that will help you drive financial accountability, optimize cost, track usage goals, implement best-practices for governance, and achieve operational excellence. 

![Images/CIDframework.png](/Cost/200_Cloud_Intelligence/Images/CIDframework.png?classes=lab_picture_small)

## Overview 
In this lab, you will find step-by-step guides on how to implement some or all of the foundational Cloud Intelligence Dashboards as well as additional dashboards.
- [Last Updated](#last-updated)
- [Feedback](#feedback)
- [Get Help](#get-help)
- [Leadership](#leadership)
- [Introduction](#introduction)
- [Cloud Intelligence Dashboards](#cloud-intelligence-dashboards)
	- [Overview](#overview)
- [Cost Intelligence Dashboard (CID)](#cost-intelligence-dashboard-cid)
	- [Authors](#authors)
	- [Contributors](#contributors)
- [CUDOS Dashboard](#cudos-dashboard)
	- [Authors](#authors-1)
- [Trusted Advisor Organizational (TAO) Dashboard](#trusted-advisor-organizational-tao-dashboard)
- [KPI Dashboard](#kpi-dashboard)
	- [Authors](#authors-2)
	- [Contributors](#contributors-1)
- [Compute Optimizer Dashboard (COD)](#compute-optimizer-dashboard-cod)
- [Additional Dashboards](#additional-dashboards)
- [Steps:](#steps)
- [Authors](#authors-3)
- [Contributors](#contributors-2)

The Cloud Intelligence Dashboards include (but are not limited to) the following benefits:

 - **Easy to Use** 
	 - All insights in plain language 
	 - Organized by services 
	 - Includes high level overviews 
- **Secure**
	- Supports IAM
	- No agents running anywhere
	- Data stays in your organizations
	- Uses all AWS native services
- **In Depth**
	- 100s of pre-built visuals
	- Resource level granularity
	- Fully customizable
	- Machine Learning driven Insights
- **Cost Efficient**
	- Amazing QuickSight Enterprise licenses start at $18 per month
	- Serverless so only pay as you go
	


## Cost Intelligence Dashboard (CID)

#### Authors
- Alee Whitman, Sr. Commercial Architect (AWS OPTICS)

#### Contributors 
- Arun Santhosh, Specialist SA (Amazon QuickSight)
- Kareem Syed-Mohammed, Senior Product Manager - Technical (Amazon QuickSight)
- Aaron Edell, Global Head of Business - Cloud Intelligence Dashboards
- Timur Tulyaganov, AWS Principal Technical Account Manager
- Yuriy Prykhodko, AWS Principal Technical Account Manager
- Aidin Khosrowshahi, AWS Sr. Technical Account Manager

{{< rawhtml >}}
<video width="600" height="450" controls>
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Cost/Videos/DashboardCostIntelligence.mp4" type="video/mp4">
  Your browser doesn't support video, or if you're on GitHub head to https://wellarchitectedlabs.com to watch the video.
</video>
{{< /rawhtml >}}

The Cost Intelligence Dashboard is a customizable and accessible dashboard to help create the foundation of your own cost management and optimization (FinOps) tool. Executives, directors, and other individuals within the CFO's line of business or who manage cloud financials for an organization will find the Cloud Intelligence Dashboard easy to use and relevant to their use cases. Little to no technical knowledge or understanding of AWS Services is required. Out-of-the-box benefits of the CID include (but are not limited to):

* Create chargeback or showback reports for internal business units, accounts, or cost centers.
* Track how Savings Plans (SP), Reserved Instances (RI), and Spot Instance usage has impacted your unit metrics such as your average hourly cost of Amazon EC2.
* Keep track of which accounts or internal business units receive savings and when RIs and SPs expire.  

**Services used:** AWS Cost and Usage Report (CUR), Amazon Athena, AWS Glue, Amazon S3, and Amazon QuickSight. 

- [Explore a sample Cost Intelligence Dashboard](https://d1s0yx3p3y3rah.cloudfront.net/anonymous-embed?dashboard=cid) 

## CUDOS Dashboard

#### Authors

- Timur Tulyaganov, AWS Principal Technical Account Manager
- Yuriy Prykhodko, AWS Principal Technical Account Manager

The CUDOS Dashboard is an in-depth, granular, and recommendation-driven dashboard to help customers dive deep into cost and usage and to fine-tune efficiency. Executives, directors, and other individuals within the CIO or CTO line of business or who manage DevOps and IT organizations will find the CUDOS Dashboard highly detailed and tailored to solve their use cases. Out-of-the-box benefits of the CUDOS dashboard include (but are not limited to):

* Use the built-in tag explorer to group and filter cost and usage by your tags.
* View resource-level detail such as your hourly AWS Lambda or individual Amazon S3 bucket costs.
* Get alerted to service-level areas of focus such as top 3 On-Demand database instances by cost.

**Services used:** AWS Cost and Usage Report (CUR), Amazon Athena, AWS Glue, Amazon S3, and Amazon QuickSight. 

- [Explore a sample CUDOS Dashboard](https://d1s0yx3p3y3rah.cloudfront.net/anonymous-embed?dashboard=cudos) 

## Trusted Advisor Organizational (TAO) Dashboard

Amazon Trusted Advisor helps you optimize your AWS infrastructure, improve security and performance, reduce overall costs, and monitors service limits. Organizational view lets you view Trusted Advisor checks for all accounts in your AWS Organizations. The only way to visualize the organizational view is to use the TAO dashboard. The TAO dashboard is a set of visualizations that provide comprehensive details and trends across your entire AWS Organization. Out-of-the-box benefits of the TAO dashboard include (but are not limited to):


* Quickly locate accounts that haven't rotated their AWS IAM keys.
* Find then sort unutilized and underutilized resources by cost or account.
* See a list of accounts that have reached 80% of individual service limits.

**Services used:** AWS Trusted Advisor, AWS Trusted Advisor Organizational report, Amazon Athena, AWS Glue, Amazon S3, and Amazon QuickSight.

{{% notice note %}}
Trusted Advisor Organizational (TAO) requires the management account in your organization to have Business or Enterprise support plan and enabled organizational view. [Click to learn more](https://docs.aws.amazon.com/awssupport/latest/user/organizational-view.html)
{{% /notice %}}

- [Explore a sample TAO Dashboard](https://d1s0yx3p3y3rah.cloudfront.net/anonymous-embed?dashboard=tao) 

## KPI Dashboard

#### Authors
- Alee Whitman, Sr. Commercial Architect (AWS OPTICS)

#### Contributors 
- Aaron Edell, Global Head of Business - Cloud Intelligence Dashboards
- Alex Head, OPTICS Manager 
- Georgios Rozakis, AWS Technical Account Manager
- Oleksandr Moskalenko, Sr. AWS Technical Account Manager
- Timur Tulyaganov, AWS Principal Technical Account Manager
- Yash Bindlish, AWS Technical Account Manager
- Yuriy Prykhodko, AWS Principal Technical Account Manager

The KPI and Modernization Dashboard helps your organization combine DevOps and IT infrastructure with Finance and the C-Suite to grow more efficiently and effectively on AWS. This dashboard lets you set and track modernization and optimization goals such as percent OnDemand, Spot adoption, and Graviton usage. By enabling every line of business to create and track usage goals, and your cloud center of excellence to make recommendations organization-wide, you can grow more efficiently and innovate more quickly on AWS. Out-of-the-box benefits of the KPI dashboard include (but are not limited to):

* Track percent on-demand across all your teams.
* See potential cost savings by meeting certain KPIs and goals for your organization.
* Quickly locate cost-optimization opportunities such as infrequently used S3 buckets, old EBS snapshots, and Graviton eligible instance usage.

**Services used:** AWS Cost and Usage Report (CUR), Amazon Athena, AWS Glue, Amazon S3, and Amazon QuickSight. 

- [Explore a sample KPI Dashboard](https://d1s0yx3p3y3rah.cloudfront.net/anonymous-embed?dashboard=kpi)


## Compute Optimizer Dashboard (COD)
This dashboard helps your organization to visualize and trace right sizing recommendations from AWS Compute Optimizer. These recommendations will help you indentify Cost savings opportunities for over provisioned resources and also see the Operational risk from under provisioned ones.

**Services used:** AWS Compute Optimizer, Amazon Athena, AWS Glue, Amazon S3, and Amazon QuickSight. 

- [Explore a sample Compute Optimizer Dashboard](https://d1s0yx3p3y3rah.cloudfront.net/anonymous-embed?dashboard=compute-optimizer-dashboard)

#### Authors
- Iakov Gan, Sr. Techical Account Manager


## Additional Dashboards
In addition to the 3 foundational dashboards, there are additional dashboards you can leverage to gain deeper insights into your cost and usage.   

* Data Transfer Dashboard 
* Trends Dashboard

**Services used:** AWS Cost and Usage Report (CUR), Amazon Athena, AWS Glue, Amazon S3, and Amazon QuickSight. 


#### Steps:
- [Get started with the Cost and Usage Dashboards](cost-usage-report-dashboards/)
- [Get started with the TAO Dashboard](trusted-advisor-dashboards/)
- [Get started with the Compute Optimizer Dashboard](compute-optimizer-dashboards/)

#### Authors

- Aaron Edell, Global Head of Business and GTM (Cloud Intelligence Dashboards)
- Alee Whitman, Sr. Commercial Architect (AWS OPTICS)
- Timur Tulyaganov, AWS Principal Technical Account Manager
- Yuriy Prykhodko, AWS Principal Technical Account Manager
- Iakov Gan, Senior Technical Account Manager

#### Contributors
- Arun Santhosh, Specialist SA (Amazon QuickSight)
- Alex Head, OPTICS Manager 
- Barry Miller, Technical Account Manager
- Chaitanya Shah, Sr. Technical Account Manager
- Cristian Popa, Sr. Technical Account Manager
- Kareem Syed-Mohammed, Senior Product Manager - Technical (Amazon QuickSight)
- Lakhvinder Singh Gill, Enterprise Support Lead
- Manik Chopra, Principal Technical Account Manager
- Meredith Holborn, Technical Account Manager
- Nisha Notani, Sr. Technical Account Manager
- Oleksandr Moskalenko, Sr. Technical Account Manager
- William Hughes, Sr. Solutions Architect
- Thomas Buatois, Cloud Infrastructure Architect
- Stephanie Gooch, Sr. Commercial Architect, AWS OPTICS
- Veaceslav Mindru, Sr. Technical Account Manager, AWS
---

{{< prev_next_button link_next_url="./cost-usage-report-dashboards/" button_next_text="Next" first_step="true" />}}
