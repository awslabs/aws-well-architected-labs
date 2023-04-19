---
title: "Getting to know AWS Cost Anomaly Detection"
date: 2023-03-13T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>1. </b>"
---

### Getting to know AWS Cost Anomaly Detection
AWS Cost Anomaly Detection leverages advanced Machine Learning technologies to identify unusual spends and root causes, so you can quickly take action. With three simple steps, you can create your own contextualized cost monitor and receive alerts when any anomalous spend is detected. This is possible by using machine learning to learn your spend patterns, including organic growth and seasonal trends, and trigger an alert as they seem abnormal. In addition, you can improve the model by providing feedback on the alerts. Currently, Anomaly Detection focuses on monitoring spend by individual AWS service, Cost Allocation tags, Cost Categories, and linked/member accounts.

{{% notice note %}}
After your billing data is processed, AWS Cost Anomaly Detection runs approximately three times a day. You might experience a slight delay in receiving alerts. Cost Anomaly Detection uses data from Cost Explorer, which has a delay of up to 24 hours. As a result, it can take up to 24 hours to detect an anomaly after a usage occurs. If you create a new monitor, it can take 24 hours to begin detecting new anomalies. For a new service subscription, 10 days of historical service usage data is needed before anomalies can be detected for that service.
{{% /notice %}}

### How Cost Anomaly Detection differs from AWS Budgets?
AWS Budgets helps monitor aggregated spend where it is under a specific dollar threshold that you set. However, it does not evaluate the usage patterns or have the capability to detect unusual spends if it is within the pre-set budget. The following diagram helps understand the different spend patterns detected by AWS Budgets versus AWS Cost Anomaly Detection.

![Images/CADvsBudgets.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cad_vs_budgets.png?classes=lab_picture_small)

Scenario 2 shows sudden spikes in spend, which are disregarded by AWS Budgets due to staying within the budget threshold. On the contrary, Cost Anomaly Detection learns usage and spend patterns based on historical data, detects such spikes in spend as unusual behavior, and consequently alerts the user.

### Accessing Cost Anomaly Detection

1. Log into the AWS console and go to the **AWS Cost Explorer** service page:
![Images/CostExplorer01.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_explorer_01.png?classes=lab_picture_small)

2. Select **Cost Anomaly Detection** on the left column:
![Images/CostExplorer02.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_explorer_02.png?classes=lab_picture_small)

3. Click **Get Started**:
![Images/CostAnomaly01.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_01.png?classes=lab_picture_small)

4. A window will pop-up welcoming you to Cost Anomaly Detection. Click **Show me around** to start service tour or click **Skip tour** to continue to next step:
![Images/CostAnomaly02.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_02.png?classes=lab_picture_small)

### Congratulations!
You have completed this section of the lab. In this section, you
learned the fundamentals of AWS Cost Anomaly Detection and how it differs from AWS Budgets. In addition, you learned to access the service using AWS console.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../" link_next_url="../2_create_monitor/" />}}
