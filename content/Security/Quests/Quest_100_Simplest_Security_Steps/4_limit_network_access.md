---
title: "Step 4 - Limit Network Access"
date: 2021-05-11T01:55:07-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---



In this exercise we will use AWS Trusted Advisor's basic security checks to identify remote access risks associated with the EC2 instance and fix them. Furthermore, we will use AWS Systems Manager's feature to secure our remote access.

Note: For this lab, it is assumed that Microsoft Windows based EC2 instance is already created with default settings. For instructions to create EC2 Instance please follow the [link](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/launching-instance.html).

1.  From the AWS console, click **Services** and select **Trusted Advisor.**
    
2.  On the Trusted Advisor console click on **Refresh All** icon on the right side as shown below.

> ![remaccess_01.png](/Security/Quests/Simple_Security_Steps/Images/remaccess_01.png)

3.  You will notice that there are few risks identified by Trusted Advisor. Click on **Security** tab. You will notice findings for
    security groups about open network access. Now let's fix these issues.

> ![remaccess_02.png](/Security/Quests/Simple_Security_Steps/Images/remaccess_02.png)

4.  Click on one of the findings, which expand with more details. You will also see the list of security group names that have this
    particular security issue. Click on the Security Group Name in the list. It will open a Security Group console on a new browser tab.

> ![remaccess_03.png](/Security/Quests/Simple_Security_Steps/Images/remaccess_03.png)

5.  On Security Groups page, click on the **Inbound rules**. You will notice that there is one rule allowing open access to port 3389
    from the internet, which is not a good practice. Therefore, we need to remove this rule.

> ![remaccess_04.png](/Security/Quests/Simple_Security_Steps/Images/remaccess_04.png)

6.  Click on **Edit inbound rules**.

7.  Click **Delete** associated with the open port of 3389. Click **Save rules**, which will remove the rule permanently.

> ![remaccess_05.png](/Security/Quests/Simple_Security_Steps/Images/remaccess_05.png)

8.  Now go back to Trusted Advisor tab and click on the **Refresh this check** icon associated with the
    security risk.
9.  Trusted Advisor will re-run the check and will show green once it finds that the issue is fixed.

> ![remaccess_06.png](/Security/Quests/Simple_Security_Steps/Images/remaccess_06.png)

10. Now to access the EC2 instance securely, we will be using AWS System's Manager capability called Session Manager.
    
11. From the AWS console, click Services and select **Systems Manager**.

12. Click on **Fleet Manager** under Node Management on the menu at the left side of Systems Manager console.
    
13. Click on **Get Started**.

14. You will see your instance(s) listed which are managed by Systems Manager.

> ![remaccess_07.png](/Security/Quests/Simple_Security_Steps/Images/remaccess_07.png)

15. Click on the **Settings** tab.

16. Click on **Change account setting** button in order to use an Advanced Instance Tier which allows you to use Session Manager
    capability.
    
17. Accept the changes by clicking on the checkbox and click on **Change setting**.
    
18. Click on **Session Manager** under Node Management on the menu at the left side of Systems Manager console.
    
19. Click on **Start Session** on upper right.

20. Select the instance that you want to have access and then click **Start session.**

> ![remaccess_08.png](/Security/Quests/Simple_Security_Steps/Images/remaccess_08.png)

21. A new tab will be opened and you will have the Microsoft Windows command prompt or Linux terminal window.

> ![remaccess_09.png](/Security/Quests/Simple_Security_Steps/Images/remaccess_09.png)

22. To exit the session simply use relevant OS command or click **Terminate** on upper right side of the page.



For more information please read the AWS User Guide:
https://docs.aws.amazon.com/awssupport/latest/user/trusted-advisor.html
https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html