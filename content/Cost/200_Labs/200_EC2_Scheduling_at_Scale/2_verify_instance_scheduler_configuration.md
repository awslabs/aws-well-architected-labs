---
title: "Verify Instance Scheduler Configuration"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

To configure the scheduler, you can use the scheduler-cli tool that has been preinstalled into the EC2 instances named admin-instance. The admin instance in this workshop is accessible using SSM Session Manager. In order to login to the admin-instance follow the steps below:

1. Open the EC2 Console using this link
    * [Direct link for EC2 Console admin instance](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:instanceState=running;tag:Name=admin-instance;v=3;$case=tags:true%5C,client:false;$regex=tags:false%5C,client:false)

2. Select the admin instance, clicking on the checkbox on the left

3. Click on Connect

![connect_to_admin_instance_1](/Cost/200_EC2_Scheduling_at_Scale/Images/connect_to_admin_instance_1.png)

4. Click on Session Manager as a connection method

5. Click on Connect

![connect_to_admin_instance_2](/Cost/200_EC2_Scheduling_at_Scale/Images/connect_to_admin_instance_2.png)

6. You have now logged in, into the admin-instance, without using SSH or a bastion and you can configure AWS Instance Scheduler using the ``scheduler-cli`` command.
    * Note: AWS Instance Scheduler can stop/start EC2 and RDS instances based on a customizable set of schedules. Schedules might contain several periods.

7. Execute the ``scheduler-cli -h`` command to see the available options of the cli, including how to list the preinstalled schedules and timeperiods.

![connect_to_admin_instance_3](/Cost/200_EC2_Scheduling_at_Scale/Images/connect_to_admin_instance_3.png)

8. In this workshop we will leverage the predefined schedules, defining new schedules is outside the scope of this workshop. Execute the following command to see the schedules that are preinstalled:
    * ``scheduler-cli describe-schedules --region us-east-1 --stack InstanceScheduler``

![connect_to_admin_instance_4](/Cost/200_EC2_Scheduling_at_Scale/Images/connect_to_admin_instance_4.png)

9. We will use the preinstalled schedule named ``seattle-office-hours``, this schedule will stop the instances with a tag key: ``Schedule``, and a tag value ``seattle-office-hours`` outside the period ``office-hours`` in the timezone ``US/Pacific``

![connect_to_admin_instance_5](/Cost/200_EC2_Scheduling_at_Scale/Images/connect_to_admin_instance_5.png)

10. Execute the command ``scheduler-cli describe-periods --region us-east-1 --stack InstanceScheduler`` to see the list of periods preconfigured

![connect_to_admin_instance_6](/Cost/200_EC2_Scheduling_at_Scale/Images/connect_to_admin_instance_6.png)

11. The period ``office-hours`` highlighted defines the period for which the instances associated with it should be running from 9.00 AM to 5.00 PM, Monday to Friday. Using this schedule for the DEV instances will allow to save costs and reduce energy consumption by 77% as they will run only 23% of the time (8 hours per day * 5 days).
    * In other words, every week, the instance with the tag Schedule=seattle-office-hours will run for ``8*5=40 hours`` instead of ``24*7=168 hours``

#### Conclusions

Congratulations, you have now completed the first section of the lab.

In this scenario we have optimized the cost and sustainability footprint of the dev EC2 instances using AWS instance Scheduler.

This concludes the first scenario of "EC2 Scheduling at scale" for the **Optimizing EC2 Usage and Spend** section of this lab.

Click 'Next Step' to continue to clean up the resources created.

{{< prev_next_button link_prev_url="../1_deploy_sample_instances_and_scheduler_solution/" link_next_url="../3_scheduling_at_scale/" />}}

