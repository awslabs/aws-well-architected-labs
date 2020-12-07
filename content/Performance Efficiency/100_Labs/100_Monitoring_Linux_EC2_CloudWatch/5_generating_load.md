---
title: "Generate CPU and Memory load"
menutitle: "Generate machine load"
date: 2020-12-01T11:16:08-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
tags:
  - Linux
  - Amazon Linux
  - EC2
  - CloudWatch
  - CloudWatch Dashboard  
---

We have a CloudWatch dashboard to show us CPU and Memory statistics for the deployed EC2 instance. In order to showcase the dashboards, lets add a synthetic load to the machine.

## Stress
For this lab, the EC2 instance will install a utility called stress.  This tool is a workload generator tool designed to subject your system to a configurable measure of CPU, memory, I/O and disk stress.

{{%expand " Click to view the stress command we will use for this test" %}}
```
sudo stress --cpu 8 --vm-bytes $(awk '/MemAvailable/{printf "%d\n", $2 * 0.9;}' < /proc/meminfo)k --vm-keep -m 1
```
{{% /expand%}}

## Generate a Load

1. Open a new tab for the AWS console with this link:
https://console.aws.amazon.com/ec2/v2/home?r#Instances:instanceState=running;tag:Name=LinuxMachineDeploy
1. You should see the EC2 instance we have deployed.
    * _Troubleshooting_: If you do not see the instance, and you changed the CloudFormation stack name when deploying, then delete the **Name: LinuxMachineDeploy** filter and search for the instance with the same name as you used for your stack
![GenerateLoad1](/Performance/100_Monitoring_Linux_EC2_CloudWatch/Images/5/GenerateLoad1.png?classes=lab_picture_small)
1. Click the checkbox next to the machine, and then click "Connect"
![GenerateLoad2](/Performance/100_Monitoring_Linux_EC2_CloudWatch/Images/5/GenerateLoad2.png?classes=lab_picture_small)
1. Select "Session Manager" and then click Connect. This will open a new Linux bash shell to run commands on the EC2 instance.
![GenerateLoad3](/Performance/100_Monitoring_Linux_EC2_CloudWatch/Images/5/GenerateLoad3.png?classes=lab_picture_small)
![GenerateLoad4](/Performance/100_Monitoring_Linux_EC2_CloudWatch/Images/5/GenerateLoad4.png?classes=lab_picture_small)
![GenerateLoad5](/Performance/100_Monitoring_Linux_EC2_CloudWatch/Images/5/GenerateLoad5.png?classes=lab_picture_small)
1. Type ```sudo stress --cpu 8 --vm-bytes $(awk '/MemAvailable/{printf "%d\n", $2 * 0.9;}' < /proc/meminfo)k --vm-keep -m 1``` This will start to consume all of the available memory as well as all CPU's within the machine"
![GenerateLoad6](/Performance/100_Monitoring_Linux_EC2_CloudWatch/Images/5/GenerateLoad6.png?classes=lab_picture_small)
1. Go back to your browser tab that contains the CloudWatch Dashboard. You should see the CPU and Memory graphs change within 10-15 seconds.
    - **cpu_usage_user** goes up as the test script consumes CPU
    - **mem_used** goes up as the script consumes all of it except for a small reserve and should level off right below mem_total
![GenerateLoad7](/Performance/100_Monitoring_Linux_EC2_CloudWatch/Images/5/GenerateLoad7.png?classes=lab_picture_small)
1. As time goes on, it will continue to update the graph. In order to remove the load, go back to each of the console windows and press CTRL-C to stop the stress script.
1. Go back to your browser tab that contains the CloudWatch Dashboard to watch as the CPU load goes down and the amount of free RAM increases.
![GenerateLoad8](/Performance/100_Monitoring_Linux_EC2_CloudWatch/Images/5/GenerateLoad8.png?classes=lab_picture_small)


{{< prev_next_button link_prev_url="../4_adding_metrics_to_dashboard/" link_next_url="../6_cleanup/" />}}
