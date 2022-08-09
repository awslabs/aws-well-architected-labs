---
title: "Baseline Sustainability KPI"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 4
pre: "<b>3. </b>"
---

## Overview

Let’s baseline the metrics which we can use to measure sustainability improvement once workload optimization is completed - in this case, we will create metrics to monitor a total number of vCPU of Amazon EC2 Instance provisioned to support the business outcome that is the number of requests to a particualr website.

### 3.1. Understand what you have provisioned in AWS (Proxy metrics)

1. Expand **Metrics** and click **All metrics**. In Custom namespaces, there will be a namespace named **Sustainability**. Click Sustainability.
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/custom_namespace.png)

2. Tick a box to see if you see total number of vCPU of Amazon EC2 Instance you just deployed. It will be **4** as expected.
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/totalvcpu.png)

### 3.2. Create Business Metrics
1. Click **Log groups** and click **httpd_access_log** that records all inbound requests handley by HTTP endpoints. 
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/httpd_access_log.png)

2. Click **Metric filters** tab. 
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/metric_filter.png)

3. You are going to define business metrics to quantify the achievement of business outcome. Click **Create metric filter** to monitor a specific pattern in access log. 
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/create_metric_filter.png)

4. Define pattern to monitor the number of requests of **load.php** page that is a critical for your business. Specify **"GET /load.php"** as filter pattern to match it in access log.
    ```
    "GET /load.php"
    ```
    Select log as **your_EC2_instance_id/var/log/httpd/access_log** to test and click **Test pattern** button. You should be able to see 3 requests par a minute.

![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/define_pattern.png)


Scroll down to the bottom to click **Next**.

![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/next.png)

5. Provide Metric details.

    1. Create a filter name as **load.php**. 
    ```
    load.php
    ```
    2. **Click radio slider** as you will select the existing metric namespace.  
    3. Use **Sustainability** as Metric namespace.
    4. Specify **BusinessMetrics** as metric name.
    ```
    BusinessMetrics
    ```
    5. set Metric value to **1** and click **Next**.

![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/mectic_details.png)

6. Review all values and click **Create metric filter**.
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/review.png)

7. Click **BusinessMetrics** to see the metrics you just created. 
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/business_metrics.png)

8. Click **Sustainability > Metrics with no dimensions**.
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/sustainability_meteics.png)

9. Tick a box to see the number of units of "GET /load.php" is being monitored. 
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/check_metrics.png)


### 3.3. Create Sustainability Key Performance Indicator Baseline

Let's evaluate specific improvement and our objective is to optimize per event provisioned resources. 
* per request total vCPU provisioned

1. Click **Dashboards** 
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/kpi_dashboard.png)

2. Click **Create dashboard**. 
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/create_kpi_dashboard.png)

3. For Dashboard name, use **SustainabilityApp-KPI** and click **Create dashboard**.
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/create_kpi_dashboard2.png)

4. Select **Line**.
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/select_line.png)

5. Select **Metrics**.
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/select_metrics.png)

6. Select **Sustainability**.
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/mectics_name.png)

7. Select **Instance**.
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/instance.png)

8. Tick a box to select EC2 Instance ID in which SustainabilityApp is running and click **Sustainatility** to go back. 
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/instance_id.png)

9. Click **Metrics with no dimensions**. 
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/metrics_no_dimensions.png)

10. Tick a box to select **BusinessMetrics** at step 3.2 and select **Graphed metrics** tab.
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/graphed_metrics.png)

11. Let's change **Statistic** and **Period**. 
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/statistic_period.png)

    We are going to use [CloudWatch metrics with metric math function](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html).
    1. For total numer of vCPI, change statistic from Average to **Maximum**. 
    2. Let's set period to 1 minute. 
    3. For Business Metrics, change statistic from Average to **Sum**.
    4. Let's set period to 1 minute.
    5. Click **Add math**.
    6. Select **Start with empty expression**.

12. Using the following formula, divide the provisioned resources by the business outcomes achieved to determine the provisioned resources per unit of work.formula
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/formula.png)
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/kpi.png)
    
    Devide total number of vCPU by the number of requests per a minute to achieve business outcome. 
    Update math expression as follows and click **Apply**.
    ```
    m1/m2
    ```
13. Click **Expression** and use **Resources provisioned per unit of work**. Click **Apply** and **Create widget**.
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/expression.png)
    
14. Click **Save** button to continuously monitor KPI after reducing idle resources and maximizing utilization. We will use Resources provisioned per unit of work as sustainability KPI. It appears to be **1.33333**.

    With, that below are baseline metrics and KPI:
    * vCPUs
        * Total number of vCPUs = 4
        * Per request vCPU = 4 / 3 requests = 1.333
![Section3 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section3/kpi_baseline.png)
    

{{< prev_next_button link_prev_url="../2_configure_env" link_next_url="../4_reducing_idle_resources_and_maximizing_utilization" />}}
