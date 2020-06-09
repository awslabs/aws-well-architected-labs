---
title: "Extend an IAM Policy to restrict EC2 usage by instance size"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

We can also restrict the size of instance that can be launched. This can be used to ensure only low cost instances can be created within an account. This is ideal for testing and development, where high capacity instances may not be required. We will extend the EC2 family policy above, and add restrictions by adding the sizes of instances allowed.


### Extend the EC2Family_Restrict IAM Policy

1. Log on to the console as your regular user with the required permissions, go to the **IAM** service page:
![Images/AWSFamilyUpdate0.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate0.png)

2. Click on **Policies** on the left menu:
![Images/AWSFamilyUpdate1.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate1.png)

3. Click on **Filter policies**, then select **Customer managed**:
![Images/AWSFamilyUpdate2.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate2.png)

4. Click on **EC2_FamilyRestrict** to modify it:
![Images/AWSFamilyUpdate3.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate3.png)

5. Click on **Edit policy**:
![Images/AWSFamilyUpdate4.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate4.png)

6. Click on the **JSON** tab:
![Images/AWSFamilyUpdate5.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate5.png)

7. Modify the policy by adding in the sizes, add in **nano**, **medium**, **large**, be careful not to change the syntax and not remove the quote characters. Click on **Review policy**:
![Images/AWSFamilyUpdate6.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate6.png)

8. Click on **Save changes**:
![Images/AWSFamilyUpdate7.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate7.png)

9. Log out from the console

{{% notice tip %}}
You have successfully modified the policy to restrict usage by instance size.
{{% /notice %}}


### Verify the policy is in effect

1. Logon to the console as the **TestUser1** user, click on **Services** and go to the **EC2** dashboard:
![Images/AWSFamilyUpdate8.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate8.png)

3. Try to launch an instance by clicking **Launch Instance**, select **Launch Instance**:
![Images/AWSPolicy17.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy17.png)

3. Click on **Select** next to the  **Amazon Linux 2 AMI**:
![Images/AWSFamilyUpdate10.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate10.png)

4. We will attempt to launch a **t3.micro** which was successful before. Click on **Review and Launch**:
![Images/AWSFamilyUpdate11.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate11.png)

5. Review the configuration and take note of the security group created, click **Launch**:
![Images/AWSFamilyUpdate12.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate12.png)

6. Select **Proceed without a key pair**, and click **I acknowledge that i will not be able to...**, then click **Launch Instances**:
![Images/AWSFamilyUpdate13.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate13.png)

7. You will get a failure, as it wasn't a size we allowed in the policy. Click **Back to Review Screen**:
![Images/AWSFamilyUpdate14.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate14.png)

8. Click **Edit instance type**:
![Images/AWSFamilyUpdate15.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate15.png)

9. We will now select a **t3.nano** which will succeed. Click **Review and Launch**:
![Images/AWSFamilyUpdate16.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate16.png)

10. Select **Yes, I want to continue with this instance type (t3.nano)**, and click **Next**:
![Images/AWSFamilyUpdate17.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate17.png)

11. Review the configuration and click **Launch**:
![Images/AWSFamilyUpdate18.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate18.png)

12. Select **Proceed without a key pair**, and click **I acknowledge that i will not be able to...**, then click **Launch Instances**:
![Images/AWSFamilyUpdate19.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate19.png)

13. It will succeed. Click on the **Instance ID** and **terminate** the instance as above:
![Images/AWSFamilyUpdate20.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyUpdate20.png)

13. Log out of the console as TestUser1.

{{% notice tip %}}
You have successfully implemented an IAM policy that restricts all EC2 instance operations by family and size.
{{% /notice %}}

