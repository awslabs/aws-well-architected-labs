---
title: "Step 3 - Replace hardcoded credentials"
date: 2021-05-11T01:25:03-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---



In this exercise we will use AWS Secrets Manager to easily manage and retrieve credentials i.e., username/passwords, API Keys and other secrets through their Lifecyle.

As a Pre-requisite this lab requires Amazon Relational Database Service (RDS) MySQL server, Amazon Elastic Container Service (ECS) cluster (with a container-based application), Amazon Elastic Container Registry (ECR).

1.  From the AWS console, click **Services** and select **Secrets Manager.**
    
2.  On the Secrets Manager console click on **Store a new secret**.

3.  On 'Store a new secret' screen click on **Select the Credentials for RDS database** radio button.

> ![secrm_01.png](/Security/Quests/Simple_Security_Steps/Images/secrm_01.png)

4.  Enter the values for **User name** and **Password** fields respectively.
    
5.  Select **DefaultEncryptionKey** in the dropdown menu.

6.  Scroll down to the bottom of the page and you will see a list of your RDS instances. Select the RDS instance for which you want to store the secret.

> ![secrm_02.png](/Security/Quests/Simple_Security_Steps/Images/secrm_02.png)

7.  Click **Next**.

8.  Enter a name for the secret and provide optional description.

> ![secrm_03.png](/Security/Quests/Simple_Security_Steps/Images/secrm_03.png)

9.  Click **Next**.

10. On 'Configure automatic rotation' screen leave the default values as is i.e., Disable automatic rotation, click **Next**.
    
11. On the Review screen, click **Store**. You will see a message saying that your secret has been successfully stored.
    
12. Now click the Secret name that you have just created.

13. Copy the Amazon Resource Name or ARN for later use.

> ![secrm_04.png](/Security/Quests/Simple_Security_Steps/Images/secrm_04.png)

14. From the AWS console, click Services and select Elastic Container Service.
    
15. Select the **Clusters** menu item to view the stack that you want to configure.

> ![secrm_05.png](/Security/Quests/Simple_Security_Steps/Images/secrm_05.png)

16. Click the **Task Definitions** menu item.

17. Click the check box next to the appropriate task definition name and then **click Create new revision**.

> ![secrm_06.png](/Security/Quests/Simple_Security_Steps/Images/secrm_06.png)

18. Leave all of the current values in place. Scroll down and **click Configure via JSON**.

> ![secrm_07.png](/Security/Quests/Simple_Security_Steps/Images/secrm_07.png)

19. Look for the list named secrets. It should have null value for now i.e., ""secrets":null,"
    
20. Edit text and insert the copied ARN of the secret that was created earlier i.e., smsdemo, as shown below.


```
 "secrets": [
 {
 "valueFrom" :"<paste the ARN you copied earlier">
 "name": :TASKDEF_SECRET"
 }
			]
```

>![secrm_08.png](/Security/Quests/Simple_Security_Steps/Images/secrm_08.png)

21. Click **Save** to save the revised JSON definition.

22. Click **Create** to create the new revision of the Task Definition that includes the JSON revisions.
    
23. You will see a message saying that the new revision has been created. Notice that the revision has a version number attached to it as shown in the figure below.

> ![secrm_09.png](/Security/Quests/Simple_Security_Steps/Images/secrm_09.png)



For more information please read the AWS User Guide:
https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html