---
title: "Create Static Resources"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---


### Create Amazon S3 Bucket and Folders
We’ll create an S3 bucket to store the organizations data to be combined with your cost and usage report. This will hold your organisation data so we can connect it to Athena.

1. Login via SSO to your Cost Optimization account, go into the **S3** console:

![Images/home_s3-dashboard.png](/Cost/300_Organization_Data_CUR_Connection/Images/home_s3-dashboard.png)

2. Click **Create bucket** and create a bucket. You will need to use a unique bucket name with **cost** at the start, (we have used cost-aws-lab-organisation-bucket). Make a note of this as we will be using it later.



### Create IAM Role and Policies
We’ll create an IAM role and policy for the AWS Lambda function to access the organizations data & write it to S3. This role will be used to get the list of accounts in the Organization and the meta data attached to them such as name and email. This is then placed in our S3 bucket.

1.	Go to the **IAM Console**

2.	Select **Policies** and **Create policy**

![Images/create_policy.png](/Cost/300_Organization_Data_CUR_Connection/Images/create_policy.png)

3.	On the **JSON** tab the following policy and replace **(bucket name)** with your bucket name from before and replace **(account id)** with your **Management Account id** which manages your Organization. Enter the following policy, click **Review policy**:

        {
            "Version":"2012-10-17",
            "Statement":[
                {
                    "Sid":"S3Org",
                    "Effect":"Allow",
                    "Action":[
                        "s3:PutObject",
                        "s3:DeleteObjectVersion",
                        "s3:DeleteObject"
                    ],
                    "Resource":"arn:aws:s3:::(bucket name)/*"
                },
                {
                    "Sid":"OrgData",
                    "Effect":"Allow",
                    "Action":[
                        "organizations:ListAccounts",
                        "organizations:ListCreateAccountStatus",
                        "organizations:DescribeOrganization",
                        "organizations:ListTagsForResource"
                    ],
                    "Resource":"*"
                },
                {
                    "Sid":"Logs",
                    "Effect": "Allow",
                    "Action": [
                        "logs:CreateLogGroup",
                        "logs:CreateLogStream",
                        "logs:PutLogEvents",
                        "logs:DescribeLogStreams"
                    ],
                    "Resource": "arn:aws:logs:*:*:*"
                },
                {
                    "Sid": "assume",
                    "Effect": "Allow",
                    "Action": "sts:AssumeRole",
                    "Resource": "arn:aws:iam::(account id):role/OrganizationLambdaAccessRole"
                }
            ]
        }

4.	Fill in the following
* **Policy Name** LambdaOrgPolicy
* **Description** Access to S3 for Lambda function to collect Orginization data
* Click **Create policy**

![Images/LambdaOrgPolicy.png](/Cost/300_Organization_Data_CUR_Connection/Images/LambdaOrgPolicy.png)

5.	Select **Roles**, click **Create role**

![Images/createrole.png](/Cost/300_Organization_Data_CUR_Connection/Images/createrole.png)

6.	Select **Lambda**, click **Next: Permissions**:

![Images/permissons.png](/Cost/300_Organization_Data_CUR_Connection/Images/permissons.png)

7.	Type lambda into the search and select the **LambdaOrgPolicy** policy, click **Next: Tags**

![Images/add_permission.png](/Cost/300_Organization_Data_CUR_Connection/Images/add_permission.png)

8.	Click **Next: Review**

9.	**Role name** LambdaOrgRole, click Create role:

![Images/create_role.png](/Cost/300_Organization_Data_CUR_Connection/Images/create_role.png)


### Create IAM Role and Policies in Management account
As we need to pull the data from the **Management account** we need to allow our role to do this. 

1. Log into your **Management account**

2. Go to the **IAM Console**

3. Select **Policies** and **Create policy**. Copy steps 2 - 4 from above to create the below policy called **ListOrganizations**.

![Images/create_policy.png](/Cost/300_Organization_Data_CUR_Connection/Images/create_policy.png)

    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "OrgData",
                "Effect": "Allow",
                "Action": [
                    "organizations:ListAccounts",
                    "organizations:ListCreateAccountStatus",
                    "organizations:DescribeOrganization",
                    "organizations:ListTagsForResource"
                ],
                "Resource": "*"
            }
        ]
    }


4.	Select **Roles**, click **Create role**

![Images/createrole.png](/Cost/300_Organization_Data_CUR_Connection/Images/createrole.png)

5. Choose **Another AWS account**,  and enter your sub account id which is where we started the lab, **Next: Permissions** 

![Images/iam_another_account.png](/Cost/300_Organization_Data_CUR_Connection/Images/iam_another_account.png)

6. Search for Organizations and select the **ListOrganizations** policy you just made. Click **Next: Tags** then click **Next: Review**

7. **Role name** OrganizationLambdaAccessRole, click **Create role**:

![Images/Org_Lambda_Role.png](/Cost/300_Organization_Data_CUR_Connection/Images/Org_Lambda_Role.png)

8. Search for your new role in the roles page and click on the role name. Click on **Trusted relationships** tab then **Edit trusted relationship**
![Images/Trusted_Relationship.png](/Cost/300_Organization_Data_CUR_Connection/Images/Trusted_Relationship.png)

9. On the **JSON** tab the replace the current json with the following policy and replace **(sub account id)** with your sub account id from before, click **Update Trust policy**:

        {
            "Version": "2012-10-17",
            "Statement": [
                {
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::(sub account id):role/LambdaOrgRole"
                },
                "Action": "sts:AssumeRole"
                }
            ]
        }


{{% notice tip %}}
Now you have completed this section you have setup the resources that will enable you to collect your Organizations data. We will use these resources in the next section when creating our Lambda function. Please return to the sub account you created your S3 bucket in.
{{% /notice %}}


{{< prev_next_button link_prev_url="../" link_next_url="../2_create_automation_resources_source/" />}}