---
title: "Creating Maintenance Windows and Scheduling Automated Operations Activities"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---
## AWS Systems Manager: Maintenance Windows

[AWS Systems Manager Maintenance Windows](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-maintenance.html) let you define a schedule for when to perform potentially disruptive actions on your instances such as patching an operating system (OS), updating drivers, or installing software. Each Maintenance Window has a schedule, a duration, a set of registered targets, and a set of registered tasks. With Maintenance Windows, you can perform tasks like the following:

* Installing applications, updating patches, installing or updating SSM Agent, or executing PowerShell commands and Linux shell scripts by using a Systems Manager Run Command task
* Building Amazon Machine Images (AMIs), boot-strapping software, and configuring instances by using Systems Manager Automation
* Executing AWS Lambda functions that trigger additional actions such as scanning your instances for patch updates
* Running AWS Step Function state machines to perform tasks such as removing an instance from an Elastic Load Balancing environment, patching the instance, and then adding the instance back to the Elastic Load Balancing environment
>**Note**<br>To register Step Function tasks you must use the AWS CLI.


### 6.1 Setting up Maintenance Windows

1. [Create the role](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-perm-console.html) that allows Systems Manager to tasks in Maintenance Windows on your behalf:
   1. Navigate to the [IAM console](https://console.aws.amazon.com/iam/).
   1. In the navigation pane, choose **Roles**, and then choose **Create role**.
   1. In the **Select type of trusted entity** section, verify that the default **AWS service** is selected.
   1. In the **Choose the service that will use this role** section, choose **EC2**. This allows EC2 instances to call AWS services on your behalf.
   1. Choose **Next: Permissions**.
1. Under **Attached permissions policy**:
   1. Search for **AmazonSSMMaintenanceWindowRole**.
   1. Check the box next to **AmazonSSMMaintenanceWindowRole** in the list.
   1. Choose **Next: Review**.
1. In the **Review** section:
   1. Enter a **Role name**, such as `SSMMaintenanceWindowRole`.
   1. Enter a **Role description**, such as `Role for Amazon SSMMaintenanceWindow`.
   1. Choose **Create role**. Upon success you will be returned to the **Roles** screen.
1. To enable the service to run tasks on your behalf, we need to edit the trust relationship for this role:
   1. Choose the role you just created to enter its **Summary** page.
   1. Choose the **Trust relationships** tab.
   1. Choose **Edit trust relationship**.
   1. Delete the current policy, and then copy and paste the following policy into the **Policy Document** field:
```
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Sid":"",
         "Effect":"Allow",
         "Principal":{
            "Service":[
               "ec2.amazonaws.com",
               "ssm.amazonaws.com",
               "sns.amazonaws.com"
            ]
         },
         "Action":"sts:AssumeRole"
      }
   ]
}
```
5. Choose **Update Trust Policy**. You will be returned to the now updated Summary page for your role.
1. Copy the **Role ARN** to your clipboard by choosing the double document icon at the end of the ARN.

When you register a task with a Maintenance Window, you specify the role you created, which the service will assume when it runs tasks on your behalf. To register the task, you must assign the IAM PassRole policy to your IAM user account. The policy in the following procedure provides the minimum permissions required to register tasks with a Maintenance Window.

7. To create the IAM PassRole policy for your Administrators IAM user group:
   1. In the IAM console navigation pane, choose **Policies**, and then choose **Create policy**.
   1. On the Create policy page, in the **Select a service area**, next to **Service** choose **Choose a service**, and then choose **IAM**.
   1. In the **Actions** section, search for **PassRole** and check the box next to it when it appears in the list.
   1. In the **Resources** section, choose "You choose actions that require the **role** resource type.", and then choose **Add ARN** to restrict access. The Add ARN(s) window will open.
   1. In the **Add ARN(s)** window, in the **Specify ARN for role field**, delete the existing entry, paste in the role ARN you created in the previous procedure, and then choose **Add** to return to the Create policy window.
   1. Choose **Review policy**.
   1. On the **Review Policy** page, type a name in the **Name** box, such as `SSMMaintenanceWindowPassRole` and then choose **Create policy**. You will be returned to the **Policies** page.
1. To assign the IAM PassRole policy to your Administrators IAM user group:
   1. In the IAM console navigation pane, choose **Groups**, and then choose your **Administrators** group to reach its Summary page.
   1. Under the permissions tab, choose **Attach Policy**.
   1. On the **Attach Policy** page, search for SSMMaintenanceWindowPassRole, check the box next to it in the list, and choose **Attach Policy**. You will be returned to the Summary page for the group.


## Creating Maintenance Windows

To [create a Maintenance Window](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-create-mw.html), you must do the following:

1. Create the window and define its schedule and duration.
1. Assign targets for the window.
1. Assign tasks to run during the window.

After you complete these steps, the Maintenance Window runs according to the schedule you defined and runs the tasks on the targets you specified. After a task is finished, Systems Manager logs the details of the execution.


### 6.2 Create a Patch Maintenance Window

First, you must [create the window](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-create-mw.html) and define its schedule and duration:

1. Open the AWS [Systems Manager console](https://console.aws.amazon.com/systems-manager/).
1. In the navigation pane, choose **Maintenance Windows** and then choose **Create a Maintenance Window**.
1. In the **Provide maintenance window details** section:
   1. In the **Name** field, type a descriptive name to help you identify this Maintenance Window, such as `PatchTestWorkloadWebServers`.
   1. (Optional) you may enter a description in the **Description** field.
   1. Choose **Allow unregistered targets** if you want to allow a Maintenance Window task to run on managed instances, even if you have not registered those instances as targets.
   >**Note**<br>If you choose **Allow unregistered targets**, then you can choose the unregistered instances (by instance ID) when you register a task with the Maintenance Window. If you don't, then you must choose previously registered targets when you register a task with the Maintenance Window.
   1. Specify a schedule for the Maintenance Window by using one of the scheduling options:
      1. Under **Specify with**, accept the default **Cron schedule builder**.
      1. Under **Window starts**, choose the third option, specify **Every Day at**, and select a time, such as `02:00`.
      1. In the **Duration** field, type the number of hours the Maintenance Window should run, such as '3' **hours**.
      1. In the **Stop initiating tasks** field, type the number of hours before the end of the Maintenance Window that the system should stop scheduling new tasks to run, such as `1` **hour before the window closes**. Allow enough time for initiate activities to complete before the close of the maintenance window.
1. (Optionally) to have the maintenance window execute more rapidly while engaged with the lab:
   1. Under **Window starts**, choose **Every 30 minutes** to have the tasks execute on every hour and every half hour.
   1. Set the **Duration** to the minimum `1` hours.
   1. Set the **Stop initiation tasks** to the minimum `0` hours.
1. Choose **Create maintenance window**. The system returns you to the **Maintenance Window** page. The state of the Maintenance Window you just created is **Enabled**.


### 6.3 Assigning Targets to Your Patch Maintenance Window

After you create a Maintenance Window, you [assign targets](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-assign-targets.html) where the tasks will run.

1. On the **Maintenance windows** page, choose the **Window ID** of your maintenance window to enter its Details page.
1. Choose **Actions** in the top right of the window and select **Register targets**.
1. On the **Register target** page under **Maintenance window target details**:
   1. In the **Target Name** field, enter a name for the targets, such as `TestWebServers`.
   1. (Optional) Enter a description in the **Description** field.
   1. (Optional) Specify a name or work alias in the **Owner information** field.
   >**Note**: Owner information is included in any CloudWatch Events that are raised while running tasks for these targets in this Maintenance Window.
1. In the **Targets** section, under **Select Targets by**:
   1. Choose the default **Specifying tags** to target instances by using Amazon EC2 tags that were previously assigned to the instances.
   1. Under **Tags**, enter 'Workload' as the key and `Test` as the value. The option to add and additional tag key/value pair will appear.
   1. Add a second key/value pair using `InstanceRole` as the key and `WebServer` as the value.
1. Choose **Register target** at the bottom of the page to return to the maintenance window details page.

If you want to assign more targets to this window, choose the **Targets** tab, and then choose **Register target**to register new targets. With this option, you can choose a different means of targeting. For example, if you previously targeted instances by instance ID, you can register new targets and target instances by specifying Amazon EC2 tags.

### 6.4 Assigning Tasks to Your Patch Maintenance Window

After you assign targets, you [assign tasks](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-maintenance-assign-tasks.html) to perform during the window:

1. From the details page of your maintenance window, choose **Actions** in the top right of the window and select **Register Run command task**.
1. On the **Register Run command task** page:
   1. In the **Name** field, enter a name for the task, such as `PatchTestWorkloadWebServers`.
   1. (Optional) Enter a description in the **Description** field.
1. In the **Command document** section:
   1. Choose the search icon, select `Platform`, and then choose `Linux` to display all the available commands that can be applied to Linux instances.
   1. Choose **AWS-RunPatchBaseline** in the list.
   1. Leave the **Task priority** at the default value of **1** (1 is the highest priority).
   4. Tasks in a Maintenance Window are scheduled in priority order, with tasks that have the same priority scheduled in parallel.
1. In the **Targets** section:
   1. For **Target by**, select **Selecting registered target groups**.
   1. Select the group you created from the list.
1. In the **Rate control** section:
   1. For **Concurrency**, leave the default **targets** selected and specify `1`.
   1. For **Error threshold**, leave the default **errors** selected and specify `1`.
1. In the **Role** section, specify the role you defined with the AmazonSSMMaintenanceWindowRole. It will be `SSMMaintenanceWindowRole` if you followed the suggestion in the instructions above.
1. In **Output options**, leave **Enable writing to S3** clear.
   1. (Optionally) Specify **Output options** to record the entire output to a preconfigured **S3 bucket** and optional **S3 key prefix**
   >**Note**<br>Only the last 2500 characters of a command document's output are displayed in the console. To capture the complete output define and S3 bucket to receive the logs.
1. In **SNS notifications**, leave **Enable SNS notifications** clear.
   1. (Optional) Specify **SNS notifications** to a preconfigured **SNS Topic** on all events or a specific event type for either the entire command or on a per-instance basis.
1. In the **Parameters** section, under **Operation**, select **Install**.
1. Choose **Register Run command task** to complete the task definition and return to the details page.

### 6.5 Review Maintenance Window Execution

1. After allowing enough time for your maintenance window to complete:
   1. Navigte to the AWS [Systems Manager console](https://console.aws.amazon.com/systems-manager/).
   1. Choose **Maintenance Windows**, and then select the **Window ID** for your new maintenance window.
1. On the **Maintenance window ID** details page, choose **History**.
1. Select a **Windows execution ID** and choose **View details**.
1. On the **Command ID** details page, scroll down to the **Targets and outputs** section, select an **Instance ID**, and choose **View output**.
1. Choose **Step 1 - Output** and review the output.
1. Choose **Step 2 - Output** and review the output.

You have now configured a maintenance window, assigned targets, assigned tasks, and validated successful execution. The same procedures can be used to schedule the execution of any [AWS Systems Manager Document](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-ssm-docs.html).
