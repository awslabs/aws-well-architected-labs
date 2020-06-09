---
title: "Assume Administrator Role from an IAM user"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---
We will assume the role using the IAM user that we previously created in the web console. As the IAM user has full access it is a best practice not to have access keys to assume the role on the CLI, instead we should use a restricted IAM user for this so we can enforce the requirement of MFA.

The following image shows what you will be doing in the next section 2.1 Use Administrator Role in Web Console.

![iam-create-user&group](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/iam-switch-role.png)

### 2.1 Use Administrator Role in Web Console

A *role* specifies a set of permissions that you can use to access AWS resources that you need. In that sense, it is similar to a user in AWS Identity and Access Management (IAM). A benefit of roles is they allow you to enforce the use of an MFA token to help protect your credentials. When you sign in as a user, you get a specific set of permissions. However, you don't sign in to a role, but once signed in (as a user) you can switch to a role. This temporarily sets aside your original user permissions and instead gives you the permissions assigned to the role. The role can be in your own account or any other AWS account. By default, your AWS Management Console session lasts for one hour.

{{% notice tip %}}
The permissions of your IAM user and any roles that you switch to are not cumulative. Only one set of permissions is active at a time. When you switch to a role, you temporarily give up your user permissions and work with the permissions that are assigned to the role. When you exit the role, your user permissions are automatically restored.
{{% /notice %}}

1. Sign in to the AWS Management Console as an IAM user [https://console.aws.amazon.com](https://console.aws.amazon.com).
2. In the console, click your user name on the navigation bar in the upper right. It typically looks like this: `username@account_ID_number_or_alias`. Alternatively you can paste the link in your browser that you recorded earlier.
3. Click Switch Role. If this is the first time choosing this option, a page appears with more information. After reading it, click Switch Role. If you clear your browser cookies, this page can appear again.

![switch-role](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/switch-role.png)

4. On the Switch Role page, type the account ID number or the account alias in the **Account** field, and the name of the role that you created for the Administrator in the **Role** field.
5. (Optional) Type text that you want to appear on the navigation bar in place of your user name when this role is active. A name is suggested, based on the account and role information, but you can change it to whatever has meaning for you. You can also select a color to highlight the display name. The name and color can help remind you when this role is active, which changes your permissions. For example, for a role that gives you access to the test environment, you might specify a Display Name of Test and select the green Color. For the role that gives you access to production, you might specify a Display Name of Production and select red as the Color.
6. Click Switch Role. The display name and color replace your user name on the navigation bar, and you can start using the permissions that the role grants you.

{{% notice tip %}}

The last several roles that you used appear on the menu. The next time you need to switch to one of those roles, you can simply click the role you want. You only need to type the account and role information manually if the role is not displayed on the Identity menu.

{{% /notice %}}

7. You are now using the role with the granted permissions!

   **To stop using a role**
   In the IAM console, click your role's Display Name on the right side of the navigation bar. Click Back to UserName. The role and its permissions are deactivated, and the permissions associated with your IAM user and groups are automatically restored.
