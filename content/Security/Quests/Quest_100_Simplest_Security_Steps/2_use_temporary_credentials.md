---
title: "Step 2 - Use temporary credentials"
date: 2021-05-11T01:20:06-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---



In this exercise we will use AWS IAM Roles to avoid the usage of AWS IAM access keys that may be required by the Amazon ELastic Compute Cloud (EC2) instance to access AWS resources. We will create a Role and assigned it to EC2 instance, instead of hard coding the access keys within the EC2 instance.

Note: For this lab, it is assumed that EC2 instance is already created with default settings. For instructions to create EC2 Instance please follow the [link](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/launching-instance.html).

1.  From the AWS console, on the top right corner, click on the drop-down list where your IAM user and Account is mentioned.

> ![iamr_01.png](/Security/Quests/Simple_Security_Steps/Images/iamr_01.png)

2.  From the drop-down list, click on **My Security Credentials.**

3.  Scroll down the page and under the ‘Access keys for CLI, SDK, & API access’ section and note the staus of any active Access key ID. Anyone with access to these long-lived keys can use them to perform actions with the configured permissions. Instead of Access Keys, we will create a role because they provide short term access.

> ![iamr_02.png](/Security/Quests/Simple_Security_Steps/Images/iamr_02.png)

4.  To avoid the access key usage we first need to create an IAM role. Click on **Roles** on the menu on the left side of the
    console under Access Management.
    
5.  Click on **Create role**.

> ![iamr_03.png](/Security/Quests/Simple_Security_Steps/Images/iamr_03.png)

6.  Click on **AWS service**. Then click on **EC2** under 'Choose a use case' section.

> ![iamr_04.png](/Security/Quests/Simple_Security_Steps/Images/iamr_04.png)

7.  Click **Next: Permission**.

8.  In the Search field type the policy that you want to attach to your EC2 instance and select from the list below i.e., AmazonRekognitionReadOnlyAccess policy.

> ![iamr_05.png](/Security/Quests/Simple_Security_Steps/Images/iamr_05.png)

9.  Click **Next: Tags**.

10. Provide the optional Key and value to the tag.

11. Click **Next: Review**

12.  Provide a meaningful name for the Role and optional description. Click **Create role.**

> ![iamr_06.png](/Security/Quests/Simple_Security_Steps/Images/iamr_06.png)

13. You will notice the newly created role is now appearing in the list of roles.
    
14. Go to services, click **EC2**.

15. On the dashboard, click on **Instances (running)**. We will create a Role and assign it to the EC2 instance, instead of hard coding the access keys within the EC2 instance.

16. Select your EC2 instance that you want to assigned the role. Click **Actions -\> Security -\> Modify IAM role**.

> ![iamr_07.png](/Security/Quests/Simple_Security_Steps/Images/iamr_07.png)

17. From the drop-down list of IAM roles, select the role that you have created in the previous steps.
    
18. Click **Save**. Your EC2 instance can now access the required AWS service with minimum privilege.
    
19. We will now disable the Access Key as it is no longer required.

20. From the AWS console, on the top right corner, click on the drop-down list where your IAM user and Account is mentioned and click on **My Security Credentials**.
    
21. Scroll down the page and under the 'Access keys for CLI, SDK, & API access' section click on **Make Inactive** under the Actions
    column of the mentioned Access Key.
    
22. Click on **Deactivate** on the confirmation dialogue box.

23. You will notice the message about deactivation of your IAM user Access key.

> ![iamr_08.png](/Security/Quests/Simple_Security_Steps/Images/iamr_08.png)



For more information please read the AWS User Guide:
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html