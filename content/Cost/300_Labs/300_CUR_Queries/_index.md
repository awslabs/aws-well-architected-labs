---
title: "Level 300: AWS CUR Query Library"
#menutitle: "Lab #1"
date: 2020-08-24T11:16:08-04:00
chapter: false
weight: 3
hidden: false
---

## Last Updated

November 2022

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: curquery@amazon.com

## Introduction
{{< rawhtml >}}
 <meta name="author" content="Chris Strzelczyk"Bill Pfeiffer>
<video width="500" height="308" controls poster="/Cost/300_CUR_Queries/Images/cost-300-cql-intro.png">
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Cost/Videos/CURQueryLibraryIntroduction.mp4" type="video/mp4">
  Your browser doesn't support video, or if you're on GitHub head to https://wellarchitectedlabs.com to watch the video.
</video>
{{< /rawhtml >}}

 The CUR Query Library is a collection of curated SQL queries to get you started with analyzing your Cost and Usage Report (CUR) data.  Cost analysis is unique to each business and these queries are intended to be modified to suit your specific needs.  The library will be updated periodically as we build new queries and receive feedback from customers.

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}


## Query Help
{{< rawhtml >}}
<meta name="author" content="Bill Pfeiffer">
<video width="500" height="308" controls poster="/Cost/300_CUR_Queries/Images/cost-300-cql-helper-intro.png">
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Cost/Videos/HelperIntroductionVideoFinal.mp4" type="video/mp4">
  Your browser doesn't support video, or if you're on GitHub head to https://wellarchitectedlabs.com to watch the video.
</video>
{{< /rawhtml >}}

The CUR Query Library Help section is intended to provide tips and information about navigating the CUR dataset.  We will cover beginner topics like getting started with querying the CUR, filtering query results, common query format, links to public documentation, and retrieving product information.  We will also cover advanced topics like understanding your AWS Cost Datasets while working with the CUR data.  

[CUR Library Query Help]({{< ref "query_help/" >}} "CUR Library Query Help")

## Queries
[Analytics]({{< ref "Queries/analytics.md" >}} "Analytics")

[Application Integration]({{< ref "Queries/application_integration.md" >}} "Application Integration")

[AWS Cost Management]({{< ref "Queries/aws_cost_management.md" >}} "AWS Cost Management")

[Compute]({{< ref "Queries/compute.md" >}} "Compute")

[Container]({{< ref "Queries/container.md" >}} "Container")

[Cost Efficiency]({{< ref "Queries/cost_efficiency.md" >}} "Cost Efficiency")

[Cost Optimization]({{< ref "Queries/cost_optimization.md" >}} "Cost Optimization")

[Customer Engagement]({{< ref "Queries/customer_engagement.md" >}} "Customer Engagement")

[Database]({{< ref "Queries/database.md" >}} "Database")

[Developer Tools]({{< ref "Queries/developer_tools.md" >}} "Developer Tools") 

[End User Computing]({{< ref "Queries/end_user_computing.md" >}} "End User Computing")

[Global]({{< ref "Queries/global.md" >}} "Global")

[Machine Learning]({{< ref "Queries/machine_learning.md" >}} "Machine Learning")

[Management & Governance]({{< ref "Queries/management_&_governance.md" >}} "Management & Governance")

[Networking & Content Delivery]({{< ref "Queries/networking_&_content_delivery.md" >}} "Networking & Content Delivery")

[Security Identity & Compliance]({{< ref "Queries/security_identity_&_compliance.md" >}} "Security Identity & Compliance")

[Storage]({{< ref "Queries/storage.md" >}} "Storage")


## Prerequisites
- An AWS Account
- Completed the [AWS Account Setup lab]({{< ref "/Cost/100_labs/100_1_aws_account_setup">}})
- Completed the [Cost and Usage Analysis lab]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}})
- Usage in your AWS account

## Contributing

Community contributions are encouraged and welcome.  Please follow the [Contribution Guide]({{< ref "/Cost/300_labs/300_CUR_Queries/Query_Help/contribution-guide.md" >}}). The goal is to pull together useful CUR queries in to a single library that is open, standardized, and maintained.

## Contributors
Please refer to the [CUR Query Library Contributors section]({{< ref "/Cost/300_labs/300_CUR_Queries/Query_Help/contributors.md" >}}).
