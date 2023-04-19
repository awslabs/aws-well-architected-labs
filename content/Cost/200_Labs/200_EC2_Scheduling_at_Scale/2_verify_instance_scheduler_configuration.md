---
title: "Verify Instance Scheduler Configuration"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

With a sample environment deployed, we can now proceed to verify the default configuration available for the Instance Scheduler solution.

To configure the scheduler, you can use the [scheduler-cli tool](https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/scheduler-cli.html) preinstalled into an EC2 instance in the sample environment named ``walab-admin-instance``. The admin instance in this lab is accessible using SSM Session Manager. In order to login to the **walab-admin-instance** instance follow the steps below:

1. Open the EC2 Console using below link:
    * [Direct link for EC2 Console "walab" instances](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:instanceState=running,stopped,stopping;tag:Name=:walab-;v=3;$case=tags:true%5C,client:false;$regex=tags:false%5C,client:false)

2. Select the instance named **walab-admin-instance**, and click on the **Connect** button:

![section2_1_schedulerconfiguration](/Cost/200_EC2_Scheduling_at_Scale/Images/section2_1_schedulerconfiguration.png)

3. Click on **Session Manager** as a connection method, and click on **Connect**:

![section2_2_schedulerconfiguration](/Cost/200_EC2_Scheduling_at_Scale/Images/section2_2_schedulerconfiguration.png)

4. You have now logged in into the **walab-admin-instance**, without using SSH or a bastion, and you can configure the Instance Scheduler solution using the ``scheduler-cli`` command line.
    * Note: The Instance Scheduler can stop/start EC2 and RDS instances based on a customizable set of schedules. Schedules might contain several periods. Refer to the [Sample schedule documentation](https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/sample-schedule.html) for more information.

5. Execute below command to see the available options of the cli, including how to list the preinstalled schedules and time periods:

```
scheduler-cli -h
```

![section2_3_schedulerconfiguration](/Cost/200_EC2_Scheduling_at_Scale/Images/section2_3_schedulerconfiguration.png)

6. In this lab we will leverage the predefined schedules, defining new schedules is outside the scope of this lab. Execute the following command to see the schedules that are preinstalled:

```
scheduler-cli describe-schedules --region us-east-1 --stack InstanceScheduler
```

![section2_4_schedulerconfiguration](/Cost/200_EC2_Scheduling_at_Scale/Images/section2_4_schedulerconfiguration.png)

7. We will use the preinstalled schedule named **"seattle-office-hours"**, this schedule will stop the instances with a tag key **"Schedule"**, and a tag value **"seattle-office-hours"** outside the period **"office-hours"** in the timezone **"US/Pacific"**:

![section2_5_schedulerconfiguration](/Cost/200_EC2_Scheduling_at_Scale/Images/section2_5_schedulerconfiguration.png)

8. Execute below command to see the list of periods pre-configured:

```
scheduler-cli describe-periods --region us-east-1 --stack InstanceScheduler
```

![section2_6_schedulerconfiguration](/Cost/200_EC2_Scheduling_at_Scale/Images/section2_6_schedulerconfiguration.png)

9. The period **"office-hours"** highlighted above defines the period for which the instances associated with it should be running: From 9:00 AM to 5:00 PM, Monday to Friday. 

    Using this schedule for any **"dev"** (non-prod) instances will allow to save costs and reduce energy consumption by 76% as they will run only 24% of the time (8 hours per day * 5 days).
    
    In other words, every week, instances that include the tag key/value **"Schedule=seattle-office-hours"** will run for **8*5=40 hours** instead of **24*7=168 hours**.

---

You have now completed this section of the lab.

In the next section we will explore how to use the [AWS Resource Groups Tag Editor](https://docs.aws.amazon.com/tag-editor/latest/userguide/tag-editor.html) in combination with the Instance Scheduler solution for making sure our **"dev"** (non-prod) instances are shut-down outside of business hours.

Click on **Next Step** to continue with the next section.

{{< prev_next_button link_prev_url="../1_deploy_sample_instances_and_scheduler_solution/" link_next_url="../3_scheduling_at_scale/" />}}

