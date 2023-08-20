---
title: "Scheduling at scale"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

With its default configuration, the Instance Scheduler solution will apply the **"seattle-office-hours"** schedule to all EC2 Instances that have a tag with **Key="Schedule"** and **Value="seattle-office-hours"**. This is the only configuration that needs to be done to stop the instance outside Seattle Office hours. A [Cloud Center of Excellence (CCOE)](https://docs.aws.amazon.com/whitepapers/latest/cost-optimization-laying-the-foundation/cloud-center-of-excellence.html) team could configure this at scale using Tag Editor feature of [AWS Resource Groups](https://docs.aws.amazon.com/tag-editor/latest/userguide/tag-editor.html) with batch of 500 instances, or with custom automation (i.e. with AWS SSM). End users and application owners could do the same for their resources. In the following steps we will use Resource Groups and Tag Editor to configure the tag **Schedule=seattle-office-hours** to all DEV instances in this account/region.

#### Apply the seattle-office-hours schedule to DEV EC2 instances at scale

1. Open the Resource Groups and Tag Editor Console using this link:
    * [Direct link for Resource Groups and Tag Editor console](https://us-east-1.console.aws.amazon.com/resource-groups/home?region=us-east-1#)

2. Click on **Tag Editor** on the left side panel:

![section3_1_scheduleatscale](/Cost/200_EC2_Scheduling_at_Scale/Images/section3_1_scheduleatscale.png)

3. For Resource Types, select ``AWS::EC2::Instance``:

![section3_2_scheduleatscale](/Cost/200_EC2_Scheduling_at_Scale/Images/section3_2_scheduleatscale.png)

4. For the **Tags**, we need to search based on two tags.

    Add a tag named ``walab-environment`` with value ``dev``. Click on the **"Add"** button.

    ![section3_3_1_scheduleatscale](/Cost/200_EC2_Scheduling_at_Scale/Images/section3_3_1_scheduleatscale.png)

    Add another tag named ``aws:autoscaling:groupName`` with value ``(not tagged)``. Click on the **"Add"** button. 
    
    ![section3_3_2_scheduleatscale](/Cost/200_EC2_Scheduling_at_Scale/Images/section3_3_2_scheduleatscale.png)

    By adding the above, we are excluding any EC2 instances that has a tag named ``aws:autoscaling:groupName`` (those launched by EC2 Auto Scaling Groups). We need to exclude any instances that are part of an Auto Scaling Group (ASG) to avoid the Instance Scheduler solution entering into a loop where it will stop instances that an ASG would immediately replace with new ones.

    Now that both tag definitions were added to the search criteria, click on the **"Search resources"** button:

    ![section3_3_3_scheduleatscale](/Cost/200_EC2_Scheduling_at_Scale/Images/section3_3_3_scheduleatscale.png)

5. Scroll down. You should now see the list of dev instances that are present in this account, select them all and click on **"Manage Tags of selected resources"**

![section3_4_scheduleatscale](/Cost/200_EC2_Scheduling_at_Scale/Images/section3_4_scheduleatscale.png)

6. Scroll down until you see the **"Edit tags of all selected resources"** section. Click on the **"Add tag"** button and add new tag key named ``Schedule`` with value ``seattle-office-hours``. Then, click on **"Review and apply tag changes"**. (Note that tags are case sensitive, be aware of any trailing blank spaces)

![section3_5_scheduleatscale](/Cost/200_EC2_Scheduling_at_Scale/Images/section3_5_scheduleatscale.png)

7. You will now see the confirmation window, go ahead and accept the changes:

![section3_6_scheduleatscale](/Cost/200_EC2_Scheduling_at_Scale/Images/section3_6_scheduleatscale.png)

8. Verify that the tag is now present on the EC2 instances, going to EC2 and selecting all instances with the tag **"Schedule=seattle-office-hours"**:
    * [You can use also the following direct link to go to the console](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:tag:Schedule=seattle-office-hours;v=3;$case=tags:true%5C,client:false;$regex=tags:false%5C,client:false;sort=tag:Name)

![section3_7_scheduleatscale](/Cost/200_EC2_Scheduling_at_Scale/Images/section3_7_scheduleatscale.png)

9. You have now configured all DEV EC2 instances in this account and region to be turned off outside of the Seattle office hours. No other action is needed. The scheduler will now take care of stopping eligible EC2 instances outside office hours and starting them back again during office hours.

![section3_8_scheduleatscale](/Cost/200_EC2_Scheduling_at_Scale/Images/section3_8_scheduleatscale.png)

#### Congratulations!

You have completed the last section of this lab!

In this lab you could see how to benefit from the [Instance Scheduler on AWS](https://aws.amazon.com/solutions/implementations/instance-scheduler-on-aws/) solution to increase the elasticity of your AWS infrastructure and follow a [time-based supply approach](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/cost_manage_demand_resources_dynamic.html) for cost optimization. As keeping instances in a stopped state when they are not needed will decrease your costs considerably.

With the default **seattle-office-hours** schedule used in this lab, we have **reduced by 76% the costs** of the DEV workloads. Using the [scheduler-cli](https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/scheduler-cli.html) you could define your own schedules, and instruct the end-users to apply such schedules on their DEV environments. This would shift the responsibility around elasticity for EC2 workloads to the application owners and the end users. You can then measure savings using [AWS Cost Explorer](https://aws.amazon.com/aws-cost-management/aws-cost-explorer/) or the [Cost and Usage Report (CUR)](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html). Cost Explorer and CUR billing data are delayed by ~48hours, so after ~2days you should be able to visualize the savings.

#### Reducing cost by 50 - 70% 

To get a better idea **with another example** on how a time-based supply approach can help in optimizing cost, in below image, you can see how the Cost Explorer report would look like when stopping instances at a large scale, **but only during weekends**.

For this example, a larger fleet of EC2 instances was used, accounting to ~22K USD/day across all instances. Notice that after using Instance Scheduler for stopping a subset of those instances, the cost was reduced to ~15K USD/day during weekends, which equates to a total of ~55K USD/month savings.

![scheduler_costexplorer](/Cost/200_EC2_Scheduling_at_Scale/Images/scheduler_costexplorer.png)

Click on **Next Step** and follow the steps to clean up the resources created in this lab.

{{< prev_next_button link_prev_url="../2_verify_instance_scheduler_configuration/" link_next_url="../4_cleanup/" />}}

