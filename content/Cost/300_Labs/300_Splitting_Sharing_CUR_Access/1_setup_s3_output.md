---
title: "Setup Output S3 Bucket"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

We need to provide a location to deliver the output from the Athena queries, so that it can be secured and restricted to the sub accounts. We'll need to create the S3 bucket, and implement a Lambda function to re-write the object ACLs when new objects are delivered.

So what we'll do is as follows:

 - Create the output S3 bucket with the required bucket policy
 - Create an IAM policy that will allow a Lambda function to re-write object ACLs
 - Implement the Lambda function

1 - Login to the consolve via SSO.

2 - Go to the S3 console

3 - Create the output S3 bucket

4 - The lab has been designed to allow multiple statements to output to a single bucket, each in a different folder. Create one folder for each Athena statement you will run, a convenient name for the folders is the Account ID of the sub account.

5 - Go to **Permissions**, and implement a bucket policy to allow sub accounts access, ensure you follow security best practices and allow least privilege:
![Images/splitsharecur0.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur0.png)


You can modify this sample policy as a starting point:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListingOfFolders",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::(account ID):root"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::(bucket)"
        },
        {
            "Sid": "AllowAllS3ActionsInSubFolder",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::(account ID):root"
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::(bucket)/(folder)/*"
        }
    ]
}
```

6 - Go to the IAM Dashboard

7 - Create an IAM policy **Lambda_S3Linked_PutACL** to allow lambda to write ACLs:
![Images/splitsharecur1.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur1.png)

You can modify the following sample policy as a starting point:

NOTE: replace (bucket name):
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:PutObjectVersionAcl",
                "s3:PutObjectAcl"
            ],
            "Resource": "arn:aws:s3:::(bucket name)/*"
        }
    ]
}
```

8 - Create an IAM role for **Lambda** named **Lambda_Put_Linked_S3ACL**

9 - Attach the **Lambda_S3Linked_PutACL** policy:
![Images/splitsharecur2.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur2.png)

10 - Go to the Lambda service dashboard

11 - Create the lambda function **S3LinkedPutACL** with the following details:

 - Node.js
 - Role: **Lambda_Put_Linked_S3ACL**
 - Code: [./Code/S3LinkedPutACL.md]({{< ref "Code/S3LinkedPutACL.md" >}})

12 - Go to the S3 service dashboard

13 - Select the **Output Bucket**, go to **Properties**, and add an S3 event to trigger on **All object create events**, and have it run the **S3LinkedPutACL** Lambda function:
![Images/splitsharecur3.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur3.png)

14 - Test the configuration is working correctly by uploading a file into the S3 folder. Verify that it has multiple Grantees to the required accounts:
![Images/splitsharecur4.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur4.png)

15 - Delete the file and ensure all folders are empty.
The output bucket setup is now complete. Every time the Athena query runs and outputs a file into the S3 bucket, it will automatically have its permissions ACL updated to allow access to the sub account.
