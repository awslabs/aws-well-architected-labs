---
title: "Create an IAM Role to use with Amazon CloudWatch Agent"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

Access to AWS resources requires permissions. You will now create an IAM role to grant permissions that the agent needs to write metrics to CloudWatch. Amazon created two new default policies called *CloudWatchAgentServerPolicy* and *CloudWatchAgentAdminPolicy* only for that purpose.

1. To create the IAM role first you will need to sign in to the **AWS Management Console** and open the **IAM console**
![Images/IAMrole01.png](/Cost/200_AWS_Resource_Optimization/Images/IAMrole01.png)

2. In the navigation pane on the left, choose **Roles** and then **Create role**.
![Images/IAMrole02.png](/Cost/200_AWS_Resource_Optimization/Images/IAMrole02.png)

3. Under **Choose the service that will use this role**, choose **EC2 Allows EC2 instances to call AWS services on your behalf.** Choose **Next: Permissions**.
![Images/IAMrole03.png](/Cost/200_AWS_Resource_Optimization/Images/IAMrole03.png)

4. In the list of policies, select the check box next to *CloudWatchAgentServerPolicy*. If necessary, use the search box to find the policy, click **Next: Tags**:
4. ![Images/IAMrole04.png](/Cost/200_AWS_Resource_Optimization/Images/IAMrole04.png)

5. Add tags (optional) for this policy, click **Next: Review**.
![Images/IAMrole05.png](/Cost/200_AWS_Resource_Optimization/Images/IAMrole05.png)

6. Confirm that **CloudWatchAgentServerPolicy** appears next to **Policies**. In Role name, enter a name for the role, such as **CloudWatchAgentServerRole**. Optionally give it a description. Then click **Create role**.
![Images/IAMrole06.png](/Cost/200_AWS_Resource_Optimization/Images/IAMrole06.png)

The role is now created.
