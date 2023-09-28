---
title: "Level 300: VPC Flow Logs Analysis Dashboard"
menutitle: "VPC Flow Logs Analysis Dashboard"
date: 2021-09-18T06:00:00-00:00
weight: 9
hidden: false
---

## Author
- Chaitanya Shah, Sr. Technical Account Manager, AWS

## Introduction
VPC Flow Logs enables you to capture information about the IP traffic going to and from network interfaces in your VPC. The VPC Flow Logs Analysis Dashboard is an interactive, customizable and accessible QuickSight dashboard to help customers gain insights into traffic details of VPC in a graphical way. 

The dashboard depends on all the fields below. Therefore all of these fields are required in the VPC Flow Logs that are stored in S3:
- version, account-id, interface-id, srcaddr, dstaddr, srcport, dstport, protocol, packets, bytes, start, end, action, log-status, vpc-id, az-id, instance-id, pkt-srcaddr, pkt-dstaddr, region, subnet-id, sublocation-id, sublocation-type, tcp-flags, type, flow-direction, pkt-dst-aws-service, pkt-src-aws-service, traffic-path

This dashboard contains breakdowns with the following visuals. Available views are Summary, Details by daily, Minutes level granularity, and Enhanced view:
 - By VPC, InterfaceIds
 - Between Source and Destination IPs
 - By Region, AZ and Instances
 - Source and destination AWS services paths (Enhanced view)

Supported flow log record formats:
- Parquet

Supported Glue Partitions:
 - Non Hive-compatible S3 prefix
 - Hive-compatible S3 prefix

Note: We recommend creating **Parquet** file format with **Hive-compatible S3 prefix** for better performance and reducing cost for querying data from S3

## Architecture
![images/qs-vpcl-architecture_v3.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcl-architecture_v3.png)

## Goals
- This dashboard allows you to analyze and visualize vpc flow log data more flexibly, instead of focusing on the underlaying infrastructure, you can focus on investigating the logs.

## Prerequisites
- An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing. This account MUST NOT be used for production or other purposes.
- An Amazon Enterprise Edition [QuickSight Account](https://docs.aws.amazon.com/quicksight/latest/user/provisioning-users.html)
    - For supported QuickSight regions please visit [link](https://docs.aws.amazon.com/quicksight/latest/user/regions.html)
- Amazon [QuickSight](https://quicksight.aws.amazon.com/sn/start) user has been already created

## Costs

_Note: Please refer to [pricing](https://aws.amazon.com/pricing/) page for current prices for below services_

- A [QuickSight Enterprise](https://aws.amazon.com/quicksight/pricing/) license starts at $18 per month and Readers $0.30/session up to $5 max/month
- [AWS Athena](https://aws.amazon.com/athena/pricing/) $5.00 per TB of data scanned
- [AWS Glue](https://aws.amazon.com/glue/pricing/) Storage: Free for the first million objects stored and $1.00 per 100,000 objects stored above 1M, per . Requests: Free for the first million requests per month. $1.00 per million requests above 1M in a month
- VPC Flow logs [pricing](https://aws.amazon.com/cloudwatch/pricing/)(Example 5) to ingest data in S3
- Data Transfer [costs](https://aws.amazon.com/ec2/pricing/on-demand/) to store data coming from different accounts to central account bucket

## Time to complete
- The lab should take approximately 15-20 minutes to complete

{{< prev_next_button link_next_url="./1_enable_vpc_flow_logs/" button_next_text="Start Lab" first_step="true" />}}

## Steps:
{{% children /%}}
