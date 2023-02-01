---
title: "Tooling Checklist "
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
 
# Tooling Checklist

### Utilization reviews 
* Use [Instance Scheduler](https://docs.aws.amazon.com/solutions/latest/instance-scheduler/welcome.html) to pause/stop development/test EC2, RDS, and Redshift environments at weekend
* Have alerting to inform you of [idle infrastructure](https://github.com/road-to-finops/cost_config). This can be EC2 instances, EBS volumes, RDS instances.
* Have alerting to inform you of [unattached infrastructure](https://github.com/road-to-finops/cost_config). This includes Elastic IP Addresses, EBS volumes, Load Balancers.
* Include reviews of [infrastructure utilization](https://github.com/Road-To-FinOps-Deploy/aws_tf_compute_optimiser_collector) by include Compute Optimizer as part of your sprint reviews. This monitors EC2, EBS and Lambda utilization.
* Enable CloudWatch alarms with SNS/Email notifications to inform owners if their utilization thresholds aren’t exceeding a certain threshold over a rolling time period.
* Review [Cost Explorer rightsize recommendations](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/ce-rightsizing.html) in portal or collect [regularly](https://github.com/Road-To-FinOps-Deploy/aws_cf_rightsize_rec_collector)  
* Include reviews of [Amazon S3 analytics](https://docs.aws.amazon.com/AmazonS3/latest/userguide/analytics-storage-class.html) – Storage class analysis to analyse storage patterns and idle data to make right storage class decisions or remove data from S3.
* Enable [Amazon S3 Storage Lens](https://aws.amazon.com/blogs/aws/s3-storage-lens/) for your organization 
 
 
### Cost Controls
* Use [AWS Budget](https://wellarchitectedlabs.com/cost/100_labs/100_2_cost_and_usage_governance/) to alert you if spend is going to exceed pre-defined budgets or approval thresholds. Based budgets on forecasted values so you can be proactive on investigation
* Use [AWS Cost Anomaly Detection](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/getting-started-ad.html) to alert you if unusual spend is detected
* Ensure all teams have access to see their [costs](https://github.com/Road-To-FinOps-Deploy/aws_member_cur) and understand what influences it.
* Put controls using CloudWatch metrics to measure [AWS Lambda](https://aws.amazon.com/about-aws/whats-new/2020/10/announcing-amazon-cloudwatch-lambda-insights-preview/?trk=el_a134p000006peKqAAI&trkCampaign=AWSInsights_Website_News_amazon-cloudwatch-lambda-insights-preview&sc_channel=el&sc_campaign=AWSInsights_Blog_finding-savings-from-2020-reinvent-announcements&sc_outcome=Product_Marketing) evocations, [Athena](https://docs.aws.amazon.com/athena/latest/ug/control-limits.html?trk=el_a134p000006peLjAAI&trkCampaign=AWSInsights_Website_Docs_athena-control-limits&sc_channel=el&sc_campaign=AWSInsights_Blog_finding-savings-from-2020-reinvent-announcements&sc_outcome=Product_Marketing), API gateway calls, VPC & IoT metrics to ensure alerting occurs if there are unusual workload. 
* Build regular reviews of [AWS Trusted Advisor](https://aws.amazon.com/solutions/implementations/aws-trusted-advisor-explorer/) checks as reviewing platform efficiency becomes part of BAU
* [Config Rules](https://docs.aws.amazon.com/config/latest/developerguide/eip-attached.html) to release unattached IP Addresses 
 

### Automation Links
* [Karpenter](https://aws.amazon.com/marketplace/features/privatemarketplace) - A open-source, flexible, high-performance Kubernetes cluster autoscaler built with AWS
* [AWS Instance Schedular](https://aws.amazon.com/solutions/implementations/instance-scheduler/) - This Solutions Implementation helps you control your AWS resource cost by configuring start and stop schedules for your Amazon Elastic Compute Cloud (Amazon EC2) and Amazon Relational Database Service (Amazon RDS) instances.
* [Amazon CodeGuru](https://aws.amazon.com/codeguru/)  - is a developer tool powered by machine learning that provides intelligent recommendations to detect security vulnerabilities, improve code quality and identify an application’s most expensive lines of code
* [Elastic IP Cleaner(https://github.com/Road-To-FinOps-Deploy/aws_tf_eip_cleaner) - The script schedules the review of any eips that are unattached
* [EBS Volume Cleaner](https://github.com/Road-To-FinOps-Deploy/aws_tf_ebs_volumes_cleaner) - The script schedules the review of any ebs volumes that have been unattached for X days (default 7). This reviews all regions in your account
* [Snapshot Cleaner](https://github.com/Road-To-FinOps-Deploy/aws_tf_ebs_snapshot_cleanup) - Find any old snapshots that have been there longer than x days and deletes them
* [Amazon Unused Workspaces](https://github.com/Road-To-FinOps-Deploy/aws_tf_unused_workspaces) - The script schedules the review of any workspaces that have had 0 user connection events for "threshold" days, defaults to 28. This reviews all regions in your account
* [Delete Unattached RDS Instances](https://github.com/Road-To-FinOps-Deploy/aws_tf_rds_delete_unattached_cleaner) - The script schedules the review of any RDS that have been unattached, stop them then delete them.
* [Well Architected Lab](https://wellarchitectedlabs.com/cost/) - This repository contains documentation and code in the format of hands-on labs to help you learn, measure, and build using architectural best practices.


