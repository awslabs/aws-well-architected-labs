---
title: "Clean up"
date: 2023-01-24T09:16:09-04:00
chapter: false
weight: 9
pre: "<b>Step 9: </b>"
---

In order to delete the resources deployed and created fot this lab:

1. Go to the Amazon S3 console and [delete the bucket created for this lab and its content](https://docs.aws.amazon.com/AmazonS3/latest/userguide/delete-bucket.html).

2. Go to the AWS Glue console and delete:
    - The tables created by the crawlers you defined during the lab
    - The database you created
    - The crawlers you created

3. Go to AWS Glue Jobs and delete the jobs you created during the lab 

4.  Go to [Amazon IAM and delete the role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_manage_delete.html) and permissions created at the beginning of the lab

