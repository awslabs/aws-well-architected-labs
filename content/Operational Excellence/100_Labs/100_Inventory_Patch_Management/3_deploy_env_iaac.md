---
title: "Deploy an Environment Using Infrastructure as Code"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

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

### 3.1 Deploy the Lab Infrastructure

To deploy the lab infrastructure:

1. [**Download the CloudFormation script** for this lab from](/Operations/100_Inventory_and_Patch_Mgmt/Code/OE_Inventory_and_Patch_Mgmt.json).
1. Use your administrator account to access the CloudFormation console at <https://console.aws.amazon.com/cloudformation/>.
1. Choose **Create Stack**.
1. On the **Select Template** page, select **Upload a template file** and select the `OE_Inventory_and_Patch_Mgmt.json` file you just downloaded.

**AWS CloudFormation Designer**

AWS [CloudFormation Designer](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/working-with-templates-cfn-designer.html) is a graphic tool for creating, viewing, and modifying AWS CloudFormation templates. With Designer you can diagram your template resources using a drag-and-drop interface. You can edit their details using the integrated JSON and YAML editor. AWS CloudFormation Designer can help you see the relationship between template resources.

5. On the **Select Template** page, in the lower-right corner, click the **View in Designer** button.
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
