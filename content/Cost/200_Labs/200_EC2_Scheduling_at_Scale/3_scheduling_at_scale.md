---
title: "Scheduling at scale"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

By now...

This scenario covers use cases where the compute power is not needed 24x7 and can be scheduled.

Your team needs to evaluate and optimize the cost and sustainability footprint of the current EC2 deployed instances as per CTO objectives:

"Use resources when they are needed: optimize idle workloads in development environments, no need to have them running when the developers are not using them".

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

{{< prev_next_button link_prev_url="../2_verify_instance_scheduler_configuration/" link_next_url="../4_cleanup/" />}}

