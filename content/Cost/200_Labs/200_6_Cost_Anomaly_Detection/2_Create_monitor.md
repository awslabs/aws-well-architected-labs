---
title: "Create A Cost Monitor"
date: 2023-03-13T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>2. </b>"
---

Cost Anomaly Detection is a feature of AWS Cost Explorer that performs the heavy lifting of continuous cost monitoring and saves users the tedious work of manually identifying unusual spend patterns in their AWS account. In other words, it helps users better govern their AWS cost and prevents unexpected charges at the end of the month.

This section walks you through the steps to get started with AWS Cost Anomaly Detection by creating a cost monitor which will enable you to establish spending segments. AWS can assess any unusual expenses at a more specific and preferred level based on the segments you have defined. A cost monitor continuously looks at your AWS spend and uses machine learning to detect anomalies. **A cost monitor can be configured to analyze your AWS services independently or by member accounts, cost allocation tags or cost categories**. Creating multiple monitors is possible if there is a need to analyze spend across different segments. However, a single monitor is created for this lab to analyze spending segmented by AWS services. During the process of creating the monitor, an alert subscription is also created. Alert subscription is a mechanism to notify relevant users or administrators if an anomaly is detected. You can notify designated individuals by email or Amazon SNS depending on the required alert frequency.

Follow the following steps to set up a new cost monitor and an alert subscription:

1. To create a cost monitor, click **Cost monitors** tab on the bottom of Cost Anomaly Detection **Overview** page:
![Images/CostAnomaly03.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_03.png?classes=lab_picture_small)

2. On the Cost monitors tab, click **Create monitor**:
![Images/CostAnomaly04.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_04.png?classes=lab_picture_small)

3. As a first step, select one of the monitor types. Under **Choose monitor type** select **AWS Services - Recommended**. It is the recommended monitor type as it meets the use case of most customers. It is the recommended monitor type as it meets the use case of most customers. It segments the total cost by each AWS service. For example, your spend patterns for Amazon EC2 usage might differ from your AWS Lambda or Amazon S3 spend patterns. By segmenting spends by AWS services, AWS Cost Anomaly Detection can detect separate spend patterns that help decrease false positive alerts:

![Images/CostAnomaly05.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_05.png?classes=lab_picture_small)

4. Scroll down, name your monitor and click **Next** to go to the next step **Configure alert subscription**:
![Images/CostAnomaly06.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_06.png?classes=lab_picture_small)

5. On **Configure alert subscription** step:
    * Choose the option **Create a new subscription** under **Alert subscription #1**
    * Enter a **Subscription name**.
    * Under **Alerting frequency**, select **Daily summaries** for the purpose of this lab. 
    * Under **Alert recipients**, add email addresses of the relevant recipients:
![Images/CostAnomaly07.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_07.png?classes=lab_picture_small)

6. Scroll down and under **Threshold** section:
* Enter **20** in the text box and
* Select **percent above expected spend** from the drop down menu

Once above options are configured, a **Summary** is displayed to inform the user of the condition in which they will receive anomaly alerts. 

![Images/CostAnomaly08.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_08.png?classes=lab_picture_small)

There are two types of thresholds: absolute and percentage. 
- Absolute thresholds trigger alerts when an anomaly's total cost impact exceeds your chosen threshold.
- Percentage thresholds trigger alerts when an anomaly's total impact percentage exceeds your chosen threshold. Total impact percentage is the percentage difference between the total expected spend and total actual spend.

While setting threshold values, customers must consider their individual use case and risk appetite. For example, a 5% increase might be significant for some customers while negligible for others. Also, consider any upcoming migrations or events that can cause substantial changes in your spend pattern as that will require re-adjusting your threshold values.

7. At the end of **Configure alert subscription** step, there is an option to create additional subscriptions. For the purpose of this lab, no more subscriptions are created. Click **Create monitor** to finish creating the monitor and subscription:
![Images/CostAnomaly09.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_09.png?classes=lab_picture_small)

{{% notice note %}}
A new monitor can take **24 hours** to begin detecting new anomalies.
{{% /notice %}}

### Congratulations!
You have completed this section of the lab. In this section, you
successfully created a Cost Monitor for analyzing cost segmented by AWS services. An alert subscription was also configured to send daily summary report of detected anomalies via email.  

Click on **Next Step** to continue to the next section.
{{< prev_next_button link_prev_url="../1_cad_intro/" link_next_url="../3_investigate_anomaly/" />}}