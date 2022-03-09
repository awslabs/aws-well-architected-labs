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
- Compute
  * [Elastic Load Balancing - Idle ELB](#elastic-load-balancing---idle-elb)
  * [Elastic Compute Cloud - Unallocated Elastic IPs](#ec2-unallocated-elastic-ips)
- End User Computing 
  * [Amazon WorkSpaces - Auto Stop](#amazon-workspaces---auto-stop)  
- Networking & Content Delivery   
  * [NAT Gateway - Idle NATGW](#nat-gateway---idle-natgw)  
- Storage  
  * [EBS Volumes Modernize gp2 to gp3](#amazon-ebs-volumes-modernize-gp2-to-gp3)
  * [EBS Snapshot Trends](#amazon-ebs-snapshot-trends)
  * [S3 Bucket Trends and Optimizations](#amazon-s3-bucket-trends-and-optimizations)
  
### Elastic Load Balancing - Idle ELB

#### Cost Optimization Technique
This query will display cost and usage of Elastic Load Balancers which didn’t receive any traffic last month and ran for more than 336 hours (14 days). Resources returned by this query could be considered for deletion.  [AWS Trusted Advisor](https://aws.amazon.com/premiumsupport/technology/trusted-advisor/best-practice-checklist/) provides a check for idle load balancers but only covers Classic Load Balancers.  This query will provide all Elastic Load Balancer types including Application Load Balancer, Network Load Balancer, and Classic Load Balancer.

The assumption is that if the Load Balancer has not received any traffic within 14 days, it is likely orphaned and can be deleted.

#### Copy Query
{{%expand "Click here - to expand the query" %}}
Copy the query below or click to [Download SQL File](/Cost/300_CUR_Queries/Code/Cost_Optimization/elastic-load-balancing-idle-elbs.sql) 

```tsql
		SELECT
		  bill_payer_account_id,
		  line_item_usage_account_id,
		  SPLIT_PART(line_item_resource_id, ':', 6) split_line_item_resource_id,
		  product_region,
		  pricing_unit,
		  sum_line_item_usage_amount,
		  CAST(cost_per_resource AS DECIMAL(16, 8)) AS sum_line_item_unblended_cost
		FROM
		  (
			SELECT
			  line_item_resource_id,
			  product_region,
			  pricing_unit,
			  line_item_usage_account_id,
			  bill_payer_account_id,
			  SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
			  SUM(SUM(line_item_unblended_cost)) OVER (PARTITION BY line_item_resource_id) AS cost_per_resource,
			  SUM(SUM(line_item_usage_amount)) OVER (PARTITION BY line_item_resource_id, pricing_unit) AS usage_per_resource_and_pricing_unit,
			  COUNT(pricing_unit) OVER (PARTITION BY line_item_resource_id) AS pricing_unit_per_resource
			FROM
			  ${table_name}
			WHERE
			  line_item_product_code = 'AWSELB'
			  -- get previous month
			  AND month = CAST(month(current_timestamp + -1 * INTERVAL '1' MONTH) AS VARCHAR)
			  -- get year for previous month
			  AND year = CAST(year(current_timestamp + -1 * INTERVAL '1' MONTH) AS VARCHAR)
			  AND line_item_line_item_type = 'Usage'
			GROUP BY
			  line_item_resource_id,
			  product_region,
			  pricing_unit,
			  line_item_usage_account_id,
			  bill_payer_account_id
		  )
		WHERE
		  -- filter only resources which ran more than half month (336 hrs)
		  usage_per_resource_and_pricing_unit > 336
		  AND pricing_unit_per_resource = 1
		ORDER BY
		  cost_per_resource DESC;
```

{{% /expand%}}


#### Helpful Links
Please refer to the [ELB AWS CLI documentation](https://docs.aws.amazon.com/elasticloadbalancing/index.html) for deletion instructions.  The commands vary between the ELB types. 

* [Classic](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-getting-started.html#delete-load-balancer)
* [Application](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancer-getting-started.html#delete-load-balancer)
* [Network](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/network-load-balancer-cli.html#delete-aws-cli)

{{< email_button category_text="Cost Optimization" service_text="Elastic Load Balancing - Idle ELB" query_text="Elastic Load Balancing - Idle ELB query 1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon WorkSpaces - Auto Stop

#### Cost Optimization Technique
AutoStop Workspaces are cost effective when used for several hours per day. If AutoStop Workspaces run for more than 80 hrs per month it is more cost effective to switch to AlwaysOn mode. This query shows AutoStop Workspaces which ran more that 80 hrs in previous month. If the usage pattern for these Workspaces is the same month over month it's possible to optimize cost by switching to AlwaysOn mode. For example, Windows PowerPro (8 vCPU, 32GB RAM) bundle in eu-west-1 runs for 400 hrs per month. In AutoStop mode it costs $612/month ($8.00/month + 400 * $1.53/hour) while if used in AlwaysOn mode it would cost $141/month.

#### Copy Query
{{%expand "Click here - to expand the query" %}}
Copy the query below or click to [Download SQL File](/Cost/300_CUR_Queries/Code/Cost_Optimization/amazon-workspaces-auto-stop.sql) 

```tsql
			SELECT
			  bill_payer_account_id,
			  line_item_usage_account_id,
			  SPLIT_PART(line_item_resource_id, '/', 2) AS split_line_item_resource_id,
			  product_region,
			  product_operating_system,
			  product_bundle_description,
			  product_software_included,
			  product_license,
			  product_rootvolume,
			  product_uservolume,
			  pricing_unit,
			  sum_line_item_usage_amount,
			  CAST(total_cost_per_resource AS DECIMAL(16, 8)) AS "sum_line_item_unblended_cost(incl monthly fee)"
			FROM
			  (
				SELECT
				  bill_payer_account_id,
				  line_item_usage_account_id,
				  line_item_resource_id,
				  product_operating_system,
				  pricing_unit,
				  product_region,
				  product_bundle_description,
				  product_rootvolume,
				  product_uservolume,
				  product_software_included,
				  product_license,
				  SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
				  SUM(SUM(line_item_unblended_cost)) OVER (PARTITION BY line_item_resource_id) AS total_cost_per_resource,
				  SUM(SUM(line_item_usage_amount)) OVER (PARTITION BY line_item_resource_id, pricing_unit) AS usage_amount_per_resource_and_pricing_unit
				FROM
				  $ {table_name}
				WHERE
				  line_item_product_code = 'AmazonWorkSpaces' 
				  -- get previous month
				  AND CAST(month AS INT) = CAST(month(current_timestamp + -1 * INTERVAL '1' MONTH) AS INT) 
				  -- get year for previous month
				  AND CAST(year AS INT) = CAST(year(current_timestamp + -1 * INTERVAL '1' MONTH) AS INT)
				  AND line_item_line_item_type = 'Usage'
				  AND line_item_usage_type LIKE '%AutoStop%'
				GROUP BY
				  line_item_usage_account_id,
				  line_item_resource_id,
				  product_operating_system,
				  pricing_unit,
				  product_region,
				  product_bundle_description,
				  product_rootvolume,
				  product_uservolume,
				  bill_payer_account_id,
				  product_software_included,
				  product_license
			  )     
			WHERE
			  -- return only workspaces which ran more than 80 hrs
			  usage_amount_per_resource_and_pricing_unit > 80
			ORDER BY
			  total_cost_per_resource DESC,
			  line_item_resource_id,
			  line_item_usage_account_id,
			  product_operating_system,
			  pricing_unit;
```

{{% /expand%}}

#### Helpful Links
Please refer to the AWS Solution, [Amazon WorkSpaces Cost Optimizer](https://aws.amazon.com/solutions/implementations/amazon-workspaces-cost-optimizer/).  This solution analyzes all of your Amazon WorkSpaces usage data and automatically converts the WorkSpace to the most cost-effective billing option (hourly or monthly), depending on your individual usage. This solution also helps you monitor your WorkSpace usage and optimize costs.  This automates the manual process of running the above query and adjusting your WorkSpaces configuration.  

{{< email_button category_text="Cost Optimization" service_text="Amazon WorkSpaces - Auto Stop" query_text="Amazon WorkSpaces - Auto Stop query 1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


### NAT Gateway - Idle NATGW

#### Cost Optimization Technique
This query shows cost and usage of NAT Gateways which didn’t receive any traffic last month and ran for more than 336 hrs. Resources returned by this query could be considered for deletion.

Besides deleting idle NATGWs you should also consider the following tips:

* Determine What Types of Data Transfers Occur the Most - [Deploy the CUDOS dashboard to help visualize top talkers](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/#cudos-dashboard)
* Eliminate Costly Cross Availability Zone Transfer Charges - create new NAT Gateways in the same availability zone as your instances
* Consider Sending Amazon S3 and Dynamo Traffic Through Gateway VPC Endpoints Instead of NAT Gateways
* Consider Setting up Interface VPC Endpoints Instead of NAT Gateways for Other Intra-AWS Traffic

#### Copy Query
{{%expand "Click here - to expand the query" %}}
Copy the query below or click to [Download SQL File](/Cost/300_CUR_Queries/Code/Cost_Optimization/nat-gateway-idle.sql) 

```tsql
		SELECT 
		  bill_payer_account_id,
		  line_item_usage_account_id,
		  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
		  CASE
			WHEN line_item_resource_id LIKE 'arn%' THEN CONCAT(SPLIT_PART(line_item_resource_id,'/',2),' - ',product_location)
			ELSE CONCAT(line_item_resource_id,' - ',product_location)
		  END AS line_item_resource_id,
		  product_location,
		  product_attachment_type,
		  pricing_unit,
		  CASE
			WHEN pricing_unit = 'hour' THEN 'Hourly charges'
			WHEN pricing_unit = 'GigaBytes' THEN 'Data processing charges'
		  END AS pricing_unit,
		  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
		  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
		FROM 
		  ${table_name}
		WHERE
		  ${date_filter}
		  AND product_group = 'AWSTransitGateway' 
		  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
		GROUP BY
		  bill_payer_account_id, 
		  line_item_usage_account_id,
		  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
		  line_item_resource_id,
		  product_location,
		  product_attachment_type,
		  pricing_unit
		ORDER BY
		  sum_line_item_unblended_cost DESC,
		  month_line_item_usage_start_date,
		  sum_line_item_usage_amount,
		  product_attachment_type;
```

{{% /expand%}}


#### Helpful Links
[Data Transfer Costs Explained](https://github.com/open-guides/og-aws#aws-data-transfer-costs)

{{< email_button category_text="Cost Optimization" service_text="Elastic Load Balancing - Idle ELB" query_text="Elastic Load Balancing - Idle ELB query 1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


### Amazon EBS Volumes Modernize gp2 to gp3

#### Cost Optimization Technique
This query will display cost and usage of general purpose Elastic Block Storage Volumes and provide the estimated cost savings for modernizing a gp2 volume to gp3  These resources returned by this query could be considered for upgrade to gp3 as with up to 20% cost savings, gp3 volumes help you achieve more control over your provisioned IOPS, giving the ability to provision storage with your unique applications in mind. This query assumes you would provision the max iops and throughput based on the volume size, but not all resources will require the max amount and should be validated by the resource owner. 

{{% notice tip %}}
If you are running this for all accounts in a large organization we recommend running the query below first to confirm export size is not over ~1M rows. If the count shown in the query is greater than 1M you will want to filter to groupings of accounts or feed this query into a BI tool such as QuickSight 
{{% /notice %}}

{{%expand "Click here - to expand the query" %}}
```tsql
	select count (distinct line_item_resource_id) 
     FROM ${table_name}
     WHERE 
		line_item_product_code = 'AmazonEC2' 
		AND line_item_line_item_type = 'Usage' 
		AND bill_payer_account_id <> ''
		AND line_item_usage_account_id <> ''
		AND (CAST("concat"("year", '-', "month", '-01') AS date) = ("date_trunc"('month', current_date) - INTERVAL  '1' MONTH))
		AND line_item_usage_type LIKE '%gp%'
		AND line_item_usage_type LIKE '%EBS%'  
```
{{% /expand%}}

#### Copy Query
{{%expand "Click here - to expand the query" %}}

Copy the query below or click to [Download SQL File](/Cost/300_CUR_Queries/Code/Cost_Optimization/amazon-ebs-volumes-modernize-gp2-to-gp3.sql)

```tsql
		-- NOTE: If running this at a payer account level with millions of 
				-- NOTE: If running this at a payer account level with millions of volumes we recommend filtering to specific accounts in line 20. You can also remove line 21 to view all EC2 EBS volumes.   
		-- Step 1: Filter CUR to return all gp EC2 EBS storage usage  
		 WITH ebs_all AS (
		 SELECT
		 bill_billing_period_start_date
		 , line_item_usage_start_date
		 , bill_payer_account_id
		 , line_item_usage_account_id
		 , line_item_resource_id 
		 , product_volume_api_name
		 , line_item_usage_type
		 , pricing_unit
		 , line_item_unblended_cost
		 , line_item_usage_amount
		 FROM
		 ${table_name}
		 WHERE (line_item_product_code = 'AmazonEC2') AND (line_item_line_item_type = 'Usage') 
		 AND (CAST("concat"("year", '-', "month", '-01') AS date) = ("date_trunc"('month', current_date) - INTERVAL  '1' MONTH))
		 AND bill_payer_account_id <> ''
		 AND line_item_usage_account_id <> ''	  
		 AND line_item_usage_type LIKE '%gp%'		 
		 AND product_volume_api_name <> ''
		 AND line_item_usage_type NOT LIKE '%Snap%'
		 AND line_item_usage_type LIKE '%EBS%' 

		 ),
		 -- Step 2: Pivot table so storage types cost and usage into separate columns
		 ebs_spend AS (
		 SELECT DISTINCT
		 bill_billing_period_start_date AS billing_period
		 , date_trunc('month',line_item_usage_start_date) AS usage_date
		 , bill_payer_account_id AS payer_account_id
		 , line_item_usage_account_id AS linked_account_id
		 , line_item_resource_id AS resource_id
		 , product_volume_api_name AS volume_api_name
		 , SUM (CASE
			WHEN (((pricing_unit = 'GB-Mo' or pricing_unit = 'GB-month') or pricing_unit = 'GB-month') AND  line_item_usage_type LIKE '%EBS:VolumeUsage%')
			THEN  line_item_usage_amount ELSE 0 END) "usage_storage_gb_mo"
		 , SUM (CASE
		 WHEN (pricing_unit = 'IOPS-Mo' AND  line_item_usage_type LIKE '%IOPS%') THEN line_item_usage_amount 
		 ELSE 0 END) "usage_iops_mo"
		 , SUM (CASE WHEN (pricing_unit = 'GiBps-mo' AND  line_item_usage_type LIKE '%Throughput%') THEN  line_item_usage_amount ELSE 0 END) "usage_throughput_gibps_mo"
		 , SUM (CASE WHEN ((pricing_unit = 'GB-Mo' or pricing_unit = 'GB-month') AND  line_item_usage_type LIKE '%EBS:VolumeUsage%') THEN  (line_item_unblended_cost) ELSE 0 END) "cost_storage_gb_mo"
		 , SUM (CASE WHEN (pricing_unit = 'IOPS-Mo' AND  line_item_usage_type LIKE '%IOPS%') THEN  (line_item_unblended_cost) ELSE 0 END) "cost_iops_mo"
		 , SUM (CASE WHEN (pricing_unit = 'GiBps-mo' AND  line_item_usage_type LIKE '%Throughput%') THEN  (line_item_unblended_cost) ELSE 0 END) "cost_throughput_gibps_mo"
		 FROM
		 ebs_all
		 GROUP BY 1, 2, 3, 4, 5,6
		 ),
		 ebs_spend_with_unit_cost AS (
		 SELECT 
		 *
		 , cost_storage_gb_mo/usage_storage_gb_mo AS "current_unit_cost"
		 , CASE
		 WHEN usage_storage_gb_mo <= 150 THEN 'under 150GB-Mo'
		 WHEN usage_storage_gb_mo > 150 AND usage_storage_gb_mo <= 1000 THEN 'between 150-1000GB-Mo' 
		 ELSE 'over 1000GB-Mo' 
		 END AS storage_summary
		 , CASE
		 WHEN volume_api_name <> 'gp2' THEN 0
		 WHEN usage_storage_gb_mo*3 < 3000 THEN 3000 - 3000
		 WHEN usage_storage_gb_mo*3 > 16000 THEN 16000 - 3000
		 ELSE usage_storage_gb_mo*3 - 3000
		 END AS gp2_usage_added_iops_mo
		 , CASE
		 WHEN volume_api_name <> 'gp2' THEN 0
		 WHEN usage_storage_gb_mo <= 150 THEN 0 
		 ELSE 125
		 END AS gp2_usage_added_throughput_gibps_mo
		 , cost_storage_gb_mo + cost_iops_mo + cost_throughput_gibps_mo AS ebs_all_cost
		 , CASE
		 WHEN volume_api_name = 'sc1' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
		 ELSE 0
		 END "ebs_sc1_cost"	
		 , CASE
		 WHEN volume_api_name = 'st1' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
		 ELSE 0
		 END "ebs_st1_cost"	
		 , CASE
		 WHEN volume_api_name = 'standard' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
		 ELSE 0
		 END "ebs_standard_cost"				   
		 , CASE
		 WHEN volume_api_name = 'io1' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
		 ELSE 0
		 END "ebs_io1_cost"
		 , CASE
		 WHEN volume_api_name = 'io2' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
		 ELSE 0
		 END "ebs_io2_cost"			   
		 , CASE
		 WHEN volume_api_name = 'gp2' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
		 ELSE 0
		 END "ebs_gp2_cost"
		 , CASE
		 WHEN volume_api_name = 'gp3' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
		 ELSE 0
		 END "ebs_gp3_cost"
		 , CASE
		 WHEN volume_api_name = 'gp2' THEN cost_storage_gb_mo*0.8/usage_storage_gb_mo
		 ELSE 0
		 END AS "estimated_gp3_unit_cost"
		 FROM
		 ebs_spend
		 ),
		 ebs_before_map AS		
		 ( 
		 SELECT DISTINCT
		 billing_period
		 , payer_account_id
		 , linked_account_id
		 , resource_id
		 , volume_api_name
		 , storage_summary
		 , sum(usage_storage_gb_mo) AS usage_storage_gb_mo
		 , sum(usage_iops_mo) AS usage_iops_mo
		 , sum(usage_throughput_gibps_mo) AS usage_throughput_gibps_mo
		 , sum(gp2_usage_added_iops_mo) gp2_usage_added_iops_mo
		 , sum(gp2_usage_added_throughput_gibps_mo) AS gp2_usage_added_throughput_gibps_mo
		 , sum(ebs_all_cost) AS ebs_all_cost
		 , sum(ebs_sc1_cost) AS ebs_sc1_cost
		 , sum(ebs_st1_cost) AS ebs_st1_cost 
		 , sum(ebs_standard_cost) AS ebs_standard_cost
		 , sum(ebs_io1_cost) AS ebs_io1_cost
		 , sum(ebs_io2_cost) AS ebs_io2_cost
		 , sum(ebs_gp2_cost) AS ebs_gp2_cost
		 , sum(ebs_gp3_cost) AS ebs_gp3_cost
		 /* Calculate cost for gp2 gp3 estimate using the following
		 - Storage always 20% cheaper
		 - Additional iops per iops-mo is 6% of the cost of 1 gp3 GB-mo
		 - Additional throughput per gibps-mo is 50% of the cost of 1 gp3 GB-mo */
		 , sum(CASE 
		 /*ignore non gp2' */
		 WHEN volume_api_name = 'gp2' THEN ebs_gp2_cost
		 - (cost_storage_gb_mo*0.8 
			+ estimated_gp3_unit_cost * 0.5 * gp2_usage_added_throughput_gibps_mo
			+ estimated_gp3_unit_cost * 0.06 * gp2_usage_added_iops_mo)
		 ELSE 0
		 END) AS ebs_gp3_potential_savings
		 FROM 
		 ebs_spend_with_unit_cost 
		 GROUP BY 1, 2, 3, 4, 5, 6)
		 SELECT DISTINCT
		 billing_period
		 , payer_account_id
		 , linked_account_id
		 , resource_id
		 , volume_api_name
		 , usage_storage_gb_mo
		 , usage_iops_mo
		 , usage_throughput_gibps_mo
		 , storage_summary
		 , gp2_usage_added_iops_mo
		 , gp2_usage_added_throughput_gibps_mo
		 , ebs_all_cost
		 , ebs_sc1_cost
		 , ebs_st1_cost 
		 , ebs_standard_cost
		 , ebs_io1_cost
		 , ebs_io2_cost
		 , ebs_gp2_cost
		 , ebs_gp3_cost
		 , ebs_gp3_potential_savings
		 FROM 
		 ebs_before_map
```

{{% /expand%}}
#### Helpful Links
* [Migrate your Amazon EBS volumes from gp2 to gp3 and save up to 20% on costs](https://aws.amazon.com/blogs/storage/migrate-your-amazon-ebs-volumes-from-gp2-to-gp3-and-save-up-to-20-on-costs/)
* [gp2 to gp3 conversion blog discussion](https://aws.amazon.com/blogs/aws-cost-management/finding-savings-from-2020-reinvent-announcements/)
* [EBS Volume Modifications](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/requesting-ebs-volume-modifications.html)


{{< email_button category_text="Cost Optimization" service_text="Elastic Block Storage gp2 modernize to gp3" query_text="Elastic Block Storage gp2 modernize to gp3 query 1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon EBS Snapshot Trends

#### Cost Optimization Technique
This query looks across your EC2 EBS Snapshots to identify all snapshots that still exist today with their previous month spend. It then provides the start date which is the first billing period the snapshot appeared in your CUR and groups them so you can see if they are over 1yr old. Snapshots over 1yr old should be tagged to keep, cleaned up, or archived.  

#### Copy Query
Copy the query below or click to [Download SQL File](/Cost/300_CUR_Queries/Code/Cost_Optimization/amazon-ebs-snapshot-trends.sql)

{{%expand "Click here - to expand the query" %}}

```tsql		
		 -- Step 1: Filter CUR to return all ebs ec2 snapshot usage data
		 WITH snapshot_usage_all_time AS (
			SELECT
			  year
			, month
			, bill_billing_period_start_date billing_period
			, line_item_usage_start_date usage_start_date
			, bill_payer_account_id payer_account_id
			, line_item_usage_account_id linked_account_id
			, line_item_resource_id resource_id
			, (CASE WHEN (line_item_usage_type LIKE '%EBS:SnapshotArchive%') THEN 'Snapshot_Archive' WHEN (line_item_usage_type LIKE '%EBS:Snapshot%') THEN 'Snapshot' ELSE "line_item_operation" END) snapshot_type
			, line_item_usage_amount
			, line_item_unblended_cost
			, pricing_public_on_demand_cost
			FROM
			 ${table_name}
			WHERE (((((bill_payer_account_id <> '') AND (line_item_resource_id <> '')) AND (line_item_line_item_type LIKE '%Usage%')) AND (line_item_product_code = 'AmazonEC2')) AND (line_item_usage_type LIKE '%EBS:Snapshot%'))

		 ),	
		 -- Step 2: Return most recent billing_period and the first billing_period
		 request_dates AS (
			SELECT DISTINCT
			  resource_id request_dates_resource_id
			, "min"(usage_start_date) start_date
			FROM
			  snapshot_usage_all_time
			WHERE (snapshot_type = 'Snapshot')
			GROUP BY 1
		 ), snapshot_usage_all_time_before_map AS 	
		 (
		 -- Step 3: Pivot table so looking at previous month filtered for only snapshots still available in the current month
			SELECT DISTINCT
			  billing_period
			, request_dates.start_date
			, payer_account_id
			, linked_account_id
			, snapshot_type
			, resource_id
			, "sum"(line_item_usage_amount) usage_quantity
			, "sum"(line_item_unblended_cost) ebs_snapshot_cost
			, "sum"(pricing_public_on_demand_cost) public_cost
			, "sum"((CASE WHEN ((request_dates.start_date > (billing_period - INTERVAL  '12' MONTH)) AND (snapshot_type = 'Snapshot')) THEN line_item_unblended_cost ELSE 0 END)) "ebs_snapshots_under_1yr_cost"  /*No savings estimate since it uses uses 100% of snapshot cost for snapshots over 6mos as savings estimate*/ 
			, "sum"((CASE WHEN ((request_dates.start_date <= (billing_period - INTERVAL  '12' MONTH)) AND (snapshot_type = 'Snapshot')) THEN line_item_unblended_cost ELSE 0 END)) "ebs_snapshots_over_1yr_cost"
			FROM
			  (snapshot_usage_all_time snapshot
			LEFT JOIN request_dates ON (request_dates.request_dates_resource_id = snapshot.resource_id))
			WHERE (CAST("concat"(snapshot.year, '-', snapshot.month, '-01') AS date) = ("date_trunc"('month', current_date) - INTERVAL  '1' MONTH))
			GROUP BY 1, 2, 3, 4, 5, 6
		 )
		 (
		 -- Step 4: Add all data
			SELECT
			  billing_period
			, start_date
			, payer_account_id
			, linked_account_id
			, resource_id
			, snapshot_type
			, usage_quantity
			, ebs_snapshot_cost
			, public_cost
			, "ebs_snapshots_under_1yr_cost"
			, "ebs_snapshots_over_1yr_cost"
			FROM
			  (snapshot_usage_all_time_before_map)
		 ) 
```

{{% /expand%}}

#### Helpful Links
* [Amazon Data Lifecycle Manager](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/snapshot-lifecycle.html)


{{< email_button category_text="Cost Optimization" service_text="EC2 EBS Snapshot Trends" query_text="EC2 EBS Snapshot Trends" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon S3 Bucket Trends and Optimizations 

#### Cost Optimization Technique
This query breaks out the previous month's costs and usage of each S3 bucket by storage class and includes and separates out identifiers that can be used to identify trends or potential areas to look into for optimization across Lifecycle Policies or Intelligent Tiering. The query uses this information to provide a variety of checks for each S3 bucket including:

{{%expand "Click here - to see Bucket Trend Checks" %}}
- **S3_all_cost:** Provides a way to find your top spend buckets  
- **bucket_name_keywords:** Checks if buckets contain any of the keywords for use of storage classes beyond S3 Standard and returns the first keyword that matches. If no keywords match it will show 'other'
- **last_requests:** Looks back across all billing periods available in your CUR to identify the last usage date that there was any usage for 'PutObject', 'PutObjectForRepl', 'GetObject', and 'CopyObject'. If this field is blank it means there have been no requests across these operations since your CUR was created and the last requests is older than your CUR's first billing_period. 
- **s3_standard_underutilized_optimization:** Checks if your bucket is only using S3 standard storage and has had no active requests ('PutObject', 'PutObjectForRepl', 'GetObject', and 'CopyObject') in the last 6 months. If it meets this criteria it will show 'Potential Underutilized S3 Bucket - S3 Standard only with no active requests in the last 6mo' and this will be something your teams should validate for moving to another storage class or deleting completely. 
- **s3_replication_bucket_optimization:** Checks if a bucket has any usage across s3 transition, put object, get_object, and s3_copy. If it it doesn't it returns 'Potential Replication Bucket Optimization - Active Non-Replication Requests or Transitions''
- **s3_standard_only_bucket:** Checks if a bucket is only using S3 standard	
- **s3_archive_in_use:** Checks if a bucket is using any Archive storage (Glacier or Glacier Deep Archive)
- **s3_inventory_in_use:** Checks if the bucket is using S3 Inventory
- **s3_analytics_in_use:** Checks if the bucket is using S3 Analytics
- **s3_int_in_use:** Checks if the bucket is using Intelligent Tiering
- **s3_standard_storage_potential_savings:** Provides an estimated savings if you were to move your S3 Standard Storage to Infrequent Access. This query uses 30% as an assumption, but you can adjust to your preferred value. 
- **s3_glacier_instant_retrieval_potential_savings:** Provides an estimated savings or additional cost if you were to move your S3 Standard-IA Storage to Glacier Instant Retrieval. This query uses a 68% storage savings, a 2x additional Tier 1 cost, a 10x additional Tier 2 cost, and a 3x retrieval cost, but you can adjust to your preferred value. 
{{% /expand%}}


#### Copy Query
{{%expand "Click here - to expand the query" %}}

Copy the query below or click to [Download SQL File](/Cost/300_CUR_Queries/Code/Cost_Optimization/s3-bucket-trends-and-optimizations.sql)

```tsql
		-- Step 1: Enter S3 standard savings savings assumption. Default is set to 0.3 for 30% savings 
		WITH inputs AS (
			SELECT * FROM (VALUES (0.3,.68,2,10,3)) t(s3_standard_savings,sia_to_glacier_instant_retrieval_storage_savings,sia_to_glacier_instant_retrieval_tier1_increase,sia_to_glacier_instant_retrieval_tier2_increase,sia_to_glacier_instant_retrieval_retriveal_increase)),
			

		-- Step 2: Filter CUR to return all storage usage data and update ${table_name} with your CUR table table  
		s3_usage_all_time AS (
			SELECT
			  year
			, month
			, bill_billing_period_start_date AS billing_period
			, line_item_usage_start_date AS usage_start_date
			, bill_payer_account_id AS payer_account_id
			, line_item_usage_account_id AS linked_account_id
			, line_item_resource_id AS resource_id
			, s3_standard_savings
			, sia_to_glacier_instant_retrieval_storage_savings
			, sia_to_glacier_instant_retrieval_tier1_increase
			, sia_to_glacier_instant_retrieval_tier2_increase
			, sia_to_glacier_instant_retrieval_retriveal_increase
			, line_item_operation AS operation
			, line_item_usage_type AS usage_type
			, CASE 
				WHEN line_item_usage_type LIKE '%EarlyDelete%' THEN 'EarlyDelete' ELSE line_item_operation END "early_delete_adjusted_operation" 
			, CASE
				  WHEN line_item_product_code = 'AmazonGlacier' AND line_item_operation = 'Storage' THEN 'Amazon Glacier'
				 				  
				  WHEN line_item_product_code = 'AmazonS3' AND product_volume_type LIKE '%Intelligent%' AND line_item_operation LIKE '%IntelligentTiering%' THEN 'Intelligent-Tiering'			  
				  ELSE product_volume_type
			  END AS storage_class_type
			, pricing_unit  
			, sum(line_item_usage_amount) AS usage_quantity
			, sum(line_item_unblended_cost) unblended_cost
			, sum(CASE
				WHEN (pricing_unit = 'GB-Mo' AND line_item_operation like '%Storage%' AND product_volume_type LIKE '%Glacier Deep Archive%') THEN line_item_unblended_cost
				WHEN (pricing_unit = 'GB-Mo' AND line_item_operation like '%Storage%') THEN line_item_unblended_cost 
				ELSE 0
				END) AS s3_all_storage_cost
			, sum(CASE WHEN (pricing_unit = 'GB-Mo' AND line_item_operation like '%Storage%') THEN line_item_usage_amount ELSE 0 END) AS s3_all_storage_usage_quantity
			FROM 
			${table_name}
				, inputs
			WHERE bill_payer_account_id <> ''
			  AND line_item_resource_id <> ''
			  AND line_item_line_item_type LIKE '%Usage%'
			  AND (line_item_product_code LIKE '%AmazonGlacier%' OR line_item_product_code LIKE '%AmazonS3%')
			GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12,13,14,15,16,17
		),

		-- Step 3: Return most recent request date to understand if bucket is in active use
		most_recent_request AS (
			SELECT DISTINCT
			  resource_id
			, max(usage_start_date) AS last_request_date
			FROM s3_usage_all_time
			WHERE usage_quantity > 0
			  AND operation IN ('PutObject', 'PutObjectForRepl', 'GetObject', 'CopyObject') AND pricing_unit = 'Requests'
			GROUP BY 1
		),

		-- Step 4: Pivot table so storage classes into separate columns and filter for current month
		month_usage AS (

			SELECT DISTINCT
			  billing_period
			, date_trunc('month', usage_start_date) AS "usage_date"
			, payer_account_id
			, linked_account_id
			, s3.resource_id
			, most_recent_request.last_request_date AS "last_requests"
			,s3_standard_savings
			, sia_to_glacier_instant_retrieval_storage_savings
			, sia_to_glacier_instant_retrieval_tier1_increase
			, sia_to_glacier_instant_retrieval_tier2_increase
			, sia_to_glacier_instant_retrieval_retriveal_increase			
			, sum(unblended_cost) AS s3_all_cost
			-- All Storage
			, sum(s3_all_storage_cost) AS s3_all_storage_cost
			, sum(s3_all_storage_usage_quantity) AS "s3_all_storage_usage_quantity"
			-- S3 Standard
			, sum(CASE WHEN storage_class_type = 'Standard' THEN s3_all_storage_cost ELSE 0 END) AS "s3_standard_storage_cost"
			, sum(CASE WHEN storage_class_type = 'Standard' THEN s3_all_storage_usage_quantity ELSE 0 END) AS "s3_standard_storage_usage_quantity"
			-- S3 Standard Infrequent Access
			, sum(CASE WHEN storage_class_type = 'Standard - Infrequent Access' THEN s3_all_storage_cost ELSE 0 END) AS "s3_standard-ia_storage_cost"
			, sum(CASE WHEN storage_class_type = 'Standard - Infrequent Access' THEN s3_all_storage_usage_quantity ELSE 0 END) AS "s3_standard-ia_storage_usage_quantity"
			, sum(CASE WHEN usage_type LIKE '%Requests-SIA-Tier1%' THEN unblended_cost ELSE 0 END) AS "s3_standard-ia_tier1_cost"
			, sum(CASE WHEN usage_type LIKE '%Requests-SIA-Tier2%' THEN unblended_cost ELSE 0 END) AS "s3_standard-ia_tier2_cost"	
			, sum(CASE WHEN usage_type LIKE '%Retrieval-SIA%' THEN unblended_cost ELSE 0 END) AS "s3_standard-ia_retrieval_cost"				
		   -- S3 One Zone Infrequent Access
			, sum(CASE WHEN storage_class_type = 'One Zone - Infrequent Access' THEN s3_all_storage_cost ELSE 0 END) AS "s3_onezone-ia_storage_cost"
			, sum(CASE WHEN storage_class_type = 'One Zone - Infrequent Access' THEN s3_all_storage_usage_quantity ELSE 0 END) AS "s3_onezone-ia_storage_usage_quantity"
		   -- S3 Reduced Redundancy
			, sum(CASE WHEN storage_class_type = 'Reduced Redundancy' THEN s3_all_storage_cost ELSE 0 END) AS "s3_reduced_redundancy_storage_cost"
			, sum(CASE WHEN storage_class_type = 'Reduced Redundancy' THEN s3_all_storage_usage_quantity ELSE 0 END) AS "s3_reduced_redundancy_storage_usage_quantity"
		   -- S3 Intelligent-Tiering
			, sum(CASE WHEN storage_class_type LIKE '%Intelligent%' THEN s3_all_storage_cost ELSE 0 END) AS "s3_intelligent-tiering_storage_cost"
			, sum(CASE WHEN storage_class_type LIKE '%Intelligent%' THEN s3_all_storage_usage_quantity ELSE 0 END) AS "s3_intelligent-tiering_storage_usage_quantity"
		   -- S3 Glacier Instant Retrieval   
			, sum(CASE WHEN storage_class_type LIKE '%Instant%' AND storage_class_type NOT LIKE '%Intelligent%' THEN s3_all_storage_cost ELSE 0 END) AS "s3_glacier_instant_retrieval_storage_cost"
			, sum(CASE WHEN storage_class_type LIKE '%Instant%' AND storage_class_type NOT LIKE '%Intelligent%' THEN  s3_all_storage_usage_quantity ELSE 0 END) AS "s3_glacier_instant_retrieval_storage_usage_quantity"	
			, sum(CASE WHEN usage_type LIKE '%Requests-GIR-Tier1%' THEN unblended_cost ELSE 0 END) AS "s3_glacier_instant_retrieval_tier1_cost"
			, sum(CASE WHEN usage_type LIKE '%Requests-GIR-Tier2%' THEN unblended_cost ELSE 0 END) AS "s3_glacier_instant_retrieval_tier2_cost"
			, sum(CASE WHEN usage_type LIKE '%Retrieval-SIA-GIR%' THEN unblended_cost ELSE 0 END) AS "s3_glacier_instant_retrieval_retrieval_cost"			
		   -- S3 Glacier Flexible Retrieval
			, sum(CASE WHEN storage_class_type = 'Amazon Glacier' THEN s3_all_storage_cost ELSE 0 END) AS "s3_glacier_flexible_retrieval_storage_cost"
			, sum(CASE WHEN storage_class_type = 'Amazon Glacier' THEN s3_all_storage_usage_quantity ELSE 0 END) AS "s3_glacier_flexible_retrieval_storage_usage_quantity"
		   -- Glacier Deep Archive
			, sum(CASE WHEN storage_class_type = 'Glacier Deep Archive' THEN s3_all_storage_cost ELSE 0 END) AS "s3_glacier_deep_archive_storage_storage_cost"
			, sum(CASE WHEN storage_class_type = 'Glacier Deep Archive' THEN s3_all_storage_usage_quantity ELSE 0 END) AS "s3_glacier_deep_archive_storage_usage_quantity"	
		   -- Operations
			, sum(CASE WHEN operation = 'PutObject' AND pricing_unit = 'Requests' THEN usage_quantity ELSE 0 END) AS "s3_put_object_usage_quantity"
			, sum(CASE WHEN operation = 'PutObjectForRepl' AND pricing_unit = 'Requests' THEN usage_quantity ELSE 0 END) AS "s3_put_object_replication_usage_quantity"
			, sum(CASE WHEN operation = 'GetObject' AND pricing_unit = 'Requests' THEN usage_quantity ELSE 0 END) AS "s3_get_object_usage_quantity"
			, sum(CASE WHEN operation = 'CopyObject' AND pricing_unit = 'Requests' THEN usage_quantity ELSE 0 END) AS "s3_copy_object_usage_quantity"
			, sum(CASE WHEN operation = 'Inventory' THEN usage_quantity ELSE 0 END) AS "s3_inventory_usage_quantity"
			, sum(CASE WHEN operation = 'S3.STORAGE_CLASS_ANALYSIS.OBJECT' THEN usage_quantity ELSE 0 END) AS "s3_analytics_usage_quantity"
			,sum(CASE WHEN operation like '%Transition%' THEN usage_quantity ELSE 0 END) AS "s3_transition_usage_quantity"
			,sum(CASE WHEN early_delete_adjusted_operation = 'EarlyDelete' THEN unblended_cost
			ELSE 0 END) AS "s3_early_delete_cost"	
			FROM s3_usage_all_time s3
			LEFT JOIN most_recent_request ON most_recent_request.resource_id = s3.resource_id
			WHERE CAST(concat(s3.year, '-', s3.month, '-01') AS date) = (date_trunc('month', current_date) - INTERVAL '1' MONTH)
			GROUP BY 1, 2, 3, 4, 5, 6,7,8,9,10,11
		)


		-- Step 6: Apply KPI logic - Add or Adjust bucket name keywords based on your requirements 
		SELECT DISTINCT
		  billing_period
		, usage_date
		, payer_account_id
		, linked_account_id
		, resource_id
		, CASE 
			WHEN resource_id LIKE '%backup%' THEN 'backup'
			WHEN resource_id LIKE '%archive%' THEN 'archive'
			WHEN resource_id LIKE '%historical%' THEN 'historical'	
			WHEN resource_id LIKE '%log%' THEN 'log' 
			WHEN resource_id LIKE '%compliance%' THEN 'compliance'
			ELSE 'Other'
		  END AS bucket_name_keywords
		, last_requests
		, CASE
			WHEN last_requests >= (usage_date - INTERVAL  '2' MONTH) THEN 'No Action'
			WHEN s3_all_storage_cost = s3_standard_storage_cost THEN 'Potential Action'
			ELSE 'No Action'
		  END AS s3_standard_underutilized_optimization
		, CASE
			WHEN ((s3_transition_usage_quantity)> 0  AND (last_requests >= (usage_date - INTERVAL  '1' MONTH)))  THEN 'No Action'
			WHEN s3_put_object_replication_usage_quantity > 0 THEN 'Potential Action'
			ELSE 'No Action' 
		  END AS s3_replication_bucket_optimization  
		, CASE
			WHEN s3_all_storage_cost = s3_standard_storage_cost THEN 'Yes'
			ELSE 'No' 
		  END AS s3_standard_only_bucket
		, CASE
			WHEN s3_glacier_deep_archive_storage_storage_cost > 0 THEN 'in use'
			WHEN s3_glacier_flexible_retrieval_storage_cost > 0 THEN 'in use'
			WHEN s3_glacier_instant_retrieval_storage_cost > 0 THEN 'in use'
			ELSE 'not in use' 
		  END AS s3_archive_in_use 
		, CASE WHEN s3_inventory_usage_quantity > 0 THEN 'in use' ELSE 'not in use' END AS s3_inventory_in_use
		, CASE WHEN s3_analytics_usage_quantity > 0 THEN 'in use' ELSE 'not in use' END AS s3_analytics_in_use
		, CASE WHEN "s3_intelligent-tiering_storage_usage_quantity" > 0 THEN 'in use' ELSE 'not in use' END AS s3_int_in_use
		, s3_standard_storage_cost * s3_standard_savings AS s3_standard_storage_potential_savings 
		, ("s3_standard-ia_retrieval_cost" + "s3_standard-ia_tier1_cost" + "s3_standard-ia_tier2_cost" + "s3_standard-ia_storage_cost")
		-((sia_to_glacier_instant_retrieval_storage_savings * "s3_standard-ia_storage_cost")+(sia_to_glacier_instant_retrieval_tier1_increase * "s3_standard-ia_tier1_cost")+
		(sia_to_glacier_instant_retrieval_tier2_increase * "s3_standard-ia_tier2_cost")+
		(sia_to_glacier_instant_retrieval_retriveal_increase * "s3_standard-ia_retrieval_cost")) AS "s3_glacier_instant_retrieval_potential_savings" 
		, s3_all_cost
		, (s3_all_cost/s3_all_storage_usage_quantity) AS "s3_all_unit_cost"			
		, s3_all_storage_cost
		, s3_all_storage_usage_quantity
		, (s3_all_storage_cost/s3_all_storage_usage_quantity) AS "s3_all_storage_unit_cost"		
		, s3_standard_storage_cost
		, s3_standard_storage_usage_quantity
		, (s3_standard_storage_cost/s3_standard_storage_usage_quantity) AS "s3_standard_storage_unit_cost"		
		, "s3_intelligent-tiering_storage_cost"
		, "s3_intelligent-tiering_storage_usage_quantity"	
		, ("s3_intelligent-tiering_storage_cost"/"s3_intelligent-tiering_storage_usage_quantity") AS "s3_intelligent-tiering_storage_unit_cost"		
		, "s3_standard-ia_storage_cost"
		, "s3_standard-ia_storage_usage_quantity"
		, ("s3_standard-ia_storage_cost"/"s3_standard-ia_storage_usage_quantity") AS "s3_standard-ia_storage_unit_cost"
		, "s3_onezone-ia_storage_cost"
		, "s3_onezone-ia_storage_usage_quantity"
		, ("s3_onezone-ia_storage_cost"/"s3_onezone-ia_storage_usage_quantity") AS "s3_onezone-ia_storage_unit_cost"
		, s3_reduced_redundancy_storage_cost
		, s3_reduced_redundancy_storage_usage_quantity
		, (s3_reduced_redundancy_storage_cost/s3_reduced_redundancy_storage_usage_quantity) AS "s3_reduced_redundancy_storage_unit_cost"
		, s3_glacier_instant_retrieval_storage_cost
		, s3_glacier_instant_retrieval_storage_usage_quantity
		, (s3_glacier_instant_retrieval_storage_cost/s3_glacier_instant_retrieval_storage_usage_quantity) AS "s3_glacier_instant_retrieval_storage_unit_cost"
		, s3_glacier_flexible_retrieval_storage_cost
		, s3_glacier_flexible_retrieval_storage_usage_quantity
		, (s3_glacier_flexible_retrieval_storage_cost/s3_glacier_flexible_retrieval_storage_usage_quantity) AS "s3_glacier_flexible_retrieval_storage_unit_cost"	
		, s3_glacier_deep_archive_storage_storage_cost
		, s3_glacier_deep_archive_storage_usage_quantity	
		, (s3_glacier_deep_archive_storage_storage_cost/s3_glacier_deep_archive_storage_usage_quantity)	 AS "s3_glacier_deep_archive_storage_unit_cost"			
		, s3_early_delete_cost  
		, s3_transition_usage_quantity
		, s3_put_object_usage_quantity
		, s3_put_object_replication_usage_quantity
		, s3_get_object_usage_quantity
		, s3_copy_object_usage_quantity
		, "s3_standard-ia_tier1_cost"
		, "s3_standard-ia_tier2_cost"
		, "s3_standard-ia_retrieval_cost"		
		, s3_glacier_instant_retrieval_tier1_cost
		, s3_glacier_instant_retrieval_tier2_cost
		, s3_glacier_instant_retrieval_retrieval_cost		
		FROM month_usage
```

{{% /expand%}}


#### Helpful Links
* [5 Ways to reduce data storage costs using Amazon S3 Storage Lens](https://aws.amazon.com/blogs/storage/5-ways-to-reduce-costs-using-amazon-s3-storage-lens/)
* [Amazon S3 cost optimization for predictable and dynamic access patterns](https://aws.amazon.com/blogs/storage/amazon-s3-cost-optimization-for-predictable-and-dynamic-access-patterns/)
* [Simplify your data lifecycle by using object tags with Amazon S3 Lifecycle](https://aws.amazon.com/blogs/storage/simplify-your-data-lifecycle-by-using-object-tags-with-amazon-s3-lifecycle/)


{{< email_button category_text="Cost Optimization" service_text="Amazon S3 Bucket Trends" query_text="Amazon S3 Bucket Trends" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### EC2 Unallocated Elastic IPs

#### Cost Optimization Technique
This query will return cost for unallocated Elastic IPs. Elastic IPs incur hourly charges when they are not allocated to a Network Load Balancer, NAT gateway or an EC2 instance (or when there are multiple Elastic IPs allocated to the same EC2 instance). The usage amount (in hours) and cost are summed and returned in descending order, along with the associated Account ID and Region.

#### Pricing
Please refer to the [EC2 Elastic IP pricing page](https://aws.amazon.com/ec2/pricing/on-demand/#Elastic_IP_Addresses).

#### Sample Output
![Images/ec2-unallocated-elastic-ips.png](/Cost/300_CUR_Queries/Images/Cost_Optimization/ec2-unallocated-elastic-ips.png)

#### Download SQL File
Copy the query below or click to [Download SQL File](/Cost/300_CUR_Queries/Code/Cost_Optimization/ec2-unallocated-elastic-ips.sql)

```tsql
		SELECT
		line_item_usage_account_id,
		line_item_usage_type,
		product_location,
		line_item_line_item_description,
		SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
		SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost
		FROM
		${table_name}
		WHERE
		${date_filter}
		AND line_item_product_code = 'AmazonEC2'
		AND line_item_usage_type LIKE '%ElasticIP:IdleAddress'
		GROUP BY
		line_item_usage_account_id,
		line_item_usage_type,
		product_location,
		line_item_line_item_description
		ORDER BY
		sum_line_item_unblended_cost DESC,
		sum_line_item_usage_amount DESC;
```

#### Helpful Links
* [Elastic IP Charges](https://aws.amazon.com/premiumsupport/knowledge-center/elastic-ip-charges/)


{{< email_button category_text="Cost Optimization" service_text="EC2 Unallocated Elastic IPs" query_text="EC2 Unallocated Elastic IPs" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}

