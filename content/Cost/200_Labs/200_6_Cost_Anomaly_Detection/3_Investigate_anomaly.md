---
title: "Dive deep into detected cost anomaly"
date: 2023-03-13T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>3. </b>"
---

In this section, we will walk you through the steps to analyze anomalies detected by Cost Anomaly Detection service and investigate the associated root cause. For demonstration, screenshots from a test AWS account are used in this section. Note that anomaly detection leverages historical data and machine learning mechanisms to identify unusual spend. This means that anomalies are specific to individual use cases. For example, $10 increase in daily spend for an AWS account that has a historical daily spend pattern of around $5 is a sharp increase and an unusual trend, whereas the same increase for an AWS account that has a historical daily spend pattern of around $500 is not significant and might not be considered unusual.

Follow the following steps to view detected anomalies and the depth of information available.

1. To view the anomalies detected by the cost monitor, go to the overview page of Cost Anomaly Detection. If **Detection History** tab is not already displayed, click **Detection History**. It shows a list of anomalies detected in the last 90 days. By default, anomalies are sorted by **Start date**. However, users can click on the column name (e.g. Total cost impact, impact percentage, Accounts, etc) to sort the anomalies by a different property. By doing this, users can focus on the anomalies which have highest total cost impact or highest percentage impact.
![Images/CostAnomaly10a.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_10a.png?classes=lab_picture_small)

Users can click the gear icon on the right side to add or change columns in the detection history. 

2. Detection history also offers search functionality that can be used to filter anomalies based on the properties like **Severity**, **Service(s)**, **Region**, etc. 
![Images/CostAnomaly10b.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_10b.png?classes=lab_picture_small)

3. Further details about the anomaly can be found by clicking the start date of the anomaly. In the following example, the start date of the latest anomaly is selected:
![Images/CostAnomaly10.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_10.png?classes=lab_picture_small)

4. Anomaly details page shows a **Summary** that provides a basic level of information, but you can click **View in Cost Explorer** to view further details.
![Images/CostAnomaly11.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_11.png?classes=lab_picture_small)

5. Another option is to scroll down to view **Top ranked potential root causes**. There can be a single or multiple contributing services or accounts. You get additional information about the **Region** where the cost was incurred and the **Usage type** responsible for the cost. In this example, the cost was incurred in South America (São Paulo) Region due to GuardDuty event analysis.
![Images/CostAnomaly12.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_12.png?classes=lab_picture_small)

6. Under **Cost Explorer link** column, click **View root cause**. The link will open Cost Explorer in a new window with all filters selected to show you the details of anomalous spend. The graph helps visualize that the cost on Mar-05 more than doubled for GuardDuty events analysis. 
![Images/CostAnomaly13.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_13.png?classes=lab_picture_small)

7. Spikes in cost at times are expected, for example, when a new workload is migrated to AWS, it might result in a sudden rise in cost. In such cases, there might be a false alert. Therefore, it is important to keep providing feedback using the link on **Anomaly details** page. Providing feedback helps improve the accuracy of detected anomalies:
![Images/CostAnomaly14.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_14.png?classes=lab_picture_small)

### Congratulations!
You have completed this section of the lab. In this section, you
learned how to navigate through the history of detected anomalies, dive deep into specific anomaly and investigate the associated root cause. 

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../2_create_monitor/" link_next_url="../4_create_individual_alert/" />}}