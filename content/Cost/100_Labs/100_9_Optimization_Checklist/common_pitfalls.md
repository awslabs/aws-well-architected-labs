---
title: "Common Pitfalls"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---
# Common Pitfalls

We often get asked what are common pitfalls we see customers fall into. This is a list of areas we wanted to highlight to stop others making the same mistakes.

### Costs:
* Using Old instance types - in most cases newer types are cheaper than previous generations. You can prevent this using [Service Control Policies](https://wellarchitectedlabs.com/cost/200_labs/200_2_cost_and_usage_governance/3_ec2_restrict_family/)
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

