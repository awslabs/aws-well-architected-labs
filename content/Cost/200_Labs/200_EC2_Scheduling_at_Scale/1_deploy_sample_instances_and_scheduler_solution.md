---
title: "Deploy lab environment and Scheduler solution"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

In this section, we will deploy the [**Instance Scheduler on AWS**](https://aws.amazon.com/solutions/implementations/instance-scheduler-on-aws/) from the AWS Solutions Library. We will also deploy a small sample fleet of EC2 instances that will be our target for the Instance Scheduler solution.

### Architecture Overview

![section1_01_solution](/Cost/200_EC2_Scheduling_at_Scale/Images/section1_01_solution.png)

**Instance Scheduler solution overview**

1. The AWS CloudFormation template provided as part of the [**Instance Scheduler solution**](https://aws.amazon.com/solutions/implementations/instance-scheduler-on-aws/) sets up an Amazon EventBridge schedule rule at a user-defined interval. This rule invokes the Instance Scheduler AWS Lambda function. During configuration, users can define the AWS Regions and accounts, and a custom tag that Instance Scheduler on AWS uses to associate schedules with applicable Amazon EC2, Amazon RDS instances, and clusters.

2. These values are stored in Amazon DynamoDB, and the Lambda function retrieves them each time it runs. You can then apply the custom tag to applicable instances.

3. During the initial configuration of the Instance Scheduler, you can define a tag key you will use to identify applicable Amazon EC2 and Amazon RDS instances. When you create a schedule, the name you specify is used as the tag value that identifies the schedule you want to apply to the tagged resource. For example, a user might use the solution’s default tag name (tag key) "Schedule" and create a schedule called "seattle-office-hours". To identify an instance that will use the "seattle-office-hours" schedule, the user adds the tag named "Schedule" value "seattle-office-hours" to the target EC2 instances.

Notice that, even though the [**Instance Scheduler solution**](https://aws.amazon.com/solutions/implementations/instance-scheduler-on-aws/) supports the scheduling of EC2 instances and RDS instances in multiple AWS accounts and Regions, for this lab we will use the default settings of this solution for scheduling EC2 instances in a single AWS Region, **us-east-1** (N. Virginia).

For more specific details about the solution, please refer to the Instance Scheduler solution [implementation guidance document](https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/solution-overview.html).


#### 1. Log into the AWS console

{{% notice note %}}
This Lab only works in AWS **N.Virginia region (us-east-1)**, while the following instructions assume that you are using **your own AWS account**. If you are attending an in-person workshop and were provided with an AWS account, please follow the instructions from the lab coordinator.
{{% /notice %}}

Sign in to the [AWS Management Console](https://us-east-1.console.aws.amazon.com/console) as an IAM user who has either AdministratorAccess or PowerUserAccess (with full IAM access) permissions to ensure the successful execution of this lab.

#### 2. Sample instance fleet deployment steps

With the below steps, we will deploy 6 EC2 instances. One instance will be the "walab-admin-instance" which will be used in the next sections for running the [scheduler-cli tool](https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/scheduler-cli.html). The other five EC2 instances will be our small sample fleet of DEV instances that we will use as the target for the Instance Scheduler solution.

1. Download the **sample_environment_template.yml** CloudFormation template using the following link:

    * [Download the sample environment template](/Cost/200_EC2_Scheduling_at_Scale/Code/sample_environment_template.yml)

2. Open the CloudFormation console in **us-east-1** region using the following link: https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new

3. Click on **Upload a template file**, and then on **Choose file**. Select the template file downloaded in step 1, named **"sample_environment_template.yml"**. Click on **Next**.

![section1_1_sampleenvstack](/Cost/200_EC2_Scheduling_at_Scale/Images/section1_1_sampleenvstack.png)

4. For the **Stack name**, use ``walab-l200-scheduling-sample-env``. Leave other parameters as default and click on the **Next** button until you get to the Review page.

5. In the **Review** page, scroll down, check the **"I acknowledge that AWS CloudFormation might create IAM resources."** box and click on the **Submit** button.

![section1_2_sampleenvstack](/Cost/200_EC2_Scheduling_at_Scale/Images/section1_2_sampleenvstack.png)

While the **walab-l200-scheduling-sample-env** stack is being deployed. Continue with the below steps to deploy the Instance Scheduler on AWS solution.

#### 3. Instance Scheduler installation steps

1. Use below link to automatically open this solution template in your CloudFormation console in **us-east-1** region:

    * [Launch the Instance Scheduler solution in the AWS Console](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?templateURL=https:%2F%2Fs3.amazonaws.com%2Fsolutions-reference%2Faws-instance-scheduler%2Flatest%2Faws-instance-scheduler.template)

2. Click on the **Next** button.

3. For the **Stack name**, use ``InstanceScheduler``. Leave all other parameters as default.

    **Important**: Use this exact name as will need it later to see the configuration of the schedules.

    {{%expand "Click here to learn more about some of the main parameters we are leaving as default."%}}

---

Here you can see a list of some of the **main parameters** available in the CloudFormation stack of this solution.

* Instance Scheduler tag name: This is the parameter where you can define the name of the Tag that identifies the instances that will be stopped/started by the Instance Scheduler solution. The default value is ``Schedule``, meaning that all the EC2 instances that have a Tag named ``Schedule`` will be targeted by this solution.

* Service(s) to schedule: The Instance Scheduler solution allows automating the starting and stopping of Amazon EC2 and Amazon RDS instances. This parameter lets you select both, or, a specific service to schedule. For this lab we will use the default option which is ``EC2``.

* Schedule Aurora Clusters: In the case the service to schedule was set as ``Both`` or as ``RDS``, this parameter lets you include Amazon Aurora clusters as part of the scheduling. The default is ``No``.

* Create RDS instance snapshot: In the case the service to schedule was set as ``Both`` or as ``RDS``, you can use this parameter to make the solution take a snapshot of the RDS instance before stopping it. The default is ``Yes`` (but, it is only considered for when you are scheduling RDS instances).

* Scheduling enabled: This parameters lets you temporarily turn off the scheduling solution. The default is ``Yes`` (enabled).

* Region(s): The Instance Scheduler solution allows the scheduling of cross-region and cross-account resources. With this parameter you can define a list of Regions where instances will be scheduled. By leaving this parameter as default (``blank``), the solution will use the current region.

* Cross-account roles: When using this Instance Scheduler for scheduling cross-account resources, you need to provide the IAM roles that the solution will assume and use for stopping/starting the instances in those other accounts. This parameter allows you to add a list of cross-account IAM roles ARNs as a comma-delimited list or as a reference to AWS Systems Manager Parameter Store. This parameter is ``blank`` by default.

* This account: You can select ``Yes`` for this parameter when you want the solution to schedule resources in the current account. If the parameter is set to ``No``, then, you must list the IAM roles for the "Cross-account roles" parameter. The default is ``Yes``.

* Frequency: With this parameter you can define the frequency at which the Lambda function (which performs the stopping/starting actions) runs and check for instances that need to be scheduled. The default value is ``5 minutes``, this means that every 5 minutes the solution will check for instances that need to be stopped or started (depending on the schedule defined for those instances). 

* Memory size: This parameter controls the memory size of the Lambda function. Consider increasing this value if you are planning to schedule a large number of instances. The default value is ``128 MB``.

For more information about all the available parameters in this CloudFormation stack, you can refer to the [**Launch the instance scheduler stack**](https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/deployment.html#step1) section of the Implementation Guide for this solution.

Also for more context around the core components of this solution, please refer to the [**Solution components**](https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/components.html) documentation.

---

    {{%/expand%}}

4. Scroll down and click on the **Next** button until you get to the Review page.

5. In the **Review** page, scroll down, check the **"I acknowledge that AWS CloudFormation might create IAM resources."** box and click on the **Submit** button.

6. Finally, go back to the [CloudFormation Stacks console](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks) and wait for both stacks **walab-l200-scheduling-sample-env** and **InstanceScheduler** to be in a **"CREATE_COMPLETE"** status. This might take up to 5 minutes to complete.

![section1_3_sampleenvstack](/Cost/200_EC2_Scheduling_at_Scale/Images/section1_3_sampleenvstack.png)

### Congratulations! 

You have now completed the first section of the lab.

You should have a working lab environment which we will use for the remainder sections of the lab.

Click on **Next Step** to continue with the next section.

{{< prev_next_button link_prev_url="..//" link_next_url="../2_verify_instance_scheduler_configuration/" />}}


