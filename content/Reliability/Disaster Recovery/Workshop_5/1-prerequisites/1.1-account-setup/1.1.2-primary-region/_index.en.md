+++
title = "Primary Region"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

#### Option 1: Deploying new resources using AWS CloudFormation template

Follow these steps if you are running this lab without previsouly completeing [Module 4: Hot Standby](/reliability/disaster-recovery/workshop_4/) or if you have cleaned up all the resources. 

{{% notice info %}}
If you want to reuse [Module 4: Hot Standby](/reliability/disaster-recovery/workshop_4/) infrastructure, please follow the steps described in the next section [Option 2: Making changes to the existing resources using AWS CloudFormation template](/reliability/disaster-recovery/workshop_5/1-prerequisites/1.1-account-setup/1.1.2-primary-region/#option-2-making-changes-to-the-existing-resources-using-aws-cloudformation-template)
{{% /notice %}}


1.1 Deploy the application to the primary region **N. Virginia (us-east-1)** by launching this [CloudFormation Template](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?stackName=hot-primary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/7ebe40ac15b94a1e815828a877bde9b3/v7/HotStandby.yaml).

1.2  Specify the stack parameters:
* Stack name: **hot-primary**
* IsPrimary: **yes** (leave the default value)
* LatestAmiId: (leave the default value)

{{% notice info %}}
**Leave isPrimary and LatestAmiId as the default values**
{{% /notice %}}

{{< img pr-4.png >}}

1.3 Click **Next** to continue.

1.4 Leave the **Configure stack options** page defaults and click **Next** to continue.

1.5 Scroll to the bottom of the page and click the **checkbox** to acknowledge IAM role creation, then click **Create stack**.

{{< img pr-5.png >}}

{{% notice warning %}}
You will need to wait for the **Hot Primary Region** stack to have a status of **Completed** before moving on to this section. This will take approximately 15 minutes.
{{% /notice %}}

#### Option 2: Making changes to the existing resources using AWS CloudFormation template

Follow these steps if you are reusing resources created and not removed yet by [Module 4: Hot Standby](/reliability/disaster-recovery/workshop_4/) lab. 

1.1 Go to the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation/) and select the stack **hot-primary** created by the previous lab. 

1.2 In the sub-menu **Stack options** select **Create change set for current stack** 

{{< img pr-chs-1.png >}}

1.3 Select **Replace current template** and use this [CloudFormation Template - URL TO BE CHANGED](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?stackName=hot-primary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/7ebe40ac15b94a1e815828a877bde9b3/v7/HotStandby.yaml).

{{< img pr-chs-2.png >}}

1.4 Specify the stack parameters:
* IsPrimary: **yes** (leave the default value)
* LatestAmiId: (leave the default value)

{{% notice info %}}
**Leave isPrimary and LatestAmiId as the default values**
{{% /notice %}}

{{< img pr-chs-3.png >}}

1.5 Click **Next** to continue.

1.6 Leave the **Configure stack options** page defaults and click **Next** to continue.

1.7 Scroll to the bottom of the page and click the **checkbox** to acknowledge IAM role creation, then click **Create change set**.

{{< img chs-4.png >}}

1.8 Confirm creation of the change set

{{< img chs-5.png >}}

1.9 Review and make sure that the changes to the existing stack as listed on the screenshot - 3 added resources and 5 updated.

{{< img chs-6.png >}}

1.10 Click **Execute change set**

{{< img chs-7.png >}}

1.10 Confirm and click **Execute change set** to apply the changes to the stack

{{< img chs-9.png >}}

{{% notice warning %}}
You will need to wait for the **Hot Primary Region** stack to have a status of **Update Completed** before moving on to the next section. This will take approximately 5 minutes.
{{% /notice %}}

{{< prev_next_button link_prev_url="../1.1.1-s3-access" link_next_url="../1.1.3-secondary-region" />}}