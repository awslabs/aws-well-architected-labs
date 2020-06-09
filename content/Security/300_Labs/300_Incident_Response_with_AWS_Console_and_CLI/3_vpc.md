---
title: "Amazon VPC"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---
A Amazon VPC that has [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html) enabled captures information about the IP traffic going to and from network interfaces in your Amazon VPC. This log information may help you investigate how Amazon EC2 instances and other resources in your VPC are communicating, and what they are communicating with. You can follow the [Automated Deployment of VPC](../200_Automated_Deployment_of_VPC/README.md) lab for creating a Amazon VPC with Flow Logs enabled.

### 3.1 Investigate Amazon VPC Flow Logs

#### 3.1.1 AWS Management Console

The AWS Management console provides a visual way of querying CloudWatch Logs, using [CloudWatch Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html) and does not require any tools to be installed.

1. Open the Amazon CloudWatch console at [https://console.aws.amazon.com/cloudwatch/](https://console.aws.amazon.com/cloudwatch/) and select your region.
2. From the left menu, choose **Insights** under **Logs**.
3. From the dropdown near the top select your CloudTrail Logs group, then the relative time to search back on the right.
4. Copy the following example queries below into the query input, then click **Run query**.

**Rejected requests by IP address:**

Rejected requests indicate attempts to gain access to your VPC, however there can often be noise from internet scanners. To count the rejected requests by source IP address:
`filter action="REJECT"
| stats count(*) as numRejections by srcAddr
| sort numRejections desc`

**Reject requests originating from inside your VPC**

Rejected requests that originate from inside your VPC may indicate your infrastructure in your VPC is attempting to connect to something it is not allowed to, e.g. a database instance is trying to connect to the internet and is blocked. This example uses regex to match the start of your VPC as *10.*:
`filter action="REJECT" and srcAddr like /^10\./
| stats count(*) as numRejections by srcAddr
| sort numRejections desc`

**Requests from an IP address**

If you suspect an IP address and want to list all requests that originate, replace *192.0.2.1* with the IP you suspect:
`filter srcAddr = "192.0.2.1"
| fields @timestamp, interfaceId, dstAddr, dstPort, action`

**Request count from a private IP address by destination address**

If you want to list and count all connections by a private IP address, replace *10.1.1.1* with your private IP:
`filter srcAddr = "10.1.1.1"
| stats count(*) as numConnections by dstAddr
| sort numConnections desc`
