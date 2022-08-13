---
title: "Review Sustainability KPI Optimization"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 6
pre: "<b>5. </b>"
---

# Overview

With optimization completed in the previous lab, let’s see if you maximized utilization and improved our sustainability KPI:

### 5.1. Applying Hardware Patterns best practices for sustainability in the cloud

1. Graviton3 processors helps you reduce your carbon footprint as it uses up to 60 % less energy for the same performance comparable to EC2 instances. 
![Section5 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section5/cpu_utilization.png)

2. Optimal compute resources to reduces idle resources and to meet performance requirement to deliver your business outcomes


### 5.2. Review Sustainability KPI Optimization

1. Now, let evaluate the improvements by checking KPIs again:
![Section5 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section5/revised_kpi_metrics.png)


With, that below are revised (improved) metrics and KPI:

        * Proxy Metric - Total number of vCPUs = 2
        * Business Metric - Total number of APIs = 3
        * KPI - Per request vCPU = 2 / 3 requests = 0.66666 

Improved value appears to be **0.66666**.

For better adotion across organization, you have these cloudwatch dashboards available across teams and publish this data as a continuing success story.

Next, we will cleanup the AWS resources created to make sure no further costs are incurred.

{{< prev_next_button link_prev_url="../4_reducing_idle_resources_and_maximizing_utilization" link_next_url="../cleanup" />}}

