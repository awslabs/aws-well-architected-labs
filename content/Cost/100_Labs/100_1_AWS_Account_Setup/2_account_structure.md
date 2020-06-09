---
title: "Create an account structure"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

**NOTE**: Do NOT do this step if you already have an organization and consolidated billing setup.

You will create an AWS Organization, and join two or more accounts to the master account. An organization will allow you to centrally manage multiple AWS accounts efficiently and consistently. It is recommended to have a master account that is  used for security and administration, with access provided for limited billing tasks. A dedicated member account will be created for the Cost Optimization team or function, and another (or multiple) member account/s created to contain workload resources.

You will need organizations:CreateOrganization access, and 2 or more AWS accounts. When you join a member account to a master account, it will contain all billing information for that member account. Member accounts will no longer have any billing information, including historical billing information.  Ensure you backup or export any reports or data before joining accounts to a master account.

### Create an AWS Organization
You will create an AWS Organization with the master account.

1. Login to the AWS console as an IAM user with the required permissions, start typing *AWS Organizations* into the **Find Services** box and click on **AWS Organizations**:
![Images/AWSOrg1.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg1.png)

2. Click on **Create organization**:
![Images/AWSOrg2.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg2.png)

3. To create a fully featured organization, Click on **Create organization**
![Images/AWSOrg3.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg3.png)

4. You will receive a verification email, click on **Verify your email address** to verify your account:
![Images/AWSOrg4.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg4.png)

5. You will then see a verification message in the console for your organization:
![Images/AWSOrg5.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg5.png)

You now have an organization that you can join other accounts to.

### Join member accounts
You will now join other accounts to your organization. You need to create and join an account that will be used to perform Cost Optimization work, as well as other member accounts used to run workloads.

1. From the AWS Organizations console click on **Add account**:
![Images/AWSOrg6.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg6.png)

2. Click on **Invite account**:
![Images/AWSOrg7.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg7.png)

3. Enter in the **Email or account ID**, enter in any relevant **Notes** and click **Invite**:
![Images/AWSOrg8.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg8.png)

4. You will then have an open request:
![Images/AWSOrg9.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg9.png)

5. Log in to your **member account**, and go to **AWS Organizations**:
![Images/AWSOrg1.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg1.png)

6. You will see an invitation in the menu, click on **Invitations**:
![Images/AWSOrg10.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg10.png)

7. Verify the details in the request (they are blacked out here), and click on **Accept**:
![Images/AWSOrg11.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg11.png)

8. Verify the Organization ID (blacked out here), and click **Confirm**:
![Images/AWSOrg12.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg12.png)

9. You are shown that the account is now part of your organization:
![Images/AWSOrg13.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg13.png)

10. The member account will receive an email showing success:
![Images/AWSOrg14.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg14.png)

11. The master account will also receive email notification of success:
![Images/AWSOrg15.png](/Cost/100_1_AWS_Account_Setup/Images/AWSOrg15.png)

Repeat the steps above for each additional member account in your organization.

### Enable Service Control Policies
We will enable Service control policies, which offer central control over the maximum permissions available - for cost governance, and Tag policies which assist to standardize tags across your organization.

1. From the AWS Organizations console in the **master account** click on **Policies**:
![Images/Organizations_Policies.png](/Cost/100_1_AWS_Account_Setup/Images/Organizations_Policies.png)

2. By default both policies are disabled, Click on **Service control policies**:
![Images/OrganizationsPolicies_SCPenable.png](/Cost/100_1_AWS_Account_Setup/Images/OrganizationsPolicies_SCPenable.png)

3. Click on **Enable service control policies**:
![Images/OrganizationsPolicies_SCPenable2.png](/Cost/100_1_AWS_Account_Setup/Images/OrganizationsPolicies_SCPenable2.png)

4. You will see **Service control policies are enabled**, click **Policies**:
![Images/OrganizationsPolicies_SCPenable3.png](/Cost/100_1_AWS_Account_Setup/Images/OrganizationsPolicies_SCPenable3.png)

