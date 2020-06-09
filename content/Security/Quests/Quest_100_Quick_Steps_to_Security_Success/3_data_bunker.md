---
title: "Data Bunker"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

Now we will create a data bunker account to store secure read only security logs and backups. In this step we will send our logs from CloudTrail to that account. The role for accessing this account will have read only access. Only ensure that this role can be accessed by those with a security role in your organization.

### Walkthrough

1. [Setup a security account, secure Amazon S3 bucket and turn on our AWS Organization CloudTrail](/security/100_labs/100_create_a_data_bunker/)
