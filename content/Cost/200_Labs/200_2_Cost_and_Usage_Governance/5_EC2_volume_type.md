---
title: "Create an IAM policy to restrict EBS Volume creation by volume type"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

Extending cost optimization governance beyond compute instances will ensure overall higher levels of cost optimization. Similar to EC2 instances, there are different storage types. Governing the type of storage that can be created in an account can be effective to minimize cost.

We will create an IAM policy that denies operations that contain provisioned IOPS (io1) EBS volume types. This will not only restrict creating a volume, but all other actions that attempt to use this volume type. 

{{% notice warning %}}
NOTE: it is best practice to provide only the minimum access required, the policy used here is for brevity and simplicity, and should only be implemented as a demonstration before being removed.
{{% /notice %}}


### Create the EBS type restrictive IAM Policy

1. Log on to the console as your regular user with the required permissions, go to the **IAM** service page:
![Images/AWSEBSPolicy0.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy0.png)

2. Click on **Policies** on the left menu:
![Images/AWSEBSPolicy1.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy1.png)

3. Click **Create policy**:
![Images/AWSEBSPolicy2.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy2.png)

4. Click on the **JSON** tab:
![Images/AWSEBSPolicy3.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy3.png)

5. Copy and paste the policy into the console:
{{%expand "IAM Policy" %}}
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Deny",
                "Action": "ec2:*",
                "Resource": "*",
                "Condition": {
                    "StringEquals": {
                        "ec2:VolumeType": "io1"
                    }
                }
            }
        ]
    }
{{% /expand%}}

6. Click on **Review Policy**:
![Images/AWSEBSPolicy4.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy4.png)

7. Configure the following details:
    - **Name**: EC2EBS_Restrict
    - **Description**: Dont allow EBS io1 volumes
    - Click **Create policy**:
![Images/AWSEBSPolicy5.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy5.png)

{{% notice tip %}}
You have successfully created an IAM policy to restrict EBS actions by volume type.
{{% /notice %}}

### Apply the policy to your test group

1. Click on **Groups** from the left menu:
![Images/AWSEBSPolicy6.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy6.png)

2. Click on the **CostTest** group:
![Images/AWSEBSPolicy7.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy7.png)

3. Click on **Attach Policy**:
![Images/AWSEBSPolicy8.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy8.png)

4. Click on **Policy Type**, then click **Customer Managed**:
![Images/AWSEBSPolicy9.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy9.png)

5. Select the checkbox next to **EC2EBS_Restrict**, and click **Attach Policy**:
![Images/AWSEBSPolicy10.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy10.png)

{{% notice tip %}}
You have successfully attached the policy to the CostTest group.
{{% /notice %}}

{{% notice note %}}
Log out from the console
{{% /notice %}}

### Verify the policy is in effect

1. Logon to the console as the **TestUser1** user, click on **Services** then click **EC2**:
![Images/AWSEBSPolicy11.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy11.png)

2. Try to launch an instance by clicking **Launch Instance**, select **Launch Instance**:
![Images/AWSPolicy17.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy17.png)

3. Click **Select** next to **Amazon Linux 2...**:
![Images/AWSEBSPolicy13.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy13.png)

4. Select **t3.nano** (which is allowed as per our already applied policy, which we tested in the last exercise), click **Next: Configure Instance Details**:
![Images/AWSEBSPolicy14.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy14.png)

5. Click **Next Add Storage**:
![Images/AWSEBSPolicy15.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy15.png)

6. Click on **Add New Volume**, click on the **dropdown**, then select **Provisioned IOPS SSD (io1)**:
![Images/AWSEBSPolicy16.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy16.png)

7. Click **Review and Launch**:
![Images/AWSEBSPolicy17.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy17.png)

8. Take note of the security group created, and click **Launch**:
![Images/AWSEBSPolicy18.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy18.png)

9. Select **Proceed without a key pair**, and click **I acknowledge that i will not be able to...**, then click **Launch Instances**:
![Images/AWSEBSPolicy19.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy19.png)

10. The launch will fail, as it contained an io1 volume.  Click **Back to Review Screen**:
![Images/AWSEBSPolicy20.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy20.png)

11. Scroll down and click **Edit storage**:
![Images/AWSEBSPolicy21.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy21.png)

12. Click the **dropdown** and change it to **General Purpose SSD(gp2)**, click **Review and Launch**:
![Images/AWSEBSPolicy22.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy22.png)

13. Click **Launch**:
![Images/AWSEBSPolicy18.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy18.png)

14. Select **Proceed without a key pair**, and click **I acknowledge that i will not be able to...**, then click **Launch Instances**:
![Images/AWSEBSPolicy23.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy23.png)

15. It will now succeed, as it doesn't contain an io1 volume type.  Click on the **instance ID** and **terminate** the instance as above:
![Images/AWSEBSPolicy24.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSEBSPolicy24.png)

16. Log out of the console as TestUser1.

{{% notice tip %}}
You have successfully implemented an IAM policy that denies operations if there is an EBS volume of type io1.
{{% /notice %}}

