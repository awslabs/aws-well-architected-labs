---
title: "Deploy lab environment and Scheduler solution"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

In this section, you will deploy the lab environment. Once the solution has been implemented, you will be able to embed AWS Health API insights into the test operational change process to automatically suspend operational changes whenever an AWS Health event is reported in a Region that you’re operating in.

### Architecture Overview

The solution leverages the following AWS Services and features in your AWS Account:

* [AWS Systems Manager Change Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/change-manager.html) which is an enterprise change management framework for requesting, approving, implementing, and reporting on operational changes to your application configuration and infrastructure. 
* AWS Systems Manager [automation runbook](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-documents.html) helps you to build automated solutions to deploy, configure, and manage AWS resources at scale.
* AWS Health provides ongoing visibility into the availability of your AWS services, where you can programmatically retrieve those availability data via [AWS Health API](https://docs.aws.amazon.com/health/latest/ug/health-api.html).

![Section1 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section1_solution_architect.png)

You will use AWS CloudFormation to provision some resources needed for this lab. As part of this lab, the CloudFormation stack that you provision will create a Systems Manager automation runbook, a SNS notification topic, a test EC2 instance, an IAM user to approve the SSM Change Template, and other relevant IAM roles and permissions. You can view the CloudFormation template [here](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Code/cfn_health_aware_ssm_stack.yaml) for a complete list of all resources that are provisioned. This lab will only work in us-east-1.

### 1.1 Log into the AWS console

{{% notice note %}}
This Lab only works in AWS **N.Virginia region (us-east-1)**, while the following instructions assume that you are using **your own AWS account**. If you are attending an in-person workshop and were provided with an AWS account, please follow the instructions from the lab coordinator.
{{% /notice %}}

**Sign in to the [AWS Management Console](https://us-east-1.console.aws.amazon.com/console) as an IAM user who has either AdministratorAccess or PowerUserAccess (with full IAM access) permissions to ensure successful execution of this lab.**

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

### Congratulations! 

You have now completed the first section of the Lab.

You should have a working lab environment which we will use for the remainder of the lab.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="..//" link_next_url="../2_verify_instance_scheduler_configuration/" />}}


