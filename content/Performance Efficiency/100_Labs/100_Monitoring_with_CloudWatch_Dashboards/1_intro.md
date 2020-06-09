---
title: "View Amazon CloudWatch Automatic Dashboards"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

## 1. View Amazon CloudWatch Automatic Dashboards <a name="automatic_dashboards"></a>

Amazon CloudWatch Automatic Dashboards allow you to easily monitor all AWS Resources, and is quick to get started. Explore account and resource-based view of metrics and alarms, and easily drill-down to understand the root cause of performance issues.

1. Open the Amazon CloudWatch console at [https://console.aws.amazon.com/cloudwatch/](https://console.aws.amazon.com/cloudwatch/) and select your region from the top menu bar.

1. If you are logging into a brand new AWS account, you will see the default Cloudwatch console such as this:
![monitoring-new-account-console](/Performance/100_Monitoring_with_CloudWatch_Dashboards/Images/monitoring_new_account.png)
*You will need to deploy something into your account to see a Cloudwatch automatic dashboard.*


1. Once you have services deployed into your AWS account, Cloudwatch will automatically populate the Overview tab with various metrics such as this:
    ![monitoring_1](/Performance/100_Monitoring_with_CloudWatch_Dashboards/Images/monitoring_1.png)

1. The upper left shows a list of AWS services you use in your account, along with the state of alarms in those services. In this example, it is showing that we have an EC2 instance in use and it is marked as OK.
    ![monitoring_2](/Performance/100_Monitoring_with_CloudWatch_Dashboards/Images/monitoring_2.png)

1. The upper right shows alarms in your account, which will contain up to four alarms that are in the ALARM state or it will show those that most recently changed state.
    ![monitoring_3](/Performance/100_Monitoring_with_CloudWatch_Dashboards/Images/monitoring_3.png)

    These upper areas enable you to assess the health of your AWS services, by seeing the alarm states in every service and the alarms that most recently changed state. This helps you monitor and quickly diagnose issues.


1. Below these areas is spot for a custom default dashboard that you can create that is named CloudWatch-Default This is a convenient way for you to add metrics about your own custom services or applications to the overview page, or to bring forward additional key metrics from AWS services that you most want to monitor. In this example, we do not have a custom default dashboard created.
    ![monitoring_4](/Performance/100_Monitoring_with_CloudWatch_Dashboards/Images/monitoring_4.png)

    * If you wish, you can click the "Create a new CloudWatch-Default dashboard" to generate a new dashboard and see it displayed in the overview screen.

1. If you use six or more AWS services, below the default dashboard is a link to the automatic cross-service dashboard. The cross-service dashboard automatically displays key metrics from every AWS service you use without requiring you to choose what metrics to monitor or create custom dashboards. You can also use it to drill down to any AWS service and see even more key metrics for that service.
    ![monitoring_5](/Performance/100_Monitoring_with_CloudWatch_Dashboards/Images/monitoring_5.png)

    In this example, we see both EC2 metrics as well as EBS volume metrics for the test machines that were created.
