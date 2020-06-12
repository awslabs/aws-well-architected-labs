---
title: "Create and Test User Role"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

### 3.1 Create User Role

While you are still assuming the *developer-restricted-iam* role you created in the previous step, create a new user role with the boundary policy attached and name it with the prefix. We will use AWS managed policies for this user role, however the *createrole-restrict-region-boundary* policy will allow us to create and attach our own policies, only if they have a prefix of *app1*.

1. Verify that you are Using the developer role previously created by checking the top bar it should look like ![iam-role-developer-restricted-iam](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-role-developer-restricted-iam.png) and open the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/). You will notice a number of permission denied messages as this developer role is restricted. Least privilege is a best practice!
2. In the navigation pane, click **Roles** and then click **Create role**.  

![iam-role-1](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-role-create-1.png)

3. Click **Another AWS account**, then enter your account ID that you have been using for this lab and tick **Require MFA**, then click **Next: Permissions**. ![iam-role-2](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-role-create-2.png)
4. In the search field start typing *ec2full* then check the box next to the *AmazonEC2FullAccess* policy.

![iam-role-3](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-role-create-b3.png)

5. Erase your previous search and start typing *lambda* then check the box next to the *AWSLambdaFullAccess* policy.

![iam-role-4](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-role-create-b4.png)

6. Expand the bottom section **Set permissions boundary** and click **Use a permissions boundary to control the maximum role permissions**. In the search field start typing *boundary* then click the radio button for *restrict-region-boundary* and then click **Next: Tags**.

![iam-role-5](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-role-create-b5.png)

7. For this lab we will not use IAM tags, click **Next: Review**.
8. Enter the **Role name** of *app1-user-region-restricted-services* for the role and click **Create role**.

![iam-role-6](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/iam-role-create-b6.png)

9. The role should create successfully if you followed all the steps. Record both the Role ARN and the link to the console.
If you receive an error message a common mistake is not changing the account number in the policies in the previous steps.

### 3.2 Test User Role
Now you will use an existing IAM user to assume the new *app1-user-region-restricted-services* role, as if you were a user who only needs to administer EC2 and Lambda in your allowed regions.

1. In the console, click your role's Display Name on the right side of the navigation bar. Click Back to your previous *username*. You are now back to using your original IAM user.
2. In the console, click your user name on the navigation bar in the upper right. Alternatively you can paste the link in your browser that you recorded earlier for the *app1-user-region-restricted-services* role.
3. On the Switch Role page, type the account ID number or the account alias and the name of the role *app1-user-region-restricted-services* that you created in the previous step.
5. Select a different color to before, otherwise it will overwrite that profile in your browser.
6. Click **Switch Role**. The display name and color replace your user name on the navigation bar, and you can start using the permissions that the role grants you.

![switch-role-user](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/switch-role-user.png)

7. You are now using the user role with the only actions allowed of EC2 and Lambda in us-east-1 (North Virginia) and us-west-1 (North California) regions!
8. Navigate to the EC2 Management Console in the us-east-1 region [https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1](https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1). The EC2 Dashboard should display a summary list of resources with the only error being *Error retrieving resource count* from Elastic Load Balancing as that requires additional permissions.

![ec2-resources-allowed](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/ec2-resources-allowed.png)

9. Navigate to the EC2 Management Console in a region that is not allowed, such as ap-southeast-2 (Sydney) [https://ap-southeast-2.console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2](https://ap-southeast-2.console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2). The EC2 Dashboard should display a number of unauthorized error messages.

![ec2-resources-denied](/Security/300_IAM_Permission_Boundaries_Delegating_Role_Creation/Images/ec2-resources-denied.png)

10. Congratulations! You have now learnt about IAM permission boundaries and have one working!
