---
title: " Database Checklist "
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
 
# Database Checklist
 
* Use [Instance Scheduler](https://docs.aws.amazon.com/solutions/latest/instance-scheduler/welcome.html) to pause/stop development/test EC2, RDS, and Redshift environments at weekend
* [Delete Unattached RDS Instances](https://github.com/Road-To-FinOps-Deploy/aws_tf_rds_delete_unattached_cleaner) - The script schedules the review of any RDS that have been unattached, stop them then delete them.
* Graviton for managed services  