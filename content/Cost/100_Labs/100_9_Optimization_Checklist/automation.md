---
title: "Automation Checklist "
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
 
# Automation Checklist

* [Karpenter](https://aws.amazon.com/marketplace/features/privatemarketplace) - A open-source, flexible, high-performance Kubernetes cluster autoscaler built with AWS
* [AWS Instance Schedular](https://aws.amazon.com/solutions/implementations/instance-scheduler/) - This Solutions Implementation helps you control your AWS resource cost by configuring start and stop schedules for your Amazon Elastic Compute Cloud (Amazon EC2) and Amazon Relational Database Service (Amazon RDS) instances.
* [Amazon CodeGuru](https://aws.amazon.com/codeguru/)  - is a developer tool powered by machine learning that provides intelligent recommendations to detect security vulnerabilities, improve code quality and identify an application’s most expensive lines of code
* [Elastic IP Cleaner](https://github.com/Road-To-FinOps-Deploy/aws_tf_eip_cleaner) - The script schedules the review of any eips that are unattached
* [EBS Volume Cleaner](https://github.com/Road-To-FinOps-Deploy/aws_tf_ebs_volumes_cleaner) - The script schedules the review of any ebs volumes that have been unattached for X days (default 7). This reviews all regions in your account
* [Snapshot Cleaner](https://github.com/Road-To-FinOps-Deploy/aws_tf_ebs_snapshot_cleanup) - Find any old snapshots that have been there longer than x days and deletes them
* [Amazon Unused Workspaces](https://github.com/Road-To-FinOps-Deploy/aws_tf_unused_workspaces) - The script schedules the review of any workspaces that have had 0 user connection events for "threshold" days, defaults to 28. This reviews all regions in your account
* [Delete Unattached RDS Instances](https://github.com/Road-To-FinOps-Deploy/aws_tf_rds_delete_unattached_cleaner) - The script schedules the review of any RDS that have been unattached, stop them then delete them.
* [Well Architected Lab](https://wellarchitectedlabs.com/cost/) - This repository contains documentation and code in the format of hands-on labs to help you learn, measure, and build using architectural best practices.
* [Config Rules](https://docs.aws.amazon.com/config/latest/developerguide/eip-attached.html) to release unattached IP Addresses 
* Use [Instance Scheduler](https://docs.aws.amazon.com/solutions/latest/instance-scheduler/welcome.html) to pause/stop development/test EC2, RDS, and Redshift environments at weekend
* Amazon S3 intelligent Teiring
* Amazon Autoscaling Groups for EC2
* Amazon Autoscaling Groups for Aroura


