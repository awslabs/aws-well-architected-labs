---
title: "Attach CloudWatch IAM role to selected EC2 Instances"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

1. We are now going to attach the IAM Role created on the previous step in one of our EC2 Instances, to do that let's go to the **Amazon EC2 Dashboard**.
![Images/MemInstall01.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall01.png?classes=lab_picture_small)

2. From the EC2 Dashboard, scroll down a bit an click on **Launch Instance**
![Images/MemInstall02a.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall02.png?classes=lab_picture_small)

3. Select **Linux 2 AMI (HVM)**
![Images/MemInstall02b.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall02a.png?classes=lab_picture_small)

4. Select **t2.micro** (free tier eligible) and click **review and launch**:
![Images/MemInstall02b.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall02c.png?classes=lab_picture_small)

5. Click **Launch**
![Images/MemInstall02b.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall02b.png?classes=lab_picture_small)

6. Select **Proceed without a key pair**

7. After the instance is launched and running, select the instance you want to start collecting Memory data and go to **Actions** on the top bar, select **Security >> Modify IAM role**.
![Images/MemInstall03.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall03.png?classes=lab_picture_small)

8. Look for the created IAM role *CloudWatchAgentServerRole* under the **IAM role** box, select it and apply.
![Images/MemInstall04.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall04.png?classes=lab_picture_small)

9. Click on the Instance ID and validate the IAM role *CloudWatchAgentServerRole* is attached to the instance
![Images/MemInstall06.png](/Cost/200_AWS_Resource_Optimization/Images/MemInstall06.png?classes=lab_picture_small)

{{< prev_next_button link_prev_url="../2_create_iamrole/" link_next_url="../4_memory_plugin/" />}}
