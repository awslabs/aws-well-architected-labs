---
title: "Step 1 - Protect privileged credentials"
date: 2021-05-11T11:09:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---



In this exercise we will use AWS Identity & Access Management (IAM) in the AWS Management Console to configure and enable a virtual multi factor authentication (MFA) device for the root. To manage MFA devices for the AWS account, you must be signed in to AWS using your root user credentials. You cannot manage MFA devices for the root user using other credentials.

1.  Use your AWS account email address and password to sign in as the AWS account root user to the IAM console at 
    <https://console.aws.amazon.com/iam/>
    
2.  On the right side of the navigation bar, click your account name, and click **My Security Credentials**. If necessary, click Continue to Security Credentials. Then expand the Multi-Factor Authentication (MFA) section on the page.

![iam_01](/Security/Quests/Simple_Security_Steps/Images/iam_01.png)

\\

![iam_02](/Security/Quests/Simple_Security_Steps/Images/iam_02.png)

3.  Click **Activate MFA**.

4.  In the wizard, click **virtual MFA** device and then click **Continue**.

![iam_03](/Security/Quests/Simple_Security_Steps/Images/iam_03.png)

5.  On the \'set up virtual MFA device window\' click **Show QR code**.

![iam_04](/Security/Quests/Simple_Security_Steps/Images/iam_04.png)

6.  With the Manage MFA Device wizard still open, open the virtual MFA app on the device.

> *If the virtual MFA software supports multiple accounts (multiple virtual MFA devices), then click the option to create a new account (a new virtual device).* 

7.  The easiest way to configure the app is to use the app to scan the QR code. If you cannot scan the code, you can type the configuration information manually.
    - To use the QR code to configure the virtual MFA device, follow the app instructions for scanning the code. For example, you  might need to tap the camera icon or tap a command like Scan account barcode, and then use the device\'s camera to scan the QR code.
    - If you cannot scan the code, type the configuration information manually by typing the Secret Configuration Key value into the app. For example,  to do this in the Virtual MFA app, click Manually add account, and then type the secret configuration key and click Create.
    
8. The device starts generating six-digit numbers.

9.  In the Manage MFA Device wizard, in the MFA Code 1 box, type the six-digit number that's currently displayed by the MFA device. Wait up to 30 seconds for the device to generate a new number, and then type the new six-digit number into the Authentication Code 2 box. 
    
    **Important:** Submit your request immediately after generating the codes. If you generate the codes and then wait too long to submit the request, the MFA device successfully associates with the user but the MFA device is out of sync. This happens because time-based one-time passwords (TOTP) expire after a short period of time. If this happens, you can resync the device.

10. Click **Assign MFA**, and then click **Finish**. Note the \'success\' confirmation and click **Close**.



For more information please read the AWS User Guide: 

https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa.html

