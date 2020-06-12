---
title: "Create and Test Developer Role"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

### 2.1 Create Developer Role

Create a role for developers that will have permission to create roles and policies, with the permission boundary and naming prefix enforced:

1. Sign in to the AWS Management Console as an IAM user with MFA enabled that can assume roles in your AWS account, and open the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
2. In the navigation pane, click **Roles** and then click **Create role**.

![iam-role-1](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-role-create-1.png)

3. Click Another AWS account, then enter your account ID and tick Require MFA, then click **Next: Permissions**. We enforce MFA here as it is a best practice.  ![iam-role-2](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-role-create-2.png)
4. In the search field start typing *createrole* then check the box next to the *createrole-restrict-region-boundary* policy.

![iam-role-3](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-role-create-3.png)

5. Erase your previous search and start typing *iam-res* then check the box next to the *iam-restricted-list-read* policy and then click **Next: Tags**.

![iam-role-4](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-role-create-4.png)

6. For this lab we will not use IAM tags, click **Next: Review**.
7. Enter the name of *developer-restricted-iam* for the **Role name** and click **Create role**.

![iam-role-6](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-role-create-5.png)

8. Check the role you have created by clicking on *developer-restricted-iam* in the list. Record both the Role ARN and the link to the console.
9. The role is now created, ready to test!

### 2.2. Test Developer Role

Now you will use an existing IAM user with MFA enabled to assume the new *developer-restricted-iam* role.

1. Sign in to the AWS Management Console as an IAM user with MFA enabled. [https://console.aws.amazon.com](https://console.aws.amazon.com).
2. In the console, click your user name on the navigation bar in the upper right. It typically looks like this: `username@account_ID_number_or_alias`then click **Switch Role**. Alternatively you can paste the link in your browser that you recorded earlier.
3. On the Switch Role page, type the account ID number or the account alias and the name of the role *developer-restricted-iam* that you created in the previous step. (Optional) Type text that you want to appear on the navigation bar in place of your user name when this role is active. A name is suggested, based on the account and role information, but you can change it to whatever has meaning for you. You can also select a color to highlight the display name.
4. Click **Switch Role**. If this is the first time choosing this option, a page appears with more information. After reading it, click Switch Role. If you clear your browser cookies, this page can appear again.

![switch-role-developer](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/switch-role-developer.png)

5. The display name and color replace your user name on the navigation bar, and you can start using the permissions that the role grants you replacing the permission that you had as the IAM user.

    **Tip**

	The last several roles that you used appear on the menu. The next time you need to switch to one of those roles, you can simply click the role you want. You only need to type the account and role information manually if the role is not displayed on the Identity menu.
6. You are now using the developer role with the granted permissions, stay logged in using the role for the next section.
