---
title: "Cost Optimization"
date: 2020-08-28T11:16:09-04:00
chapter: false
weight: 5
pre: "<b> </b>"
---

These are queries for AWS Services under the [AWS Well-Architected Framework Cost Optimization Pillar](https://wa.aws.amazon.com/wellarchitected/2020-07-02T19-33-23/wat.pillar.costOptimization.en.html).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost/300_labs/300_CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

{{% notice warning %}}
Prior to deleting resources, check with the application owner that your analysis is correct and the resources are no longer in use. 
{{% /notice %}}

### Table of Contents
  * [Elastic Load Balancing - Idle ELB](#elastic-load-balancing---idle-elb)
  * [NAT Gateway - Idle NATGW](#nat-gateway---idle-natgw)
  * [Amazon WorkSpaces - Auto Stop](#amazon-workspaces---auto-stop)
  * [Amazon EBS Volumes Upgrade gp2 to gp3](#amazon-ebs-volumes-upgrade-gp2-to-gp3)
  
### Elastic Load Balancing - Idle ELB

#### Cost Optimization Technique
This query will display cost and usage of Elastic Load Balancers which didn’t receive any traffic last month and ran for more than 336 hours (14 days). Resources returned by this query could be considered for deletion.  [AWS Trusted Advisor](https://aws.amazon.com/premiumsupport/technology/trusted-advisor/best-practice-checklist/) provides a check for idle load balancers but only covers Classic Load Balancers.  This query will provide all Elastic Load Balancer types including Application Load Balancer, Network Load Balancer, and Classic Load Balancer.

The assumption is that if the Load Balancer has not received any traffic within 14 days, it is likely orphaned and can be deleted.

#### Link to Query
[Elastic Load Balancing - Idle ELB](../compute/#elastic-load-balancing---idle-elb)

#### Helpful Links
Please refer to the [ELB AWS CLI documentation](https://docs.aws.amazon.com/elasticloadbalancing/index.html) for deletion instructions.  The commands vary between the ELB types. 

* [Classic](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-getting-started.html#delete-load-balancer)
* [Application](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancer-getting-started.html#delete-load-balancer)
* [Network](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/network-load-balancer-cli.html#delete-aws-cli)

{{< email_button category_text="Cost Optimization" service_text="Elastic Load Balancing - Idle ELB" query_text="Elastic Load Balancing - Idle ELB query 1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### NAT Gateway - Idle NATGW

#### Cost Optimization Technique
This query shows cost and usage of NAT Gateways which didn’t receive any traffic last month and ran for more than 336 hrs. Resources returned by this query could be considered for deletion.

Besides deleting idle NATGWs you should also consider the following tips:

* Determine What Types of Data Transfers Occur the Most - [Deploy the CUDOS dashboard to help visualize top talkers](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/#cudos-dashboard)
* Eliminate Costly Cross Availability Zone Transfer Charges - create new NAT Gateways in the same availability zone as your instances
* Consider Sending Amazon S3 and Dynamo Traffic Through Gateway VPC Endpoints Instead of NAT Gateways
* Consider Setting up Interface VPC Endpoints Instead of NAT Gateways for Other Intra-AWS Traffic

#### Link to Query
[NAT Gateway - Idle NATGW](../networking_&_content_delivery#nat-gateway---idle-natgw)

#### Helpful Links
[Data Transfer Costs Explained](https://github.com/open-guides/og-aws#aws-data-transfer-costs)

{{< email_button category_text="Cost Optimization" service_text="Elastic Load Balancing - Idle ELB" query_text="Elastic Load Balancing - Idle ELB query 1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon WorkSpaces - Auto Stop

#### Cost Optimization Technique
AutoStop Workspaces are cost effective when used for several hours per day. If AutoStop Workspaces run for more than 80 hrs per month it is more cost effective to switch to AlwaysOn mode. This query shows AutoStop Workspaces which ran more that 80 hrs in previous month. If the usage pattern for these Workspaces is the same month over month it's possible to optimize cost by switching to AlwaysOn mode. For example, Windows PowerPro (8 vCPU, 32GB RAM) bundle in eu-west-1 runs for 400 hrs per month. In AutoStop mode it costs $612/month ($8.00/month + 400 * $1.53/hour) while if used in AlwaysOn mode it would cost $141/month.

#### Link to Query
[Amazon WorkSpaces - Auto Stop](../end_user_computing/#amazon-workspaces---auto-stop)

#### Helpful Links
Please refer to the AWS Solution, [Amazon WorkSpaces Cost Optimizer](https://aws.amazon.com/solutions/implementations/amazon-workspaces-cost-optimizer/).  This solution analyzes all of your Amazon WorkSpaces usage data and automatically converts the WorkSpace to the most cost-effective billing option (hourly or monthly), depending on your individual usage. This solution also helps you monitor your WorkSpace usage and optimize costs.  This automates the manual process of running the above query and adjusting your WorkSpaces configuration.  

{{< email_button category_text="Cost Optimization" service_text="Amazon WorkSpaces - Auto Stop" query_text="Amazon WorkSpaces - Auto Stop query 1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon EBS Volumes Upgrade gp2 to gp3

#### Cost Optimization Technique
This query will display cost and usage of Elastic Block Storage Volumes that are type gp3. These resources returned by this query could be considered for upgrade to gp3 as with up to 20% cost savings, gp3 volumes help you achieve more control over your provisioned IOPS, giving the ability to provision storage with your unique applications in mind. This query uses 0.088 gp3 pricing please check the pricing page to confirm you are using the correct pricing for your applicable region. 

#### Link to Query
[Amazon EBS Volumes Upgrade gp2 to gp3](../storage/#amazon-ebs-volumes-upgrade-gp2-to-gp3)

#### Helpful Links
* [gp2 to gp3 conversion blog discussion](https://aws.amazon.com/blogs/aws-cost-management/finding-savings-from-2020-reinvent-announcements/)
* [EBS Volume Modifications](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/requesting-ebs-volume-modifications.html)

{{< email_button category_text="Cost Optimization" service_text="Elastic Block Storage gp2 upgrade to up3" query_text="Elastic Block Storage gp2 upgrade to gp3 query 1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}

