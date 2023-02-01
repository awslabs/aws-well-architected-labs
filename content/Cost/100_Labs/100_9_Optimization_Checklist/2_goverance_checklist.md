---
title: "Governance Checklist "
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

# Governance Checklist

 
### Using Service Control Policies
* Restrict [deployment to regions](https://aws.amazon.com/blogs/security/easier-way-to-control-access-to-aws-regions-using-iam-policies/) you don’t expect to deploy in. 
* Restrict access to our most [expensive EC2 instance families](https://blog.vizuri.com/limiting-allowed-aws-instance-type-with-iam-policy) (for example p-family GPU Instances or high memory x instances) with defined exceptions
* Restrict deployment on [previous generation of instances](https://wellarchitectedlabs.com/cost/200_labs/200_2_cost_and_usage_governance/3_ec2_restrict_family/) (for example, restrict m4 and earlier but allow m5)
* Restrict access to services with large upfront fees or commitments, for example our Snow Family, AWS Outputs and AWS Shield Advanced services
* Restrict access to [AWS MarketPlace](https://docs.aws.amazon.com/marketplace/latest/buyerguide/buyer-iam-users-groups-policies.html) or develop a private MarketPlace if you expect usage to occur.
* Restrict access to any commercial operating systems/database engines which aren’t expected to be used (for example, Oracle databases or RedHat Instances)
* Implement [Tagging Policies](https://wellarchitectedlabs.com/cost/100_labs/100_8_tag_policies/) to ensure any mandatory tags are using a consistent naming conventions.
* Use Service Control Policies to restrict deployment of infrastructure if the required tags aren’t included. For existing accounts, apply these rules in AWS Config so you don’t affect any infrastructure being automatically deployed but can notify owners if there are some non-compliant resources.
 
### Storage Lifecycle Policies
* Restrict EBS volumes to [latest volumes types](https://wellarchitectedlabs.com/cost/200_labs/200_2_cost_and_usage_governance/5_ec2_volume_type/) (gp3, io2, st1, sc1) Use Service Control Policies to apply this across your account
* Ensure you have an [EBS snapshot policy](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/snapshot-lifecycle.html) in place. We recommend you use AWS Backup to uniformly set the policy, and to restrict snapshots to be less than 45 days old. However this should be aligned to your business SLAs and backup policies to prevent unnecessary copies of data but stops data being accidentally deleted.
* Have controls or reviews of EC2 AMI retention to determine if you have any AMI no longer in use.
* Ensure all S3 Buckets have [lifecycle policies](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html) in place. Not sure what the policy should be? Use S3 Intelligent Tiering
* Ensure that EFS has a [lifecycle policy](https://docs.aws.amazon.com/efs/latest/ug/lifecycle-management-efs.html) in place
 

### Cost Controls
* Use [AWS Budget](https://wellarchitectedlabs.com/cost/100_labs/100_2_cost_and_usage_governance/) to alert you if spend is going to exceed pre-defined budgets or approval thresholds. Based budgets on forecasted values so you can be proactive on investigation
* Use [AWS Cost Anomaly Detection](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/getting-started-ad.html) to alert you if unusual spend is detected
* Ensure all teams have access to see their [costs](https://github.com/Road-To-FinOps-Deploy/aws_member_cur) and understand what influences it.
* Put controls using CloudWatch metrics to measure [AWS Lambda](https://aws.amazon.com/about-aws/whats-new/2020/10/announcing-amazon-cloudwatch-lambda-insights-preview/?trk=el_a134p000006peKqAAI&trkCampaign=AWSInsights_Website_News_amazon-cloudwatch-lambda-insights-preview&sc_channel=el&sc_campaign=AWSInsights_Blog_finding-savings-from-2020-reinvent-announcements&sc_outcome=Product_Marketing) evocations, [Athena](https://docs.aws.amazon.com/athena/latest/ug/control-limits.html?trk=el_a134p000006peLjAAI&trkCampaign=AWSInsights_Website_Docs_athena-control-limits&sc_channel=el&sc_campaign=AWSInsights_Blog_finding-savings-from-2020-reinvent-announcements&sc_outcome=Product_Marketing), API gateway calls, VPC & IoT metrics to ensure alerting occurs if there are unusual workload. 
* Build regular reviews of [AWS Trusted Advisor](https://aws.amazon.com/solutions/implementations/aws-trusted-advisor-explorer/) checks as reviewing platform efficiency becomes part of BAU
* [Config Rules](https://docs.aws.amazon.com/config/latest/developerguide/eip-attached.html) to release unattached IP Addresses 
 
### Governance
* Introduce Cloud Center of Excellences within each program to centrally share best practices not just in cost optimization but architecture, security and performance strategies
* Document every restriction you have implemented, who the owner of this restriction is, and a brief justification on why this is in place.
* [AWS Private Marketplace](https://aws.amazon.com/marketplace/features/privatemarketplace) enables administrators to build customized digital catalogs of approved products from AWS Marketplace. 
 

