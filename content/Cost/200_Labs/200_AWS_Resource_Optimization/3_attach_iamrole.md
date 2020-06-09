---
title: "Attach CloudWatch IAM role to selected EC2 Instances"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

1. We are now going to attach the IAM Role created on the previous step in one of our EC2 Instances, to do that let's go to the **Amazon EC2 Dashboard**.
![Images/MemInstall01.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall01.png)

2. On the left bar, click on **Instances**.
![Images/MemInstall02.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall02.png)

3. Click on **Launch Instance** and select **Linux 2 AMI (HVM)** and **t2.micro** (free tier eligible) on the following screens. Click **Review and launch**:
![Images/MemInstall02a.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall02a.png)
![Images/MemInstall02b.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall02b.png)

4. Click **Launch**

5. Select **Proceed without a key pair**

Complete this step by launching this testing t2.micro EC2 instance. In order to install the CloudWatch agent We will need to access this instance using the browser-based SSH native AWS connection tool so make sure that the port 22 is not blocked in the Security Group attached to this instance.

4. After the instance is launched and runnning, select the instance you want to start collecting Memory data by going to **Actions** on the top bar, select **Instance Settings>>Attach/Replace IAM Role**.
![Images/MemInstall03.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall03.png)

5. Look for the created IAM role *CloudWatchAgentServerRole* under the **IAM role** box, select it and apply.
![Images/MemInstall04.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall04.png)

6. Confirm that the *CloudWatchAgentServerRole* was sucessfully attached to your **EC2 instance**
![Images/MemInstall05.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall05.png)

7. Validade if the IAM role *CloudWatchAgentServerRole* is attached to the desired instance
![Images/MemInstall06.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall06.png)
