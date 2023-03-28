---
title: "Teardown"
date: 2023-03-13T11:16:09-04:00
chapter: false
weight: 6
pre: "<b>5. </b>"
---

1. Delete cost monitor by going to Cost Anomaly Detection **Overview** page and under **Cost monitors** tab, select the monitor and click **Delete**:
![Images/CostAnomaly15.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_15.png?classes=lab_picture_small)

A confirmation window will appear; click **Delete** to continue. 

2. Delete alert subscription by going to Cost Anomaly Detection **Overview** page and under **Alert subscriptions** tab, select the subscription and click **Delete**:
![Images/CostAnomaly16.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_16.png?classes=lab_picture_small)

A confirmation window will appear; click **Delete** to continue.

3. Delete SNS topic by going to Amazon SNS console, click **Topics** from the left navigation pane. Then select the radio button next to the SNS topic you created and click **Delete**.
![Images/CostAnomaly26.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_26.png?classes=lab_picture_small)

A confirmation window will appear; type **delete me** in the text box and click **Delete**
![Images/CostAnomaly27.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_27.png?classes=lab_picture_small)

4. Delete SNS subscription by going to Amazon SNS console, click **Subscriptions** from the left navigation pane. Then select the radio button next to the subscription you created and click **Delete**.
![Images/CostAnomaly28.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_28.png?classes=lab_picture_small)

A confirmation window will appear; click **Delete** to continue.

{{< prev_next_button link_prev_url="../4_create_individual_alert/"  title="Congratulations!" final_step="true" >}}
