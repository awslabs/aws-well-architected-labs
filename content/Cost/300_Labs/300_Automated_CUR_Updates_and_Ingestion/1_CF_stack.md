---
title: "Create the CloudFormation Stack"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

This step is used when there is a single CUR being delivered, and have it automatically update Athena/Glue when there are new versions and new months data.

We will follow the steps here: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/setting-up-athena.html#use-athena-cf to implement the CloudFormation template, which will automatically update existing CURs, and include new CURs when they are delivered.

NOTE: IAM roles will be created, these are used to:
- Add event notification to existing S3 buckets
- Create s3 buckets and upload objects
- Create and run a Glue crawler
- Create and update a Glue database and tables

- Please review the CloudFormation template with your security team.

We will build the following solution:
![Images/Setup.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/Setup.png)

1. Log into the console via SSO. Go to the S3 dashboard, go to the bucket and folders which contain your CUR file. Open the CloudFormation(CF) file and save it locally:
![Images/AWSCURAutoUpdate1.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSCURAutoUpdate1.png)

2. Here is a sample of the CF file:
![Images/AWSCURAutoUpdate2.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSCURAutoUpdate2.png)

3. Go to the CloudFormation dashboard and create a stack:
![Images/AWSCURAutoUpdate3.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSCURAutoUpdate3.png)

4. Load the template and click **Next**:
![Images/AWSCURAutoUpdate4.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSCURAutoUpdate4.png)

5. Specify the details for the stack and click **Next**:
![Images/AWSCURAutoUpdate5.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSCURAutoUpdate5.png)

6. Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources**, and click **Create stack**:
![Images/AWSCURAutoUpdate6.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSCURAutoUpdate6.png)

7. You will see the stack will start in **CREATE_IN_PROGRESS**:
![Images/AWSCURAutoUpdate7.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSCURAutoUpdate7.png)

8. Once complete, the stack will show **CREATE_COMPLETE**:
![Images/AWSCURAutoUpdate8.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSCURAutoUpdate8.png)

9. Click on **Resources** to view the resources that it will create:
![Images/AWSCURAutoUpdate9.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSCURAutoUpdate9.png)

10. Go to the AWS Glue dashboard:
![Images/AWSCURAutoUpdate10.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSCURAutoUpdate10.png)

11. Click on **Databases** and click the database starting with **athenacurcfn**:
![Images/AWSCURAutoUpdate11.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSCURAutoUpdate11.png)

12. View the table within that database and its properties:
![Images/AWSCURAutoUpdate12.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSCURAutoUpdate12.png)

You will see that the table is populated, the **recordCount** should be greater than 0. You can now go to Athena and load the partitions and view the cost and usage reports.
