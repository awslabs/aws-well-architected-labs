---
title: "Sub Account Crawler Setup"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

The final step is to setup the sub account to automatically scan the S3 folders each morning using a Glue Crawler, and update a local Athena database.

1 - Login to the sub account as an IAM user with the required permissions, and go into the **Glue console**.

2 - Add a **Crawler** with the following details:

 - **Include path**: the S3 bucket in the account with the delivered CURs
 - **Exclude patterns**:

 ```
 **.json, **.yml, **.sql, **.csv, **.gz, **.zip (1 per line)
```

![Images/splitsharecur12.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur12.png)

3 - Create a new role for the crawler to use
![Images/splitsharecur13.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur13.png)


4 - Create a daily schedule to update the tables each morning before you come into work
![Images/splitsharecur14.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur14.png)

5 - Create a new database

6 - Review the crawler configuration and finish:
![Images/splitsharecur15.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur15.png)

7 - Run the crawler, and check that it has added tables.

8 - Go into Athena and execute a preview query to verify access and the data.


You have now given the sub account access to their specific CUR files as extracted from the Master/Payer CUR file. This will be automatically updated on any new versions delivered, or any new months delivered.
