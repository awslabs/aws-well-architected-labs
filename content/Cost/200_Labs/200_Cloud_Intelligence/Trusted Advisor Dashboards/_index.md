---
title: "Trusted Advisor Organizational (TAO) Dashboard"
#menutitle: "Lab #2"
date: 2020-09-07T11:16:08-04:00
chapter: false
weight: 3
hidden: false
pre: "<b> </b>"
---
## Last Updated

December 2021

## Authors

+ Yuriy Prykhodko, Senior Technical Account Manager, EMEA
+ Timur Tulyaganov, Senior Technical Account Manager, EMEA

## Contributors
+ Oleksandr Moskalenko, Technical Account Manager, EMEA
+ Georgios Rozakis, Technical Account Manager, EMEA


## Feedback

If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: cloud-intelligence-dashboards@amazon.com

## Introduction

Amazon Trusted Advisor helps you optimize your AWS infrastructure, improve security and performance, reduce over all costs, and monitors service limits. Organizational view lets you view Trusted Advisor check for all accounts in your AWS Organizations. The only way to visualize the organizational view is to use the TAO dashboard. The TAO dashboard is a set of visualizations that provide comprehensive details and trends across your entire AWS Organization. Out-of-the-box benefits of the TAO dashboard include (but are not limited to):

* Quickly locate accounts and users that haven't rotated their AWS IAM keys
* Identify idle and underutilized resources by cost or account
* See a list of accounts that have reached over 80% of individual service limits

## Demo Dashboard

Get more familiar with TAO Dashboard using the live, interactive demo dashboard below or following this [link](https://d1s0yx3p3y3rah.cloudfront.net/anonymous-embed?dashboard=tao)


![Images](/Cost/200_Cloud_Intelligence/Images/tao/TAO_Dashboard_Summary.png)

{{% notice note %}}
These dashboards and their content: (a) are for informational purposes only, (b) represents current AWS product offerings and practices, which are subject to change without notice, and (c) does not create any commitments or assurances from AWS and its affiliates, suppliers or licensors. AWS content, products or services are provided “as is” without warranties, representations, or conditions of any kind, whether express or implied. The responsibilities and liabilities of AWS to its customers are controlled by AWS agreements, and this document is not part of, nor does it modify, any agreement between AWS and its customers.
{{% /notice %}}

## Goals

- Create TAO dashboard
- Share the dashboard in your organization

## Permissions

This workshop can be deployed by any user who has permission to access the **Trusted Advisor Organizational view, S3, Athena, Glue and QuickSight**.

The management account in your organization must have a **Business** or **Enterprise** support plan.

## Costs 

- A QuickSight Enterprise license starts at $18 per month. 
- Incremental costs associated with AWS Glue, Amazon Athena, and Amazon S3. 
- Estimated total cost for all Dashboards together in a large AWS deployment is $54 per month. 

## Time to Complete

+ **Pre-requisites**: Should take approximately 15 minutes to complete
+ **Installation**: Should take approximately 60 minutes to complete

## Steps:
{{% children  /%}}

{{< prev_next_button link_next_url="./dashboards/1_prerequistes/" button_next_text="Start Lab" first_step="true" />}}