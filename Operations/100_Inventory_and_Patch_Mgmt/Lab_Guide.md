# Level 100: Inventory and Patch Management: Lab Guide

In the cloud, you can apply the same engineering discipline that you use for application code to your entire environment. You can define your entire workload (applications, infrastructure, etc.) as code and update it with code. You can script your operations procedures and automate their execution by triggering them in response to events. By performing operations as code, you limit human error and enable consistent execution of operations activities.

In this lab you will apply the concepts of _Infrastructure as Code_ and _Operations as Code_ to the following activities:
* Deployment of Infrastructure
* Inventory Management
* Patch Management

Included in the lab guide are bonus sections that can be completed if you have time or later if interested.
* Creating Maintenance Windows and Scheduling Automated Operations Activities
* Create and Subscribe to a Simple Notification Service Topic



>**Important**
You will be billed for any applicable AWS resources used in this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/). At the end of the lab guide there is an additional section on how to remove all the resources you have created.
* Removing Lab Resources


# 1. Setup


## Requirements

You will need the following to be able to perform this lab:
* Your own device for console access
* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, **that is not used for production** or other purposes
* An available region within your account with capacity to add 2 additional VPCs


## User and Group Management

When you create an Amazon Web Services (AWS) account, you begin with a single sign-in identity that has complete access to all AWS services and resources in the account. This identity is called the AWS account root user. It is accessed by signing in with the email address and password that you used to create the account.

