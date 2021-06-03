---
title: "Step 5 - Apply patches"
date: 2021-05-11T02:06:01-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---



In this exercise we will perform vulnerability scanning and patching on a pre-install EC2 instance, Microsoft based Windows Operating System using Amazon Inspector and AWS Systems Manager respectively. 

Note: For this lab, it is assumed that Microsoft Windows based EC2 instance is already created. For instructions to create EC2 Instance please follow the [link](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/launching-instance.html).

1.  From the AWS console, click **Services** and select **Amazon Inspector.**
    
2.  On the Inspector console click on **Get started**.

3.  Click **Advanced Setup** on the welcome page with default options.

> ![sm_01.png](/Security/Quests/Simple_Security_Steps/Images/sm_01.png)

4.  One 'Define an assessment target' page, leave the values as is and click **Next**.
    
5.  On 'Define an assessment template' page leave the default values as is and click **Next**.
    
6.  On the 'Review' page click on **Create**.

7.  A success notification will appear once the template is created.

> ![sm_02.png](/Security/Quests/Simple_Security_Steps/Images/sm_02.png)

8.  On 'Assessment templates' page select the template that you just have created click on **Run**.

> ![sm_03.png](/Security/Quests/Simple_Security_Steps/Images/sm_03.png)

9.  Wait till the 'Last run' status shows Analysis complete (it may take 5 -10 minutes). Click the refresh icon to view the latest status.
    
10. Click on **Dashboard** on the menu at the left side of the console.

11. Then click on **Important findings,** which will show the list of important issues i.e., missing patches (if the EC2 instance is
    from the latest AMI then you may not get the findings as the AMI is fully patched).
    
12. Now let's patch our machine.

13. From the AWS console, click **Services** and select **AWS Systems Manager**.
    
14. Click on **Quick setup** on menu at the left side of the console.

15. Make sure that correct region is selected on the top right corner of the console. Click on **Get started**.
    
16. On the Quick Setup page click on **Create**.

> ![sm_04.png](/Security/Quests/Simple_Security_Steps/Images/sm_04.png)

17. On 'Choose a configuration type' page, select **Host Management** settings and click **Next**.

> ![sm_05.png](/Security/Quests/Simple_Security_Steps/Images/sm_05.png)

18. On the 'Customize Host Management configuration options' page leave the default values as is and click on **Create**.
    
19. Notification will appear on screen once the host management setup is completed successfully (may take up to 5 minutes).
    
20. One the menu at the left side, scroll down and click on the **Compliance** under Node Management.
    
21. One the 'Compliance resources summary' page the non-compliance status against Patch will be visible if the systems manager detects missing patches within the EC2 instance. Click on the number showing against the missing patches.
    
22. For patching the Operating System, click on **Patch Manager** under Node Management.
    
23. Click on **Patch now** on the upper right side.

24. On 'Patch instances now' page select **Scan and install**. Leave the remaining options as is, scroll down and click **Patch now.**

> ![sm_06.png](/Security/Quests/Simple_Security_Steps/Images/sm_06.png)

25. On 'Association execution summary' page the Status of the operation will become success after few minutes.
    
26. Now go back to 'Compliance' section under Node Management on the left side menu.
    
27. On the 'Compliance resources summary' section, the Patch Compliance type will now show as Compliant.

> ![sm_07.png](/Security/Quests/Simple_Security_Steps/Images/sm_07.png)

28. Click on the Instance ID showed under the resource, which will take you to the Fleet Manager console. Click on the **Patch** tab,
    which will show that no more updates required.

> ![sm_08.png](/Security/Quests/Simple_Security_Steps/Images/sm_08.png)



For more information please read the AWS User Guide:
https://docs.aws.amazon.com/inspector/latest/userguide/inspector_introduction.html
https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-patch.html