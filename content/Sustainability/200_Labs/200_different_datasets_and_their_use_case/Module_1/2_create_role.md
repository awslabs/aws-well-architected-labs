---
title: "Set up the permissions"
date: 2023-01-24T09:16:09-04:00
chapter: false
weight: 3
pre: "<b>Step 2: </b>"
---

#### 2. Create an IAM role to use during this lab.

During this lab, you will use AWS Glue to scan our data stored in Amazon S3, to transform that data and to store it transformed on Amazon S3. You need a service role that will give AWS Glue the permissions to do so.

**2.1** On the AWS Console, navigate to AWS IAM or click [here](https://us-east-1.console.aws.amazon.com/iamv2/home#/home). 

**2.2** On the left menu, select **Policies** and click on **Create Policy**.
![Policies](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/7_1_Policies.png)

**2.3** Select the JSON tab, replace the content by the folowing policy statement, replace `[YOUR BUCKET NAME]` by the name of the bucket you just created:
![Policy JSON](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/7_2_Policy_json.png)

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::[YOUR BUCKET NAME]*"
            ]
        }
    ]
}
```
This policy allows the principal it is attach to to get and put objects on your newly created Amazon S3 bucket. Click **Next: Tags**, and **Next: Review**. Give your policy a name such as: `module-1-s3-policy` and enter a description `Read and write on asl-aws-module-1-lab bucket`. Click on **Create policy**.

![Policy review](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/7_3_review_policy.png)

**2.4** On the IAM left menu, now select **Roles** and click on **Create role**. 

![Roles](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/7_4_roles_create.png)

**2.5** Keep **AWS service** selected. Select **Glue** from the _Use cases for other AWS services_ drop down menu and click **Next**.
![Trust Entity](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/7_5_select_trust.png)

On the _Filter policies by property or policy name and press enter_ field, write `AWSGlueServiceRole` and select the policy with that name. Then, filter again by the name you just set to your new policiy and select it also. Click **Next**.
![add awsglueservicerole](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/7_6_awsglueservicerole.png)
![add policycreated](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/7_7_policy_created.png)

**2.6** Set a name for your role: `AWSGlueRole-module-1-lab`. Make sure both policies are selected and click **Create role**.
![review role](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/7_8_review_role.png)
![review role](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/7_9_role_create.png)

You will use this role int he next steps of the lab. Let's explore the dataset!

**Click on *Next Step* to continue to the next module.**

{{< prev_next_button link_prev_url="../1_intro" link_next_url="../3_explore_your_data" />}}