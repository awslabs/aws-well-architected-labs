---
title: "Review Sustainability KPI Optimization"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 6
pre: "<b>5. </b>"
---

# Overview

With optimization completed in the previous lab, let’s see if you maxmized utilization and improved our sustainability KPI:

### 5.1. Maximize utilization with Graviton3 processors

1. Graviton3 processors helps you reduce your carbon footprint as it uses up to 60 % less energy for the same performance comparable to EC2 instances. 
![Section5 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section5/cpu_utilization.png)


### 5.2. Review Sustainability KPI Optimization

1. Now, let check if the **consumer** cluster is storing any tables locally in the database by running below query:
![Section5 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section5/revised_kpi_metrics.png)

With, that below are revised (improved) metrics and KPI:
* vCPUs
    * Total number of vCPUs = 2
    * Per request vCPU = 2 / 3 requests = 0.666
    

**For per event data storage sustainability KPI, we see there is 50% reduction (improvement) by using the Amazon Redshift Data Sharing feature.**

For per event data transfer KPI, trade-off analysis should be performed comparing daily refresh data transfer vs. all queries execution dataset transfer over network. One option is to analyze data transfer between regions is using AWS Cost Explorer. [Refer to this AWS blog post](https://aws.amazon.com/blogs/mt/using-aws-cost-explorer-to-analyze-data-transfer-costs/) explaining how to use AWS Cost Explorer to analyze data transfer volume and cost.

Next, we will cleanup the AWS resources created to make sure no further costs are incurred.

{{< prev_next_button link_prev_url="../4_reducing_idle_resources_and_maximizing_utilization" link_next_url="../cleanup" />}}

