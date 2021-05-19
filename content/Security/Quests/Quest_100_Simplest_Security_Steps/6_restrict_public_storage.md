---
title: "Step 6 - Restrict public storage"
date: 2021-05-11T02:20:08-04:00
chapter: false
weight: 6
pre: "<b>6. </b>"
---



In this exercise we will configure S3 Block Public Access, an easy way to prevent public access to your S3 bucket.

1.  From the AWS console, click **Services** and select **S3.**

2.  Click the bucket name that you want to block public access.

3.  Click on the **Permissions** tab.

4.  Click **Edit** under the section 'Block public access (bucket
    settings)'.

> ![bpa_01.png](/Security/Quests/Simple_Security_Steps/Images/bpa_01.png)

5.  Select **Block all public access** to prevent all sort of public access to your bucket.
    
6.  Click on **Save changes.**

> ![bpa_02.png](/Security/Quests/Simple_Security_Steps/Images/bpa_02.png)

7.  Confirm the settings by typing confirm in the field of confirmation dialogue box and click on **Confirm.**
    
8.  The buckets and objects will now have no public access as shown in the permission overview.

> ![bpa_03.png](/Security/Quests/Simple_Security_Steps/Images/bpa_03.png)

9.  You can also configure the policy to block public access to all the existing and newly created buckets in the account by clicking on S3 menu bar on left side of the S3 management console.
    
10. Click on **Block Public Access setting for this account.**

11. Click on **Block all public access** on the right side of the S3 management console.
    
12. Click on **Save changes.**

> ![bpa_04.png](/Security/Quests/Simple_Security_Steps/Images/bpa_04.png)

13. Confirm the settings by typing confirm in the field of confirmation dialogue box and click on **Confirm.**
    
14. Click on **Buckets** and note that all of the buckets in your account no longer have a public access.

> ![bpa_05.png](/Security/Quests/Simple_Security_Steps/Images/bpa_05.png)



For more information please read the AWS User Guide:
https://docs.aws.amazon.com/AmazonS3/latest/userguide/security.html