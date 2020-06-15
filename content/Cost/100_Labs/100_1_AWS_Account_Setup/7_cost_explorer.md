---
title: "Enable AWS Cost Explorer"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>7. </b>"
weight: 7
---

AWS Cost Explorer has an easy-to-use interface that lets you visualize, analyze, and manage your AWS costs and usage over time. You must enable it before you can use it within your accounts, once enabled it is enabled for **ALL** accounts and controlled through IAM policies. The default configuration of Cost Explorer is free, however we will enable hourly granularity, which incurrs an additional cost - [AWS Cost Management Pricing](https://aws.amazon.com/aws-cost-management/pricing/).

1. Log in to your Master account as an IAM user with the required permissions, and go to the **Billing** console:
![Images/AWSExplorer0.png](/Cost/100_1_AWS_Account_Setup/Images/AWSExplorer0.png)

2. Select **Cost Explorer** from the left menu:
![Images/AWSExplorer1.png](/Cost/100_1_AWS_Account_Setup/Images/AWSExplorer1.png)

3. Click on **Enable Cost Explorer**:
![Images/AWSExplorer2.png](/Cost/100_1_AWS_Account_Setup/Images/AWSExplorer2.png)

4. You will receive notification that Cost Explorer has been enabled, and data will be populated:
![Images/AWSExplorer3.png](/Cost/100_1_AWS_Account_Setup/Images/AWSExplorer3.png)

5. After 24hrs, go into **Cost Explorer**:
![Images/AWSExplorer4.png](/Cost/100_1_AWS_Account_Setup/Images/AWSExplorer4.png)

6. Click **Settings** in the top right:
![Images/AWSExplorer5.png](/Cost/100_1_AWS_Account_Setup/Images/AWSExplorer5.png)

7. Select **Hourly and Resource Level Data**, and click **Save**:
![Images/AWSExplorer6.png](/Cost/100_1_AWS_Account_Setup/Images/AWSExplorer6.png)

{{% notice note %}}
This will incur costs depending on the number of resources you are running.
{{% /notice %}}

