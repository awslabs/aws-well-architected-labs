---
title: "Create A Cost Monitor"
date: 2023-03-13T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>2. </b>"
---

Cost monitors look at your spend continuously and uses machine learning to detect anomalies.

1. To create a cost monitor, click **Cost monitors** tab on the bottom of Cost Anomaly Detection **Overview** page:
![Images/CostAnomaly03.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_03.png?classes=lab_picture_small)

2. On the Cost monitors tab, click **Create monitor**:
![Images/CostAnomaly04.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_04.png?classes=lab_picture_small)

3. In **Step 1**, choose a monitor type. Each monitor type also shows a brief description of how that monitor segments the cost. **AWS Services** is the recommended type as it can meet the use case of most customers. It segments the total cost by each AWS service. For example, your spend patterns for Amazon EC2 usage might be different from your AWS Lambda or Amazon S3 spend patterns. By segmenting spends by AWS services, AWS Cost Anomaly Detection can detect separate spend patterns that help decrease false positive alerts:
![Images/CostAnomaly05.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_05.png?classes=lab_picture_small)

For large customers that have multi-account landing zone or have cost allocation tags based on different teams or different business units, a Linked Account, Cost Category or Cost Allocation Tag based monitor can be selected to meet the specific needs. Note that customer can choose to have multiple cost monitors of different types to cater for different cost segments. 

4. Scroll down, name your monitor and click **Next** to go to **Step 2**:
![Images/CostAnomaly06.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_06.png?classes=lab_picture_small)

5. In **Step 2**, choose the option to **Create a new subscription**, then enter a **Subscription name**. An alert subscription notifies you when a cost monitor detects an anomaly. Depending on the alert frequency, you can notify designated individuals by email or Amazon SNS. Under **Alerting frequency**, select **Daily summaries** for the purpose of this lab. Under **Alert recipients**, add email addresses of the relevant recipients:
![Images/CostAnomaly07.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_07.png?classes=lab_picture_small)

6. Scroll down, under **Threshold** section, you can chose the type of threshold using the drop down menu. There are two types of thresholds: absolute and percentage. Absolute thresholds trigger alerts when an anomaly's total cost impact exceeds your chosen threshold. Percentage thresholds trigger alerts when an anomaly's total impact percentage exceeds your chosen threshold. Total impact percentage is the percentage difference between the total expected spend and total actual spend.
For the purpose of this lab, **percent above expected spend** is selected. In the text box, enter 20 indicating that an alert is generated when the anomaly impact is 20% above the expected spend:
![Images/CostAnomaly08.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_08.png?classes=lab_picture_small)

7. At the end of **Step 2**, there is an option to create additional subscriptions. For the purpose of this lab, no more subscriptions are created. Click **Create monitor** to finish creating the monitor and subscription:
![Images/CostAnomaly09.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_09.png?classes=lab_picture_small)

{{% notice note %}} NOTE: A new monitor can take 24 hours to begin detecting new anomalies. {{% /notice %}}

{{< prev_next_button link_prev_url="../1_CAD_intro/" link_next_url="../3_Investigate_anomaly/" />}}