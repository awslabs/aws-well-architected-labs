---
title: "Baseline Sustainability KPIs"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 4
pre: "<b>3. </b>"
---

Let’s baseline the metrics which we can use to measure sustainability improvement once workload optimization is completed. In this section, we will identify:

1. The metric to monitor the total number of VCPUs which we can use as a proxy metric for sustainability.
2. The business outcome metric (number of API calls served).
3. The Sustainability KPI (resources provisioned per unit of work).

You will learn more about the following [design principles](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/design-principles-for-sustainability-in-the-cloud.html) in the AWS Well-Architected Sustainability Pillar:
* Understand your impact
* Establish sustainability goals

### 3.1. Understand what you have provisioned in AWS (Proxy metrics)
Let's understand the resources provisioned to support your workload including compute, storage, and network resources. Then, evaluate the resources provisioned using your proxy metrics to see how those resources are consumed.

1. From the Amazon CloudWatch console, expand **Metrics** and click **All metrics**. In Custom namespaces, there will be a new namespace named **Sustainability**. Click Sustainability.
![Section3 custom_namespace](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/custom_namespace.png)

2. Tick a box to see if you see a total number of vCPU of Amazon EC2 Instance you just deployed. It will be **4** as expected. It will be used for proxy metrics that best reflect the type of improvement you are accessing and the resources targeted for improvement.
![Section3 totalvcpu](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/totalvcpu.png)

### 3.2. Create Business Metrics
Your business metrics should reflect the value provided by your workload, for example, the number of simultaneously active users, API calls served, or the number of transactions completed.

1. Within the Amazon CloudWatch console, click **Log groups** and click **httpd_access_log** that records all inbound requests handled by HTTP endpoints.
![Section3 httpd_access_log](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/httpd_access_log.png)

2. Click **Metric filters** tab.
![Section3 metric_filter](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/metric_filter.png)

3. You will define business metrics to quantify the achievement of business outcome. Click **Create metric filter** button to monitor a specific pattern in the access log.
![Section3 create_metric_filter](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/create_metric_filter.png)

4. You now need to define the pattern to monitor the number of requests of **businessapi.php** page that is a critical for your business. Specify **"GET /businessapi.php"** as a filter pattern to match it in the access log as shown.
    ```
    "GET /businessapi.php"
    ```
    Select log as **your_EC2_instance_id/var/log/httpd/access_log** to test and click **Test pattern** button. You should be able to see 3 http requests per minute.

![Section3 define_pattern](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/define_pattern.png)


Scroll down to the bottom to click **Next**.

![Section3 next](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/next.png)

5. Provide the metric details.
    ![Section3 mectic_details](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/mectic_details.png)

    1. Create a filter name as **businessapi.php**.
    ```
    businessapi.php
    ```
    2. Click the **radio slider** as you will select the existing metric namespace.  
![Section3 mectic_details](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/radio_slider.png)
    3. Select **Sustainability** as Metric namespace.
    4. Specify **BusinessMetrics** as metric name.
    ```
    BusinessMetrics
    ```
    5. Set the Metric value to **1** and click **Next**.

6. Review all values and click **create metric filter**.
![Section3 review](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/review.png)

7. Click **BusinessMetrics** to see the metrics you created previously.
![Section3 business_metrics](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/business_metrics.png)

8. Click **Sustainability > Metrics with no dimensions**.
![Section3 sustainability_meteics](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/sustainability_meteics.png)

9. Tick a box to see the number of units of "GET /businessapi.php" is being monitored. It may take a few minutes for metrics to be displayed on the graph.
![Section3 check_metrics](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/check_metrics.png)

### 3.3. Create Sustainability Key Performance Indicators Baseline

Our improvement goal is to maximize utilization of provisioned resources. Let's create the metrics for KPIs to evaluate ways to improve productivity and estimate the impact of proposed changes over time.

1. Click **Dashboards** 
![Section3 kpi_dashboard](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/kpi_dashboard.png)

2. Click **create dashboard** button.
![Section3 create_kpi_dashboard](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/create_kpi_dashboard.png)

3. For the dashboard name, use **SustainabilityApp-KPI** and click the **Create dashboard** button.
![Section3 create_kpi_dashboard2](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/create_kpi_dashboard2.png)

4. Select **Line** as a widget type.
![Section3 select_line](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/select_line.png)

5. Select **Metrics**.
![Section3 select_metrics](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/select_metrics.png)

6. Select **Sustainability** in custom namespaces.
![Section3 mectics_name](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/mectics_name.png)

7. Select **Instance**.
![Section3 instance](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/instance.png)

8. Tick a box to select your EC2 Instance ID where SustainabilityApp is running and click **Sustainatility** metrics to go back.
![Section3 instance_id](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/instance_id.png)

9. Now let's add business metrics. Click **Metrics with no dimensions**.
![Section3 metrics_no_dimensions](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/metrics_no_dimensions.png)

10. Tick a box to select **BusinessMetrics** at step 3.2 and select **Graphed metrics** tab.
![Section3 graphed_metrics](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/graphed_metrics.png)

11. Let's change the **statistic** and **period** setting as shown:
![Section3 statistic_period](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/statistic_period.png)

    We are going to use [CloudWatch metrics with metric math function.](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html)
    1. For the total number of vCPUs, change statistic from Average to **Maximum**. This will be m1.
    2. For the vCPU period, change the setting to **1 minute**.
    3. For Business Metrics, change statistic from Average to **Sum**. We will need to add the number of API requests per minute. This will be m2.
    4. For Business Metrics period, change the setting to **1 minute**.
    5. Click **Add math**.
    6. Select **Start with empty expression**.

12. The following formula divides the provisioned resources by the business outcomes achieved to determine the provisioned resources per unit of work.

    **Formula:**
    ```
    Resources provisioned per unit of work = Total number of vCPU minutes / The number of API requests per minute
    ```
![Section3 kpi](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/kpi.png)

Then, edit math expression as follows and click **Apply**.
    
    m1/m2
    
13. Click **Expression** and use **Resources provisioned per unit of work**. Click **Apply** and **Create widget**.
![Section3 expression](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/expression.png)

    1. Click **Expression**.
    2. Provide **Resources provisioned per unit of work** as Label.
        ```
        Resources provisioned per unit of work
        ```
    3. Click **Apply**.
    4. Click **Create widget**.

14. Click **Save** button to continuously monitor KPIs after reducing idle resources and maximizing utilization in the next step. You will use Resources provisioned per unit of work as sustainability KPIs.

    These are the improved metrics and KPIs:

        * Proxy Metric - Total number of vCPUs = 4
        * Business Metric - Total number of APIs = 3
        * KPIs - Resources provisioned per unit of work = 4 / 3 requests = 1.333

    Sustainability KPIs Baseline appears to be **1.33333**
![Section3 kpi_baseline](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section3/kpi_baseline.png)


{{< prev_next_button link_prev_url="../2_configure_env" link_next_url="../4_reducing_idle_resources_and_maximizing_utilization" />}}
