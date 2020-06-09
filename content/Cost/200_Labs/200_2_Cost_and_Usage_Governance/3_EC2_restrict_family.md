---
title: "Create an IAM Policy to restrict EC2 usage by family"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

AWS offers different instance families within EC2. Depending on your workload requirements - different types will be most cost effective. For non-specific environments such as testing or development, you can restrict the instance families in those accounts to the most cost effective generic types. It is also an effective way to increase Savings Plan or Reserved Instance utilization, by ensuring these accounts will consume any available commitment discounts.

We will create a policy that allows operations on specific instance families only. This will not only restrict launching an instance, but all other activities. NOTE: it is best practice to provide only the minimum access required, the policy used here is for brevity and simplicity, and should only be implemented as a demonstration before being removed.

### Create the Instance family restrictive IAM Policy

1. Log on to the console as your regular user with the required permissions, Go to the **IAM** service page:
![Images/AWSFamilyRestrict0.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict0.png)

2. Select **Policies** from the left menu:
![Images/AWSFamilyRestrict1.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict1.png)

3. Click **Create Policy**:
![Images/AWSFamilyRestrict2.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict2.png)

4. Click on the **JSON** tab:
![Images/AWSFamilyRestrict3.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict3.png)

5. Copy and paste the policy into the console:
{{%expand "IAM Policy" %}}
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "ec2:*",
                "Resource": "*",
                "Condition": {
                    "ForAllValues:StringLike": {
                        "ec2:InstanceType": [
                            "t3.*",
                            "a1.*",
                            "m5.*"
                        ]
                    }
                }
            }
        ]
    }
{{% /expand%}}


6. Click **Review policy**:
![Images/AWSFamilyRestrict4.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict4.png)

7. Enter the details:
    - **Name**: EC2_FamilyRestrict
    - **Description**: Restrict to t3, a1 and m5 families
    -  Click on **Create Policy**:
![Images/AWSFamilyRestrict5.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict5.png)

{{% notice tip %}}
You have successfully created an IAM policy to restrict usage by **Instance Family**.
{{% /notice %}}


### Apply the policy to your test group

1. Click on **Groups** from the left menu:
![Images/AWSFamilyRestrict6.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict6.png)

2. Click on the **CostTest** group (created previously):
![Images/AWSFamilyRestrict7.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict7.png)

3. We need to remove the **RegionRestrict** policy, as it permitted all EC2 actions. Click on **Detach Policy** for **RegionRestrict**:
![Images/AWSFamilyRestrict8.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict8.png)

4. Click on **Detach**:
![Images/AWSFamilyRestrict9.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict9.png)

5. Click on **Attach Policy**:
![Images/AWSFamilyRestrict10.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict10.png)

6. Click on **Policy Type**, then click **Customer Managed**:
![Images/AWSFamilyRestrict11.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict11.png)

7. Select the checkbox next to **Ec2_FamilyRestrict**, and click **Attach Policy**:
![Images/AWSFamilyRestrict12.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict12.png)

{{% notice tip %}}
You have successfully attached the policy to the CostTest group.
{{% /notice %}}

{{% notice note %}}
Log out from the console
{{% /notice %}}

### Verify the policy is in effect

1. Logon to the console as the **TestUser1** user, go to the EC2 Service dashboard:
![Images/AWSFamilyRestrict13.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict13.png)

3. Try to launch an instance by clicking **Launch Instance**, select **Launch Instance**:
![Images/AWSPolicy17.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy17.png)

3. Click on **Select** next to the **Amazon Linux 2** AMI:
![Images/AWSFamilyRestrict15.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict15.png)

4. We will select an instance we are not able to launch first, so select a **c5.large** instance, click **Review and Launch**:
![Images/AWSFamilyRestrict16.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict16.png)

5. Make note of the security group created, click **Launch**:
![Images/AWSFamilyRestrict17.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict17.png)

6. Select **Proceed without a key pair**, and click **I acknowledge that I will not be able to...**, then click **Launch Instances**:
![Images/AWSFamilyRestrict18.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict18.png)

7. You will receive an error, notice the failed step was **Initiating launches**.  Click **Back to Review Screen**:
![Images/AWSFamilyRestrict19.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict19.png)

8. Click **Edit instance type**:
![Images/AWSFamilyRestrict20.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict20.png)

9. We will select an instance type we can launch (t3, a1 or m5) select **t3.micro**, and click **Review and Launch**:
![Images/AWSFamilyRestrict21.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict21.png)

10. Select **Yes, I want to continue with this instance type (t3.micro)**, click **Next**:
![Images/AWSFamilyRestrict22.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict22.png)

11. Click **Launch**:
![Images/AWSFamilyRestrict23.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict23.png)

12. Select **Proceed without a key pair**, and click **I acknowledge that i will not be able to...**, then click **Launch Instances**:
![Images/AWSFamilyRestrict24.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict24.png)

13. You will receive a success message.  Click on the **Instance ID** and **terminate the instance** as above:
![Images/AWSFamilyRestrict25.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSFamilyRestrict25.png)

14. Log out of the console as TestUser1.

{{% notice tip %}}
You have successfully implemented an IAM policy that restricts all EC2 actions to T3, A1 and M5 instance types.
{{% /notice %}}
 


