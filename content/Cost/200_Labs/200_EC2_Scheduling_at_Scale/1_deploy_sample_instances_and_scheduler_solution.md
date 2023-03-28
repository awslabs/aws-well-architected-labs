---
title: "Deploy lab environment and Scheduler solution"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

In this section, we will deploy the [**Instance Scheduler on AWS**](https://aws.amazon.com/solutions/implementations/instance-scheduler-on-aws/) from the AWS Solutions Library. And also small sample fleet of EC2 instances that we will use as the target for the Instance Scheduler solution.

### Architecture Overview

![section1_01_solution](/Cost/200_EC2_Scheduling_at_Scale/Images/section1_01_solution.png)

**Instance Scheduler on the AWS Cloud**

1. The AWS CloudFormation template provided as part of the [**Instance Scheduler solution**](https://aws.amazon.com/solutions/implementations/instance-scheduler-on-aws/) sets up an Amazon EventBridge schedule rule at a user-defined interval. This event invokes the Instance Scheduler AWS Lambda function. During configuration, the user defines the AWS Regions and accounts, as well as a custom tag that Instance Scheduler on AWS uses to associate schedules with applicable Amazon EC2, Amazon RDS instances, and clusters.

2. These values are stored in Amazon DynamoDB, and the Lambda function retrieves them each time it runs. You can then apply the custom tag to applicable instances.

3. During initial configuration of the Instance Scheduler, you can define a tag key you will use to identify applicable Amazon EC2 and Amazon RDS instances. When you create a schedule, the name you specify is used as the tag value that identifies the schedule you want to apply to the tagged resource. For example, a user might use the solution’s default tag name (tag key) "Schedule" and create a schedule called "seattle-office-hours". To identify an instance that will use the "seattle-office-hours" schedule, the user adds the tag named "Schedule" value "seattle-office-hours" to the target EC2 instances.

Notice that even though, the [**Instance Scheduler solution**](https://aws.amazon.com/solutions/implementations/instance-scheduler-on-aws/) supports the scheduling of EC2 instances and RDS instances in multiple AWS accounts and Regions, for this lab we will use the default settings for this solution for scheduling EC2 instances in a single AWS Region.

For more specific details about the solution, please refer to the Instance Scheduler solution [implementation guidance document](https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/solution-overview.html).


#### 1. Log into the AWS console

{{% notice note %}}
This Lab only works in AWS **N.Virginia region (us-east-1)**, while the following instructions assume that you are using **your own AWS account**. If you are attending an in-person workshop and were provided with an AWS account, please follow the instructions from the lab coordinator.
{{% /notice %}}

Sign in to the [AWS Management Console](https://us-east-1.console.aws.amazon.com/console) as an IAM user who has either AdministratorAccess or PowerUserAccess (with full IAM access) permissions to ensure successful execution of this lab.

#### 2. Sample instance fleet deployment steps

1. Download the **sample_environment_template.yml** CloudFormation template using the following link:

    * [Download the sample environment template](/Cost/200_EC2_Scheduling_at_Scale/Code/sample_environment_template.yml)

2. Open the CloudFormation console in **us-east-1** region using the following link: https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new

3. Click on **Upload a template file**, and then on **Choose file**. Select the template file downloaded in step 1, named **"sample_environment_template.yml"**. Click on **Next**.

![section1_1_sampleenvstack](/Cost/200_EC2_Scheduling_at_Scale/Images/section1_1_sampleenvstack.png)

4. For the **Stack name**, use ``walab-l200-scheduling-sample-env``. Leave other parameters as default and click on **Next** button twice.

5. In the **Review** page, scroll down, check the **"I acknowledge that AWS CloudFormation might create IAM resources."** box and click on the **Submit** button.

![section1_2_sampleenvstack](/Cost/200_EC2_Scheduling_at_Scale/Images/section1_2_sampleenvstack.png)

While the **walab-l200-scheduling-sample-env** stack is being deployed. Continue to the next section below to deploy the [Instance Scheduler on AWS solution](https://aws.amazon.com/solutions/implementations/instance-scheduler-on-aws/).

#### 3. Instance Scheduler installation steps

1. Use below link to automatically open this solution template in your CloudFormation console in **us-east-1** region:

    * [Launch Instance Scheduler solution in the AWS Console](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?templateURL=https:%2F%2Fs3.amazonaws.com%2Fsolutions-reference%2Faws-instance-scheduler%2Flatest%2Faws-instance-scheduler.template)

2. Click on the **Next** button.

3. For the **Stack name**, use ``InstanceScheduler``. Leave all other parameters as default.

    **Important**: Use this exact name as will need it later to see the configuration of the schedules.

4. Scroll down and click on the **Submit** button twice.

5. In the **Review** page, scroll down, check the **"I acknowledge that AWS CloudFormation might create IAM resources."** box and click on the **Submit** button.

![section1_2_sampleenvstack](/Cost/200_EC2_Scheduling_at_Scale/Images/section1_2_sampleenvstack.png)

6. Finally, go back to the [CloudFormation Stacks console](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks) and wait for both **walab-l200-scheduling-sample-env** and **InstanceScheduler** to be in a **"CREATE_COMPLETE"** status. This might take up to 5 minutes to complete.


### Congratulations! 

You have now completed the first section of the Lab.

You should have a working lab environment which we will use for the remainder of the lab.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="..//" link_next_url="../2_verify_instance_scheduler_configuration/" />}}


