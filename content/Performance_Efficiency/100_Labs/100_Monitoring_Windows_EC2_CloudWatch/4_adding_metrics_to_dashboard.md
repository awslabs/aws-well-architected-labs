---
title: "Add metrics to Dashboard"
menutitle: "Add metrics to Dashboard"
date: 2020-11-19T12:00:00-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
tags:
 - Windows Server
 - Windows
 - EC2
 - CloudWatch
 - CloudWatch Dashboard
---

Now that we have a dashboard for our Windows EC2 instance, we can add an additional metric for available memory.

1. Let's add a new widget to our CloudWatch Dashboard. Click on the "Add Widget" button in the upper right corner.
![AddMetricsToDash1](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/3/AddMetricsToDash1.png?classes=lab_picture_small)
1. Click Line, then next
1. Click Metrics and then Configure
1. Select CWAgent and then select the second metric group "ImageId, InstanceId, InstanceType, objectname"
1. Make sure to search only for the InstanceId if you have multiple machines reporting metrics
1. Find the "Memory available Mbytes" and click the check box next to it.
![AddMetricsToDash2](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/3/AddMetricsToDash2.png?classes=lab_picture_small)
1. Click on "Graphed Metrics (1)" and then select "5 seconds" as the period
1. Click on Create widget
![AddMetricsToDash3](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/3/AddMetricsToDash3.png?classes=lab_picture_small)
1. You should now see two widgets on your Dashboard.
![AddMetricsToDash4](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/3/AddMetricsToDash4.png?classes=lab_picture_small)
1. You can drag the widgets around the screen and re-size them if you wish.
![AddMetricsToDash5](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/3/AddMetricsToDash5.png?classes=lab_picture_small)
1. You can also change the time period, select 1h to show just the most recent metrics
![AddMetricsToDash6](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/3/AddMetricsToDash6.png?classes=lab_picture_small)
1. You can also set the auto-refresh rate for the Dashboard by using this pull-down. Select 10s
![AddMetricsToDash7](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/3/AddMetricsToDash7.png?classes=lab_picture_small)
1. Click the "Save Dashboard" button before proceeding to the next step.

{{< prev_next_button link_prev_url="../3_creating_cloudwatch_dashboard/" link_next_url="../5_generating_load/" />}}
