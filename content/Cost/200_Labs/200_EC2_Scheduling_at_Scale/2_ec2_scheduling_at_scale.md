---
title: "EC2 Scheduling at scale"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

This scenario covers use cases where the compute power is not needed 24x7 and can be scheduled.

Your team needs to evaluate and optimize the cost and sustainability footprint of the current EC2 deployed instances as per CTO objectives:

"Use resources when they are needed: optimize idle workloads in development environments, no need to have them running when the developers are not using them".

#### Optimization Goal

* Leverage the AWS Instance Scheduler to implement a schedule with the following requirements:
    * EC2 instances with "environment" Tag set to "dev" should always be in stopped state outside Seattle business hours

We will use the [AWS Instance Scheduler solution](https://aws.amazon.com/solutions/implementations/instance-scheduler-on-aws/) to achieve the goal above. Note, for security reasons, the role you are assuming to access the workshop account, does not allow to create IAM resources, which is a requirement for the AWS instance Scheduler public cloudformation template. We have customized the environment with a special version of AWS Instance Scheduler cloudformation for this workshop. Use the cloudformation template provided in the instruction in the next step instead of the official one otherwise you will not be able to install Instance Scheduler in this account.

#### Instance Scheduler installation steps

1. Download instance scheduler template using the following link, with a template created on purpose for this workshop. In production you should use the official template referenced at the end of the page. Save this template on your local computer.

    * [Download the cloudformation for InstanceScheduler](https://static.us-east-1.prod.workshops.aws/public/074b7ca8-8f0c-4a8f-b17c-8412087636b1/assets/aws-instance-scheduler-sup304v2.template)

2. Open the CloudFormation console using the following link: https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new 

3. Click on upload a ``template file``

4. Click on the ``Choose File`` button

5. Choose the file downloaded in step 1, by default the name is ``aws-instance-scheduler-sup304v2.template``

![install_instance_scheduler_1](/Cost/200_EC2_Scheduling_at_Scale/Images/install_instance_scheduler_1.png)

6. Click on next

7. Enter "InstanceScheduler" as a stack name. We will need the name later to see configuration of the schedules.

![install_instance_scheduler_2](/Cost/200_EC2_Scheduling_at_Scale/Images/install_instance_scheduler_2.png)

8. Scroll down and click on next

9. Scroll down and click on next once again

10. Scroll up and crosscheck that the name of the cloudformation stack is "InstanceScheduler", if this the case the first title at the very top of the page will be "Review InstanceScheduler"

![install_instance_scheduler_3](/Cost/200_EC2_Scheduling_at_Scale/Images/install_instance_scheduler_3.png)

11. If the name of the cloudformation stack is "InstanceScheduler", scroll down and click on ``Submit``, otherwise go back and change the name of the stack to "InstanceScheduler"

![install_instance_scheduler_4b](/Cost/200_EC2_Scheduling_at_Scale/Images/install_instance_scheduler_4b.png)

12. Make sure that the cloudformation stack is deployed successfully before continuing with the next steps. This might take up to 5 minutes to complete.

#### Verify Instance Scheduler Configuration

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

#### Apply the seattle-office-hours schedule to DEV EC2 instances at scale

AWS Instance Scheduler will apply the ``seattle-office-hours`` schedule to all EC2 Instances that have a tag with Key="Schedule" and Value="seattle-office-hours". This is the only configuration that needs to be done to stop the instance outside Seattle Office hours. The Cloud Center of Excellence (CCOE) Team could configure this at scale using Tag Editor with batch of 500 instances, or with custom automations (i.e. with AWS SSM). End Users and application owners could do the same for their resources. In the following steps we will use Resource Groups and Tag Editor to configure the tag Schedule=seattle-office-hours to all DEV instances in this account/region.

1. Open the Resource Groups and Tag Editor Console using this link:
    * [Direct link for Resource Groups and Tag Editor console](https://us-east-1.console.aws.amazon.com/resource-groups/home?region=us-east-1#)

2. Click on Tag Editor on the left side panel

![add_tag_schedule_at_scale1](/Cost/200_EC2_Scheduling_at_Scale/Images/add_tag_schedule_at_scale1.png)

3. Select as Resource Types ``AWS::EC2::Instance``

![add_tag_schedule_at_scale2](/Cost/200_EC2_Scheduling_at_Scale/Images/add_tag_schedule_at_scale2.png)

4. Set as TAG key the ``environment`` tag, and as tag value ``dev``, then click on "Add" and then on "Search resources"

![add_tag_schedule_at_scale3](/Cost/200_EC2_Scheduling_at_Scale/Images/add_tag_schedule_at_scale3.png)

5. Scroll down, you should now see the list of dev instances that are present in this account, select them all and click on "Manage Tags of selected resources"

![add_tag_schedule_at_scale4](/Cost/200_EC2_Scheduling_at_Scale/Images/add_tag_schedule_at_scale4.png)

6. Scroll down once you see the "Edit Tags for all selected resources" section, let's add there the tag key "Schedule" with value "seattle-office-hours". In order to do so, click on Add Tag and insert the Key "Schedule" and as Value "seattle-office-hours" and click on "Review and apply tag changes". Note that tags are case sensitive, be aware of trailing blank spaces!

![add_tag_schedule_at_scale5](/Cost/200_EC2_Scheduling_at_Scale/Images/add_tag_schedule_at_scale5.png)

7. You will now see the confirmation window, go ahead and accept the changes:

![add_tag_schedule_at_scale6](/Cost/200_EC2_Scheduling_at_Scale/Images/add_tag_schedule_at_scale6.png)

8. Verify that the tag is now present on the EC2 instances, going to EC2 and selecting all instances with the tag "Schedule=seattle-office-hours"
    * [You can use also the following direct link to go to the console](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:tag:Schedule=seattle-office-hours;v=3;$case=tags:true%5C,client:false;$regex=tags:false%5C,client:false;sort=tag:Name)

![add_tag_schedule_at_scale7](/Cost/200_EC2_Scheduling_at_Scale/Images/add_tag_schedule_at_scale7.png)

9. You have now configured all DEV EC2 instances in this account to be turned off outside Seattle office hours! No other action is needed. The scheduler will now take care of stopping eligible EC2 instances outside office hours and starting them back again during office hours.

#### Considerations

You can benefit from Instance Scheduler to increase the elasticity of your AWS infrastructure, keeping instances in a stopped state when they are not needed will decrease both your carbon footprint and your costs. With the default schedule ``seattle-office-hours`` we have reduced by 77% the costs and the energy consumptions of the DEV workloads. Using the ``scheduler-cli`` you could define your own schedules, and instruct the end-users to apply such schedules on their dev environments. This will shift the responsibility around elasticity for EC2 workloads to the application owners and the end users. You can then measure savings using Cost Explorer or the Cost and Usage Report (CUR). Cost Explorer and CUR billing data are delayed by ~48hours, after ~2days you will be able to visualize the savings. Have a look how cost explorer will look like, when stopping instances during weekend, at a large scale. You can see the daily costs for EC2 instances at ~22K USD/day during weekdays and ~15K USD/day during weekends, which consists of ~55K USD/month savings, in the following example:

![scheduler_costexplorer](/Cost/200_EC2_Scheduling_at_Scale/Images/scheduler_costexplorer.png)

#### Conclusions

Congratulations, you have now completed the first section of the lab.

In this scenario we have optimized the cost and sustainability footprint of the dev EC2 instances using AWS instance Scheduler.

This concludes the first scenario of "EC2 Scheduling at scale" for the **Optimizing EC2 Usage and Spend** section of this lab.

Click 'Next Step' to continue to clean up the resources created.

{{< prev_next_button link_prev_url="../1_deploy_ssm_application_environment/" link_next_url="../3_cleanup/" />}}

