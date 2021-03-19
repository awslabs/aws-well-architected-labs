---
title: "Multi-region Deployment with CloudFormation StackSets"
menutitle: "Multi-region Deployment"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

There might be situations where you want to deploy the same infrastructure in multiple AWS Regions and/or multiple AWS accounts to increase reliability of the workload or to improve performance by having the infrastructure geographically closer to your end users. You can use [AWS CloudFormation StackSets](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/what-is-cfnstacksets.html) to perform this as a single operation instead of switching regions or accounts to individually deploy each stack.

From an administrator account, you can define a CloudFormation template and use it to provision stacks in multiple target accounts, across multiple AWS Regions.

![StackSetsArchitecture](/Reliability/200_Deploy_and_Update_CloudFormation/Images/StackSetsArchitecture.png?classes=lab_picture_auto)

For this exercise we will assume you now know how to edit your CloudFormation template and update your CloudFormation stack with the updated template.

### 6.1 Set up permissions for CloudFormation StackSets

AWS CloudFormation StackSets requires specific permissions to be able to deploy stacks in multiple AWS accounts across multiple AWS Regions. It needs an administrator role that is used to perform StackSets operations, and an execution role to deploy the actual stacks in target accounts. These roles require specific naming conventions - **AWSCloudFormationStackSetAdministrationRole** for the administrator role, and **AWSCloudFormationStackSetExecutionRole** for the execution role. StackSets execution will fail if either of these roles are missing. The **AWSCloudFormationStackSetAdministrationRole** should be created in the account where you are creating the StackSet. The **AWSCloudFormationStackSetExecutionRole** should be created in each target account where you wish to deploy the stack. Learn more about [granting self-managed permissions](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-prereqs-self-managed.html) for CloudFormation StackSets. If you accounts are managed using AWS Organizations, you can [enable trusted access](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacksets-orgs-enable-trusted-access.html) and CloudFormation will take care of provisioning all the necessary roles across the accounts.

For this lab, I will walk you through the process of creating a StackSet to deploy stacks across multiple regions in a single account (the same account where the StackSet is being created). For simplicity and ease of use, I will use CloudFormation to create the administrator and execution roles.

1.  Download the administrator role CloudFormation template - https://s3.amazonaws.com/cloudformation-stackset-sample-templates-us-east-1/AWSCloudFormationStackSetAdministrationRole.yml
1.  Go to the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation) and click **Create Stack** > **With new resources**
1.  Leave **Prepare template** setting as-is
    * For Template source select Upload a template file
    * Click Choose file and supply the CloudFormation template you downloaded: _AWSCloudFormationStackSetAdministrationRole.yml_
1.  For **Stack name** use `StackSetAdministratorRole`
1.  For **Configure stack options** we recommend configuring tags, which are key-value pairs, that can help you identify your stacks and the resources they create. For example, enter _Owner_ in the left column which is the key, and your email address in the right column which is the value. We will not use additional permissions or advanced options so click **Next**. For more information, see [Setting AWS CloudFormation Stack Options](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide//cfn-console-add-tags.html)
1.  For **Review**
    * Review the contents of the page
    * At the bottom of the page, select **I acknowledge that AWS CloudFormation might create IAM resources with custom names**
    * Click **Create stack**

The stack will finish creating and the **Status** will be _CREATE_COMPLETE_ in about 30 seconds.

Now that a StackSet administrator role has been created, we need to create the StackSet execution role.

1.  Download the execution role CloudFormation template - https://s3.amazonaws.com/cloudformation-stackset-sample-templates-us-east-1/AWSCloudFormationStackSetExecutionRole.yml
1.  Go to the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation) and click **Create Stack** > **With new resources**
1.  Leave **Prepare template** setting as-is
    * For Template source select Upload a template file
    * Click Choose file and supply the CloudFormation template you downloaded: _AWSCloudFormationStackSetExecutionRole_
