# Level 200: Cost and Usage Governance

## Authors
- Nathan Besh, Cost Lead Well-Architected
- Spencer Marley, Commercial Architect
 
## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com


# Table of Contents
1. [Create a cost optimization team](#create_team)
2. [Create an IAM Policy to restrict EC2 usage by region](#EC2_restrict_region)
3. [Create an IAM Policy to restirct EC2 usage by family](#EC2_restrict_family)
4. [Extend an IAM Policy to restrict EC2 usage by instance size](#EC2_restrict_size)
5. [Create an IAM policy to restrict EBS Volume creation by volume type](#EC2_volume_type)
6. [Tear down](#tear_down)
7. [Feedback survey](#survey)  




## 1. Create a cost optimization team <a name="create_team"></a>
We are going to create a cost optimization team. Within your organization there needs to be a team of people that are focused around costs and usage. This exercise will create the users and the group, then assign all the access they need.
This team will then be able to manage the organizations cost and usage, and start to implement optimization mechanisms.

      
### 1.1 Create an IAM policy for the team
This provides access to allow the cost optimization team to perform their work, namely the Labs in the 100 level fundamental series. This is the minimum access the team requires.

1. Log into the console as an IAM user with the required permissions and go to the **IAM** Service page:
![Images/AWSIAM1.png](Images/AWSIAM1.png)

2. Select **Policies** from the left menu:
![Images/AWSIAM2.png](Images/AWSIAM2.png)

3. Select **Create Policy**:
![Images/AWSIAM3.png](Images/AWSIAM3.png)
  
4. Select the **JSON** tab:
![Images/AWSIAM4.png](Images/AWSIAM4.png)
  
5. Modify the policy below, replace **-billing bucket-** (2 replacements) with the name of the bucket your CUR files are delivered to. Then copy & paste the policy into the the field:
**NOTE**: Ensure you copy the entire policy, everything including the first '{' and last '}'
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::-billing bucket-",
        "arn:aws:s3:::-billing bucket-/*"
      ]
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": [
        "iam:GetPolicyVersion",
        "quicksight:CreateAdmin",
        "iam:DeletePolicy",
        "iam:CreateRole",
        "iam:AttachRolePolicy",
        "aws-portal:ViewUsage",
        "iam:GetGroup",
        "aws-portal:ModifyBilling",
        "iam:DetachRolePolicy",
        "iam:ListAttachedRolePolicies",
        "ds:UnauthorizeApplication",
        "aws-portal:ViewBilling",
        "iam:DetachGroupPolicy",
        "iam:ListAttachedGroupPolicies",
        "iam:CreatePolicyVersion",
        "ds:CheckAlias",
        "quicksight:Subscribe",
        "ds:DeleteDirectory",
        "iam:ListPolicies",
        "iam:GetRole",
        "ds:CreateIdentityPoolDirectory",
        "ds:DescribeTrusts",
        "iam:GetPolicy",
        "iam:ListGroupPolicies",
        "aws-portal:ViewAccount",
        "iam:ListEntitiesForPolicy",
        "iam:AttachUserPolicy",
        "iam:ListRoles",
        "iam:DeleteRole",
        "budgets:*",
        "iam:CreatePolicy",
        "quicksight:CreateUser",
        "s3:ListAllMyBuckets",
        "iam:ListPolicyVersions",
        "iam:AttachGroupPolicy",
        "quicksight:Unsubscribe",
        "iam:ListAccountAliases",
        "ds:DescribeDirectories",
        "iam:ListGroups",
        "iam:GetGroupPolicy",
        "ds:CreateAlias",
        "ds:AuthorizeApplication",
        "iam:DeletePolicyVersion"
      ],
      "Resource": "*"
    }
  ]
}
```
5. Click **Review policy**: 
![Images/AWSIAM5.png](Images/AWSIAM5.png)

6. Enter a **Name** and **Description** for the policy and click **Create policy**:
![Images/AWSIAM6.png](Images/AWSIAM6.png)

You have successfully created the cost optimization teams policy.
  
    
### 1.2 Create an IAM Group
This group will bring together IAM users and apply the required policies.

1. While in the IAM console, select **Groups** from the left menu:
![Images/AWSIAM7.png](Images/AWSIAM7.png)

2. Click on **Create New Group**:
![Images/AWSIAM8.png](Images/AWSIAM8.png)

3. Enter a **Group Name** and click **Next Step**:
![Images/AWSIAM9.png](Images/AWSIAM9.png)

4. Click **Policy Type** and select **Customer Managed**:
![Images/AWSIAM10.png](Images/AWSIAM10.png)

5. Select the **CostOptimization_Summit** policy (created previously):
![Images/AWSIAM11.png](Images/AWSIAM11.png)

6. We will now add more policies, click on **Customer Managed** and select **AWS Managed**:
![Images/AWSIAM12.png](Images/AWSIAM12.png)

7. Type **Athena** into the filter box, select **both** policies, and click **Next Step**:
![Images/AWSIAM13.png](Images/AWSIAM13.png)

8. Click **Create Group**:
![Images/AWSIAM14.png](Images/AWSIAM14.png)


You have now successfully created the cost optimization group, and attached the required policies.


### 1.3 Create an IAM User
For this lab we will create a user and join them to the group above.

NOTE: it is best practice to have Multi Factor Authentication (MFA) enabled for all users. We omit this step here for brevity and simplicity, and should only be implemented as a demonstration before being removed/rectified.

1. In the IAM console, select **Users** from the left menu:
![Images/AWSIAM15.png](Images/AWSIAM15.png)

2. Click **Add user**:
![Images/AWSIAM16.png](Images/AWSIAM16.png)

3. Enter a **User name**, select **AWS Management Console access**, choose **Custom Password**, type a suitable password, deselect **Require password reset**, and click **Next: Permissions**:
![Images/AWSIAM17.png](Images/AWSIAM17.png)

4. Select the **CostOptimization** group (created previously), and click **Next: Tags**:
![Images/AWSIAM18.png](Images/AWSIAM18.png)

5. Click **Next Review**:
![Images/AWSIAM19.png](Images/AWSIAM19.png)

6. Click **Create user**:
![Images/AWSIAM20.png](Images/AWSIAM20.png)

7. Copy the link provided, and logout by clicking on your username in the top right, and selecting **Sign Out**::
![Images/AWSIAM21.png](Images/AWSIAM21.png)

8. Log back in as the username you just created, with the link you copied for the remainder of the Lab.
![Images/AWSIAM21.png](Images/AWSIAM22.png)

You have successfully create a user, placed them in the cost optimization group and have applied policies.
You can continue to expand this group by adding additional users from your organization.



## 2. Create an IAM Policy to restrict service usage by region <a name="EC2_restrict_region"></a>
To manage costs you need to manage and control your usage. AWS offers multilpe regions, so depending on your business requirements you can limit access to AWS services depending on the region. This can be used to ensure usage is only allowed in specific regions which are more cost effective, and minimize associated usage and cost, such as data transfer.

We will create a policy that allows all EC2, RDS and S3 access in a single region only. NOTE: it is best practice to provide only the minimum access required, the policy used here is for brevity and simplicity, and should only be implemented as a demonstration before being removed.


### 2.1 Create the IAM Policy

1. Go to the **IAM** service page: 
![Images/AWSPolicy1.png](Images/AWSPolicy1.png)

2. Select **Policies** from the left menu:
![Images/AWSPolicy2.png](Images/AWSPolicy2.png)

3. Click **Create Policy**:
![Images/AWSPolicy3.png](Images/AWSPolicy3.png)

4. Click the **JSON** tab:
![Images/AWSPolicy4.png](Images/AWSPolicy4.png)

5. Open the following text file, copy and paste the policy into the console:
**NOTE** Ensure you copy the entire policy, including the start '{' and end '}' 
[./Code/Region_Restrict](./Code/Region_Restrict.md) 
               
6. Click **Review policy**:
![Images/AWSPolicy5.png](Images/AWSPolicy5.png)
NOTE: the policy may be different from the image above

7. Enter a **Name** and **Description**, and click **Create policy**: 
![Images/AWSPolicy6.png](Images/AWSPolicy6.png)

You have successfully created the Policy.


### 2.2 Apply it to a group

1. Select **Groups** from the left menu:
![Images/AWSPolicy7.png](Images/AWSPolicy7.png)

2. Click on the **CostOptimization** group (created previously):
![Images/AWSPolicy8.png](Images/AWSPolicy8.png)

3. Select the **Permissions** tab:
![Images/AWSPolicy9.png](Images/AWSPolicy9.png)

4. Click **Attach Policy**:
![Images/AWSPolicy10.png](Images/AWSPolicy10.png)

5. Click **Policy Type** and select **Customer Managed**:
![Images/AWSPolicy12.png](Images/AWSPolicy12.png)

6. Select the checkbox next to **Region_Restrict** (created above) and click **Attach Policy**:
![Images/AWSPolicy13.png](Images/AWSPolicy13.png)

You have successfully attached the policy to the Cost Optimizaiton group. 


### 2.3 Verify the policy is in effect
1. Go to the EC2 Service dashboard: 
![Images/AWSPolicy14.png](Images/AWSPolicy14.png)

2. Click the current region in the top right, and select **US West (N.California)**: 
![Images/AWSPolicy15.png](Images/AWSPolicy15.png)

3. You will notice that there are authorization messages due to not having access in that region (the policy restricted EC2 usage to N. Virginia only):
![Images/AWSPolicy16.png](Images/AWSPolicy16.png)

4. Try to launch an instance by clicking **Launch Instance**:
![Images/AWSPolicy17.png](Images/AWSPolicy17.png)

5. Click on **Select** next to the **Amazon Linux 2 AMI**, You will receive an error when you select an AMI as you do not have permissions:
![Images/AWSPolicy18.png](Images/AWSPolicy18.png)

You have successfully verified that you can not launch any instances outside of the N.Virginia region. We will now verify we have access in us-east-1 (N.Virginia):

6. Change the region by clicking the current region, and selecting **US East (N.Virginia)**:
![Images/AWSPolicy19.png](Images/AWSPolicy19.png)

7. Now attempt to launch an instance, choose the **Amazon Linux 2 AMI**, leave **64-bit (x86)** selected, click **Select**:
![Images/AWSPolicy20.png](Images/AWSPolicy20.png)

8. Scroll down and select a **c5.large**, and click **Review and Launch**:
![Images/AWSPolicy21.png](Images/AWSPolicy21.png)

9. Take note of the security group created (as you need to delete it), Click **Launch**:
![Images/AWSPolicy23.png](Images/AWSPolicy23.png)

10. Select **Proceed without a key pair**, and click **I acknowledge..** checkbox, and click **Launch Instances**:
![Images/AWSPolicy24.png](Images/AWSPolicy24.png)

11. You will get a success message, click on the instance id:
![Images/AWSPolicy25.png](Images/AWSPolicy25.png)

12. Ensure the correct instance is selected, click **Actions**, then **Instance State**, then **Terminate**:
![Images/AWSPolicy26.png](Images/AWSPolicy26.png)

13. Confirm the instance ID is correct, click **Yes, Terminate**:
![Images/AWSPolicy27.png](Images/AWSPolicy27.png)

You have successfully implemented an IAM policy that restricts all EC2, RDS and S3 operations to a single region.



## 3. Create an IAM Policy to restirct EC2 usage by family <a name="EC2_restrict_family"></a>
AWS offers different instance families within EC2. Depending on your workload requirements - different types will be most cost effective. For non-specific environments such as testing or development, you can restrict the instance families in those accounts to the most cost effective generic types. It is also an effective way to increase RI utilization, by ensuring these accounts will consume any available Reserved Instances. 

We will create a policy that allows operations on specific instance families only. This will not only restrict launching an instance, but all other activities. NOTE: it is best practice to provide only the minimum access required, the policy used here is for brevity and simplicity, and should only be implemented as a demonstration before being removed.


### 3.1 Create the IAM Policy

1. Go to the **IAM** service page: 
![Images/AWSFamilyRestrict0.png](Images/AWSFamilyRestrict0.png)

2. Select **Policies** from the left menu:
![Images/AWSFamilyRestrict1.png](Images/AWSFamilyRestrict1.png)

3. Click **Create Policy**:
![Images/AWSFamilyRestrict2.png](Images/AWSFamilyRestrict2.png)

4. Click on the **JSON** tab:
![Images/AWSFamilyRestrict3.png](Images/AWSFamilyRestrict3.png)

5. Open the following text file, copy and paste the policy into the console:
**NOTE** Ensure you copy the entire policy, including the start '{' and end '}' 
![./Code/EC2Family_Restrict](./Code/EC2Family_Restrict.md) 
               
6. Click **Review policy**:
![Images/AWSFamilyRestrict4.png](Images/AWSFamilyRestrict4.png)

7. Enter a **Name**, a **Description**, and click on **Create Policy**:
![Images/AWSFamilyRestrict5.png](Images/AWSFamilyRestrict5.png)


### 3.2 Attach the policy to the group

1. Click on **Groups** from the left menu: 
![Images/AWSFamilyRestrict6.png](Images/AWSFamilyRestrict6.png)

2. Click on the **CostOptimization** group (created previously):
![Images/AWSFamilyRestrict7.png](Images/AWSFamilyRestrict7.png)

3. We need to remove the **RegionRestrict** policy, as it permitted all EC2 actions. Click on **Detach Policy** for **RegionRestrict**:
![Images/AWSFamilyRestrict8.png](Images/AWSFamilyRestrict8.png)

4. Click on **Detach**:
![Images/AWSFamilyRestrict9.png](Images/AWSFamilyRestrict9.png)

5. Click on **Attach Policy**:
![Images/AWSFamilyRestrict10.png](Images/AWSFamilyRestrict10.png)

6. Click on **Policy Type**, then click **Customer Managed**:
![Images/AWSFamilyRestrict11.png](Images/AWSFamilyRestrict11.png)

7. Select the checkbox next to **Ec2_FamilyRestrict**, and click **Attach Policy**:
![Images/AWSFamilyRestrict12.png](Images/AWSFamilyRestrict12.png)


### 3.3 Verify the policy is in effect

1. Click on **Services** and click **EC2**:
![Images/AWSFamilyRestrict13.png](Images/AWSFamilyRestrict13.png)

2. Click on **Launch Instance**:
![Images/AWSFamilyRestrict14.png](Images/AWSFamilyRestrict14.png)

3. Click on **Select** next to the **Amazon Linux 2** AMI:
![Images/AWSFamilyRestrict15.png](Images/AWSFamilyRestrict15.png)

4. We will select an instance we are not able to launch first, so select a **c5.large** instance, click **Review and Launch**:
![Images/AWSFamilyRestrict16.png](Images/AWSFamilyRestrict16.png)

5. Make note of the security group created, click **Launch**:
![Images/AWSFamilyRestrict17.png](Images/AWSFamilyRestrict17.png)

6. Select **Proceed without a key pair**, and click **I acknowledge that i will not be able to...**, then click **Launch Instances**: 
![Images/AWSFamilyRestrict18.png](Images/AWSFamilyRestrict18.png)

7. You will receive an error, notice the failed step was **Initiating launches**.  Click **Back to Review Screen**:
![Images/AWSFamilyRestrict19.png](Images/AWSFamilyRestrict19.png)

8. Click **Edit instance type**:
![Images/AWSFamilyRestrict20.png](Images/AWSFamilyRestrict20.png)

9. We will select an instance type we can launch (t3, a1 or m5) select **t3.micro**, and click **Review and Launch**:
![Images/AWSFamilyRestrict21.png](Images/AWSFamilyRestrict21.png)

10. Select **Yes, I want to continue with this instance type (t3.micro)**, click **Next**:
![Images/AWSFamilyRestrict22.png](Images/AWSFamilyRestrict22.png)

11. Click **Launch**:
![Images/AWSFamilyRestrict23.png](Images/AWSFamilyRestrict23.png)

12. Select **Proceed without a key pair**, and click **I acknowledge that i will not be able to...**, then click **Launch Instances**:
![Images/AWSFamilyRestrict24.png](Images/AWSFamilyRestrict24.png)

13. You will receive a success message.  Click on the **Instance ID** and terminate the instance as above:
![Images/AWSFamilyRestrict25.png](Images/AWSFamilyRestrict25.png)















## 4. Extend an IAM Policy to restrict EC2 usage by instance size <a name="EC2_restrict_size"></a>
We can also restrict the size of instance that can be launched. This can be used to ensure only low cost instances can be created within an account. This is ideal for testing and development, where high capacity instances may not be required. We will extend the EC2 family policy above, and add restrictions by adding the sizes of instances allowed.


### 4.1 Extend the EC2Family_Restrict IAM Policy

1. Go to the **IAM** service page: 
![Images/AWSFamilyUpdate0.png](Images/AWSFamilyUpdate0.png)

2. Click on **Policies** on the left menu:
![Images/AWSFamilyUpdate1.png](Images/AWSFamilyUpdate1.png)

3. Click on **Filter policies**, then select **Customer managed**:
![Images/AWSFamilyUpdate2.png](Images/AWSFamilyUpdate2.png)

4. Click on **EC2_FamilyRestrict** to modify it:
![Images/AWSFamilyUpdate3.png](Images/AWSFamilyUpdate3.png)

5. Click on **Edit policy**:
![Images/AWSFamilyUpdate4.png](Images/AWSFamilyUpdate4.png)

6. Click on the **JSON** tab:
![Images/AWSFamilyUpdate5.png](Images/AWSFamilyUpdate5.png)

7. Modify the policy by adding in the sizes, be careful not to change the syntax and only remove the * characters. Click on **Review policy**:
![Images/AWSFamilyUpdate6.png](Images/AWSFamilyUpdate6.png)

8. Click on **Save changes**:
![Images/AWSFamilyUpdate7.png](Images/AWSFamilyUpdate7.png)


### 4.2 Verify the policy is in effect

1. Click on **Services** and go to the **EC2** dashboard:
![Images/AWSFamilyUpdate8.png](Images/AWSFamilyUpdate8.png)

2. Click on **Launch Instance**:
![Images/AWSFamilyUpdate9.png](Images/AWSFamilyUpdate9.png)

3. Click on **Select** next to the  **Amazon Linux 2 AMI**: 
![Images/AWSFamilyUpdate10.png](Images/AWSFamilyUpdate10.png)

4. We will attempt to launch a **t3.micro** which was successful before. Click on **Review and Launch**:
![Images/AWSFamilyUpdate11.png](Images/AWSFamilyUpdate11.png)

5. Review the configuraion and take note of the security group created, click **Launch**:
![Images/AWSFamilyUpdate12.png](Images/AWSFamilyUpdate12.png)

6. Select **Proceed without a key pair**, and click **I acknowledge that i will not be able to...**, then click **Launch Instances**:
![Images/AWSFamilyUpdate13.png](Images/AWSFamilyUpdate13.png)

7. You will get a failure, as it wasnt a size we allowed in the policy. Click **Back to Review Screen**:
![Images/AWSFamilyUpdate14.png](Images/AWSFamilyUpdate14.png)

8. Click **Edit instance type**: 
![Images/AWSFamilyUpdate15.png](Images/AWSFamilyUpdate15.png)

9. We will now select a **t3.nano** which will succeed. Click **Review and Launch**:
![Images/AWSFamilyUpdate16.png](Images/AWSFamilyUpdate16.png)

10. Select **Yes, I want to continue with this instance type (t3.nano)**, and click **Next**:
![Images/AWSFamilyUpdate17.png](Images/AWSFamilyUpdate17.png)

11. Review the configuration and click **Launch**:
![Images/AWSFamilyUpdate18.png](Images/AWSFamilyUpdate18.png)

12. Select **Proceed without a key pair**, and click **I acknowledge that i will not be able to...**, then click **Launch Instances**:
![Images/AWSFamilyUpdate19.png](Images/AWSFamilyUpdate19.png)

13. It will succeed. Click on the **Instance ID** and terminate the instance as above:
![Images/AWSFamilyUpdate20.png](Images/AWSFamilyUpdate20.png)


You have successfully implemented an IAM policy that restricts all EC2 instance operations by family and size.






## 5. Create an IAM policy to restrict EBS Volume creation by volume type <a name="EC2_volume_type"></a>
Extending cost optimization governance beyond compute instances will ensure overall higher levels of cost optimization. Similar to EC2 instances, there are different storage types. Governing the type of storage that can be created in an account can be effective to minimise cost. 

We will create an IAM policy that denies operations that contain provisioned IOPS (io1) EBS volume types. This will not only restrict creating a volume, but all other actions that attempt to use this volume type. NOTE: it is best practice to provide only the minimum access required, the policy used here is for brevity and simplicity, and should only be implemented as a demonstration before being removed.


### 5.1 Create the IAM Policy

1. Go to the **IAM** service page: 
![Images/AWSEBSPolicy0.png](Images/AWSEBSPolicy0.png)

2. Click on **Policies** on the left menu:
![Images/AWSEBSPolicy1.png](Images/AWSEBSPolicy1.png)

3. Click **Create policy**:
![Images/AWSEBSPolicy2.png](Images/AWSEBSPolicy2.png)

4. Click on the **JSON** tab:
![Images/AWSEBSPolicy3.png](Images/AWSEBSPolicy3.png)

5. Open the following text file, copy and paste the policy into the console:
**NOTE** Ensure you copy the entire policy, including the start '{' and end '}' 
[./Code/EC2EBS_Restrict](./Code/EC2EBS_Restrict.md) 

6. Click on **Review Policy**:
![Images/AWSEBSPolicy4.png](Images/AWSEBSPolicy4.png)

7. Enter a **Name** and a **Description**, and click **Create policy**:
![Images/AWSEBSPolicy5.png](Images/AWSEBSPolicy5.png)

### 5.2 Attach the policy to the Cost Optimization group

1. Click on **Groups** from the left menu: 
![Images/AWSEBSPolicy6.png](Images/AWSEBSPolicy6.png)

2. Click on the **CostOptimization** group:
![Images/AWSEBSPolicy7.png](Images/AWSEBSPolicy7.png)

3. Click on **Attach Policy**:
![Images/AWSEBSPolicy8.png](Images/AWSEBSPolicy8.png)

4. Click on **Policy Type**, then click **Customer Managed**:
![Images/AWSEBSPolicy9.png](Images/AWSEBSPolicy9.png)

5. Select the checkbox next to **EC2EBS_Restrict**, and click **Attach Policy**:
![Images/AWSEBSPolicy10.png](Images/AWSEBSPolicy10.png)

### 5.3 Verify the policy is in effect

1. Click on **Services** then click **EC2**:
![Images/AWSEBSPolicy11.png](Images/AWSEBSPolicy11.png)

2. Click **Launch Instance**:
![Images/AWSEBSPolicy12.png](Images/AWSEBSPolicy12.png)

3. Click **Select** next to **Aamzon Linux 2...**:
![Images/AWSEBSPolicy13.png](Images/AWSEBSPolicy13.png)

4. Select **t3.nano** (which is allowed as per our already applied policy, which we tested in the last exercise), click **Next: Configure Instance Details**:
![Images/AWSEBSPolicy14.png](Images/AWSEBSPolicy14.png)

5. Click **Next Add Storage**:
![Images/AWSEBSPolicy15.png](Images/AWSEBSPolicy15.png)

6. Click on **Add New Volume**, click on the **dropdown**, then select **Provisioned IOPS SSD (io1)**:
![Images/AWSEBSPolicy16.png](Images/AWSEBSPolicy16.png)

7. Click **Review and Launch**:
![Images/AWSEBSPolicy17.png](Images/AWSEBSPolicy17.png)

8. Take note of the security group created, and click **Launch**:
![Images/AWSEBSPolicy18.png](Images/AWSEBSPolicy18.png)

9. Select **Proceed without a key pair**, and click **I acknowledge that i will not be able to...**, then click **Launch Instances**:
![Images/AWSEBSPolicy19.png](Images/AWSEBSPolicy19.png)

10. The launch will fail, as it contained an io1 volume.  Click **Back to Review Screen**:
![Images/AWSEBSPolicy20.png](Images/AWSEBSPolicy20.png)

11. Click **Edit storage**:
![Images/AWSEBSPolicy21.png](Images/AWSEBSPolicy21.png)

12. Click the **dropdown** and change it to **General Purpose SSD(gp2)**, click **Review and Launch**: 
![Images/AWSEBSPolicy22.png](Images/AWSEBSPolicy22.png)

13. Select **Proceed without a key pair**, and click **I acknowledge that i will not be able to...**, then click **Launch Instances**:
![Images/AWSEBSPolicy23.png](Images/AWSEBSPolicy23.png)

14. It will now succeed, as it doesnt contain an io1 volume type.  Click on the **instance ID** and terminate the instance as above:
![Images/AWSEBSPolicy24.png](Images/AWSEBSPolicy24.png)




## 6. Tear down <a name="tear_down"></a>
NOTE: The cost optimization user, group and policies are required for the completion of the fundamental labs. If you remove these resources you will not be able to complete the labs. There is no tear down for this component as it is best practices to have this group created in all organizations.

### Delete a security group
When you attempted to, and successfully launched instances above it created a **launch-wizard** security group automatically, which you will need to delete.

1. Go to the EC2 Dashboard:
![Images/AWSTeardown1.png](Images/AWSTeardown1.png)

2. Confirm the instances launched as part of this exercise are terminated. Click on **Instances** on the left and view the instances. You can use the **Launch Time** column to verify this.
![Images/AWSTeardown15.png](Images/AWSTeardown15.png)

3. Select **Security Groups** under **NETWORK AND SECURITY** on the left:
![Images/AWSTeardown2.png](Images/AWSTeardown2.png)

4. Click the checkbox next to the security group you need to delete:
NOTE: you took note of the specific group in the exercise above, you can also use the **Description** column which will show when it was created.
![Images/AWSTeardown3.png](Images/AWSTeardown3.png)

5. Click **Actions**, then select **Delete Security Group**:
![Images/AWSTeardown4.png](Images/AWSTeardown4.png)

6. Click **Yes, Delete**:
![Images/AWSTeardown5.png](Images/AWSTeardown5.png)


### Remove a policy from a group
We will remove the IAM policies from our cost optimization group.

1. Go to the IAM Console:
![Images/AWSPolicy1.png](Images/AWSPolicy1.png)

2. Select **Groups** from the left menu:
![Images/AWSTeardown6.png](Images/AWSTeardown6.png)

3. Click on the **CostOptimization** group (that was created previously):
![Images/AWSTeardown7.png](Images/AWSTeardown7.png) 

4. Click on **Permissions**:
![Images/AWSTeardown8.png](Images/AWSTeardown8.png)

5. Click on **Detach Policy** next to the **EC2_FamilyRestrict** and also **EC2EBS_Restrict** Policy Names:
![Images/AWSTeardown9.png](Images/AWSTeardown9.png)

6. Click **Detach**:
![Images/AWSTeardown10.png](Images/AWSTeardown10.png)

7. Repeat the steps above for **EC2EBS_Restrict**:
![Images/AWSTeardown9.5.png](Images/AWSTeardown9.5.png)

8. Click **Detach**:
![Images/AWSTeardown10.5.png](Images/AWSTeardown10.5.png)


### Delete a policy
We will delete the IAM policies created above, as they are no longer applied to any groups.

1. Go to the IAM Console:
![Images/AWSPolicy1.png](Images/AWSPolicy1.png)

2. Click on **Policies** on the left:
![Images/AWSPolicy2.png](Images/AWSPolicy2.png)

3.Click on **Filter Policies** and select **Customer managed**: 
![Images/AWSTeardown11.png](Images/AWSTeardown11.png)

4. Select the policy you want to delete **Region_Restrict**:
![Images/AWSTeardown12.png](Images/AWSTeardown12.png)

5. Click on **Policy actions**, and select **Delete**:
![Images/AWSTeardown13.png](Images/AWSTeardown13.png)

6. Click on **Delete**:
![Images/AWSTeardown14.png](Images/AWSTeardown14.png)

7. Perform the same steps above to delete the **Ec2_FamilyRestrict** and **EC2EBS_Restrict** policies.


## 7. Survey <a name="survey"></a>
Thanks for taking the lab, We hope that you can take this short survey (<2 minutes), to share your insights and help us improve our content.

[![Survey](Images/survey.png)](https://amazonmr.au1.qualtrics.com/jfe/form/SV_9EPtEoy72tDcIDP)


This survey is hosted by an external company (Qualtrics) , so the link above does not lead to our website.  Please note that AWS will own the data gathered via this survey and will not share the information/results collected with survey respondents.  Your responses to this survey will be subject to Amazons Privacy Policy.
 


