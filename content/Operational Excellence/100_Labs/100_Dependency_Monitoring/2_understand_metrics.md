---
title: "Understanding Metrics"
menutitle: "Understanding Metrics"
date: 2020-09-15T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

Workloads can and should be designed to emit a variety of metrics such as application metrics (number of requests, error codes), infrastructure metrics (CPU, memory, disk usage), etc. These metrics should be tied back to KPI(s) that are used to measure a certain aspect of the business. Understanding different workload metrics will allow you to select the right metric to monitor, and understand the availability or status of your workload and its dependencies.

In this case, a Lambda function gets invoked after every data write using the S3 PutObject API call. Understanding metrics related to the Lambda function will provide insight on what the right metrics are to determine the health of the dependent service i.e. the external data write service.

"AWS Lambda automatically monitors Lambda functions on your behalf and reports metrics through Amazon CloudWatch. To help you monitor your code as it executes, Lambda automatically tracks the number of requests, the execution duration per request, and the number of requests that result in an error. It also publishes the associated CloudWatch metrics and you can leverage these metrics to set CloudWatch custom alarms to enable automated responses to changes in metrics." - https://docs.aws.amazon.com/lambda/latest/dg/lambda-monitoring.html

AWS Lambda provides default metrics on CloudWatch across three categories:

* [Invocation Metrics](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics.html#monitoring-metrics-invocation)
* [Performance Metrics](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics.html#monitoring-metrics-performance)
* [Concurrency Metrics](https://docs.aws.amazon.com/lambda/latest/dg/monitoring-metrics.html#monitoring-metrics-concurrency)

For the use-case in this lab, invocation metrics provided by Lambda will be used. The two key invocation metrics to focus on here are **Invocations** and **Errors**.

Monitoring the **Errors** metric will provide visibility into function errors. Function errors include exceptions thrown by your code and exceptions thrown by the Lambda runtime. The runtime returns errors for issues such as timeouts and configuration errors. This is a valuable metric to identify issues with the function code, or configuration, as well as certain issues related to the external service.

For example, if the Lambda function is expecting the file written by the external service to be in a certain format, and if the written file does not match this format, it could result in a Lambda function error. Creating an alarm on **Errors** will provide visibility into the function execution.

There might be a situation where the external service is running at reduced capacity, some capabilities may be impaired, or it could be experiencing a complete outage with no data writes to S3. If no new files are being written to S3 monitoring for Lambda function errors will not suffice.

If the external service is no longer writing files to S3 at 50 second intervals, there would be no S3 notification, and subsequently, no Lambda invocations. As the Lambda function was never invoked, the **Errors** metric will show no change. A different approach is necessary.

The SLA with the external service expects new files to be written at 50 second intervals. The expected Lambda invocation rate is a minimum of 1 invocation per minute as a results of the S3 notifications. Now that a baseline has been established as to what the **Invocations** metric should look like, you can create an alarm to alert when the metric deviates from the baseline.

1. Go to the Amazon CloudWatch console at <https://console.aws.amazon.com/cloudwatch> and click on **Metrics**
1. In the search bar under **All metrics**, enter the name of the data read function - `WA-Lab-DataReadFunction` and press enter
1. In the metric breakdown, select **Lambda > By Resource** and you will see a list of Lambda metrics available

    ![CWSearchMetrics](/Operations/100_Dependency_Monitoring/Images/CWSearchMetrics.png)

1. Check the box for the metric **Invocations** and observe the graph, you will see all the function invocations
1. Change the range by clicking on the **custom** option and selecting **15 Minutes**

    ![CWSelectMetric](/Operations/100_Dependency_Monitoring/Images/CWSelectMetric.png)

1. Change the period to **1 Minute** by going to the **Graphed metrics** tab

    ![CWSelectPeriod](/Operations/100_Dependency_Monitoring/Images/CWSelectPeriod.png)

You should now see a graph that has a data point at 1 minute intervals representing a Lambda function invocation. Each invocation represents a write to the S3 bucket. By monitoring the number and frequency of lambda invocations, you are monitoring the availability of the external service. If the number of invocations drops below the expected value, there may be an issue with the external service.
