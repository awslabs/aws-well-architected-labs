---
title: "Create Lambda function to run the Saved Queries"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---
This Lambda function ties everything together, it will remove all objects in the current months S3 folders, find the Athena queries to run, and then execute the saved Athena queries. First we will create the role with permissions for Lambda to use, then the Lambda function itself.

1 - Go to the IAM service dashboard

2 - Create a policy named **LambdaSubAcctSplit**

3 - Edit the following policy inline with security best practices, and add it to the policy:

[./Code/SubAcctSplit_Role.md]({{< ref "Code/SubAcctSplit_Role.md" >}})

4 - Create a Role for **Lambda** to call services

5 - Attach the **LambdaSubAcctSplit** policy

6 - Name the role **LambdaSubAcctSplit**

7 - Go into the Lambda service dashboard

8 - Create a function named **SubAcctSplit**, **Author from scratch** using the **Python 3.7** Runtime and role **LambdaSubAcctSplit**:  
![Images/splitsharecur9.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur9.png)

9 - Copy the code into the editor from here:
[./Code/Sub_Account_Split.md]({{< ref "Code/Sub_Account_Split.md" >}})

10 - Edit the code as per the instructions at the top.

11 - Under **Basic settings** set the **Timeout** to 30seconds, and review this after the test at the end

12 - Change the **Execution role** to **LambdaSubAcctSplit**  

13 - Save the function

14 - Test that the function by clicking on the **Test** button at the top, and make sure that it executes correctly:
![Images/splitsharecur10.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur10.png)

15 - Go into the S3 Service dashboard, view the output folder and verify that there are files for the current month. Check the **Last modified** time stamp to ensure they were created at the time of the test.



You have now setup the Lambda function which executes the queries. The final step is to trigger this Lambda function every time a new CUR file is delivered.
