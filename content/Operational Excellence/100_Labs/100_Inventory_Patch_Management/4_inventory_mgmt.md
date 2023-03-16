---
title: "Inventory Management using Operations as Code"
menutitle: "Inventory Management"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

## Management Tools: Systems Manager

[AWS Systems Manager](https://aws.amazon.com/systems-manager/features/) is a collection of features that enable IT Operations that we will explore throughout this lab.

There are [set up tasks](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-setting-up.html) and [pre-requisites](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-prereqs.html) that must be satisfied prior to using Systems Manager to manage your EC2 instances or on-premises systems in [hybrid environments](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-managedinstances.html).
* You must use a supported operating system
    * Supported operating systems include versions of Windows, Amazon Linux, Ubuntu Server, RHEL, and CentOS
* The SSM Agent must be installed
    * The SSM Agent for Windows also requires PowerShell 3.0 or later to run some [SSM documents](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-prereqs.html#prereqs-powershell)
* Your EC2 instances must have outbound internet access
* You must access Systems Manager in a supported region
* Systems Manager requires IAM roles
    * for instances that will process commands
	* for users executing commands

SSM Agent is installed by default on:
* Amazon Linux _base_ AMIs dated 2017.09 and later
* Windows Server 2016 instances
* Instances created from Windows Server 2003-2012 R2 AMIs published in November 2016 or later

[There is no additional charge for AWS Systems Manager](https://aws.amazon.com/systems-manager/pricing/). You only pay for your underlying AWS resources managed or created by AWS Systems Manager (e.g., Amazon EC2 instances or Amazon CloudWatch metrics). You only pay for what you use as you use it. There are no minimum fees and no upfront commitments.


### 4.1 Setting up Systems Manager

1. Use your administrator account to access the Systems Manager console at <https://console.aws.amazon.com/systems-manager/>.
1. Choose **Fleet Manager** from the navigation bar in the **Node Management** menu. If you have not satisfied the pre-requisites for Systems Manager, you will arrive at the **AWS Systems Manager Managed Instances** page.
   * As a user with AdministratorAccess permissions, you already have [User Access to Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-access-user.html).
   * The Amazon Linux AMIs used to create the instances in your environment are dated 2017.09. They are [supported operating systems](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-supported-oses.html) and have the [SSM Agent](https://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent.html) installed by default.
   * If you are in a [supported region](https://docs.aws.amazon.com/general/latest/gr/rande.html#ssm_region) the remaining step is to configure the IAM role for instances that will process commands.
1. Create an Instance Profile for Systems Manager managed instances:
   1. Navigate to the [IAM console](https://console.aws.amazon.com/iam/)
   1. In the navigation pane, choose **Roles**.
   1. Then choose **Create role**.
   1. In the **Select type of trusted entity** section, verify that the default **AWS service** is selected.
   1. In the **Choose the service that will use this role** section, scroll past the first reference to EC2 (**EC2 Allows EC2 instances to call AWS services on your behalf**) and choose **EC2** from within the field of services. This will open the **Select your use case** section further down the page.
   1. In the **Select your use case** section, choose **EC2 Role for AWS Systems Manager** to select it.
   1. Then choose **Next: Permissions**.
1. Under **Attached permissions policy**, verify that **AmazonSSMManagedInstanceCore** is listed, and then choose **Next: Tags**.
1. In the **Tags** section:
   1. Add one or more **keys** and **values**, then choose **Next: Review**.
1. In the **Review** section:
   1. Enter a **Role name**, such as `ManagedInstancesRole`.
   1. Accept the default in the **Role description**.
   1. Choose **Create role**.
1. Apply this role to the instances you wish to manage with Systems Manager:
   1. Navigate to the [EC2 Console](https://console.aws.amazon.com/ec2/) and choose **Instances**.
   1. Select the first instance and then choose **Actions**, **Security**, and **Modify IAM Role**.
   1. Under **Modify IAM Role**, select **ManagedInstancesRole** from the drop down list and choose **Save**.
   1. Repeat this process, assigning **ManagedInstancesRole** to each of the 3 remaining instances.
1. Return to the [Systems Manager console](https://console.aws.amazon.com/systems-manager/) and choose **Fleet Manager** from the navigation bar in the **Node Management** menu. Periodically choose **Fleet Manager** until your instances begin to appear in the list. Over the next couple of minutes your instances will populate into the list as managed instances.

>**Note** If desired, you can use a [more restrictive permission set](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-access-user.html) to grant access to Systems Manager.

### 4.2 Create a Second CloudFormation Stack

1. Create a second CloudFormation stack using the procedure in 3.1 with the following changes:
   * In the **Specify Details** section, define a Stack name, such as `OELabStack2`.
   * Specify the **InstanceProfile** using the `ManagedInstancesRole` you defined.
   * Define the **Workload Name** as `Prod`.

## Systems Manager: Inventory

You can use [AWS Systems Manager Inventory](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-inventory.html) to collect operating system (OS), application, and instance metadata from your Amazon EC2 instances and your on-premises servers or virtual machines (VMs) in your hybrid environment. You can query the metadata to quickly understand which instances are running the software and configurations required by your software policy, and which instances need to be updated.


### 4.3 Using Systems Manager Inventory to Track Your Instances

1. Under **Node Management** in the AWS Systems Manager navigation bar, choose **Inventory**.
   1. Scroll down in the window to the **Corresponding managed instances** section. Inventory currently contains only the instance data available from the EC2
   1. Choose the **InstanceID** of one of your systems.
   1. Examine each of the available tabs of data under the **Instance ID** heading.
1. Inventory collection must be specifically configured and the data types to be collected must be specified
   1. Choose **Inventory** in the navigation bar.
   1. Choose **Setup Inventory** in the top right corner of the window
1. In the **Setup Inventory** screen, define targets for inventory:
   1. Under **Specify targets by**, select **Specifying a tag**
   1. Under **Tags** specify `Environment` for the key and `OELabIPM` for the value
>**Note** You can select all managed instances in this account, ensuring that all managed instances will be inventoried. You can constrain inventoried instances to those with specific tags, such as Environment or Workload. Or you can manually select specific instances for inventory.

4. Schedule the frequency with which inventory is collected. The default and minimum period is 30 minutes
   1. For **Collect inventory data every**, accept the default **30** Minute(s)
1. Under parameters, specify what information to collect with the inventory process
   1. Review the options and select the defaults
1. (Optional) If desired, you may specify an S3 bucket to receive the inventory execution logs (you will need to [create a destination bucket for the logs](https://docs.aws.amazon.com/AmazonS3/latest/gsg/CreatingABucket.html) prior to proceeding):
   1. Check the box next to **Sync inventory execution logs to an S3 bucket** under the **Advanced** options.
   1. Provide an S3 bucket name.
   1. (Optional) Provide an S3 bucket prefix.
1. Choose **Setup Inventory** at the bottom of the page (it can take up to 10 minutes to deploy a new inventory policy to an instance).
1. To create a new inventory policy, from **Inventory**, choose **Setup inventory**.
1. To edit an existing policy, from **State Manager** in the left navigation menu, select the association and choose **Edit**.

>**Note** You can create multiple Inventory specifications. They will each be stored as **associations** within **Systems Manager State Manager**.


## Systems Manager: State Manager

In State Manager, an [association](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-associations.html) is the result of binding configuration information that defines the state you want your instances to be in to the instances themselves. This information specifies when and how you want instance-related operations to run that ensure your Amazon EC2 and hybrid infrastructure is in an intended or consistent state.

An association defines the state you want to apply to a set of targets. An association includes three components and one optional set of components:
  * A document that defines the state
  * Target(s)
  * A schedule
  * (Optional) Runtime parameters.

When you performed the **Setup Inventory** actions, you created an association in State Manager.


### 4.4 Review Association Status

1. Under **Node Management** in the navigation bar, select **State Manager**. At this point, the **Status** may show that the inventory activity has not yet completed.
   1. Choose the single Association id that is the result of your **Setup Inventory** action.
   1. Examine each of the available tabs of data under the **Association ID** heading.
   1. Choose **Edit**.
   1. Enter a name under **Name - optional** to provide a more user friendly label to the association, such as `InventoryAllInstances` (white space is not permitted in an _Association Name_).

_Inventory_ is accomplished through the following:
   * The activities defined in the AWS-GatherSoftwareInventory command document.
   * The parameters provided in the **Parameters** section are passed to the document at execution.
   * The targets are defined in the **Targets** section.
   >**Important** In this example there is a single target, the wildcard. The wildcard matches _all_ instances making them _all_ targets.
   * The schedule for this activity is defined under **Specify schedule** and **Specify with** to use a CRON/Rate expression on a 30 minute interval.
   * There is the option to specify **Output options**.
   >**Note** If you change the command document, the **Parameters** section will change to be appropriate to the new command document.



2. Navigate to **Fleet Manager** under **Node Management** in the navigation bar. An **Association Status** has been established for the inventoried instances under management.
1. Choose one of the **Instance ID** links to go to the inventory of the instance. The Inventory tab is now populated and you can track associations and their last activity under the Associations tab.
1. Navigate to **Compliance** under **Node Management** in the navigation bar. Here you can view the overall compliance status of your managed instances in the **Compliance Resources Summary** and the individual compliance status of systems in the **Corresponding managed instances** section below.

>**Note** The inventory activity can take up to 10 minutes to complete. While waiting for the inventory activity to complete, you can proceed with the next section.


## Systems Manager: Compliance

You can use AWS Systems Manager Configuration [Compliance](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-compliance.html) to scan your fleet of managed instances for patch compliance and configuration inconsistencies. You can collect and aggregate data from multiple AWS accounts and Regions, and then drill down into specific resources that aren’t compliant.

By default, Configuration Compliance displays compliance data about Systems Manager Patch Manager patching and **Systems Manager State Manager** associations. You can also customize the service and create your own compliance types based on your IT or business requirements. You can also port data to **Amazon Athena** and **Amazon QuickSight** to generate fleet-wide reports.

{{< prev_next_button link_prev_url="../3_deploy_env_iaac/" link_next_url="../5_patch_mgmt/" />}}