5. We will enable tag policies, Click **Tag policies**:
![Images/OrganizationsPolicies_Tagenable.png](/Cost/100_1_AWS_Account_Setup/Images/OrganizationsPolicies_Tagenable.png)

6. Click **Enable tag policies**:
![Images/OrganizationsPolicies_Tagenable2.png](/Cost/100_1_AWS_Account_Setup/Images/OrganizationsPolicies_Tagenable2.png)

7. You will see **Tag policies are enabled**, click **Policies**:
![Images/OrganizationsPolicies_Tagenable3.png](/Cost/100_1_AWS_Account_Setup/Images/OrganizationsPolicies_Tagenable3.png)

8. You will now see that both policies are enabled:
![Images/OrganizationsPolicies_complete.png](/Cost/100_1_AWS_Account_Setup/Images/OrganizationsPolicies_complete.png)


### Create a Cost Optimization role in the master account
We will create an IAM role with an attached policy that will allow Cost Optimization users from the Cost Optimization account, to access the required Cost Optimization services in the master account.

{{% notice warning %}}
You **MUST** work with your security team/specialist to ensure you create the policies inline with least privileges for your organization.
{{% /notice %}}

1. Login to your master account with the required IAM privileges.

2. Go to the **IAM Console**:
![Images/Home_IAMConsole.png](/Cost/100_1_AWS_Account_Setup/Images/Home_IAMConsole.png)

3. Click on **Policies**:
![Images/IAM_Policies.png](/Cost/100_1_AWS_Account_Setup/Images/IAM_Policies.png)

4. Click **Create policy**:
![Images/IAMPolicy_Create.png](/Cost/100_1_AWS_Account_Setup/Images/IAMPolicy_Create.png)

5. Click the **JSON** tab, edit the following policy as required to achieve least privileges and paste it into the editor, click **Review policy**:

{{% notice tip %}}
The reference for managing access permissions to billing and cost management is: [Here](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/control-access-billing.html)
{{% /notice %}}

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "budgets:*",
	                "ce:*",
	                "aws-portal:*Usage",
                    "aws-portal:*PaymentMethods",
                    "aws-portal:*Billing",
                    "cur:DescribeReportDefinitions",
                    "cur:PutReportDefinition",
                    "cur:DeleteReportDefinition",
                    "cur:ModifyReportDefinition",
                    "pricing:DescribeServices",
                    "wellarchitected:*"
                ],
                "Resource": "*"
            }
        ]
    }

![Images/IAMPolicy_JSONreview.png](/Cost/100_1_AWS_Account_Setup/Images/IAMPolicy_JSONreview.png)

6. Enter a policy name of **Cost_Optimization**, a description of **Access to cost optimization services in the master account**, click **Create policy**:
![Images/IAMPolicy_COFinish.png](/Cost/100_1_AWS_Account_Setup/Images/IAMPolicy_COFinish.png)

7. Click **Roles**:
![Images/IAM_Role.png](/Cost/100_1_AWS_Account_Setup/Images/IAM_Role.png)

8. Click **Create role**:
![Images/IAMRole_Create.png](/Cost/100_1_AWS_Account_Setup/Images/IAMRole_Create.png)

9. Select **Another AWS account**, enbter the **Member Account ID**, select **Require MFA** and click **Next: Permissions**
![Images/IAMCreateRole_anotheraccount.png](/Cost/100_1_AWS_Account_Setup/Images/IAMCreateRole_anotheraccount.png)

10. Enter **Cost_Opt** in the searchbar, and select the **Cost_Optimization** policy, click **Next: Tags**:
![Images/IAMRole_addpolicy.png](/Cost/100_1_AWS_Account_Setup/Images/IAMRole_addpolicy.png)

11. Click **Next: review**:
![Images/IAMRole_tags.png](/Cost/100_1_AWS_Account_Setup/Images/IAMRole_tags.png)

12. Enter a Role name of **CostOptimization** and a Role description of **Access to cost optimization services in the master account**, and click **Create role**:
![Images/IAMRole_finish.png](/Cost/100_1_AWS_Account_Setup/Images/IAMRole_finish.png)





