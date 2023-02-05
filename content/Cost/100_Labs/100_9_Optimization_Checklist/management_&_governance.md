---
title: " Management & Governance Checklist "
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
 
# Management & Governance Checklist
 

 ### Using Service Control Policies
* Restrict [deployment to regions](https://aws.amazon.com/blogs/security/easier-way-to-control-access-to-aws-regions-using-iam-policies/) you don’t expect to deploy in. 
* Restrict access to our most [expensive EC2 instance families](https://blog.vizuri.com/limiting-allowed-aws-instance-type-with-iam-policy) (for example p-family GPU Instances or high memory x instances) with defined exceptions
* Restrict deployment on [previous generation of instances](https://wellarchitectedlabs.com/cost/200_labs/200_2_cost_and_usage_governance/3_ec2_restrict_family/) (for example, restrict m4 and earlier but allow m5)
* Restrict access to services with large upfront fees or commitments, for example our Snow Family, AWS Outputs and AWS Shield Advanced services
* Restrict access to [AWS MarketPlace](https://docs.aws.amazon.com/marketplace/latest/buyerguide/buyer-iam-users-groups-policies.html) or develop a private MarketPlace if you expect usage to occur.
* Restrict access to any commercial operating systems/database engines which aren’t expected to be used (for example, Oracle databases or RedHat Instances)
* Implement [Tagging Policies](https://wellarchitectedlabs.com/cost/100_labs/100_8_tag_policies/) to ensure any mandatory tags are using a consistent naming conventions.
* Use Service Control Policies to restrict deployment of infrastructure if the required tags aren’t included. For existing accounts, apply these rules in AWS Config so you don’t affect any infrastructure being automatically deployed but can notify owners if there are some non-compliant resources.
 


### Governance
* Introduce Cloud Center of Excellences within each program to centrally share best practices not just in cost optimization but architecture, security and performance strategies
* Document every restriction you have implemented, who the owner of this restriction is, and a brief justification on why this is in place.
* [AWS Private Marketplace](https://aws.amazon.com/marketplace/features/privatemarketplace) enables administrators to build customized digital catalogs of approved products from AWS Marketplace. 
