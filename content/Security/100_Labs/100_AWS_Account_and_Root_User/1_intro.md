---
title: "Account Settings & Root User Security"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

When you first create an Amazon Web Services (AWS) account, you begin with a single sign-in identity that has complete access to all AWS services and resources in the account. This identity is called the AWS account root user and is accessed by signing in with the email address and password that you used to create the account.
It is strongly recommend that you do not use the root user for your everyday tasks, even the administrative ones. Instead, adhere to the best practice of using the root user only to create your first IAM user, groups and roles. Then securely lock away the root user credentials and use them to perform only a few account and service management tasks. To view the tasks that require you to sign in as the root user, see [AWS Tasks That Require Root User](https://docs.aws.amazon.com/general/latest/gr/aws_tasks-that-require-root.html).

### 1.1 Generate and Review the AWS Account Credential Report

Its good to get an idea of what you have configured already in your AWS account especially if you have had it for a while. You should audit your security configuration in the following situations:

* On a periodic basis. You should perform the steps described here at regular intervals as a best practice for security.
* If there are changes in your organization, such as people leaving.
* If you have stopped using one or more individual AWS services. This is important for removing permissions that users in your account no longer need.
* If you've added or removed software in your accounts, such as applications on Amazon EC2 instances, AWS OpsWorks stacks, AWS CloudFormation templates, etc.
* If you ever suspect that an unauthorized person might have accessed your account.

As you review your account's security configuration, follow these guidelines:

* **Be thorough**. Look at all aspects of your security configuration, including those you might not use regularly.
* **Don't assume**. If you are unfamiliar with some aspect of your security configuration (for example, the reasoning behind a particular policy or the existence of a role), investigate the business need until you are satisfied.
* **Keep things simple**. To make auditing (and management) easier, use IAM groups, consistent naming schemes, and straightforward policies.

*More information can be found at [https://docs.aws.amazon.com/general/latest/gr/aws-security-audit-guide.html](https://docs.aws.amazon.com/general/latest/gr/aws-security-audit-guide.html)*

You can use the AWS Management Console to download a credential report as a comma-separated values (CSV) file. Please note that credential report can take 4 hours to reflect changes.
To download a credential report using the AWS Management Console:

1. Sign in to the AWS Management Console and open the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
2. In the navigation pane, click Credential report.
3. Click Download Report.

![iam-credential-report](/Security/100_AWS_Account_and_Root_User/Images/iam-credential-report.png)

*Further information about the report can be found at [https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_getting-report.html](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_getting-report.html)*

### 1.2 Enable a Virtual MFA Device for Your AWS Account Root User

You can use IAM in the AWS Management Console to configure and enable a virtual MFA device for your root user. To manage MFA devices for the AWS account, you must be signed in to AWS using your root user credentials. You cannot manage MFA devices for the root user using other credentials.

If your MFA device is lost, stolen, or not working, you can still sign in using alternative factors of authentication. To do this, you must verify your identity using the email and phone that are registered with your account. This means that if you can't sign in with your MFA device, you can sign in by verifying your identity using the email and phone that are registered with your account. Before you enable MFA for your root user, review your account settings and contact information to make sure that you have access to the email and phone number. To learn about signing in using alternative factors of authentication, see [What If an MFA Device Is Lost or Stops Working](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_lost-or-broken.html)?. To disable this feature, contact [AWS Support](https://console.aws.amazon.com/support/home#/).

1. Use your AWS account email address and password to sign in as the AWS account root user to the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/)
2. Do one of the following:

   * **Option 1**: Click Dashboard, and under Security Status, expand Activate MFA on your root user.

   * **Option 2**: On the right side of the navigation bar, click your account name, and click Security Credentials. If necessary, click Continue to Security Credentials. Then expand the Multi-Factor Authentication (MFA) section on the page.

     ![Security Credentials in the navigation menu](/Security/100_AWS_Account_and_Root_User/Images/security-credentials-root.shared.console.png)

     ![MFA section in root credentials screen](/Security/100_AWS_Account_and_Root_User/Images/security-credentials-root-mfa.png)

3. Click Manage MFA or Activate MFA, depending on which option you chose in the preceding step.
4. In the wizard, click A virtual MFA device and then click Next Step.
5. Confirm that a virtual MFA app is installed on the device, and then click Next Step. IAM generates and displays configuration information for the virtual MFA device, including a QR code graphic. The graphic is a representation of the secret configuration key that is available for manual entry on devices that do not support QR codes.
6. With the Manage MFA Device wizard still open, open the virtual MFA app on the device.
7. If the virtual MFA software supports multiple accounts (multiple virtual MFA devices), then click the option to create a new account (a new virtual device).
8. The easiest way to configure the app is to use the app to scan the QR code. If you cannot scan the code, you can type the configuration information manually.
   * To use the QR code to configure the virtual MFA device, follow the app instructions for scanning the code. For example, you might need to tap the camera icon or tap a command like Scan account barcode, and then use the device's camera to scan the QR code.
   * If you cannot scan the code, type the configuration information manually by typing the Secret Configuration Key value into the app. For example, to do this in the AWS Virtual MFA app, click Manually add account, and then type the secret configuration key and click Create.

    **Important**

    Make a secure backup of the QR code or secret configuration key, or make sure that you enable multiple virtual MFA devices for your account. A virtual MFA device might become unavailable, for example, if you lose the smartphone where the virtual MFA device is hosted). If that happens, you will not be able to sign in to your account and you will have to contact customer service to remove MFA protection for the account.

    **Note**

    The QR code and secret configuration key generated by IAM are tied to your AWS account and cannot be used with a different account. They can, however, be reused to configure a new MFA device for your account in case you lose access to the original MFA device.

    The device starts generating six-digit numbers.

