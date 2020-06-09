---
title: "Teardown"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

Log onto the console as your regular user with the required permissions.

### Delete the IAM policies
We will delete the IAM policies created, as they are no longer applied to any groups.

1. Log on to the console as your regular user with the required permissions, go to the **IAM** service page:
![Images/AWSPolicy1.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy1.png)

2. Click on **Policies** on the left:
![Images/AWSPolicy2.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSPolicy2.png)

3.Click on **Filter Policies** and select **Customer managed**:
![Images/AWSTeardown11.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown11.png)

4. Select the policy you want to delete **Region_Restrict**:
![Images/AWSTeardown12.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown12.png)

5. Click on **Policy actions**, and select **Delete**:
![Images/AWSTeardown13.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown13.png)

6. Click on **Delete**:
![Images/AWSTeardown14.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown14.png)

7. Perform the same steps above to delete the **Ec2_FamilyRestrict** and **EC2EBS_Restrict** policies.

8. Click on **Groups**:
![Images/AWSTeardown15.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown15.png)

9. Select the **CostTest** group, click **Group Actions**, click **Delete Group**:
![Images/AWSTeardown16.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown16.png)

10. Click **Yes, Delete**:
![Images/AWSTeardown17.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown17.png)

11. Click **Users**:
![Images/AWSTeardown18.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown18.png)

12. Select **TestUser1**, and click **Delete user**:
![Images/AWSTeardown19.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown19.png)

13. Click **Yes, delete**:
![Images/AWSTeardown20.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown20.png)

14. Go to the **EC2** dashboard:
![Images/AWSTeardown21.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown21.png)

15. Click **Security Groups** on the left:
![Images/AWSTeardown22.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown22.png)

16. Select the security groups **you took note of**, ensure you have the correct groups that were created. Click **Actions**, select **Delete Security Groups**:
![Images/AWSTeardown23.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown23.png)

17. **Triple check** they are the groups you wrote down, and click **Yes, Delete**:
![Images/AWSTeardown24.png](/Cost/200_2_Cost_and_Usage_Governance/Images/AWSTeardown24.png)

18. Confirm there are no io1 unattached EBS volumes, go to the **EC2 dashboard**, click on **Elastic Block Store**, click **Volumes**. You can sort by the **Created** column to help identify volumes that were not terminated as part of this lab.
