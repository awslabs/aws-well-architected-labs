---
title: "Patch Management"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

## Systems Manager: Patch Manager

AWS Systems Manager [Patch Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-patch.html) automates the process of patching managed instances with security related updates.

>**Note**<br>For Linux-based instances, you can also install patches for non-security updates.

You can patch fleets of Amazon EC2 instances or your on-premises servers and virtual machines (VMs) by operating system type. This includes supported versions of Windows, Ubuntu Server, Red Hat Enterprise Linux (RHEL), SUSE Linux Enterprise Server (SLES), and Amazon Linux. You can scan instances to see only a report of missing patches, or you can scan and automatically install all missing patches. You can target instances individually or in large groups by using Amazon EC2 tags.

> **Warning**
>* **AWS does not test patches for Windows or Linux before making them available in Patch Manager** .
>* **If any updates are installed by Patch Manager the patched instance is rebooted**.
>* **Always test patches thoroughly before deploying to production environments**.


## Patch Baselines

Patch Manager uses **patch baselines**, which include rules for auto-approving patches within days of their release, as well as a list of approved and rejected patches. Later in this lab we will schedule patching to occur on a regular basis using a Systems Manager **Maintenance Window** task. Patch Manager integrates with AWS Identity and Access Management (IAM), AWS CloudTrail, and Amazon CloudWatch Events to provide a secure patching experience that includes event notifications and the ability to audit usage.

>**Warning**<br>The [operating systems supported by Patch Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-supported-oses.html) may vary from those supported by the SSM Agent.


### 5.1 Create a Patch Baseline

1. Under **Instances and Nodes** in the **AWS Systems Manager** navigation bar, choose **Patch Manager**.
1. Click the **View predefined patch baselines** link under the **Configure patching** button on the upper right.
1. Choose **Create patch baseline**.
1. On the **Create patch baseline** page in the **Provide patch baseline details** section:
   1. Enter a **Name** for your custom patch baseline, such as `AmazonLinuxSecAndNonSecBaseline`.
   1. Optionally enter a description, such as `Amazon Linux patch baseline including security and non-security patches`.
   1. Select **Amazon Linux** from the list.
1. In the **Approval rules** section:
   1. Examine the options in the lists and ensure that **Product**, **Classification**, and **Severity** have values of **All**.
   1. Leave the **Auto approval delay** at its default of **0 days**.
   1. Change the value of **Compliance reporting - optional** to **Critical**.
   1. Choose **Add another rule**.
   1. In the new rule, change the value of **Compliance reporting - optional** to **Medium**.
   1. Check the box under **Include non-security updates** to include all Amazon Linux updates when patching.

If an approved patch is reported as missing, the option you choose in **Compliance reporting**, such as `Critical` or `Medium`, determines the severity of the compliance violation reported in System Manager **Compliance**.

5. In the **Patch exceptions** section in the **Rejected patches - optional** text box, enter `system-release.*` This will [reject patches](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-approved-rejected-package-name-formats.html) to new Amazon Linux releases that may advance you beyond the [Patch Manager supported operating systems](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-supported-oses.html) prior to your testing new releases.
1. For Linux operating systems, you can optionally define an [alternative patch source repository]( https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-how-it-works-alt-source-repository.html). Choose the **X** in the **Patch sources** area to remove the empty patch source definition.
1. Choose **Create patch baseline** and you will go to the **Patch Baselines** page where the AWS provided default patch baselines, and your custom baseline, are displayed.


## Patch Groups

A [patch group](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-patch-patchgroups.html) is an optional method to organize instances for patching. For example, you can create patch groups for different operating systems (Linux or Windows), different environments (Development, Test, and Production), or different server functions (web servers, file servers, databases). Patch groups can help you avoid deploying patches to the wrong set of instances. They can also help you avoid deploying patches before they have been adequately tested.

You create a patch group by using Amazon EC2 tags. Unlike other tagging scenarios across Systems Manager, a patch group must be defined with the tag key: `Patch Group` (tag keys are case sensitive). You can specify any value (for example, `web servers`) but the key must be `Patch Group`.

>**Note**<br>An instance can only be in one patch group.

