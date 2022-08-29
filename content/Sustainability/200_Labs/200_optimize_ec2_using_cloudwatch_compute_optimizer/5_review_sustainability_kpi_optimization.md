---
title: "Review Sustainability KPIs Optimization"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 6
pre: "<b>5. </b>"
---

With optimization completed in the previous lab, let’s evaluate if you maximized utilization and improved our sustainability KPIs:

### 5.1. Applying Hardware Patterns Best Practices for Sustainability in the cloud

1. With c6g.large instance, CPU utilization appears to be 26% from 13%, which means we maximized compute resources. You reduced idle resources and met performance requirements.
![Section5 cpu_utilization](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section5/cpu_utilization.png)

### 5.2. Review Sustainability KPIs Optimization

1. Now, let's evaluate the improvements by checking KPIs:
![Section5 revised_kpi_metrics](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section5/revised_kpi_metrics.png)


With, that below are improved metrics and KPIs:

        * Proxy Metric - Total number of vCPUs = 2
        * Business Metric - Total number of APIs = 3
        * KPI - Per request vCPU = 2 / 3 requests = 0.66666 

The improved Sustainability KPIs appear to be **0.66666**. Your workload shows an initial improvement of 50% reduction in compute resource requirements after changing your Amazon EC2 instance type from t4g.xlarge to c7g.large.

For better the adoption of sustainability KPIs across the organizations, you have these CloudWatch dashboards available across teams and publish it as a continuing success story.

Next, we will clean up the AWS resources created to ensure no further costs are incurred.

{{< prev_next_button link_prev_url="../4_reducing_idle_resources_and_maximizing_utilization" link_next_url="../cleanup" />}}

