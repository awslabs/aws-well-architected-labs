---
title: "Create an IAM Policy to restrict service usage by region"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

To manage costs you need to manage and control your usage. AWS offers multiple regions, so depending on your business requirements you can limit access to AWS services depending on the region. This can be used to ensure usage is only allowed in specific regions which are more cost effective, and minimize associated usage and cost, such as data transfer.

We will create a policy that allows all EC2, RDS and S3 access in a single region only. NOTE: it is best practice to provide only the minimum access required, the policy used here is for brevity and simplicity, and should only be implemented as a demonstration before being removed.


### Create the Region restrictive IAM Policy

1. Go to the **IAM** service page:
![Images/AWSPolicy1.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy1.png)

2. Select **Policies** from the left menu:
![Images/AWSPolicy2.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy2.png)

3. Click **Create Policy**:
![Images/AWSPolicy3.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy3.png)

4. Click the **JSON** tab:
![Images/AWSPolicy4.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy4.png)

5. Copy and paste the policy into the console:
{{%expand "IAM Policy" %}}
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ec2:*",
                    "rds:*",
                    "s3:*"
                ],
                "Resource": "*",
        "Condition": {"StringEquals": {"aws:RequestedRegion": "us-east-1"}}
            }
        ]
    }
{{% /expand%}}



6. Click **Review policy**:
![Images/AWSPolicy5.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy5.png)

7. Create the policy with the following details:
    - **Name**: RegionRestrict
    - **Description**: EC2, RDS, S3 access in us-east-1 only
    - Click **Create policy**:
![Images/AWSPolicy6.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy6.png)

{{% notice tip %}}
You have successfully created an IAM policy to restrict usage by region.
{{% /notice %}}


### Apply the policy to your test group

1. Select **Groups** from the left menu:
![Images/AWSPolicy7.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy7.png)

2. Click on the **CostTest** group (created previously):
![Images/AWSPolicy8.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy8.png)

3. Select the **Permissions** tab:
![Images/AWSPolicy9.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy9.png)

4. Click **Attach Policy**:
![Images/AWSPolicy10.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy10.png)

5. Click **Policy Type** and select **Customer Managed**:
![Images/AWSPolicy12.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy12.png)

6. Select the checkbox next to **Region_Restrict** (created above) and click **Attach Policy**:
![Images/AWSPolicy13.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy13.png)


{{% notice tip %}}
You have successfully attached the policy to the CostTest group.
{{% /notice %}}

{{% notice note %}}
Log out from the console
{{% /notice %}}


### Verify the policy is in effect

1. Logon to the console as the **TestUser1** user, go to the **EC2** Service dashboard:
![Images/AWSPolicy14.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy14.png)

2. Click the current region in the top right, and select **US West (N.California)**:
![Images/AWSPolicy15.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy15.png)

3. Try to launch an instance by clicking **Launch Instance**, select **Launch Instance**:
![Images/AWSPolicy17.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy17.png)

4. Click on **Select** next to the **Amazon Linux 2 AMI**, You will receive an error when you select an AMI as you do not have permissions:
![Images/AWSPolicy18.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy18.png)

You have successfully verified that you cannot launch any instances outside of the N.Virginia region. We will now verify we have access in us-east-1 (N.Virginia):

5. Change the region by clicking the current region, and selecting **US East (N.Virginia)**:
![Images/AWSPolicy19.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy19.png)

6. Now attempt to launch an instance, choose the **Amazon Linux 2 AMI**, leave **64-bit (x86)** selected, click **Select**:
![Images/AWSPolicy20.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy20.png)

7. Scroll down and select a **c5.large**, and click **Review and Launch**:
![Images/AWSPolicy21.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy21.png)

8. Take note of the security group created (as you need to delete it), Click **Launch**:
![Images/AWSPolicy23.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy23.png)

9. Select **Proceed without a key pair**, and click **I acknowledge..** checkbox, and click **Launch Instances**:
![Images/AWSPolicy24.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy24.png)

10. You will get a success message, click on the instance id:
![Images/AWSPolicy25.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy25.png)

11. Ensure the correct instance is selected, click **Actions**, then **Instance State**, then **Terminate**:
![Images/AWSPolicy26.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy26.png)

12. Confirm the instance ID is correct, click **Yes, Terminate**:
![Images/AWSPolicy27.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy27.png)

13. Log out of the console as TestUser1.

{{% notice tip %}}
You have successfully implemented an IAM policy that restricts all EC2, RDS and S3 operations to a single region. You have also successfully launched a **c5 Instance Type**.
{{% /notice %}}

