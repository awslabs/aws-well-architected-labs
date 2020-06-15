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


