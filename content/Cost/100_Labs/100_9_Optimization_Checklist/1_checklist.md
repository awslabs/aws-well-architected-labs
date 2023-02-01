---
title: "Checklist "
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
Optimisation Checklist for new workloads and migrations


 
### Using Service Control Policies
* Restrict [deployment to regions](https://aws.amazon.com/blogs/security/easier-way-to-control-access-to-aws-regions-using-iam-policies/) you don’t expect to deploy in. 
* Restrict access to our most [expensive EC2 instance families](https://blog.vizuri.com/limiting-allowed-aws-instance-type-with-iam-policy) (for example p-family GPU Instances or high memory x instances) with defined exceptions
* Restrict deployment on [previous generation of instances](https://wellarchitectedlabs.com/cost/200_labs/200_2_cost_and_usage_governance/3_ec2_restrict_family/) (for example, restrict m4 and earlier but allow m5)
* Restrict access to services with large upfront fees or commitments, for example our Snow Family, AWS Outputs and AWS Shield Advanced services
* Restrict access to AWS MarketPlace or develop a private MarketPlace if you expect usage to occur.
* Restrict access to any commercial operating systems/database engines which aren’t expected to be used (for example, Oracle databases or RedHat Instances)
* Implement Tagging Policies to ensure any mandatory tags are using a consistent naming conventions.
* Use Service Control Policies to restrict deployment of infrastructure if the required tags aren’t included. For existing accounts, apply these rules in AWS Config so you don’t affect any infrastructure being automatically deployed but can notify owners if there are some non-compliant resources.
 
### Storage Lifecycle Policies
* Restrict EBS volumes to latest volumes types (gp3, io2, st1, sc1)
 Use Service Control Policies to apply this across your account
* Ensure you have an EBS snapshot policy in place. We recommend you use AWS Backup to uniformly set the policy, and to restrict snapshots to be less than 45 days old. However this should be aligned to your business SLAs and backup policies to prevent unnecessary copies of data but stops data being accidentally deleted.
* Have controls or reviews of EC2 AMI retention to determine if you have any AMI no longer in use.
* Ensure all S3 Buckets have lifecycle policies in place. Not sure what the policy should be? Use S3 Intelligent Tiering
* Ensure that EFS has a lifecycle policy in place
 
### Utilization reviews 
* Use Instance Scheduler to pause/stop development/test EC2, RDS, and Redshift environments at weekend
* Have alerting to inform you of idle infrastructure. This can be EC2 instances, EBS volumes, RDS instances.
* Have alerting to inform you of unattached infrastructure. This includes Elastic IP Addresses, EBS volumes, Load Balancers.
* Include reviews of infrastructure utilization by include Compute Optimizer as part of your sprint reviews. This monitors EC2, EBS and Lambda utilization.
* Enable CloudWatch alarms with SNS/Email notifications to inform owners if their utilization thresholds aren’t exceeding a certain threshold over a rolling time period.
* Review Cost Explorer rightsize recommendations in portal or collect regularly  
* Include reviews of Amazon S3 analytics – Storage class analysis to analyse storage patterns and idle data to make right storage class decisions or remove data from S3.
* Enable Amazon S3 Storage Lens
 
 
### Cost Controls
* Use AWS Budget to alert you if spend is going to exceed pre-defined budgets or approval thresholds. Based budgets on forecasted values so you can be proactive on investigation
* Use AWS Cost Anomaly Detection to alert you if unusual spend is detected
* Ensure all teams have access to see their costs and understand what influences it.
* Put controls using CloudWatch metrics to measure Lambda evocations, Athena, API gateway calls, VPC & IoT metrics to ensure alerting occurs if there are unusual workload. 
* Build regular reviews of AWS Trusted Advisor checks as reviewing platform efficiency becomes part of BAU
* Config Rules to release unattached IP Addresses 
 
### Governance
* Introduce Cloud Center of Excellences within each program to centrally share best practices not just in cost optimization but architecture, security and performance strategies
* Document every restriction you have implemented, who the owner of this restriction is, and a brief justification on why this is in place.
* AWS Private Marketplace enables administrators to build customized digital catalogs of approved products from AWS Marketplace. 
 

### Automation Links
* Karpenter - A open-source, flexible, high-performance Kubernetes cluster autoscaler built with AWS
* AWS Instance Schedular - This Solutions Implementation helps you control your AWS resource cost by configuring start and stop schedules for your Amazon Elastic Compute Cloud (Amazon EC2) and Amazon Relational Database Service (Amazon RDS) instances.
* Amazon CodeGuru  - is a developer tool powered by machine learning that provides intelligent recommendations to detect security vulnerabilities, improve code quality and identify an application’s most expensive lines of code
* Elastic IP Cleaner - The script schedules the review of any eips that are unattached
* EBS Volume Cleaner - The script schedules the review of any ebs volumes that have been unattached for X days (default 7). This reviews all regions in your account
* Snapshot Cleaner - Find any old snapshots that have been there longer than x days and deletes them
* Amazon Unused Workspaces - The script schedules the review of any workspaces that have had 0 user connection events for "threshold" days, defaults to 28. This reviews all regions in your account
* Delete Unattached RDS Instances - The script schedules the review of any RDS that have been unattached, stop them then delete them.
* Well Architected Labs - This repository contains documentation and code in the format of hands-on labs to help you learn, measure, and build using architectural best practices.
Common Pitfalls
Costs:
* Using Old instance types - in most cases newer types are cheaper than previous generations. You can prevent this using SPC
* Not having a data lifecycle management(DLM) policy for snapshots - The DLM automates snapshot and AMI management this reduces storage costs by deleting outdated backups
* Not using Infrastructure as Code (IAC) - Using IAC will enable development to be faster, will reduce the risk of recourses being idle and allow for ease of changes to infrastructure
* Leaving around Idle resources - Trusted Advisor will show you resources which are idle. These are often costing money and not being used. Manually deleting them is a good start, but using automation or having all resources created through IAC will prevent costs growing
* Buying Instance Savings Plans for unstable workloads - If you know your workload is stable buying instance savings plans will give you the best discount. If you are unsure then choose compute as it covers more options and gives you flexibility. The ideal situation is having a mixed of both. 
* Modernising without checking RI Fleet  
* Having CloudWatch frequency set to ‘Never expire’ for all logs - Logs should be kept for a relevant amount of time. If they are created daily, then they may only be needed for a month. If they are created monthly, then maybe for 6month. 
* 3rd party monitoring on CW - 3rd part tools often ping CloudWatch very regularly. Check how much data is needed. 
* Having Detailed monitoring enabled when you don’t need it - Data is available in 1-minute periods, you are charged per metric that is sent to CloudWatch.
* Choosing gp2 as standard for EBS - gp3 are 20% cheaper than gp2. They are not always the cheapest option but follow this guide to see which ones are
* All or nothing with Spot - a great way of taking advantage of Spot is by having it cover spikes. Using Auto Scaling groups with multiple instance types and purchase options is a great way to get the best of both worlds. 
* Not using Graviton with managed services - As AWS looks after everything under the hood with managed services, graviton can be a great option. Often giving you a 40% better price performance, many services can take advantage of this.  
* Over provisioned lambda - Lambda functions ask you to choose your memory when creating them. Customers often don’t review these choices and so can be paying for unnecessary storage. You can see this in aws compute optimizer
* Using Serverless when you should be static - do a cost exercise when moving from static workload to serverless.
* Always using S3 Standard storage - This is the most expensive tier of S3 but is good for regular access. If you know your access patterns you should use lifecycle polices and if you are unsure use S3 intelligent tiering. Choose the tier for what you need! 
* Storing old versions or failed mpu’s - If you are storing objects with many versions or potential for failed mpus, create lifecycle policies to remove them. 
* Having multiple cloud trails - Your first cloud trail is free! Any after that cost you per management events for the same set of data to be stored. You will also be paying for twice the data storage costs. 
* Keeping resource ‘on’ 24/7 - Not all services need to be on 24/7. Dev/test environments can often be shut down out of office hours. Use instance schedular to do this using Tags
* Nat Gateways - having data in and out 
* Which S3 tiers are you getting data from? - There are different costs for retrial of object so be mindful of where you are pulling data from 
* Data Transfer - Using Availability Zone Affinity to  reduces the number of times an AZ boundary is crossed reducing costs and latency. 
* API calls that cost money - Some APIs you have to pay too query. Cost Explorer and EBS Snapshots are examples. Check before you create a costly script. Cloudtrail, S3 , Athena,Service Catalog

### Management:
* Not having a tagging/allocation method
* Having no cost visualisation
* Not having S3 lens dashboard created
* Not Turning on right-sizing recommendations
* Not turning on Compute Optimiser
* Not having a basic AWS budget created
* Not having anomaly detection setup 
* Not Creating a CUR
* Not enablinng Cost Explore
* No Ownership stratergy
* Not enabling Billing PDF


### Cost Optimization
* Education on RI
* Education on Savings Plans 

### Architecture best practices
* Autoscaling 
* Scheduling 
* Idle Resource
* Storage types
* EBS
* S3
* S3 Lifecycles
* Graviton
* Spot
* Containers
* Serverless
* Rightsizeing

### Tooling (Ca/CES)
* Trusted Advisor
* Compute Optimizer (enable)
* S3 Lens (enable and Org create)
* Cost Explorer
* Spot numbers
* Config
* CloudWatch
* Budgets 
* Anomoly detection
* Cost Catagory

### Concepts
* Use  IAC
* Automation 
* Centralized team 
* Cost Account 
* AWS Orgonisations 
* WA Review
* KPI Reviews/ setting 

### Finance and Culture side:
* Establish a Cloud-Specific General Ledger (GL) account number. COF didn't have this initially, so it was a struggle to understand early year AWS spend, as the costs were posted to a Data Processing GL used for network carrier costs
* Establish norms around SP/RI purchases. E.g. purchased by a central team or local teams, how are benefits spread, etc. Get buy-in from all parties
* Establish an Account to Org structure early (basically the tagging comment above). Have a common language of how teams speak about their workloads (account level, application level, etc)
* Cloud for Finance education early - identify Cloud Finance SMEs to bring them along in the journey.
* Same thing with Accounting - make sure they understand how SP/RI purchases, premium support fees, credits, other one-time items need to be amortized. Get buy-in early. Cleaning up the GL is a giant pain when you inevitably are asked the question two years from now 'how much has our AWS spend grown by Line of Business' and the GL doesn't align


