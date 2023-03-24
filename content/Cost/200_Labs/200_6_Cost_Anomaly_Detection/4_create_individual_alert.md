---
title: "Creating additional alert subscription for individual alerts"
date: 2023-03-13T11:16:09-04:00
chapter: false
weight: 5
pre: "<b>4. </b>"
---

As discussed in earlier sections of this lab, AWS Cost Anomaly Detection helps users prevent unexpected charges for their AWS accounts. It is achieved by:
* Anomaly detection using Machine Learning models
* Alerting users via subscriptions
Alert subscriptions are critical as it is a mechanism to notify users of detected anomalies proactively. Weekly or daily summary reports may not be the right choice in situations where users need to react quickly to a notification. Therefore, an option is to configure an alert subscription to notify users of each anomaly.

This section guides you on how to create an additional alert subscription with **Individual alert** mechanism and attach it to the existing cost monitor.

1. To create a new alert subscription, go to Cost Anomaly Detection **Overview** page and select **Alert subscriptions** tab. Then click **Create a subscription**:
![Images/CostAnomaly17.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_17.png?classes=lab_picture_small)

2. On the **Create a subscription** page, enter a subscription name and the select **Individual alerts** from Alerting frequency drop-down menu. If there is an existing SNS topic, enter the ARN in the **Enter an Amazon SNS ARN**:
![Images/CostAnomaly18.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_18.png?classes=lab_picture_small)

3. If no SNS topic is available, search for **Amazon SNS** in AWS console to create a new one. Select **Topics** from the left navigation menu in Amazon SNS and click **Create topic** button.
![Images/CostAnomaly19.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_19.png?classes=lab_picture_small)

4. On the **Create topic** page, **FIFO (first-in, first-out)** SNS type is selected by default. FIFO topics are helpful for use cases where message order needs to be preserved. For further details, refer to [FIFO topics use case.](https://docs.aws.amazon.com/sns/latest/dg/fifo-example-use-case.html) For this lab, select **Standard** SNS type and enter a name. Keep all other options as default and click **Create topic**:
![Images/CostAnomaly20.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_20.png?classes=lab_picture_small)

5. Create a subscription once the SNS topic is successfully created. Under the **Subscriptions** tab, click **Create Subscription**:
![Images/CostAnomaly21.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_21.png?classes=lab_picture_small)

6. On the **Create Subscription** page, select **Email** under the **Protocol** drop-down menu and enter an email address in the text field under **Endpoint**. Then click **Create Subscription** at the bottom of the page to finish creating subscription:
![Images/CostAnomaly22.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_22.png?classes=lab_picture_small)

At times, there is a requirement to alert multiple individuals or multiple teams such as FinOps, DevOps, SRE or Management team. In such a scenario, additional subscriptions can be created.

{{% notice note %}}
To send notifications, you must accept the subscription to the Amazon SNS notification topic.
{{% /notice %}}

7. Take a note of Amazon SNS ARN: 
![Images/CostAnomaly22-ARN.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_22-arn.png?classes=lab_picture_small)

{{% notice note %}}
Amazon SNS ARN is required to complete the rest of steps. 
{{% /notice %}}

8. Now go back to the **Create a subscription** page where you left off at step 2 in Cost Anomaly Detection and enter SNS ARN you recorded:
![Images/CostAnomaly23.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_23.png?classes=lab_picture_small) 

9. Next, select a **Threshold** type and enter the threshold value. For example, we have selected an absolute threshold and set the value to 100. Under **Cost monitors**, select your pre-existing cost monitor and then click **Create subscription**.
![Images/CostAnomaly24.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_24.png?classes=lab_picture_small)

While setting threshold value, customers must consider their individual use case and risk appetite.

10. **Alert subscription details** page shows that the subscription is successfully created with **Individual alerts** frequency. 
![Images/CostAnomaly25.png](/Cost/200_6_Cost_Anomaly_Detection/Images/cost_anomaly_25.png?classes=lab_picture_small)

11. Users also have the option to cost anomaly alerts in a Slack channel or an Amazon Chime chat room. For the details, refer to [Receiving AWS Cost Anomaly Detection alerts in Amazon Chime and Slack](https://docs.aws.amazon.com/cost-management/latest/userguide/cad-alert-chime.html)

### Congratulations!
You have completed this section of the lab. In this section, you
successfully created an alert subscription which leverages [Amazon Simple Notification Service(SNS)](https://aws.amazon.com/sns/) to notify the subscribers every time an anomaly is detected. 

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../3_investigate_anomaly/" link_next_url="../5_teardown/" />}}