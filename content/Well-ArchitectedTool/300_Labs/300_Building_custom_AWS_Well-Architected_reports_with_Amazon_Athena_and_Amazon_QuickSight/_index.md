---
title: "Build custom reports of AWS Well-Architected Reviews"
#menutitle: "Lab #1"
date: 2021-03-24T15:16:08+10:00
chapter: false
weight: 4
---
## Authors
- Tom McMeekin, Solutions Architect

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: tommcm@amazon.com

## Introduction
You can use the [AWS Well-Architected Tool](https://aws.amazon.com/well-architected-tool) (AWS WA Tool) to review the state of your workloads and compare them to the latest AWS architectural best practices. Its API allows customers, ISVs, and AWS Partner Network to extend AWS Well-Architected functionality, best practices, measurements, and lessons learned into their existing architecture governance processes, applications, and workflows.

By building your own integrations with the AWS WA Tool, your enterprise can support a range of use cases, such as integrating AWS Well-Architected data into centralized reporting tools or ticketing and management solutions. The API can also be used to create automation for specific use cases.

This lab presents a simple approach for aggregating the data of the workload reviews into a central data lake repository. It helps teams to analyze their organization's Well-Architected maturity across multiple AWS accounts and workloads and perform centralized reporting on high-risk issues (HRIs).

![DashboardExample](/Well-ArchitectedTool/300_Labs/300_Building_custom_AWS_Well-Architected_reports_with_Amazon_Athena_and_Amazon_QuickSight/Images/fig-12-dashboard-example.png)

## Architecture overview

Many customers use multiple AWS accounts to provide administrative autonomy for their teams. The AWS WA Tool offers a simple way to share workloads with other AWS accounts. You can share a workload that you own in your account with AWS accounts used by other members of your review team or with a centralized AWS account.  For more information, see [sharing a Workload](https://docs.aws.amazon.com/wellarchitected/latest/userguide/workloads-sharing.html).

![Architecture diagram with data flow steps (1-4) described in the post.](/Well-ArchitectedTool/300_Labs/300_Building_custom_AWS_Well-Architected_reports_with_Amazon_Athena_and_Amazon_QuickSight/Images/fig-1-architecture-diagram.png)

1.  After workloads are defined in the AWS WA Tool, [AWS Lambda](https://aws.amazon.com/lambda/) can poll the AWS Well-Architected Tool API to extract the raw data and store it in an [Amazon Simple Storage Service](https://aws.amazon.com/s3/) (Amazon S3) bucket.
2.  [AWS Glue](https://aws.amazon.com/glue) crawlers are used to discover schema and store it in the AWS Glue Data Catalog.
3.  [Amazon Athena](https://aws.amazon.com/athena) is then used for data preparation tasks like building views of the workload report data.
4.  [Amazon QuickSight](https://aws.amazon.com/quicksight/) can now query and build visualizations to discover insights into your Well-Architected Reviews.

This pattern can extend the visibility of HRIs identified in the AWS WA Tool to enable custom visualizations and more insights. The central management account would typically be managed by a Cloud Center of Excellence (CCoE) team, who can advise and act on emerging HRIs across their entire AWS application portfolio.

## Goals
- Automatically extract Well-Architected workload data via the API 
- Query and visualise the extracted Well-Architected workload data using Amazon QuickSight


## Prerequisites
-   Define and document a workload in the AWS WA Tool. For better understanding, refer to [AWS documentation.](https://docs.aws.amazon.com/wellarchitected/latest/userguide/define-workload.html)
-   Create or use an existing S3 bucket where you will store the extracted AWS Well-Architected data.

## Permissions required
- Create IAM policies and roles
- Create and modify S3 Buckets, including policies and events
- Create and modify Lambda functions
- Modify CloudFormation templates
- Create, save and execute Athena queries
- Create and run a Glue crawler
- Create and publish QuickSight dashboards

## Steps:
{{% children  /%}}

{{< prev_next_button link_next_url="./1_etl_wa_workload_data/" button_next_text="Start Lab" first_step="true" />}}