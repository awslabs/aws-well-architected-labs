---
title: " Checklist "
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
 
# Compute Checklist
 
* Use [Instance Scheduler](https://docs.aws.amazon.com/solutions/latest/instance-scheduler/welcome.html) to pause/stop development/test EC2, RDS, and Redshift environments at weekend
* Have alerting to inform you of [idle infrastructure](https://github.com/road-to-finops/cost_config). This can be EC2 instances, EBS volumes, RDS instances.
* Include reviews of [infrastructure utilization](https://github.com/Road-To-FinOps-Deploy/aws_tf_compute_optimiser_collector) by include Compute Optimizer as part of your sprint reviews. This monitors EC2, EBS and Lambda utilization.
* Enable CloudWatch alarms with SNS/Email notifications to inform owners if their utilization thresholds aren’t exceeding a certain threshold over a rolling time period.
* Using Old instance types - in most cases newer types are cheaper than previous generations. You can prevent this using [Service Control Policies](https://wellarchitectedlabs.com/cost/200_labs/200_2_cost_and_usage_governance/3_ec2_restrict_family/)