9. In the Manage MFA Device wizard, in the Authentication Code 1 box, type the six-digit number that's currently displayed by the MFA device. Wait up to 30 seconds for the device to generate a new number, and then type the new six-digit number into the Authentication Code 2 box.

   **Important**

   Submit your request immediately after generating the codes. If you generate the codes and then wait too long to submit the request, the MFA device successfully associates with the user but the MFA device is out of sync. This happens because time-based one-time passwords (TOTP) expire after a short period of time. If this happens, you can resync the device.

10. Click Next Step, and then click Finish.

The device is ready for use with AWS. For information about using MFA with the AWS Management Console, see [Using MFA Devices With Your IAM Sign-in Page](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_sign-in-mfa.html).

### 1.3 Configure Account Security Challenge Questions

Configure account security challenge questions because they are used to verify that you own an AWS account.

1. Use your AWS account email address and password to sign in as the AWS account root user and open the AWS account settings page at [https://console.aws.amazon.com/billing/home?#/account/](https://console.aws.amazon.com/billing/home?#/account/).
2. Navigate to security challenge questions configuration section.

![account-challenge-questions](/Security/100_AWS_Account_and_Root_User/Images/account-challenge-questions.png)

3. Select three challenge questions and enter answers for each.
4. Securely store the questions and answers as you would passwords or other credentials.
5. Click update.

### 1.4 Configure Account Alternate Contacts

Alternate contacts enable AWS to contact another person about issues with the account, even if you are unavailable.

1. Use your AWS account email address and password to sign in as the AWS account root user and open the AWS account settings page at [https://console.aws.amazon.com/billing/home?#/account/](https://console.aws.amazon.com/billing/home?#/account/).
2. Navigate to alternate contacts configuration section.

![account-alternate-contacts](/Security/100_AWS_Account_and_Root_User/Images/account-alternate-contacts.png)

3. Enter contact details for billing, operations and security.
4. Click update.

### 1.5 Remove Your AWS Account Root User Access Keys

You use an access key (an access key ID and secret access key) to make programmatic requests to AWS. However, **do not** use your AWS account root user access key. The access key for your AWS account gives full access to all your resources for all AWS services, including your billing information. You cannot restrict the permissions associated with your AWS account access key.

* Check in the credential report; if you don't already have an access key for your AWS account, don't
create one unless you absolutely need to. Instead, use your account email address and password to sign
in to the AWS Management Console and create an IAM user for yourself that has administrative privileges.
This will be explained in a later section.
* If you do have an access key for your AWS account, delete it unless you have a specific requirement. To delete or rotate your AWS account access keys, go to the [Security Credentials](https://console.aws.amazon.com/iam/home?#security_credential) page in the AWS Management Console and sign in with your account's email address and password. You can manage your access keys in the Access keys section.

![account-root-keys](/Security/100_AWS_Account_and_Root_User/Images/account-root-keys.png)

* Never share your AWS account password or access keys with anyone.

### 1.6 Periodically Change the AWS Account Root User Password

You must be signed in as the AWS account root user in order to change the password. To learn how to reset a forgotten root user password, see [Resetting Your Lost or Forgotten Passwords or Access Keys](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys_retrieve.html).

To change the password for the root user:

1. Use your AWS account email address and password to sign in to the AWS Management Console as the root user.

   **Note**

     If you previously signed in to the console with IAM user credentials, your browser might remember this preference and open your account-specific sign-in page. You cannot use the IAM user sign-in page to sign in with your AWS account root user credentials. If you see the IAM user sign-in page, click Sign-in using root account credentials near the bottom of the page to return to the main sign-in page. From there, you can type your AWS account email address and password.

2. In the upper right corner of the console, click your account name or number and then click My Account.
3. On the right side of the page, next to the Account Settings section, click Edit.
4. On the Password line choose Click here to change your password.

![account-root-password](/Security/100_AWS_Account_and_Root_User/Images/account-root-password.png)

5. Choose a strong password. Although you can set an account password policy for IAM users, that policy does not apply to your AWS account root user.

   AWS requires that your password meet these conditions:

   * have a minimum of 8 characters and a maximum of 128 characters
   * include a minimum of three of the following mix of character types: uppercase, lowercase, numbers, and `! @ # $ % ^ & * () <> [] {} | _ + - =` symbols
   * not be identical to your AWS account name or email address

    **Note**

   AWS is rolling out improvements to the sign-in process. One of those improvements is to enforce a more secure password policy for your account. If your account has been upgraded, you are required to meet the password policy above. If your account has not yet been upgraded, then AWS does not enforce this policy, but highly recommends that you follow its guidelines for a more secure password.

    To protect your password, it's important to follow these best practices:

   * Change your password periodically and keep your password private, since anyone who knows your password
   can access your account.
   * Use a different password on AWS than you use on other sites.
   * Avoid passwords that are easy to guess. These include passwords such as secret, password, amazon, or 123456. They also include things like a dictionary word, your name, email address, or other personal information that can easily be obtained.

### 1.7 Configure a Strong Password Policy for Your Users

You can set a password policy on your AWS account to specify complexity requirements and mandatory rotation periods for your IAM users' passwords. The IAM password policy does not apply to the AWS root account password.

To create or change a password policy:

1. Sign in to the AWS Management Console and open the IAM console at https://console.aws.amazon.com/iam/.
2. In the navigation pane, click Account Settings.
3. In the Password Policy section, select the options you want to apply to your password policy.
4. Click Apply Password Policy.

![iam-password-policy](/Security/100_AWS_Account_and_Root_User/Images/iam-password-policy.png)
