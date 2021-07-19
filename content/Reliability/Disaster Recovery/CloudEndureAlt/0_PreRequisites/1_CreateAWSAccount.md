+++
title = "Set up AWS Account"
weight = 1
+++
----------------

{{% notice info %}}
This section requires you to have access to an active *AWS account* with Administrator privileges. If you already have an active AWS account with administrator access, you can skip Step: 1 and Step: 2 and proceed to Step: 3.
{{% /notice %}}

### Step: 1 - Create and activate an AWS account

To create and activate a new AWS account, follow the steps given in the below URL:
https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/

### Step: 2 - Create an AWS IAM user with administrator privilege 
Once an AWS account is created and activated, we need to create an administrator IAM user. To do that, follow the steps given in the section “*Creating an administrator IAM user and group (console)*” in the below URL:
https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html 

### Step: 3 - Creating a Policy for CloudEndure

In this step, we will:

* Create an IAM access policy that contains the necessary permissions for using AWS as the target DR infrastructure
* Create an IAM user which will be used by the CloudEndure service to replicate data to the target DR infrastructure.

#### Step: 3(a) -Creating a New IAM User and Generating AWS Credentials 

1. Sign in to [AWS Console](https://signin.aws.amazon.com/) as an IAM user with administrator privileges.

2. In the AWS Console, click on **Services** and then navigate to **Security, Identity & Compliance > IAM.**

3. On the **Welcome to Identity and Access Management** page, select the **Policies** option from the left-hand navigational menu.
  
4. On the **Policies** page, click the **Create policy** button.
  
5. On the **Create Policy** page, click the **JSON** tab and delete the existing json document.
   ![Create Policy](https://docs.cloudendure.com/Content/Resources/Images/CloudEndure%20-%20User%20Guide%20-Ch4%20Standalone%20-%20Draft1/Generating%20the%20Required%20AWS_4.png?classes=shadow,border)

6. From a new browser tab, navigate to this URL [CloudEndure](https://docs.cloudendure.com/Content/IAMPolicy.json). Copy the entire raw JSON document and paste into the JSON field in the *Create Policy* page.

7. Click on **Review policy** at the bottom right of the page.
  
8. On the **Review policy** page, enter a name for the new AWS-CloudEndure policy in the **Name** field. Enter an optional description in the **Description** field.
   ![Description](https://docs.cloudendure.com/Content/Resources/Images/Generating%20the%20Required%20AWS_8.png?classes=shadow,border)

9. Click the **Create policy** button at the bottom right of the page.

10. You will be redirected back to the main **Policies** page and a confirmation stating that your new policy has been created will appear at the top of the page.
    ![C:\Users\Pavel-pc\Downloads\aws10.png](https://docs.cloudendure.com/Content/Resources/Images/CloudEndure%20-%20User%20Guide%20-Ch4%20Standalone%20-%20Draft1/Generating%20the%20Required%20AWS_10.png?classes=shadow,border)

The next step is to create a new IAM user and then attach the policy you created in this step to the user.
#### Step: 3(b) -Creating a New IAM User and Generating AWS Credentials

{{% notice info %}}
At the end of this procedure, you will be provided with an **Access key ID** and **Secret access key**. It is important to save these values in an accessible and secured location.
{{% /notice %}}


1. In the AWS Console, click on *Services* and then navigate to **Security, Identity & Compliance > IAM.**
2. Navigate to **Users** on the left-hand navigational menu within **IAM**.
3. Click on **Add user**.
4. On the **Add user** page, set the following:

    - **User name** - add a username for the new user.
    - **Access type** - check the **Programmatic** access option.
    
5. Click **Next: Permissions** at the bottom right of the page.

6. On the **Set permissions** page, select the **Attach existing policies directly** option.

7. Locate the policy you created in the previous **Create a Policy for CloudEndure** section. You can either search for the policy in the **Search** box or locate it manually by scrolling through the policy list.
   ![img](https://docs.cloudendure.com/Content/Resources/Images/a3.png?classes=shadow,border)

8. Once you have located the policy, check the box next to it.
   ![img](https://docs.cloudendure.com/Content/Resources/Images/Generating%20the%20Required%20AWS_17%20(1).png?classes=shadow,border)

9. Click the **Next: Tags** button at the bottom right of the page.

10. You do not need to add any tags. Click the **Next: Review** button at the bottom right of the page

11. On the **Review** page, verify that the correct **User name, AWS access type** (Programmatic access), and **Managed policy** are selected.

12. Click the **Create User** button at the bottom right of the page.

13. A confirmation page will appear. This page provides you with your **Access key ID** and **Secret access key** which you will need to enter into the CloudEndure User Console.Save your **Access key ID** and **Secret access key**. To finish the procedure, click the **Close** button at the bottom right of the page.
    
14. You will be returned to the **Users** page, and the details of the new user you created will be shown.
  
You have now completed the process of generating the required AWS credentials. We will be using these credentials in the later sections. 