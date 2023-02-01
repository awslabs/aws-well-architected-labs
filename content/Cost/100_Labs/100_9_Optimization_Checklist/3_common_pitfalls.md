---
title: " Common Pitfalls "
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---
# Common Pitfalls

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