1.  For **Stack name** use `StackSetExecutionRole`
1.  For **Parameters**, enter the 12 digit account ID for the AWS account you are using for this lab.
1.  For **Configure stack options** we recommend configuring tags, which are key-value pairs, that can help you identify your stacks and the resources they create. For example, enter _Owner_ in the left column which is the key, and your email address in the right column which is the value. We will not use additional permissions or advanced options so click **Next**. For more information, see [Setting AWS CloudFormation Stack Options](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide//cfn-console-add-tags.html)
1.  For **Review**
    * Review the contents of the page
    * At the bottom of the page, select **I acknowledge that AWS CloudFormation might create IAM resources with custom names**
    * Click **Create stack**

The stack will finish creating and the **Status** will be _CREATE_COMPLETE_ in about 30 seconds.

Now that the necessary permissions have been created, the next step is to launch CloudFormation stacks across different AWS Regions using StackSets.

### 6.2 Deploy CloudFormation stacks using CloudFormation StackSets

1.  Download the sample template [simple_stackset_plus_s3_ec2_server.yaml](/Reliability/200_Deploy_and_Update_CloudFormation/Code/CloudFormation/simple_stackset_plus_s3_ec2_server.yaml)
1.  Go to the [AWS CloudFormation StackSets console](https://console.aws.amazon.com/cloudformation/home#/stacksets) and click **Create StackSet**

    ![CFNCreateStackSetButton](/Reliability/200_Deploy_and_Update_CloudFormation/Images/CFNCreateStackSetButton.png?classes=lab_picture_auto)

1.  Leave Prepare template setting as-is
    * For **Template source** select **Upload a template file**
    * Click **Choose file** and supply the CloudFormation template you downloaded: _simple_stackset_plus_s3_ec2_server.yaml_

    ![StackSetUploadTemplateFile](/Reliability/200_Deploy_and_Update_CloudFormation/Images/StackSetUploadTemplateFile.png?classes=lab_picture_auto)

1.  Click **Next**
1.  For **Stack name** use `StackSetsLab`
1.  Ensure that the values for the following **Parameters** are as follows. You can use default values for the rest.
    * **PublicEnabledParam** - set to **true**
    * **EC2SecurityEnabledParam** - set to **true**

    ![StackSetParameters](/Reliability/200_Deploy_and_Update_CloudFormation/Images/StackSetParameters.png?classes=lab_picture_auto)

1.  Click **Next**
1.  For **Configure StackSet options** we recommend configuring tags, which are key-value pairs, that can help you identify your stacks and the resources they create. For example, enter _Owner_ in the left column which is the key, and your email address in the right column which is the value.
1.  For **Permissions** select **Self-service permissions**.
    * For **IAM admin role ARN - optional**, select **IAM role name** and then select **AWSCloudFormationStackSetAdministrationRole** from the drop-down.
    * For **IAM execution role name** enter `AWSCloudFormationStackSetExecutionRole`.

    ![StackSetOptions](/Reliability/200_Deploy_and_Update_CloudFormation/Images/StackSetOptions.png?classes=lab_picture_auto)

1.  Click **Next**
1.  Under **Accounts**, select **Deploy stacks in accounts** under **Deployment locations**.
1.  Under **Account numbers** enter the 12 digit AWS account ID for the account you are using for this lab. You can find this by clicking on the user/role drop down you have logged into the account with on the top right corner.

    ![StackSetAccounts](/Reliability/200_Deploy_and_Update_CloudFormation/Images/StackSetAccounts.png?classes=lab_picture_auto)

1.  Under **Specify regions** select 2 regions you would like to deploy the stacks across. I have selected **US East (N.Virginia)** and **US West (Oregon)**.
1.  Leave values for **Deployment options** as-is and click **Next**.

    ![StackSetRegions](/Reliability/200_Deploy_and_Update_CloudFormation/Images/StackSetRegions.png?classes=lab_picture_auto)

1.  For **Review**
    * Review the contents of the page
    * Click **Submit**

The operation takes about 3-4 minutes to complete and the stacks to be deployed in the selected Regions.

### 6.3 Review infrastructure created

1.  Go to the [AWS CloudFormation StackSets console](https://console.aws.amazon.com/cloudformation/home#/stacksets) and click on the StackSet **StackSetsLab**.
1.  Click on the **Stack instances** tab to see the AWS account and region stacks were deployed in.

    ![StackSetStackInstances](/Reliability/200_Deploy_and_Update_CloudFormation/Images/StackSetStackInstances.png?classes=lab_picture_auto)

1.  Change the AWS Region you are on by clicking on the top right corner of the console and select one of the AWS Regions you specified for the StackSet. In my case, I will select **US West (Oregon) us-west-2**.
1.  After switching regions, go to the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation)
1.  You should see a new CloudFormation stack that has been created with the prefix **StackSet-StackSetsLab-**.
1.  Click on the stack name and then click on the **Outputs** tab.
1.  Click on the **Value** for **PublicServerDNS** and observe the response.

    ![StackInstance](/Reliability/200_Deploy_and_Update_CloudFormation/Images/StackInstance.png?classes=lab_picture_auto)

Repeat the previous steps for another AWS Region that you specified when creating the StackSet. You will see that the webpage has changed to reflect the region the instance was launched in. Using StackSets, you have deployed your infrastructure to various AWS Regions in a single operation. This will greatly increase the speed of multi-region and multi-account deployments of your infrastructure and is controlled from a central location.

**Troubleshooting**

* If the CloudFormation StackSet operation fails, then click on the **Stack instances** tab to find the source of the error
* Note that some AWS Service Quotas are regional. If you are seeing an error that says you have reached the limit for a particular resource type, try using a different region or submitting a ticket to AWS Support to increase the limit.
* If you see an error regarding missing execution role, make sure you have completed section 6.1 of this lab guide and created the necessary execution role.

{{< prev_next_button link_prev_url="../5_add_ec2/" link_next_url="../7_cleanup" />}}
