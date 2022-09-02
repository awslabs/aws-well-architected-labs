---
title: "Review Sustainability KPIs Optimization"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 6
pre: "<b>5. </b>"
---

With our EC2 instance optimization completed, let’s evaluate our utilization levels to see if they have improved and effected our sustainability KPIs.

### 5.1. Review Sustainability KPIs Optimization

1. Go back to the dashboard for Sustainability KPIs Baseline in the Amazon CloudWatch.
![Section5 revised_kpi_metrics](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section5/dashboard.png)

2. Let's evaluate the sustainability KPIs. 
![Section5 revised_kpi_metrics](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section5/revised_kpi_metrics.png)


These are the improved metrics and KPIs:

        * Proxy Metric - Total number of vCPUs = 2
        * Business Metric - Total number of APIs = 3
        * KPIs - Resources provisioned per unit of work = 2 / 3 requests = 0.66666 

The improved Sustainability KPIs appear to be **0.66666**. Your workload shows an initial improvement of 50% reduction in compute resource requirements after changing your Amazon EC2 instance type from t4g.xlarge to c6g.large.

For better the adoption of sustainability KPIs across the organizations, you have these CloudWatch dashboards available across teams and publish it as a continuing success story.

Next, we will clean up the AWS resources created to ensure no further costs are incurred.

{{< prev_next_button link_prev_url="../4_reducing_idle_resources_and_maximizing_utilization" link_next_url="../cleanup" />}}

