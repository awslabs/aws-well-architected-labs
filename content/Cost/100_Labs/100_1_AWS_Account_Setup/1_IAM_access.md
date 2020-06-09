---
title: "Configure IAM access"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
**NOTE**: You will need to sign into the master account with root account credentials to perform this action.

To allow access to your billing information without using the root credentials you need to enable IAM access. This allows other users (non-root) to access billing information in the master account. This approach provides individual sign-in information for each user, and you can grant each user only the permissions they need to work with your account. For example, you can grant your financial teams access to the billing information only, and ensure they dont have access to resources in the account. 


1. Log in to your Master account as the root user, Click on the account name in the top right, and click on **My Account** from the menu:
![Images/AWSAcct4.png](/Cost/100_1_AWS_Account_Setup/Images/AWSAcct4.png)

2. Scroll down to **IAM User and Role Access to Billing Information**, and click **Edit**:
![Images/AWSAcct5.png](/Cost/100_1_AWS_Account_Setup/Images/AWSAcct5.png)

3. Select **Activate IAM Access** and click on **Update**:
![Images/AWSAcct6.png](/Cost/100_1_AWS_Account_Setup/Images/AWSAcct6.png)

4. Confirm that **IAM user/role access to billing information is activated**:
![Images/AWSAcct7.png](/Cost/100_1_AWS_Account_Setup/Images/AWSAcct7.png)

You will now be able to provide access to non-root users to billing information via IAM policies.

**NOTE:** Logout as the root user before continuing.
