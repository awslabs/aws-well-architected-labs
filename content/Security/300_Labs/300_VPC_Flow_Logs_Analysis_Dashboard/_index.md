---
title: "Level 300: VPC Flow Logs Analysis Dashboard"
menutitle: "VPC Flow Logs Analysis Dashboard"
date: 2021-09-18T06:00:00-00:00
#chapter: false
weight: 9
hidden: false
---

## Author
- Chaitanya Shah, Sr. Technical Account Manager, AWS
<!-- ![class=thumbnail](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/ChaitanyaShah.png?floatleft) -->

<!-- ## Feedback -->

## Introduction
VPC Flow Logs enables you to capture information about the IP traffic going to and from network interfaces in your VPC. The VPC Flow Logs Analysys Dashboard is an interactive, customizable and accessible QuickSight dashboard to help customers gain insights into traffic details of VPC in a graphical way. 

Dashboard depends on all the fields below and required in VPC Flow Logs that are stored in S3:
- version, account-id, interface-id, srcaddr, dstaddr, srcport, dstport, protocol, packets, bytes, start, end, action, log-status, vpc-id, az-id, instance-id, pkt-srcaddr, pkt-dstaddr, region, subnet-id, sublocation-id, sublocation-type, tcp-flags, type, flow-direction, pkt-dst-aws-service, pkt-src-aws-service, traffic-path

This dashboard contains breakdowns with the following visuals. Available views are Summary, Details by daily, minutes level granularity and enhanced view:
 - By VPC, InterfaceIds
 - Between Source and Destination IPs
 - By Region, AZ and Instances
 - Source and destination AWS services paths (Enhanced view)

Supported flow log record formats:
- CSV
- _Parquet format coming soon.._

Supported Glue Partitions:
 - Non Hive-compatible S3 prefix

Note: This lab currently does not support **Hive-compatible S3 prefix**

## Architecture
<!-- ![Images/architecture.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/architecture.png) -->
![images/qs-vpcl-architecture_v3.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcl-architecture_v3.png)

## Goals
- To allow customers to use VPC Flow Logs dashboard along with Data Transfer Dashboard to visualize and understand data transfer, IP traffic patterns. Pinpoint the problem areas or abillity to look into areas where you can improve. Spot any anomalies, outliers in ingress and egress traffic.

## Prerequisites
- An AWS Account
- An Amazon Enterprise Edition [QuickSight Account](https://us-east-1.quicksight.aws.amazon.com/sn/admin#subscriptions)
    - For supported QuickSight regions please visit [link](https://docs.aws.amazon.com/quicksight/latest/user/regions.html)
- Amazon [QuickSight](https://quicksight.aws.amazon.com/sn/start) user has been already created
<!-- - AWS [CLI 2.0](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) -->
<!-- - Cloud formation Templates:
    - Download  [vpc-flow-logs-custom.yaml](https://d36ux702kcm75i.cloudfront.net/vpc-flow-logs-custom.yaml) 
        - This cloudformation template enables VPC Flow Logs in the account you run it. You will need to run it per VPC.
    - Download  [vpc_lambda_function.yaml](https://d36ux702kcm75i.cloudfront.net/vpc_lambda_function.yaml) 
        - This cloudformation template creates a cloudwatch rule and a lambda function which creates a partition for external Athena table daily as VPC Flow Logs creates a new folder for each day. -->


## Costs

_Note: Please refer to [pricing](https://aws.amazon.com/pricing/) page for current prices for below sercvices_

- A [QuickSight Enterprise](https://aws.amazon.com/quicksight/pricing/) license starts at $18 per month and Readers $0.30/session up to $5 max/month
- [AWS Athena](https://aws.amazon.com/athena/pricing/) $5.00 per TB of data scanned and AWS Glue 
- [AWS Glue](https://aws.amazon.com/glue/pricing/) Storage: Free for the first million objects stored and $1.00 per 100,000 objects stored above 1M, per . Requests: Free for the first million requests per month. $1.00 per million requests above 1M in a month
- VPC Flow logs [pricing](https://aws.amazon.com/cloudwatch/pricing/)(Example 5) to ingest data in S3

## Time to complete
- The lab should take approximately 15-20 minutes to complete

{{< prev_next_button link_next_url="./1_enable_vpc_flow_logs/" button_next_text="Start Lab" first_step="true" />}}

## Steps:
{{% children  %}}
