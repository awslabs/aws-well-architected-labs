+++
title = "Expenditure Awareness"
date = 2020-04-20T22:31:40-04:00
weight = 2
chapter = false
pre = ""
+++

## About expenditure awareness

The capability to attribute resource costs to the individual organization or product owners drives efficient usage behavior and helps reduce waste. Accurate cost attribution allows you to know which products are truly profitable, and allows you to make more informed decisions about where to allocate budget.

---

## Step 1 - Cost and Usage Governance - Notifications
Configuring notifications allows you to receive an email when usage or cost is above a defined amount.

| | |
|---|---|
| [![Go to lab](/Common/images/gotolab.png)]({{< ref "/Cost/100_Labs/100_2_Cost_and_Usage_Governance" >}}) | **100 Level Lab**: This lab will show you how to implement AWS Budgets to provide notifications on usage and spend. |

---

## Step 2 - Monitor Usage and Cost - Analysis
Cost and Usage Analysis will enable you to understand how you consumed the cloud, and what your costs are for that consumption.

| | |
| --- | --- |
| [![Go to lab](/Common/images/gotolab.png)]({{< ref "/Cost/100_Labs/100_4_Cost_and_Usage_Analysis" >}}) | **100 Level Lab**: This lab introduces you to the billing console, allowing you to view your current and past bills, and also inspect your usage across services and accounts. |

---

## Step 3 - Monitor Usage and Cost - Visualization
Visualizing cost and usage highlights trends and allows you to gain further insights.

| | |
|---|---|
| [![Go to lab](/Common/images/gotolab.png)]({{< ref "/Cost/100_Labs/100_5_Cost_Visualization" >}}) | **100 Level Lab**: This lab will introduce AWS Cost Explorer, and demonstrate how to use its features to provide insights. |

---

## Step 4 - Govern Usage and Cost - Controls
Implementing usage controls will ensure excess usage and accompanying costs does not occur.

| | |
|---|---|
| [![Go to lab](/Common/images/gotolab.png)]({{< ref "/Cost/200_Labs/200_2_Cost_and_Usage_Governance" >}}) |  **200 Level Lab**: This lab will extend the permissions of the Cost Optimization team, then utilize Identity and Access Management (IAM) policies to control and restrict usage. |

---

## Step 5 - Monitor Usage and Cost - Advanced Analysis
Advanced analysis using your Cost and Usage Report (CUR) will allow you to answer the most challenging questions on your usage and cost. It is the most detailed source of information on your cost and usage available.

| | |
|---|---|
| [![Go to lab](/Common/images/gotolab.png)]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}}) | **200 Level Lab**: This lab will utilize Amazon Athena to provide an interface to query the CUR, provide you the most common customer queries, and help you to build your own queries. |

---

## Step 6 - Monitor Usage and Cost - Advanced Visualization
Utilizing the CUR data source in the previous step, you can provide more detailed and custom visualizations and dashboards.

| | |
|---|---|
| [![Go to lab](/Common/images/gotolab.png)]({{< ref "/Cost/200_Labs/200_5_Cost_Visualization" >}}) | **200 Level Lab**: This Lab extends the previous step, utilizing Amazon Quicksight to visualize the CUR data source. |

---

## Step 7 - Monitor Workload Efficiency
This hands-on lab will guide you through the steps to measure the efficiency of a workload. It shows you how to get the overall efficiency, then look deeper for patterns in usage to be able to allocate different weights to different outputs of a system.

| | |
|---|---|
| [![Go to lab](/Common/images/gotolab.png)]({{< ref "/Cost/200_Labs/200_Workload_Efficiency" >}}) | **200 Level Lab**: This lab combines your application logs with cost data, to provide an efficiency metric and insights for your workloads. |

---

## Step 8 (Optional) - Automated CUR Updates and Ingestion
This hands-on lab will guide you through the steps to enable automated updates of your CUR files into Athena, every time a new CUR file is delivered.

| | |
|---|---|
| [![Go to lab](/Common/images/gotolab.png)]({{< ref "/Cost/300_Labs/300_Automated_CUR_Updates_and_Ingestion" >}}) | **300 Level Lab**: This lab uses s3 events and Lambda to trigger a Glue crawler and update Athena when a new CUR is delivered. |

---

## Step 9 (Optional) - Splitting and sharing the CUR
This hands-on lab will guide you on how to automatically extract part of your CUR file, and then deliver it to another S3 bucket and folder to allow another account to access it. Ideal for partners to deliver a sub-account only CUR to each of its customers, or large enterprises.

| | |
|---|---|
| [![Go to lab](/Common/images/gotolab.png)]({{< ref "/Cost/300_Labs/300_Splitting_Sharing_CUR_Access" >}}) | **300 Level Lab**: This Lab uses S3 events, Lambda and Athena to extract part of a CUR file and deliver it to an S3 bucket for another account. |


## Step 10 (Optional) - Automated CUR Reports and email delivery

| | |
|---|---|
| [![Go to lab](/Common/images/gotolab.png)]({{< ref "/Cost/300_Labs/300_Automated_CUR_Query_and_Email_Delivery" >}}) | **300 Level Lab**: This Lab uses CloudWatch events, Lambda, Athena and SES to run queries against the CUR file, and send financial reports to recipients. |
