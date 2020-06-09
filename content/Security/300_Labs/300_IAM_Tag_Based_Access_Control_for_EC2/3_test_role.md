---
title: "Test Role"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

### 3.1 Assume **ec2-admin-team-alpha** Role

Now you will use an existing IAM user with MFA enabled to assume the new *ec2-admin-team-alpha* role.

1. Sign in to the AWS Management Console as an IAM user with MFA enabled. [https://console.aws.amazon.com](https://console.aws.amazon.com).
2. In the console, click your user name on the navigation bar in the upper right. It typically looks like this: `username@account_ID_number_or_alias` then click **Switch Role**. Alternatively you can paste the link in your browser that you recorded earlier.
3. On the Switch Role page, type you account ID number in the **Account** field,  and the name of the role *ec2-admin-team-alpha* that you created in the previous step in the **Role** field. (Optional) Type text that you want to appear on the navigation bar in place of your user name when this role is active. A name is suggested, based on the account and role information, but you can change it to whatever has meaning for you. You can also select a color to highlight the display name.
4. Click **Switch Role**. If this is the first time choosing this option, a page appears with more information. After reading it, click Switch Role. If you clear your browser cookies, this page can appear again.

![switch-role-developer](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/switch-role-developer.png)

5. The display name and color replace your user name on the navigation bar, and you can start using the permissions that the role grants you replacing the permission that you had as the IAM user.

    **Tip**

	The last several roles that you used appear on the menu. The next time you need to switch to one of those roles, you can simply click the role you want. You only need to type the account and role information manually if the role is not displayed on the Identity menu.

### 3.2 Launch Instance With & Without Tags

1. Navigate to the EC2 Management Console in the us-east-2 (Ohio) region [https://us-east-2.console.aws.amazon.com/ec2/v2/home?region=us-east-2](https://us-east-2.console.aws.amazon.com/ec2/v2/home?region=us-east-2). The EC2 Dashboard should display a list of errors including *You are not authorized*. This is the first test passed, as us-east-2 region is not allowed.

![ec2-resources-denied](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-resources-denied.png)

2. Navigate to the EC2 Management Console in the us-east-1 (North Virginia) region [https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1](https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1). The EC2 Dashboard should display a summary list of resources with the only error being *Error retrieving resource count* from Elastic Load Balancing as that requires additional permissions.

![ec2-resources-denied](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-resources-allowed.png)

3. Click *Launch Instance* button to start the wizard.
4. Click *Select* next to the first Amazon Linux 2 Amazon Machine Image to launch.

![ec2-launch-1](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-launch-1.png)

5. Accept the default instance size by clicking *Next: Configure Instance Details*.

![ec2-launch-2](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-launch-2.png)

6. Accept default details by clicking *Next: Add Storage*.

![ec2-launch-3](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-launch-3.png)

7. Accept default storage options by clicking *Next: Add Tags*.

![ec2-launch-4](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-launch-4.png)

8. Lets add an incorrect tag now that will fail to launch. Click *Add Tag* enter *Key* of **Name** and *Value* of **Example**. Repeat to add *Key* of **Team** and *Value* of **Beta**. Note: Keys and values are case sensitive! Click *Next: Configure Security Group*.

![ec2-launch-5-tag-beta](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-launch-5-tag-beta.png)

9. Click *Select an existing security group*, click the check box next to security group with name *default*, then click *Review and Launch*.

![ec2-launch-6](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-launch-6.png)

10. Click *Launch* then click the option to *Proceed without a key pair*. Tick the *I acknowledge* box then click *Launch Instances*.

![ec2-launch-5-tag-beta](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-launch-7-no-key.png)

11. The launch should fail, if it succeeded verify the role you are using and the managed roles you have attached as per previous steps.

![ec2-launch-failed](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-launch-failed.png)

12. Click *Back to Review Screen* then click *Edit tags* to modify the tags. Change the *Team* key to a value of **Alpha** which matches the IAM policy previously created then click *Review and Launch*.

![ec2-launch-5-tag-alpha](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-launch-5-tag-alpha.png)

13. On the review launch page once again click *Launch* then click the option to *Proceed without a key pair*. Tick the *I acknowledge* box then click *Launch Instances*.
14. You should see a message that the instance is now launching. Click *View Instances* and do not terminate it just yet.

![ec2-launch-5-tag-success](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-launch-success.png)

### 3.3 Modify Tags On Instances

1. Continuing from 3.2 in the EC2 Management Console instances view, click the check box next to the instance named *Example* then the *Tags* tab.

![ec2-tag-1](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-tag-1.png)

2. Click *Add/Edit Tags*, try changing the *Team* key to a value of **Test** then click *Save*. An error message should appear.
3. Change the *Team* key back to Alpha, and edit the *Name* key to a value of **Test** and click *Save*. The request should succeed.

### 3.4 Manage Instances

1. Continuing from 3.3 in the EC2 Management Console instances view, click the check box next to the instance named *Test*. Click *Actions* button then expand out *Instance State* then *Terminate*. Check the instance is the one you wish to terminate by it's name and click *Yes, Terminate*. The instance should now terminate.

![ec2-instance-terminate](/Security/300_IAM_Tag_Based_Access_Control_for_EC2/Images/ec2-instance-terminate.png)

10. Congratulations! You have now learnt about IAM tag based permissions for EC2!
