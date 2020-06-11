---
title: "Creating new AWS credentials for your AWS account"
date: 2020-04-24T11:16:09-04:00
chapter: false
hidden: true
---

Use these instructions to get a `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` which you will need for the workshop

**If you are using your own AWS account**

* These instructions are for you.  Use this guide if you are running the workshop on your own, or with at an event using your own AWS account you have brought with you

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**

* **STOP** -- Follow the **If you are attending an in-person workshop and were provided with an AWS account by the instructor** [instructions here instead]({{< ref "../1_deploy_infra.md#awslogin" >}})

---

## Create new AWS credentials for an IAM User you already control

1. Sign in to the AWS Management Console as a IAM user who has IAM management permissions and open the IAM console at <https://console.aws.amazon.com/iam/>

1. In the navigation pane, choose **Users**.

1. Choose the name of the user whose access keys you want to manage.

1. Select the **Permissions** tab of this user and confirm that they have either PowerUserAccess or AdministratorAccess policy attached. If not, attach the PowerUserAccess policy using the **Add permissions** button.

1. Select the **Security credentials** tab.

1. Choose **Create access key**. Then choose **Download .csv file** to save the access key ID and secret access key to a CSV file on your computer. Store the file in a secure location. You will not have access to the secret access key again after this dialog box closes. After you download the CSV file, choose Close.

---

## Create a new IAM User for use in the lab

Use the instructions only if you cannot **Create new AWS credentials for an IAM User you already control**. If you have already obtained a `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` using the preceding instructions then STOP and **[Click here to return to the Lab Guide]({{< ref "../1_deploy_infra.md#awslogin" >}})**

1. Sign in to the AWS Management Console and open the IAM console at <https://console.aws.amazon.com/iam/>

1. In the navigation pane, choose **Users** and then choose **Add user**.

1. Type the user name for the new user. if you wish you can choose `rel300-workshop`

1. Select **programmatic access**. Including access to the AWS Management Console is optional

1. Choose **Next: Permissions**

1. select **Attach existing policies to user directly**
     * In the search box type `PowerUserAccess`
     * tick the check box next to **PowerUserAccess**

1. Choose **Next: Tags**

1. Choose **Next: Review**

1. Choose **Create User**

1. **IMPORTANT**: Choose **Download.csv file** to save the access key ID and secret access key to a CSV file on your computer. Store the file in a secure location. You will not have access to the secret access key again after this dialog box closes. After you download the CSV file, choose Close.

---
