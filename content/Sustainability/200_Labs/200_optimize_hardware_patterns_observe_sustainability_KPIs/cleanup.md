---
title: "Cleanup"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 7
---

To avoid incurring further costs for AWS resources, let’s delete all resources that you created for this lab. 

1. Open the CloudFormation console at [https://console.aws.amazon.com/cloudformation](https://console.aws.amazon.com/cloudformation/) and select the correct region you used to deploy this lab.

    Select the previous CloudFormation stack you used and click **Delete**.
![Section6 delete_stack](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section6/delete_stack.png)

2. Click **Dashboards** and select your newly created dashboard. Click **Delete**.  
![Section6 delete_dashboard](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section6/delete_dashboard.png)


{{< prev_next_button link_prev_url="../5_review_sustainability_kpi_optimization"  title="Congratulations!" final_step="true" >}}
You should now have a firm understanding of how to use proxy metric, business metric, and sustainability KPI using Amazon CloudWatch metrics with metric math function. Also you leant how to use AWS Compute Optimizer for optimizing compute resources for environmental sustainability improvements.
{{< /prev_next_button >}}
