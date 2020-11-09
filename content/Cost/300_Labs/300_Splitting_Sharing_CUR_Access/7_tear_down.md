---
title: "Tear Down"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>7. </b>"
weight: 7
---

We will tear down this lab, removing any data, resources and configuration that it created. We will restore any modified code or resources to their original state before the lab.

### 7.1 Sub Account
1 - Log into the sub account as an IAM user with the required privileges

2 - Go to the Glue service dashboard

3 - Delete the created database and tables

4 - Delete the recurring Glue crawler

### 7.2 Management/Payer Account
1 - Log into the management/payer account as an IAM user with the required privileges

2 - Go to the Cloudformation service dashboard, and select the CUR update stack

3 - Update the stack and use the original Template yml file

4 - Go to the Lambda service dashboard

5 - Delete the **SubAcctSplit** and **S3LinkedPutACL** Lambda functions

6 - Go to the IAM service dashboard

7 - Delete the **LambdaSubAcctSplit** and **Lambda_Put_Linked_S3ACL** roles

8 - Delete the **LambdaSubAcctSplit** and **Lambda_S3Linked_PutACL** policies

9 - Go to the Athena service dashboard

10 - Delete the **create_linked_** and **delete_linked_** Athena saved queries

11 - Delete any temp tables

12 - Go into the S3 service dashboard

13 - Delete the S3 output folder


{{< prev_next_button link_prev_url="../6_sub_acct/"  title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST 3 - "How do you monitor usage and cost?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-expenditure-and-usage-awareness.html)
{{< /prev_next_button >}}





