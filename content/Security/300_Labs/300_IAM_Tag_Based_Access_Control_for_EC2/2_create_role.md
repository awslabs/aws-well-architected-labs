---
title: "Create Role"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

Create a role for EC2 administrators, and attach the managed policies previously created.

1. Sign in to the AWS Management Console as an IAM user with MFA enabled that can assume roles in your AWS account, and open the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
2. In the navigation pane, click **Roles** and then click **Create role**.

![iam-role-1](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/iam-role-create-1.png)

3. Click Another AWS account, then enter the account ID of the account you are using now and tick Require MFA, then click **Next: Permissions**. We enforce MFA here as it is a best practice.
![iam-role-2](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/iam-role-create-2.png)

4. In the search field start typing *ec2-* then check the box next to the policies you just created: *ec2-create-tags*, *ec2-create-tags-existing*, *ec2-list-read*, *ec2-manage-instances*, *ec2-run-instances*. and then click **Next: Tags**.

![iam-role-3](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/iam-role-create-3.png)

5. For this lab we will not use IAM tags, click **Next: Review**.
6. Enter the name of *ec2-admin-team-alpha* for the **Role name** and click **Create role**.

![iam-role-6](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/iam-role-create-4.png)

8. Check the role you have created by clicking on *ec2-admin-team-alpha* in the list. Record both the Role ARN and the link to the console.
9. The role is now created, ready to test!