We strongly recommend that you do not use the root user for your everyday tasks, even the administrative ones. Instead, adhere to the best practice of using the root user only to create your first IAM user. Securely store the root user credentials and use them to perform only a few account and service management tasks. To view the tasks that require you to sign in as the root user, see [AWS Tasks That Require Root User](https://docs.aws.amazon.com/general/latest/gr/aws_tasks-that-require-root.html).


## IAM Users & Groups

As a best practice, do not use the AWS account root user for any task where it's not required. Instead, create a new IAM user for each person that requires administrator access. Then grant administrator access by placing the users into an "Administrators" group to which the **AdministratorAccess** managed policy is attached.

Use administrators group members to manage permissions and policy for the AWS account. Limit use of the root user to only those [actions that require it](https://docs.aws.amazon.com/general/latest/gr/aws_tasks-that-require-root.html).


### 1.1 Create Administrator IAM User and Group

To create an administrator user for yourself and add the user to an administrators group:

1. Use your AWS account email address and password to sign in as the AWS account root user to the IAM console at <https://console.aws.amazon.com/iam/>.
1. In the IAM navigation pane, choose **Users** and then choose **Add user**.
1. In **Set user details** for **User name**, type a user name for the administrator account you are creating. The name can consist of letters, digits, and the following characters: plus (+), equal (=), comma (,), period (.), at (@), underscore (_), and hyphen (-). The name is not case sensitive and can be a maximum of 64 characters in length.
1. In **Select AWS access type** for **Access type**, select the check box next to **AWS Management Console access**, select **Custom password**, and then type your new password in the text box. If you're creating the user for someone other than yourself, you can leave *Require password reset* selected to force the user to create a new password when first signing in. Clear the box next to **Require password reset** and then choose **Next: Permissions**.
1. In **set permissions for user** ensure **Add user to group** is selected.
1. Under **Add user to group** choose **Create group**.
1. In the **Create group** dialog box, type a **Group name** for the new group, such as Administrators. The name can consist of letters, digits, and the following characters: plus (+), equal (=), comma (,), period (.), at (@), underscore (_), and hyphen (-). The name is not case sensitive and can be a maximum of 128 characters in length. In the policy list, select the check box next to **AdministratorAccess** and then choose **Create group**.
1. Back at **Add user to group**, in the list of groups, ensure the check box for your new group is selected. Choose Refresh if necessary to see the group in the list. choose **Next: Review** to see the list of group memberships to be added to the new user. When you are ready to proceed, choose **Create user**.
1. At the confirmation screen you do not need to download the user credentials for programmatic access at this time. You can create new credentials at any time.

You can use this same process to create more groups and users and to give your users access to your AWS account resources. To learn about using policies that restrict user permissions to specific AWS resources, see [Access Management](https://docs.aws.amazon.com/IAM/latest/UserGuide/access.html) and [Example Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_examples.html). To add additional users to the group after it's created, see [Adding and Removing Users in an IAM Group](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups_manage_add-remove-users.html).


### 1.2 Log in to the AWS Management Console using your administrator account

1. You can now use this administrator user instead of your root user for this AWS account. **Choose the link** https\://\<yourAccountNumber\>.signin.aws.amazon.com/console and log in with your administrator user credentials.
1. **Select the region** you will use for the lab from the the list in the upper right corner.
1. Verify that you have 2 available VPCs (3 or less in use) in the selected region by navigating to the VPC Console (https://console.aws.amazon.com/vpc/) and in the **Resources** section reviewing the number of VPCs.


### 1.3 Create an EC2 Key Pair

[Amazon EC2 uses public-key cryptography](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) to encrypt and decrypt login information. Public-key cryptography uses a public key to encrypt a piece of data, such as a password, then the recipient uses the private key to decrypt the data. The public and private keys are known as a key pair. To [log in to the Amazon Linux instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html) we will create in this lab, you must create a key pair, specify the name of the key pair when you launch the instance, and provide the private key when you connect to the instance.

1. Use your administrator account to access the Amazon EC2 console at <https://console.aws.amazon.com/ec2/>.
1. In the IAM navigation pane under **Network & Security**, choose **Key Pairs** and then choose **Create Key Pair**.
1. In the **Create Key Pair** dialog box, type a **Key pair name** such as `OELabIPM` and then choose **Create**.
1. **Save the** `keyPairName.pem` **file** for optional later use [accessing the EC2 instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html) created in this lab.


# 2. Deploy an Environment Using Infrastructure as Code


## Tagging

We will make extensive use of tagging throughout the lab. The CloudFormation template for the lab includes the definition of multiple tags against a variety of resources.

AWS enables you to assign metadata to your AWS resources in the form of [tags](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html). Each tag is a simple label consisting of a customer-defined key and an optional value that can make it easier to manage, search for, and filter resources. Although there are no inherent types of tags, commonly adopted categories of tags include technical tags (e.g., Environment, Workload, InstanceRole, and Name), tags for automation (e.g., Patch Group, and SSMManaged), business tags (e.g., Owner), and security tags (e.g., Confidentiality).

Apply the following best practices when using tags:
* Use a standardized, case-sensitive format for tags, and implement it consistently across all resource types
* Consider tag dimensions that support the following:
  * **Managing resource access control** with [IAM](https://aws.amazon.com/premiumsupport/knowledge-center/iam-ec2-resource-tags/)
  * **Cost tracking**
  * **Automation**
  * **AWS console organization**
* Implement automated tools to help manage resource tags. [The Resource Groups Tagging API](https://docs.aws.amazon.com/resourcegroupstagging/latest/APIReference/Welcome.html) enables programmatic control of tags, making it easier to automatically manage, search, and filter tags and resources.
* Err on the side of using too many tags rather than too few tags.
* [Develop a tagging strategy](https://aws.amazon.com/answers/account-management/aws-tagging-strategies/).

>**Note**<br>It is easy to modify tags to accommodate changing business requirements; however, consider the consequences of future changes, especially in relation to tag-based access control, automation, or upstream billing reports.

>**Important**<br>**Patch Group** is a reserved tag key used by **Systems Manager Patch Manager** that is case sensitive with a space between the two words.

## Management Tools: CloudFormation

[AWS CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html) is a service that helps you model and set up your Amazon Web Services resources so that you can spend less time managing those resources and more time focusing on your applications. You create a template that describes all the AWS resources that you want (like Amazon EC2 instances or Amazon RDS DB instances) and AWS CloudFormation provisions and configures those resources for you. AWS CloudFormation enables you to use a template file to create and delete a collection of resources as a single unit (a stack).

[There is no additional charge for AWS CloudFormation](https://aws.amazon.com/cloudformation/pricing/). You pay for AWS resources (such as Amazon EC2 instances, Elastic Load Balancing load balancers, etc.) created using AWS CloudFormation in the same manner as if you created the resources manually. You only pay for what you use as you use it. There are no minimum fees and no required upfront commitments.

### 2.1 Deploy the Lab Infrastructure

To deploy the lab infrastructure:

1. **Download the CloudFormation script** for this lab from [/Code](https://github.com/awslabs/aws-well-architected-labs/blob/master/Operations/100_Inventory_and_Patch_Mgmt/Code).
1. Use your administrator account to access the CloudFormation console at <https://console.aws.amazon.com/cloudformation/>.
1. Choose **Create Stack**.
1. On the **Select Template** page, select **Upload a template file** and select `OE_Inventory_and_Patch_Mgmt.json` file you had just downloaded.

**AWS CloudFormation Designer**

AWS [CloudFormation Designer](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/working-with-templates-cfn-designer.html) is a graphic tool for creating, viewing, and modifying AWS CloudFormation templates. With Designer you can diagram your template resources using a drag-and-drop interface. You can edit their details using the integrated JSON and YAML editor. AWS CloudFormation Designer can help you see the relationship between template resources.

5. On the **Select Template** page, next to **Specify an Amazon S3 template URL**, choose the link to **View/Edit template in Designer**.
1. Briefly review the graphical representation of the environment we are about to create, including the template in the JSON and YAML formats. You can use this feature to convert between JSON and YAML formats.
1. **Choose the Create Stack icon** (a cloud with an arrow) to return to the **Select Template page**.
1. On the **Select Template** page, choose **Next**.

A CloudFormation template is a JSON or YAML formatted text file that describes your AWS infrastructure [containing both optional and required sections](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-anatomy.html). In the next steps, we will provide a name for our stack and parameters that will be passed into the template to help define the resources that will be implemented.

9. In the **Specify Details** section, define a **Stack name**, such as `OELabStack1`.
1. In the **Parameters** section:
   1. Leave **InstanceProfile** blank as we have not yet defined an instance profile.
   1. Leave **InstanceTypeApp** and **InstanceTypeWeb** as the default free-tier-eligible t2.micro value.
   1. Select the EC2 **KeyName** you defined earlier from the list.
   * In a browser window, go to <https://checkip.amazonaws.com/> to get your IP. Enter your IP address in **SSHLocation** in CIDR notation (i.e., ending in /32).
   * Define the **Workload Name** as `Test`.
   * Choose **Next**.
1. On the **Options** page under **Tags**, define a **Key** of **Owner**, with **Value** set to the username you choose for your administrator. You may define additional keys as needed. The CloudFormation template creates all the example tags given in the discussion on tagging above.
1. Leave all other sections unmodified. Scroll to the bottom of the page and choose **Next**.
1. On the **Review** page, review your choices and then choose **Create**.
1. On the CloudFormation console page
    1. **Check the box next to your Stack Name** to see its details.
    1. If your **Stack Name** is not displayed, click the **refresh** button (circular arrow) in the top right until it appears.
    1. If the details are not displayed, choose the refresh button until details appear.
1. Choose the **Events** tab for your selected workload to see the activity log from the creation of your CloudFormation stack.

When the **Status** of your stack displays **CREATE_COMPLETE** in the filter list, you have just created a representation of a typical lift and shift 2-tier application migrated to the cloud.

13. Navigate to the [EC2 console](https://console.aws.amazon.com/ec2/) to view the deployed systems:
 	1. Choose **Instances**.
	1. Select a server and review the details under its **Description** and **Tag** tabs.
	1. (Optional) choose **Security Groups** and select the Security Group whose name begins with the name of your stack. Examine the inbound rules.
	1. (Optional) navigate to the VPC console and examine the configuration of the VPC you just created.

## The impact of Infrastructure as Code

With infrastructure as code, if you can deploy one environment, you can deploy any number of copies of that environment. In this example we have created a `Test` environment. Later, we will repeat these steps to deploy a `Prod` environment.

The ability to dynamically deploy temporary environments on-demand enables parallel experimentation, development, and testing efforts. It allows duplication of environments to recreate and analyze errors, as well as cut-over deployment of production systems using blue-green methodologies. These practices contribute to reduced risk, increased operations effectiveness, and efficiency.



# 3. Inventory Management using Operations as Code


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


### 3.1 Setting up Systems Manager

1. Use your administrator account to access the Systems Manager console at <https://console.aws.amazon.com/systems-manager/>.
1. Choose **Managed Instances** from the navigation bar. If you have not satisfied the pre-requisites for Systems Manager, you will arrive at the **AWS Systems Manager Managed Instances** page.
   * As a user with AdministratorAccess permissions, you already have [User Access to Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-access-user.html).
   * The Amazon Linux AMIs used to create the instances in your environment are dated 2017.09. They are [supported operating systems](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-supported-oses.html) and have the [SSM Agent](https://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent.html) installed by default.
   * If you are in a [supported region](https://docs.aws.amazon.com/general/latest/gr/rande.html#ssm_region) the remaining step is to configure the IAM role for instances that will process commands.
1. Create an Instance Profile for Systems Manager managed instances:
   1. Navigate to the [IAM console](https://console.aws.amazon.com/iam/)
   1. In the navigation pane, choose **Roles**.
   1. Then choose **Create role**.
   1. In the **Select type of trusted entity** section, verify that the default **AWS service** is selected.
   1. In the **Choose the service that will use this role** section, scroll past the first reference to EC2 (**EC2 Allows EC2 instances to call AWS services on your behalf**) and choose **EC2** from within the field of services. This will open the **Select your use case** section further down the page.
   1. In the **Select your use case** section, choose **EC2 Role for Simple Systems Manager** to select it.
   1. Then choose **Next: Permissions**.
1. Under **Attached permissions policy**, verify that **AmazonEC2RoleforSSM** is listed, and then choose **Next: Review**.
1. In the **Review** section:
   1. Enter a **Role name**, such as `ManagedInstancesRole`.
   1. Accept the default in the **Role description**.
   1. Choose **Create role**.
1. Apply this role to the instances you wish to manage with Systems Manager:
   1. Navigate to the [EC2 Console](https://console.aws.amazon.com/ec2/) and choose **Instances**.
   1. Select the first instance and then choose **Actions**, **Instance Settings**, and **Attach/Replace IAM Role**.
   1. Under **Attach/Replace IAM Role**, select **ManagedInstancesRole** from the drop down list and choose **Apply**.
   1. After you receive confirmation of success, choose **Close**.
   1. Repeat this process, assigning **ManagedInstancesRole** to each of the 3 remaining instances.
1. Return to the [Systems Manager console](https://console.aws.amazon.com/systems-manager/) and choose **Managed Instances** from the navigation bar. Periodically choose **Managed Instances** until your instances begin to appear in the list. Over the next couple of minutes your instances will populate into the list as managed instances.

>**Note**<br>If desired, you can use a [more restrictive permission set](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-access-user.html) to grant access to Systems Manager.

### 3.2 Create a Second CloudFormation Stack

1. Create a second CloudFormation stack using the procedure in 2.1 with the following changes:
   * In the **Specify Details** section, define a Stack name, such as `OELabStack2`.
   * Specify the **InstanceProfile** using the `ManagedInstancesRole` you defined.
   * Define the **Workload Name** as `Prod`.

## Systems Manager: Inventory

You can use [AWS Systems Manager Inventory](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-inventory.html) to collect operating system (OS), application, and instance metadata from your Amazon EC2 instances and your on-premises servers or virtual machines (VMs) in your hybrid environment. You can query the metadata to quickly understand which instances are running the software and configurations required by your software policy, and which instances need to be updated.


### 3.3 Using Systems Manager Inventory to Track Your Instances

1. Under **Instances & Nodes** in the AWS Systems Manager navigation bar, choose **Inventory**.
   1. Scroll down in the window to the **Corresponding managed instances** section. Inventory currently contains only the instance data available from the EC2
   1. Choose the **InstanceID** of one of your systems.
   1. Examine each of the available tabs of data under the **Instance ID** heading.
1. Inventory collection must be specifically configured and the data types to be collected must be specified
   1. Choose **Inventory** in the navigation bar.
   1. Choose **Setup Inventory** in the top right corner of the window
1. In the **Setup Inventory** screen, define targets for inventory:
   1. Under **Specify targets by**, select **Specifying a tag**
   1. Under **Tags** specify `Environment` for the key and `OELabIPM` for the value
>>**Note**<br>You can select all managed instances in this account, ensuring that all managed instances will be inventoried. You can constrain inventoried instances to those with specific tags, such as Environment or Workload. Or you can manually select specific instances for inventory.

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

>**Note**<br>You can create multiple Inventory specifications. They will each be stored as **associations** within **Systems Manager State Manager**.


## Systems Manager: State Manager

In State Manager, an [association](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-associations.html) is the result of binding configuration information that defines the state you want your instances to be in to the instances themselves. This information specifies when and how you want instance-related operations to run that ensure your Amazon EC2 and hybrid infrastructure is in an intended or consistent state.

An association defines the state you want to apply to a set of targets. An association includes three components and one optional set of components:
  * A document that defines the state
  * Target(s)
  * A schedule
  * (Optional) Runtime parameters.

When you performed the **Setup Inventory** actions, you created an association in State Manager.


### 3.4 Review Association Status

1. Under **Actions** in the navigation bar, select **State Manager**. At this point, the **Status** may show that the inventory activity has not yet completed.
   1. Choose the single Association id that is the result of your **Setup Inventory** action.
   1. Examine each of the available tabs of data under the **Association ID** heading.
   1. Choose **Edit**.
   1. Enter a name under **Name - optional** to provide a more user friendly label to the association, such as `InventoryAllInstances` (white space is not permitted in an _Association Name_).

_Inventory_ is accomplished through the following:
   * The activities defined in the AWS-GatherSoftwareInventory command document.
   * The parameters provided in the **Parameters** section are passed to the document at execution.
   * The targets are defined in the **Targets** section.
   >**Important**<br>In this example there is a single target, the wildcard. The wildcard matches _all_ instances making them _all_ targets.
   * The schedule for this activity is defined under **Specify schedule** and **Specify with** to use a CRON/Rate expression on a 30 minute interval.
   * There is the option to specify **Output options**.
   >**Note**<br>If you change the command document, the **Parameters** section will change to be appropriate to the new command document.



2. Navigate to **Managed Instances** under **Instances and Nodes** in the navigation bar. An **Association Status** has been established for the inventoried instances under management.
1. Choose one of the **Instance ID** links to go to the inventory of the instance. The Inventory tab is now populated and you can track associations and their last activity under the Associations tab.
1. Navigate to **Compliance** under **Instances & Nodes** in the navigation bar. Here you can view the overall compliance status of your managed instances in the **Compliance Summary** and the individual compliance status of systems in the **Corresponding managed instances** section below.

>**Note**<br>The inventory activity can take up to 10 minutes to complete. While waiting for the inventory activity to complete, you can proceed with the next section.


## Systems Manager: Compliance

You can use AWS Systems Manager Configuration [Compliance](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-compliance.html) to scan your fleet of managed instances for patch compliance and configuration inconsistencies. You can collect and aggregate data from multiple AWS accounts and Regions, and then drill down into specific resources that aren’t compliant.

By default, Configuration Compliance displays compliance data about Systems Manager Patch Manager patching and **Systems Manager State Manager** associations. You can also customize the service and create your own compliance types based on your IT or business requirements. You can also port data to **Amazon Athena** and **Amazon QuickSight** to generate fleet-wide reports.



# 4. Patch Management

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


### 4.1 Create a Patch Baseline

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


### 4.2 Assign a Patch Group

1. Choose the **Baseline ID** of your newly created baseline to enter the details screen.
1. Choose **Actions** in the top right of the window and select **Modify patch groups**.
1. In the **Modify patch groups** window under **Patch groups**, enter `Critical`, choose **Add**, and then choose **Close** to be returned to the **Patch Baseline** details screen.


## AWS-RunPatchBaseline

[AWS-RunPatchBaseline](https://docs.aws.amazon.com/systems-manager/latest/userguide/patch-manager-ssm-documents.html#patch-manager-ssm-documents-recommended-AWS-RunPatchBaseline) is a command document that enables you to control patch approvals using patch baselines. It reports patch compliance information that you can view using the Systems Manager **Compliance** tools. For example,you can view which instances are missing patches and what those patches are.

For Linux operating systems, compliance information is provided for patches from both the default source repository configured on an instance and from any alternative source repositories you specify in a custom patch baseline. AWS-RunPatchBaseline supports both Windows and Linux operating systems.


## AWS Systems Manager: Document

An [AWS Systems Manager document](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-ssm-docs.html) defines the actions that Systems Manager performs on your managed instances. Systems Manager includes many pre-configured documents that you can use by specifying parameters at runtime, including 'AWS-RunPatchBaseline'. These documents use JavaScript Object Notation (JSON) or YAML, and they include steps and parameters that you specify.

All AWS provided Automation and Run Command documents can be viewed in AWS Systems Manager **Documents**. You can [create your own documents](https://docs.aws.amazon.com/systems-manager/latest/userguide/create-ssm-doc.html) or launch existing scripts using provided documents to implement custom operations as code activities.


### 4.3 **Examine AWS-RunPatchBaseline in Documents**

To examine AWS-RunPatchBaseline in Documents:

1. In the AWS Systems Manager navigation bar under **Shared Resources**, choose **Documents**.
1. Click in the **search box**, select **Document name prefix**, and then **Equal**.
1. Type `AWS-Run` into the text field and press _Enter_ on your keyboard to start the search.
1. Select AWS-RunPatchBaseline and choose **View details**.
1. Review the content of each tab in the details page of the document.


## AWS Systems Manager: Run Command

[AWS Systems Manager Run Command](https://docs.aws.amazon.com/systems-manager/latest/userguide/execute-remote-commands.html) lets you remotely and securely manage the configuration of your managed instances.  Run Command enables you to automate common administrative tasks and perform ad hoc configuration changes at scale. You can use Run Command from the AWS Management Console, the AWS Command Line Interface, AWS Tools for Windows PowerShell, or the AWS SDKs.


### 4.4 Scan Your Instances with AWS-RunPatchBaseline via Run Command

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


### 4.5 Review Initial Patch Compliance

1. Under **Instances & Nodes** in the the AWS Systems Manager navigation bar, choose **Compliance**.
1. On the **Compliance** page in the **Compliance resources summary**, you will now see that there are 4 systems that have critical severity compliance issues. In the **Resources** list, you will see the individual compliance status and details.


### 4.6 Patch Your Instances with AWS-RunPatchBaseline via Run Command

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

### 4.7 Review Patch Compliance After Patching

1. Under **Instances & Nodes** in the the AWS Systems Manager navigation bar, choose **Compliance**.
1. The **Compliance resources summary** will now show that there are 4 systems that have satisfied critical severity patch compliance.

In the optional Scheduling Automated Operations Activities section of this lab you can set up Systems Manager Maintenance Windows and schedule the automated application of patches.


### **The Impact of Operations as Code**

In a traditional environment, you would have had to set up the systems and software to perform these activities. You would require a server to execute your scripts. You would need to manage authentication credentials across all of your systems.

_Operations as code_ reduces the resources, time, risk, and complexity of performing operations tasks and ensures consistent execution. You can take operations as code and automate operations activities by using scheduling and event triggers. Through integration at the infrastructure level you avoid "swivel chair" processes that require multiple interfaces and systems to complete a single operations activity.


# Bonus Content: Creating Maintenance Windows and Scheduling Automated Operations Activities


## AWS Systems Manager: Maintenance Windows

[AWS Systems Manager Maintenance Windows](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-maintenance.html) let you define a schedule for when to perform potentially disruptive actions on your instances such as patching an operating system (OS), updating drivers, or installing software. Each Maintenance Window has a schedule, a duration, a set of registered targets, and a set of registered tasks. With Maintenance Windows, you can perform tasks like the following:

* Installing applications, updating patches, installing or updating SSM Agent, or executing PowerShell commands and Linux shell scripts by using a Systems Manager Run Command task
* Building Amazon Machine Images (AMIs), boot-strapping software, and configuring instances by using Systems Manager Automation
* Executing AWS Lambda functions that trigger additional actions such as scanning your instances for patch updates
* Running AWS Step Function state machines to perform tasks such as removing an instance from an Elastic Load Balancing environment, patching the instance, and then adding the instance back to the Elastic Load Balancing environment
>**Note**<br>To register Step Function tasks you must use the AWS CLI.


### 5.1 Setting up Maintenance Windows

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


### 5.2 Create a Patch Maintenance Window

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


### 5.3 Assigning Targets to Your Patch Maintenance Window

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

### 5.4 Assigning Tasks to Your Patch Maintenance Window

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

### 5.5 Review Maintenance Window Execution

1. After allowing enough time for your maintenance window to complete:
   1. Navigte to the AWS [Systems Manager console](https://console.aws.amazon.com/systems-manager/).
   1. Choose **Maintenance Windows**, and then select the **Window ID** for your new maintenance window.
1. On the **Maintenance window ID** details page, choose **History**.
1. Select a **Windows execution ID** and choose **View details**.
1. On the **Command ID** details page, scroll down to the **Targets and outputs** section, select an **Instance ID**, and choose **View output**.
1. Choose **Step 1 - Output** and review the output.
1. Choose **Step 2 - Output** and review the output.

You have now configured a maintenance window, assigned targets, assigned tasks, and validated successful execution. The same procedures can be used to schedule the execution of any [AWS Systems Manager Document](https://docs.aws.amazon.com/systems-manager/latest/userguide/sysman-ssm-docs.html).

# Bonus Content: Creating a Simple Notification Service Topic

[Amazon Simple Notification Service](https://docs.aws.amazon.com/sns/latest/dg/welcome.html) (Amazon SNS) coordinates and manages the delivery or sending of messages to subscribing endpoints or clients. In Amazon SNS, there are two types of clients: publishers and subscribers. These are also referred to as producers and consumers. Publishers communicate asynchronously with subscribers by producing and sending a message to a topic, which is a logical access point and communication channel. Subscribers (i.e., web servers, email addresses, Amazon SQS queues, AWS Lambda functions) consume or receive the message or notification over one of the supported protocols (i.e., Amazon SQS, HTTP/S, email, SMS, Lambda) when they are subscribed to the topic.

### 6.1 Create and Subscribe to an SNS Topic

To create and subscribe to an SNS topic:

1. Navigate to the SNS console at <https://console.aws.amazon.com/sns/>.
1. Choose **Create topic**.
1. In the **Create new topic** window:
   1. In the **Topic name** field, enter `AdminAlert`.
   1. In the **Display name** field, enter `AdminAlert`.
   1. Choose **Create topic**.
1. On the **Topic details: AdminAlert** page, choose **Create subscription**.
1. In the **Create subscription** window:
   1. Select **Email** from the **Protocol** list.
   1. Enter your email address in the **Endpoint** field.
   1. Choose **Create subscription**.
1. You will receive an email request for confirmation. Your Subscription ID will remain **PendingConfirmation** until you confirm your subscription by clicking through the link to **Confirm subscription** in the email.
1. Refresh the page after confirming your subscription to view the populated **Subscription ARN**.

You can now use this SNS topic to send notifications to your Administrator user.


# 7 Removing Lab Resources

> **Note**<br>When the lab is complete, remove the resources you created. Otherwise you will be charged for any resources that are not covered in the AWS Free Tier.

### 7.1 Remove resources created with CloudFormation
1. Navigate to the **CloudFormation** dashboard at <https://console.aws.amazon.com/cloudformation/>:
   1. Select your first stack.
   1. Choose **Actions** and choose **delete stack**.
   1. Select your second stack.
   1. Choose **Actions** and choose **delete stack**   .
1. Navigate to Systems Manager console at <https://console.aws.amazon.com/systems-manager/>:
   1. Choose **State Manager**.
   1. Select the association you created.
   1. Choose **Delete**.
1. If you created an **S3 bucket** to store detailed output, delete the bucket and associated data:
   1. Navigate to the S3 console <https://s3.console.aws.amazon.com/s3/>.
   1. Select the bucket.
   1. Choose **Delete** and provide the bucket name to confirm deletion.
1. If you created the optional **SNS Topic**, delete the SNS topic:
   1. Navigate to the SNS console <https://console.aws.amazon.com/sns/>.
   1. Select your **AdminAlert** SNS topic from the list.
   1. Choose **Actions** and select **Delete topics**.
1. If you created a **Maintenance Window**, delete the Maintenance Window:
   1. Navigate to the **Systems Manager console** at <https://console.aws.amazon.com/systems-manager/>.
   1. Choose **Maintenance Windows**.
   1. Select the maintenance window you created.
   1. Choose **Delete**.
   1. In the **Delete maintenance window** window, choose **Delete**.
1. If you do not intend to continue to use the Administrator account you created, delete the account:
   1. Navigate to the IAM console at <https://console.aws.amazon.com/iam/>.
   1. Choose **Users**.
   1. Select your user from the list.
   1. Choose **Delete user**.
   1. Select the check box next to "One or more of these users have recently accessed AWS. Deleting them could affect running systems. Check the box to confirm that you want to delete these users.".
   1. Choose **Yes, delete**.
   1. When next you navigate within the console you will be returned to the account login page.
1. If you **do** intend to continue to use the Administrator account you created, we strongly suggest you [**enable MFA**](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable.html).

Thank you for using this lab.
