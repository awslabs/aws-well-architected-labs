# Level 200: Automated Deployment of IAM Groups and Roles: Lab Guide


## 1. AWS CloudFormation to Create a Groups, Policies and Roles with MFA Enforced
Using [AWS CloudFormation](https://aws.amazon.com/cloudformation/) we are going to deploy a set of groups, roles, and managed policies that will help with your security "baseline" of your AWS account.

### 1.1 Create AWS CloudFormation Stack
1. Sign in to the AWS Management Console, select your preferred region, and open the CloudFormation console at [https://console.aws.amazon.com/cloudformation/](https://console.aws.amazon.com/cloudformation/).
2. Click Create New Stack.
3. Select Specify an Amazon S3 template URL and enter the following URL for the template: `https://s3-us-west-2.amazonaws.com/aws-well-architected-labs/Security/Code/baseline-iam.yaml` and click Next.
4. Enter the following details:
  * Stack name: The name of this stack. For this lab, use `baseline-iam`.
  * AllowRegion: A single region to restrict access, for future use.
  * BaselineExportName: The CloudFormation export name prefix used with the resource name for the resources created, for example, Baseline-PrivilegedAdminRole.
  * BaselineNamePrefix: The prefix for roles, groups, and policies created by this stack.
  * IdentityManagementAccount: (optional) AccountId that contains centralized IAM users and is trusted to assume all roles, or blank for no cross-account trust. Note that the trusted account needs to be appropriately secured.
  * OrganizationsRootAccount: (optional) AccountId that is trusted to assume Organizations role, or blank for no cross-account trust. Note that the trusted account needs to be appropriately secured.
  * ToolingManagementAccount: AccountId that is trusted to assume the ReadOnly and StackSet roles, or blank for no cross-account trust. Note that the trusted account needs to be appropriately secured.
5. Click Next.
6. In this scenario, we won't add any tags or other options. Click Next. Tags, which are key-value pairs, can help you identify your stacks. For more information, see [Adding Tags to Your AWS CloudFormation Stack](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide//cfn-console-add-tags.html).
7. Review the information for the stack. When you're satisfied with the settings, click Next.
8. Select I acknowledge that AWS CloudFormation might create IAM resources with custom names, and click
Create.
9. After a few minutes, the stack status should change from CREATE_IN_PROGRESS to CREATE_COMPLETE.
10. You have now set up a number of managed polices, groups, and roles that you can test to improve your AWS security!

## 2. Assume Roles from an IAM user
We will assume the roles previously created in the web console and command line interface (CLI) using an existing IAM user.

### 2.1 Use Restricted Administrator Role in Web Console
A *role* specifies a set of permissions that you can use to access AWS resources that you need. In that sense, it is similar to a user in AWS Identity and Access Management (IAM). A benefit of roles is they allow you to enforce the use of an MFA token to help protect your credentials. When you sign in as a user, you get a specific set of permissions. However, you don't sign in to a role, but once signed in (as a user) you can switch to a role. This temporarily sets aside your original user permissions and instead gives you the permissions assigned to the role. The role can be in your own account or any other AWS account. By default, your AWS Management Console session lasts for one hour.

  **Important**

    The permissions of your IAM user and any roles that you switch to are not cumulative. Only one set of permissions is active at a time. When you switch to a role, you temporarily give up your user permissions and work with the permissions that are assigned to the role. When you exit the role, your user permissions are automatically restored.

1. Sign in to the AWS Management Console as an IAM user [https://console.aws.amazon.com](https://console.aws.amazon.com).
2. In the console, click your user name on the navigation bar in the upper right. It typically looks like this: `username@account_ID_number_or_alias`. Alternatively you can paste the link in your browser that you recorded earlier.
3. Click Switch Role. If this is the first time choosing this option, a page appears with more information. After reading it, click Switch Role. If you clear your browser cookies, this page can appear again. ![switch-role](Images/switch-role.png)
4. On the Switch Role page, type the account ID number or the account alias and the name of the role that you created for the Administrator in the previous step, for example, `arn:aws:iam::account_ID:role/Administrator`.
5. (Optional) Type text that you want to appear on the navigation bar in place of your user name when this role is active. A name is suggested, based on the account and role information, but you can change it to whatever has meaning for you. You can also select a color to highlight the display name. The name and color can help remind you when this role is active, which changes your permissions. For example, for a role that gives you access to the test environment, you might specify a Display Name of Test and select the green Color. For the role that gives you access to production, you might specify a Display Name of Production and select red as the Color.
6. Click Switch Role. The display name and color replace your user name on the navigation bar, and you can start using the permissions that the role grants you.

    **Tip**

	The last several roles that you used appear on the menu. The next time you need to switch to one of those roles, you can simply choose the role you want. You only need to type the account and role information manually if the role is not displayed on the Identity menu.
7. You are now using the role with the granted permissions!
	**To stop using a role**
    In the IAM console, choose your role's Display Name on the right side of the navigation bar.
    Choose Back to UserName. The role and its permissions are deactivated, and the permissions associated with your IAM user and groups are automatically restored.

### 2.2 Use Restricted Administrator Role in Command Line Interface (CLI)
Coming soon, for now check out: [https://docs.aws.amazon.com/cli/latest/userguide/cli-roles.html](https://docs.aws.amazon.com/cli/latest/userguide/cli-roles.html)


***


## 3. Tear down this lab
The following instructions will remove the resources that have a cost for running them. Please note that the changes you made to the root login, users, groups, and policies have no charges associated with them.

Delete the IAM stack:
1. Sign in to the AWS Management Console, and open the CloudFormation console at https://console.aws.amazon.com/cloudformation/.
2. Select the `baseline-iam` stack.
3. Click the Actions button then click Delete Stack.
4. Confirm the stack and then click the Yes, Delete button.


***

## References & useful resources:
[AWS Identity and Access Management User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)  
[IAM Best Practices and Use Cases](https://docs.aws.amazon.com/IAM/latest/UserGuide/IAMBestPracticesAndUseCases.html)  
[AWS CloudFormation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)  

***

## License
Licensed under the Apache 2.0 and MITnoAttr License. 

Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
