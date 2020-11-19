---
title: "Create CloudWatch Dashboard"
menutitle: "Create CloudWatch Dashboard"
date: 2020-11-19T12:00:00-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
tags:
 - Windows Server
 - Windows
 - EC2
 - CloudWatch
 - CloudWatch Dashboard
---

We have deployed a single Windows EC2 instance and we will now connect via SSM to run a pair of scripts to consume memory and CPU resources so we can see our AWS CloudWatch Dashboard update.


1. From the AWS Console, click the search box and type in CloudWatch (or you can open this link directly https://console.aws.amazon.com/cloudwatch/home)
![CreateDashBoard1](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard1.png?width=50pc)
1. Click on Dashboards link on the left side
![CreateDashBoard2](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard2.png?width=50pc)
1. Click on Create Dashboard button
![CreateDashBoard3](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard3.png?width=50pc)
1. Under Dashboard Name, type in "WindowsEC2Server" and then click "Create Dashboard"
![CreateDashBoard4](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard4.png?width=50pc)
1. You will be presented with dialog box to "Add to the dashboard". Select Line and click Next
![CreateDashBoard5](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard5.png?width=50pc)
1. Select Metrics and click Configure
![CreateDashBoard6](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard6.png?width=50pc)
1. Under "All metrics", scroll down to "Custom Namespaces" and click on "CWAgent"
![CreateDashBoard7](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard7.png?width=50pc)
1. You will find multiple metrics, but we will start with each of the CPU's in the machine.
1. Click on "ImageId, InstanceId, InstanceType, instance, o..."
![CreateDashBoard8](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard8.png?width=50pc)
1. Make sure the Instance Name starts with WindowsMachineDeploy, then click on one of the InstanceId and select "Search for this only".  This will ensure we are only looking at instances created for this lab.
![CreateDashBoard9](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard9.png?width=50pc)
![CreateDashBoard10](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard10.png?width=50pc)
1. Under Metric Name, look for "Processor % User Time" and then click "Add to search". This will limit your choices again to only the CPU metrics for this machine. In this case you should see 2 processors listed, but if the machine you have deployed has more, you will see them each listed.
![CreateDashBoard11](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard11.png?width=50pc)
1. On the left side of the screen, select the box right above the list, this will add both metrics to your graph.
![CreateDashBoard12](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard12.png?width=50pc)
![CreateDashBoard13](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard13.png?width=50pc)

1. Click on the "Graphed Metrics (2)" tab, and on the right side next to Period, select "5 seconds"
![CreateDashBoard14](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard14.png?width=50pc)
![CreateDashBoard15](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard15.png?width=50pc)

1. The metric graph will now update with more data points. Click "Create Widget"
![CreateDashBoard16](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard16.png?width=50pc)
1. You should now see the dashboard we have created displayed with the first metric widget.
![CreateDashBoard17](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard17.png?width=50pc)



{{< prev_next_button link_prev_url="../1_deploy/" link_next_url="../3_adding_metrics_to_dashboard/" />}}
