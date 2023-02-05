---
title: " AWS Cost Management Checklist "
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
 
# AWS Cost Management Checklist
 


### Cost Controls
* Use [AWS Budget](https://wellarchitectedlabs.com/cost/100_labs/100_2_cost_and_usage_governance/) to alert you if spend is going to exceed pre-defined budgets or approval thresholds. Based budgets on forecasted values so you can be proactive on investigation
* Use [AWS Cost Anomaly Detection](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/getting-started-ad.html) to alert you if unusual spend is detected
* Ensure all teams have access to see their [costs](https://github.com/Road-To-FinOps-Deploy/aws_member_cur) and understand what influences it.
* Put controls using CloudWatch metrics to measure [AWS Lambda](https://aws.amazon.com/about-aws/whats-new/2020/10/announcing-amazon-cloudwatch-lambda-insights-preview/?trk=el_a134p000006peKqAAI&trkCampaign=AWSInsights_Website_News_amazon-cloudwatch-lambda-insights-preview&sc_channel=el&sc_campaign=AWSInsights_Blog_finding-savings-from-2020-reinvent-announcements&sc_outcome=Product_Marketing) evocations, [Athena](https://docs.aws.amazon.com/athena/latest/ug/control-limits.html?trk=el_a134p000006peLjAAI&trkCampaign=AWSInsights_Website_Docs_athena-control-limits&sc_channel=el&sc_campaign=AWSInsights_Blog_finding-savings-from-2020-reinvent-announcements&sc_outcome=Product_Marketing), API gateway calls, VPC & IoT metrics to ensure alerting occurs if there are unusual workload. 
* Build regular reviews of [AWS Trusted Advisor](https://aws.amazon.com/solutions/implementations/aws-trusted-advisor-explorer/) checks as reviewing platform efficiency becomes part of BAU

* Review [Cost Explorer rightsize recommendations](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/ce-rightsizing.html) in portal or collect [regularly](https://github.com/Road-To-FinOps-Deploy/aws_cf_rightsize_rec_collector)  
* Cost Explorer
* Cost Catagory
* Cost allocation Tags
* Education on RI
* Education on Savings Plans 
* Enabling Billing PDF
* Create a CUR