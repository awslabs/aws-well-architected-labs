+++
title = "Create Backup Resources"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

Now we are going to backup our resources.  

We will perform the following:
- Backup the RDS database
- Create an EC2 AMI (Amazon Machine Image)
- Create a new S3 UI bucket

We would create a [backup plan](https://docs.aws.amazon.com/aws-backup/latest/devguide/creating-a-backup-plan.html) for a production application and schedule recurring backups to meet the target RPO. 

However, for the workshop, we will create a **manual backup**.

{{< prev_next_button link_prev_url="../prerequisites/" link_next_url="./rds/" />}}
