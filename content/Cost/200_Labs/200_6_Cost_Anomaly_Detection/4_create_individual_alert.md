---
title: "Creating additional alert subscription for individual alerts"
date: 2023-03-13T11:16:09-04:00
chapter: false
weight: 5
pre: "<b>4. </b>"
---

Earlier in this lab, an alert subscription was created as part of creating cost monitor. The alert frequency was selected to be daily summaries. This section guides you on how to create an additional alert subscription with Individual alert mechanism and attach it to the existing cost monitor.

1. To create a new alert subscription, go to Cost Anomaly Detection **Overview** page and select **Alert subscriptions** tab. Then click **Create a subscription**:
![Images/CostAnomaly17.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_17.png?classes=lab_picture_small)

2. On the **Create a subscriptio** page, enter a subscription name and the select **Individual alerts** from Alerting frequency drop down menu. If there is an existing SNS topic, enter the ARN in the **Enter an Amazon SNS ARN**:
![Images/CostAnomaly18.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_18.png?classes=lab_picture_small)

3. For the purpose of this lab, a new SNS topic is created by going to Amazon SNS console page. Select **Topic** from the left navigation menu and then click **Create topic**
![Images/CostAnomaly19.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_19.png?classes=lab_picture_small)

4. On the **Create topic** page, select **Standard** type SNS topic and enter a name. Keep all other options as default and click Create topic:
![Images/CostAnomaly20.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_20.png?classes=lab_picture_small)

The default SNS access policy allow all Principals with in the owner account to publish message to SNS topic. Following access policy may be used to explicity allow alerts to publish message to the SNS topic. Remember to replace **your topic ARN** with the Amazon SNS topic Amazon Resource Name (ARN).:

```json
{
  "Sid": "AWSAnomalyDetectionSNSPublishingPermissions",
  "Effect": "Allow",
  "Principal": {
    "Service": "costalerts.amazonaws.com"
  },
  "Action": "SNS:Publish",
  "Resource": "your topic ARN"
}
```

5. Once the SNS topic is successfully created, a subscription needs to be created. Under the **Subscription** tab On the SNS topic page, click **Create Subscription**:
![Images/CostAnomaly21.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_21.png?classes=lab_picture_small)

6. On the **Create Subscription** page, select **Email** under the **Protocol** drop down menu and enter an email address in the text field under **Endpoint**. Then click **Create Subscription** at the bottom of the page to finish creating subscription:
![Images/CostAnomaly22.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_22.png?classes=lab_picture_small) 

Note that for notifications to be sent, you must accept the subscription to the Amazon SNS notification topic.

7. Now go back to Cost Anomaly Detection **Create a subscription** page and enter SNS ARN:
![Images/CostAnomaly23.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_23.png?classes=lab_picture_small) 

8. Next select a **Threshold** type and enter the threshold value. As an example, we have selected an absolute threshold and set the value to 100. Under **Cost monitors**, select you pre-existing cost monitor and then click **Create subscription**. 
![Images/CostAnomaly24.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_24.png?classes=lab_picture_small) 

9. **Alert subscription details** page shows that the subscription is successfully created with **Individual alerts** frequency. 
![Images/CostAnomaly25.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_25.png?classes=lab_picture_small) 

{{< prev_next_button link_prev_url="../3_investigate_anomaly/" link_next_url="../5_teardown/" />}}