After you create a patch group and tag instances, you can register the patch group with a patch baseline. By registering the patch group with a patch baseline, you ensure that the correct patches are installed during the patching execution. When the system applies a patch baseline to an instance, the service checks if a patch group is defined for the instance.
* If the instance is assigned to a patch group, the system checks to see which patch baseline is registered to that group.
* If a patch baseline is found for that group, the system applies that patch baseline.
* If an instance isn't assigned to a patch group, the system automatically uses the currently configured default patch baseline.


### 5.2 Assign a Patch Group

1. Choose the **Baseline ID** of your newly created baseline to enter the details screen.
1. Choose **Actions** in the top right of the window and select **Modify patch groups**.
1. In the **Modify patch groups** window under **Patch groups**, enter `Critical`, choose **Add**, and then choose **Close** to be returned to the **Patch Baseline** details screen.


## AWS-RunPatchBaseline

[AWS-RunPatchBaseline](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-ssm-documents.html#patch-manager-ssm-documents-recommended-AWS-RunPatchBaseline) is a command document that enables you to control patch approvals using patch baselines. It reports patch compliance information that you can view using the Systems Manager **Compliance** tools. For example,you can view which instances are missing patches and what those patches are.

For Linux operating systems, compliance information is provided for patches from both the default source repository configured on an instance and from any alternative source repositories you specify in a custom patch baseline. AWS-RunPatchBaseline supports both Windows and Linux operating systems.


## AWS Systems Manager: Document

An [AWS Systems Manager document](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-ssm-docs.html) defines the actions that Systems Manager performs on your managed instances. Systems Manager includes many pre-configured documents that you can use by specifying parameters at runtime, including 'AWS-RunPatchBaseline'. These documents use JavaScript Object Notation (JSON) or YAML, and they include steps and parameters that you specify.

All AWS provided Automation and Run Command documents can be viewed in AWS Systems Manager **Documents**. You can [create your own documents](https://docs.aws.amazon.com/systems-manager/latest/userguide/create-ssm-doc.html) or launch existing scripts using provided documents to implement custom operations as code activities.


### 5.3 **Examine AWS-RunPatchBaseline in Documents**

To examine AWS-RunPatchBaseline in Documents:

1. In the AWS Systems Manager navigation bar under **Shared Resources**, choose **Documents**.
1. Click in the **search box**, select **Document name prefix**, and then **Equal**.
1. Type `AWS-Run` into the text field and press _Enter_ on your keyboard to start the search.
1. Select AWS-RunPatchBaseline and choose **View details**.
1. Review the content of each tab in the details page of the document.


## AWS Systems Manager: Run Command

[AWS Systems Manager Run Command](https://docs.aws.amazon.com/systems-manager/latest/userguide/execute-remote-commands.html) lets you remotely and securely manage the configuration of your managed instances.  Run Command enables you to automate common administrative tasks and perform ad hoc configuration changes at scale. You can use Run Command from the AWS Management Console, the AWS Command Line Interface, AWS Tools for Windows PowerShell, or the AWS SDKs.


### 5.4 Scan Your Instances with AWS-RunPatchBaseline via Run Command

1. Under **Instances and Nodes** in the AWS Systems Manager navigation bar, choose **Run Command**. In the Run Command dashboard, you will see previously executed commands including the execution of AWS-RefreshAssociation, which was performed when you set up inventory.
1. (Optional) choose a Command ID from the list and examine the record of the command execution.
1. Choose **Run Command** in the top right of the window.
1. In the **Run a command** window, under **Command document**:
    * Choose the search icon and select `Platform types`, and then choose `Linux` to display all the available commands that can be applied to Linux instances.
	* Choose **AWS-RunPatchBaseline** in the list.
1. In the **Command parameters** section, leave the **Operation** value as the default **Scan**.
1. In the **Targets** section:
   * Under **Specify targets by**, choose **Specifying a tag** to reveal the **Tags** sub-section.
   * Under **Enter a tag key**, enter `Workload`, and under **Enter a tag value**, enter `Test` and click **Add**.

The remaining Run Command features enable you to:
* Specify **Rate control**, limiting **Concurrency** to a specific number of targets or a calculated percentage of systems, or to specify an **Error threshold** by count or percentage of systems after which the command execution will end.
* Specify **Output options** to record the entire output to a preconfigured **S3 bucket** and optional **S3 key prefix**.
>**Note**<br>Only the last 2500 characters of a command document's output are displayed in the console.
* Specify **SNS notifications** to a specified **SNS Topic** on all events or on a specific event type for either the entire command or on a per-instance basis. This requires Amazon SNS to be preconfigured.
* View the command as it would appear if executed within the AWS Command Line Interface.

1. Choose **Run** to execute the command and return to its details page.
1. Scroll down to **Targets and outputs** to view the status of the individual targets that were selected through your tag key and value pair. Refresh your page to update the status.
1. Choose an **Instance ID** from the targets list to view the **Output** from command execution on that instance.
1. Choose **Step 1 - Output** to view the first 2500 characters of the command output from Step 1 of the command, and choose **Step 1 - Output** again to conceal it.
1. Choose **Step 2 - Output** to view the first 2500 characters of the command output from Step 2 of the command.  The execution step for **PatchWindows** was skipped as it did not apply to your Amazon Linux instance.
1. Choose **Step 1 - Output** again to conceal it.


### 5.5 Review Initial Patch Compliance

1. Under **Instances & Nodes** in the the AWS Systems Manager navigation bar, choose **Compliance**.
1. On the **Compliance** page in the **Compliance resources summary**, you will now see that there are 4 systems that have critical severity compliance issues. In the **Resources** list, you will see the individual compliance status and details.


### 5.6 Patch Your Instances with AWS-RunPatchBaseline via Run Command

1. Under **Instances and Nodes** in the AWS Systems Manager navigation bar, choose **Run Command**.
1. Choose **Run Command** in the top right of the window.
1. In the **Run a command** window, under **Command document**:
   1. Choose the search icon, select `Platform types`, and then choose `Linux` to display all the available commands that can be applied to Linux instances.
   1. Choose **AWS-RunPatchBaseline** in the list.
1. In the **Targets** section:
   1. Under **Specify targets by**, choose **Specifying a tag** to reveal the **Tags** sub-section.
   1. Under **Enter a tag key**, enter `Workload` and under **Enter a tag value** enter `Test`.
1. In the **Command parameters** section, change the **Operation** value to **Install**.
1. In the **Targets** section, choose **Specify a tag** using `Workload` and `Test`.
>**Note** You could have choosen **Manually selecting instances** and used the check box at the top of the list to select all instances displayed, or selected them individually.

>**Note** there are multiple pages of instances. If manually selecting instances, individual selections must be made on each page.

1. In the **Rate control** section:
   1. For **Concurrency**, ensure that **targets** is selected and specify the value as `1`.
   >**Tip**<br>Limiting concurrency will stagger the application of patches and the reboot cycle, however, to ensure that your instances are not rebooting at the same time, create separate tags to define target groups and schedule the application of patches at separate times.
   2. For **Error threshold**, ensure that **error** is selected and specify the value as `1`.
1. Choose **Run** to execute the command and to go to its details page.
1. Refresh the page to view updated status and proceed when the execution is successful.

>**Warning**<br>Remember, if any updates are installed by Patch Manager, the patched instance is rebooted.

### 5.7 Review Patch Compliance After Patching

1. Under **Instances & Nodes** in the the AWS Systems Manager navigation bar, choose **Compliance**.
1. The **Compliance resources summary** will now show that there are 4 systems that have satisfied critical severity patch compliance.

In the optional Scheduling Automated Operations Activities section of this lab you can set up Systems Manager Maintenance Windows and schedule the automated application of patches.


### **The Impact of Operations as Code**

In a traditional environment, you would have had to set up the systems and software to perform these activities. You would require a server to execute your scripts. You would need to manage authentication credentials across all of your systems.

_Operations as code_ reduces the resources, time, risk, and complexity of performing operations tasks and ensures consistent execution. You can take operations as code and automate operations activities by using scheduling and event triggers. Through integration at the infrastructure level you avoid "swivel chair" processes that require multiple interfaces and systems to complete a single operations activity.
