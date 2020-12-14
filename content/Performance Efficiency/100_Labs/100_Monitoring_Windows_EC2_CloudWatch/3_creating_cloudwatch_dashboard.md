---
title: "Create CloudWatch Dashboard"
menutitle: "Create CloudWatch Dashboard"
date: 2020-11-19T12:00:00-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
tags:
 - Windows Server
 - Windows
 - EC2
 - CloudWatch
 - CloudWatch Dashboard
---

We have deployed a single Windows 2 EC2 instance and we will now create a CloudWatch Dashboard to monitor the memory and CPU resources consumed by the instance.


1. From the AWS Console, click the search box and type in CloudWatch (or you can open this link directly https://console.aws.amazon.com/cloudwatch/home)
![CreateDashBoard1](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard1.png?classes=lab_picture_small)
1. Click on Dashboards link on the left side
![CreateDashBoard2](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard2.png?classes=lab_picture_small)
1. Click on Create Dashboard button
{{% notice info %}}
If you have not done so already, make sure to click "Try out the new interface" to see the updated CloudWatch interface.
{{% /notice %}}
![CreateDashBoard3](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard3.png?classes=lab_picture_small)
1. Under Dashboard Name, type in "WindowsEC2Server" and then click "Create Dashboard"
![CreateDashBoard4](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard4.png?classes=lab_picture_small)
1. You will be presented with dialog box to "Add to the dashboard". Select Line and click Next
![CreateDashBoard5](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard5.png?classes=lab_picture_small)
1. Select Metrics and click Configure
![CreateDashBoard6](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard6.png?classes=lab_picture_small)
1. Under "All metrics", scroll down to "Custom Namespaces" and click on "CWAgent"
![CreateDashBoard7](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard7.png?classes=lab_picture_small)
1. You will find multiple metrics, but we will start with each of the CPU's in the machine.
1. Click on "ImageId, InstanceId, InstanceType, instance, o..."
![CreateDashBoard8](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard8.png?classes=lab_picture_small)
1. Make sure the Instance Name starts with WindowsMachineDeploy, then click on one of the InstanceId and select "Search for this only".  This will ensure we are only looking at instances created for this lab.
![CreateDashBoard9](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard9.png?classes=lab_picture_small)
![CreateDashBoard10](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard10.png?classes=lab_picture_small)
1. Under Metric Name, look for "Processor % User Time" and then click "Add to search". This will limit your choices again to only the CPU metrics for this machine. In this case you should see 2 processors listed, but if the machine you have deployed has more, you will see them each listed.
![CreateDashBoard11](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard11.png?classes=lab_picture_small)
1. On the left side of the screen, select the box right above the list, this will add both metrics to your graph.
![CreateDashBoard12](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard12.png?classes=lab_picture_small)
![CreateDashBoard13](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard13.png?classes=lab_picture_small)

1. Click on the "Graphed Metrics (2)" tab, and on the right side next to Period, select "5 seconds"
![CreateDashBoard14](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard14.png?classes=lab_picture_small)
![CreateDashBoard15](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard15.png?classes=lab_picture_small)

1. The metric graph will now update with more data points. Click "Create Widget"
![CreateDashBoard16](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard16.png?classes=lab_picture_small)
1. You should now see the dashboard we have created displayed with the first metric widget.
![CreateDashBoard17](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Images/2/CreateDashBoard17.png?classes=lab_picture_small)



{{< prev_next_button link_prev_url="../2_deploy_instance/" link_next_url="../4_adding_metrics_to_dashboard/" />}}
