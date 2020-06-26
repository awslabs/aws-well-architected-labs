---
title: "AWS Identity & Access Management"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

As a best practice, do not use the AWS account root user for any task where it's not required. Instead, create a new IAM user for each person that requires administrator access. Then make those users administrators (only if they absolutely need full access to everything) by placing the users into an "Administrators" group to which you attach the AdministratorAccess managed policy.

{{% notice note %}}
It is highly recommended you centralize your identities instead of using IAM Users and Groups as outlined in this lab. If you have more than a simple AWS test account, use [AWS Single Sign-On](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html).
{{% /notice %}}

The following image shows what you will be doing in the next section 1.1 Create Administrator IAM User and Group.

![iam-create-user&group](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/iam-create-user&group.png)

### 1.1 Create Administrator IAM User and Group

To create an administrator user for yourself and add the user to an administrators group:

1. Use your AWS account email address and password to sign in as the AWS account root user to the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
2. In the navigation pane, click **Users** and then click **Add user**.

![iam-create-user](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/iam-create-user.png)

3. For *User name*, type a user name for yourself, such as Bob or Alice. Each user should have their own user name, do not share credentials. The name can consist of letters, digits, and the following characters: plus `(+)`, equal `(=)`, comma `(,)`, period `(.)`, at `(@)`, underscore `(_)`, and hyphen `(-)`. The name is not case sensitive and can be a maximum of 64 characters in length.
4. Select the check box next to **AWS Management Console access**, select **Custom password**, and then type your new password in the text box. This user will be able to do almost anything in your account, by not giving it programmatic access (access & secret key) you reduce your risk, and we will configure lower-privileged users and roles later. If you're creating the user for someone other than yourself, you can optionally select Require password reset to force the user to create a new password when first signing in.

![iam-add-user-1](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/iam-add-user-1.png)

5. Click **Next: Permissions**.
6. On the Set permissions for user page, click **Add user to group**.
7. Click **Create group**.
8. In the Create group dialog box, type the name for the new group such as Administrators. The name can consist of letters, digits, and the following characters: `plus (+), equal (=), comma (,), period (.), at (@), underscore (_), and hyphen (-).` The name is not case sensitive and can be a maximum of 128 characters in length.
9. In the policy list, select the check box next to **AdministratorAccess**. Then click **Create group**.

![iam-add-user-2](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/iam-add-user-2.png)

10. Back in the list of groups, verify the check box is next to your new group. Click **Refresh** if necessary to see the group in the list.

![iam-add-user-3](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/iam-add-user-3.png)

11. Click **Next: Tags**. For this lab we will not add tags to the user.
12. Click **Next: Review** to see the list of group memberships to be added to the new user. When you are ready to proceed, click Create user.

![iam-add-user-4](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/iam-add-user-4.png)

You can use this same process to create more groups and users and to give your users access to your AWS account resources. To learn about using policies that restrict user permissions to specific AWS resources, see [Access Management](https://docs.aws.amazon.com/IAM/latest/UserGuide/access.html) and [Example Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_examples.html). To add users to the group after it's created, see [Adding and Removing Users in an IAM Group](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups_manage_add-remove-users.html).

13. Configure MFA on your new administrator user by choosing **Users** from the navigation pane.
14. In the User Name list, click the name of the intended MFA user.
15. Click the **Security credentials** tab. Next to **Assigned MFA device**, click the **edit** icon.

![iam-user-mfa](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/iam-user-mfa.png)

16. You can now use this administrator user instead of your root user for this AWS account. It is a best practice to use least privileged access approach to granting permissions, not everyone needs full administrator access!

The following image shows what you will be doing in the next section 1.2 Create Administrator IAM Role.

![iam-create-user&group](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/iam-create-role.png)

### 1.2 Create Administrator IAM Role

To create an administrator role for yourself (and other administrators) to be used with the administrator user and group you just created:

1. Sign in to the AWS Management Console and open the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
2. In the navigation pane, click **Roles** and then click **Create role**.
3. Click Another AWS account, then enter your account ID and tick **Require MFA**, then click **Next: Permissions**

![iam-role-1](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/iam-role-create-1.png)

4. Tick AdministratorAccess from the list, and then click **Next: Tags**.
5. Click **Next: Review**

![iam-role-2](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/iam-role-create-2.png)

5. Enter a role name, e.g. 'Administrators' then click **Create role**.

![iam-role-3](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/iam-role-create-3.png)

6. Check the role you have configured by clicking the role you have just created. Record both the Role ARN and the link to the console. You can also optionally change the session duration timeout. ![iam-role-created](/Security/100_Basic_Identity_and_Access_Management_User_Group_Role/Images/iam-role-created.png)
6. The role is now created, with full administrative access and MFA enforced.
