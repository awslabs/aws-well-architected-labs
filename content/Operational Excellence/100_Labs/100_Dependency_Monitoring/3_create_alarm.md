---
title: "Create an Alarm"
menutitle: "Create Alarm"
date: 2020-09-15T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

Now that the right metric has been identified to monitor the dependency, it is time to create an alarm to monitor the metric and send notifications based on thresholds defined. [CloudWatch Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch_concepts.html#CloudWatchAlarms) can be used to automatically initiate actions on your behalf. An alarm watches a single metric over a specified time period, and performs one or more specified actions, based on the value of the metric relative to a threshold over time. The action is a notification sent to an Amazon SNS topic or an Auto Scaling policy.

An alarm needs to be created that checks the Lambda function invocation every minute to ensure that it has been invoked at least one time, and treats missing data as an indication that the function has not not been invoked, and as such the dependency that is being monitoring has failed. If the alarm is triggered, a notification should be sent to an SNS topic so that someone can be notified and respond, or an automatic remediation activity can be triggered as a result.

1. Go to the Amazon CloudWatch console at <https://console.aws.amazon.com/cloudwatch>, click on **Alarms**, and then **Create alarm**

    ![CWAlarms](/Operations/100_Dependency_Monitoring/Images/CWAlarms.png)

1. Click on **Select metric**
1. In the search bar under **All metrics**, enter the name of the data read function - `WA-Lab-DataReadFunction` and press enter
1. In the metric breakdown, select **Lambda > By Resource** and you will see a list of Lambda metrics available
1. Check the box for the metric **Invocations** and click **Select metric**

    ![CWAlarmSelectMetric](/Operations/100_Dependency_Monitoring/Images/CWAlarmSelectMetric.png)

1. On the **Specify metric and conditions** page, make the following changes for the **Metric**:

    * Change **Statistic** from Average to Sum
    * Change **Period** from 5 minutes to 1 minute

    ![CWAlarmSelectPeriod](/Operations/100_Dependency_Monitoring/Images/CWAlarmSelectPeriod.png)

1. Scroll down to the **Conditions** section and configure it as follows:

    * **Threshold type** - set to Static
    * **Whenever invocations is...** - set to Lower
    * **than...** - enter 1 since this is the minimum number of invocations that is expected every minute

1. Click on the arrow next to **Additional Configuration** to expand that section and make the following configuration changes:

    * **Datapoints to alarm** should be 1 out of 1
    * **Missing data treatment** should be set to Treat missing data as bad (breaching threshold) since Lambda will not report any metrics if a function was not invoked

1. Click **Next** to go to the **Configure actions** page

    ![CWAlarmConditions](/Operations/100_Dependency_Monitoring/Images/CWAlarmConditions.png)

1. Under **Notification**, make the following changes:

    * **Alarm state trigger** - select In alarm
    * **Select an SNS topic** - choose Select an existing SNS topic since a topic was created as part of the CloudFormation stack
    * **Send a notification to...** - select WA-Lab-Dependency-Notification and verify that the **Email (endpoints)** listed below is the same that was specified during stack creation

1. Click **Next** to go to the **Add name and description** page

    ![CWAlarmAction](/Operations/100_Dependency_Monitoring/Images/CWAlarmAction.png)

1. Under **Name and description**, specify the following:

    * **Alarm name** - enter a recognizable name for the alarm such as `WA-Lab-Dependency-Alarm`
    * **Alarm description** - this is an optional field that can be left blank for this exercise

    ![CWAlarmName](/Operations/100_Dependency_Monitoring/Images/CWAlarmName.png)

1. Click **Next** to go to the **Preview and create** page
1. Click **Create alarm**

Once the alarm has been created, you will be returned to the **Alarms** page on the CloudWatch console. In the search bar, enter the name of the alarm that was just created WA-Lab-Dependency-Alarm. The alarm will be listed with a state of **Insufficient data**. This is because CloudWatch is currently evaluating the underlying metric to determine the current state. In a few minutes, you will see the alarm transition from **Insufficient data** to **OK**. Click on the alarm name to go to the alarm details page. Review contents of the page to understand the configuration of the alarm such as metric used, threshold set, evaluation interval, etc. The red line on the graph indicates the threshold that has been set for the alarm. Based on the alarm conditions, the alarm will go into an **In alarm** state if the metric graph falls below this threshold.

![CWAlarmInsufficientData](/Operations/100_Dependency_Monitoring/Images/CWAlarmInsufficientData.png)

Under the **History** section, you will be able to view all state changes with respect to the alarm. Once the alarm is in an **OK** state, you will see a **State update** event under **History**.

![CWAlarmStateChange](/Operations/100_Dependency_Monitoring/Images/CWAlarmStateChange.png)

An alarm has now been created on a suitable metric to identify if the external service that the workload is dependent on is experiencing outage. Additionally, notifications have been configured to alert relevant stakeholders when the workload outcome is at risk due to failure/unavailability of the external service.

![ArchitectureLast](/Operations/100_Dependency_Monitoring/Images/ArchitectureLast.png)
