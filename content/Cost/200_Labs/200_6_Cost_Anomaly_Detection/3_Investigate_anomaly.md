---
title: "Dive deep into detected cost anomaly"
date: 2023-03-13T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>3. </b>"
---

In this section, we will walk you through the steps to analyze anomalies detected by Cost Anomaly Detection service and investigate the associated root cause. For the purpose of demonstration, screenshots from a test AWS account are used in this sections. Note that anomaly detection leverages historical data and machine learning mechanism to identify unusual spend. This means that anomalies are specific to individual use case. For example $10 increase in daily spend for an AWS account that has historical daily spend pattern of around $5, is a sharp increase and an unusual trend, whereas the same increase for an AWS account that has historical daily spend pattern of around $500 is not significant and might not be considered unusual. 

Let's see how to view detected anomalies and the depth of information available.

1. To view the anomalies detected by cost monitor, go to the overview page of Cost Anomaly Detection. If **Detection History** tab is not already displayed, click **Detection History**. It shows a list of anomalies detected in the last 90 days. The Detection History shows some information about the anomaly e.g. Last detected date, Total cost impact, impact percentage, Service(s), etc. However, further details can be found by clicking the start date of the anomaly. In the following example, the start date of the latest anomaly is selected:
![Images/CostAnomaly10.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_10.png?classes=lab_picture_small)

2. Anomaly details page show a **Summary** that provides a basic level of information, but you can click **View in Cost Explorer** to view further details
![Images/CostAnomaly11.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_11.png?classes=lab_picture_small)

3. Another option is to scroll down to view **Top ranked potential root causes**. There can be a single or multiple contributing services or accounts. You get additional information about the **Region** where the cost was incurred and the **Usage type** responsible for the cost. In this example, the cost was incurred in South America (São Paulo) region and it was due to GuardDuty event analysis. 
![Images/CostAnomaly12.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_12.png?classes=lab_picture_small)

4. Under **Cost Explorer link** column, click **View root cause**. The link will open Cost Explorer in a new window with all filters selected to show you the details of anomalous spend. The graph helps visualize that the cost on Mar-05 more than doubled for GuardDuty events analysis. 
![Images/CostAnomaly13.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_13.png?classes=lab_picture_small)

5. Spikes in cost at times are expected, for example when a new workload is migrated to AWS it might result in a sudden rise in cost. In such cases, there might be a false alert. It is important to keep providing feedback using the link on **Anomaly details** page. Providing feedback helps improve the accuracy of detected anomalies:
![Images/CostAnomaly14.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_14.png?classes=lab_picture_small)


{{< prev_next_button link_prev_url="../2_Create_monitor/" link_next_url="../3_create_individual_alert/" />}}