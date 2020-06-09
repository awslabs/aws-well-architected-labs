---
title: "Setup"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

## Requirements

You will need the following to be able to perform this lab:
* Your own device for console access
* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, **that is not used for production** or other purposes
* An available region within your account with capacity to add 2 additional VPCs


## User and Group Management

When you create an Amazon Web Services (AWS) account, you begin with a single sign-in identity that has complete access to all AWS services and resources in the account. This identity is called the AWS account root user. It is accessed by signing in with the email address and password that you used to create the account.

We strongly recommend that you do not use the root user for your everyday tasks, even the administrative ones. Instead, adhere to the best practice of using the root user only to create your first IAM user. Securely store the root user credentials and use them to perform only a few account and service management tasks. To view the tasks that require you to sign in as the root user, see [AWS Tasks That Require Root User](https://docs.aws.amazon.com/general/latest/gr/aws_tasks-that-require-root.html).


## IAM Users & Groups

As a best practice, do not use the AWS account root user for any task where it's not required. Instead, create a new IAM user for each person that requires administrator access. Then grant administrator access by placing the users into an "Administrators" group to which the **AdministratorAccess** managed policy is attached.

Use administrators group members to manage permissions and policy for the AWS account. Limit use of the root user to only those [actions that require it](https://docs.aws.amazon.com/general/latest/gr/aws_tasks-that-require-root.html).


### 2.1 Create Administrator IAM User and Group

To create an administrator user for yourself and add the user to an administrators group:

1. Use your AWS account email address and password to sign in as the AWS account root user to the IAM console at <https://console.aws.amazon.com/iam/>.
1. In the IAM navigation pane, choose **Users** and then choose **Add user**.
1. In **Set user details** for **User name**, type a user name for the administrator account you are creating. The name can consist of letters, digits, and the following characters: plus (+), equal (=), comma (,), period (.), at (@), underscore (_), and hyphen (-). The name is not case sensitive and can be a maximum of 64 characters in length.
1. In **Select AWS access type** for **Access type**, select the check box next to **AWS Management Console access**, select **Custom password**, and then type your new password in the text box. If you're creating the user for someone other than yourself, you can leave *Require password reset* selected to force the user to create a new password when first signing in. Clear the box next to **Require password reset** and then choose **Next: Permissions**.
1. In **set permissions for user** ensure **Add user to group** is selected.
1. Under **Add user to group** choose **Create group**.
1. In the **Create group** dialog box, type a **Group name** for the new group, such as Administrators. The name can consist of letters, digits, and the following characters: plus (+), equal (=), comma (,), period (.), at (@), underscore (_), and hyphen (-). The name is not case sensitive and can be a maximum of 128 characters in length. In the policy list, select the check box next to **AdministratorAccess** and then choose **Create group**.
1. Back at **Add user to group**, in the list of groups, ensure the check box for your new group is selected. Choose Refresh if necessary to see the group in the list. choose **Next: Review** to see the list of group memberships to be added to the new user. When you are ready to proceed, choose **Create user**.
1. At the confirmation screen you do not need to download the user credentials for programmatic access at this time. You can create new credentials at any time.

You can use this same process to create more groups and users and to give your users access to your AWS account resources. To learn about using policies that restrict user permissions to specific AWS resources, see [Access Management](https://docs.aws.amazon.com/IAM/latest/UserGuide/access.html) and [Example Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_examples.html). To add additional users to the group after it's created, see [Adding and Removing Users in an IAM Group](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_groups_manage_add-remove-users.html).


### 2.2 Log in to the AWS Management Console using your administrator account

1. You can now use this administrator user instead of your root user for this AWS account. **Choose the link** https\://\<yourAccountNumber\>.signin.aws.amazon.com/console and log in with your administrator user credentials.
1. **Select the region** you will use for the lab from the the list in the upper right corner.
1. Verify that you have 2 available VPCs (3 or less in use) in the selected region by navigating to the VPC Console (https://console.aws.amazon.com/vpc/) and in the **Resources** section reviewing the number of VPCs.


### 2.3 Create an EC2 Key Pair

[Amazon EC2 uses public-key cryptography](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) to encrypt and decrypt login information. Public-key cryptography uses a public key to encrypt a piece of data, such as a password, then the recipient uses the private key to decrypt the data. The public and private keys are known as a key pair. To [log in to the Amazon Linux instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html) we will create in this lab, you must create a key pair, specify the name of the key pair when you launch the instance, and provide the private key when you connect to the instance.

1. Use your administrator account to access the Amazon EC2 console at <https://console.aws.amazon.com/ec2/>.
1. In the IAM navigation pane under **Network & Security**, choose **Key Pairs** and then choose **Create Key Pair**.
1. In the **Create Key Pair** dialog box, type a **Key pair name** such as `OELabIPM` and then choose **Create**.
1. **Save the** `keyPairName.pem` **file** for optional later use [accessing the EC2 instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html) created in this lab.
