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
  * [Elastic Compute Cloud - Instance Cost by Pricing Model](#ec2-instance-cost-by-pricing-model)
  * [Graviton Usage](#graviton-usage)
  * [Lambda Graviton Cost Savings](#lambda-graviton-savings)
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
  SPLIT_PART(line_item_resource_id, ':', 6) AS split_line_item_resource_id,
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

### EC2 Unallocated Elastic IPs

#### Cost Optimization Technique
This query will return cost for unallocated Elastic IPs. Elastic IPs incur hourly charges when they are not allocated to a Network Load Balancer, NAT gateway or an EC2 instance (or when there are multiple Elastic IPs allocated to the same EC2 instance). The usage amount (in hours) and cost are summed and returned in descending order, along with the associated Account ID and Region.

#### Pricing
Please refer to the [EC2 Elastic IP pricing page](https://aws.amazon.com/ec2/pricing/on-demand/#Elastic_IP_Addresses).

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

### Graviton Usage

#### Cost Optimization Technique
AWS Graviton processors are designed by AWS to deliver the best price performance ratio for cloud workloads, delivering up to 40% improvement over comparable current gen x86 processors. Due to the improved price performance, many organizations track Graviton usage as a KPI to drive cost savings for their cloud workloads. Graviton-based EC2 instances are available, and many other AWS services such as Amazon Relational Database Service, Amazon ElastiCache, Amazon EMR, and Amazon OpenSearch also support Graviton-based instance types. 

This query provides detail on Graviton-based usage. Amortized cost, usage hours, and a count of unique resources are summed. Output is grouped by day, payer account ID, linked account ID, service, instance type, and region. Output is sorted by day (descending) and amortized cost (descending).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Cost_Optimization/gravitonusage.sql) 

#### Copy Query
```tsql
SELECT 
  DATE_TRUNC('day',line_item_usage_start_date) AS day_line_item_usage_start_date,
  bill_payer_account_id,
  line_item_usage_account_id,
  line_item_product_code,
  product_instance_type,
  product_region,
  SUM(CASE
    WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN savings_plan_savings_plan_effective_cost
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
    WHEN line_item_line_item_type = 'Usage' THEN line_item_unblended_cost
    ELSE 0 
  END) AS sum_amortized_cost, 
  SUM(line_item_usage_amount) as sum_line_item_usage_amount, 
  COUNT(DISTINCT(line_item_resource_id)) AS count_line_item_resource_id
FROM 
  ${table_name}
WHERE 
  ${date_filter}
  AND REGEXP_LIKE(line_item_usage_type, '.?[a-z]([1-9]|[1-9][0-9]).?.?[g][a-zA-Z]?\.')
  AND line_item_usage_type NOT LIKE '%EBSOptimized%' 
  AND (line_item_line_item_type = 'Usage'
    OR line_item_line_item_type = 'SavingsPlanCoveredUsage'
    OR line_item_line_item_type = 'DiscountedUsage'
  )
GROUP BY
  DATE_TRUNC('day',line_item_usage_start_date),
  bill_payer_account_id,
  line_item_usage_account_id,
  line_item_product_code,
  line_item_usage_type,
  product_instance_type,
  product_region
ORDER BY 
  day_line_item_usage_start_date DESC,
  sum_amortized_cost DESC;
```

{{< email_button category_text="Cost Optimization" service_text="Graviton Usage" query_text="Graviton Usage" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Lambda Graviton Savings

#### Cost Optimization Technique
This query will output all Lambda queries and their processor architecture.  Lambda functions which are running on X86 may be 
cost optimized by moving to ARM64 architecture.  On average functions using the Arm/Graviton2 architecture, duration charges are 20 percent lower than the current pricing for x86.  Thus the query calculates a 20% savings on each X86 Lambda.


#### Copy Query
Copy the query below or click to [Download SQL File](/Cost/300_CUR_Queries/Code/Cost_Optimization/lambda-graviton-savings.sql) 

```tsql
WITH x86_v_arm_spend AS (
SELECT
   line_item_resource_id      AS line_item_resource_id,
   bill_payer_account_id      AS bill_payer_account_id,
   line_item_usage_account_id AS line_item_usage_account_id,
   line_item_line_item_type AS line_item_line_item_type,
   CASE SUBSTR(line_item_usage_type, length(line_item_usage_type)-2)
      WHEN 'ARM' THEN 'arm64'
      ELSE 'x86_64'
   END AS "processor",
   CASE SUBSTR(line_item_usage_type, length(line_item_usage_type)-2)
      WHEN 'ARM' THEN 0
      ELSE line_item_unblended_cost * .2
   END AS "potential_arm_savings",
   SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost
FROM 
${table_name}
WHERE 
   line_item_product_code  = 'AWSLambda'
   AND line_item_operation = 'Invoke'
   AND ( 
      line_item_usage_type    LIKE '%Request%'
      OR line_item_usage_type LIKE '%Lambda-GB-Second%'
   )
   AND line_item_usage_start_date > CURRENT_DATE - INTERVAL '1' MONTH
   AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY 1,2,3,5,6,4
)
SELECT 
line_item_resource_id,
bill_payer_account_id,
line_item_usage_account_id,
line_item_line_item_type,
processor,
sum(sum_line_item_unblended_cost)           AS sum_line_item_unblended_cost,
sum(potential_arm_savings) AS "potential_arm_savings"
FROM 
x86_v_arm_spend
GROUP BY 2,3,1,5,4
```

#### Helpful Links
* [Lambda Functions Powered By AWS Graviton2](https://aws.amazon.com/blogs/aws/aws-lambda-functions-powered-by-aws-graviton2-processor-run-your-functions-on-arm-and-get-up-to-34-better-price-performance/)


{{< email_button category_text="Cost Optimization" service_text="Lambda Graviton2 Savings" query_text="Lambda Graviton2 Savings" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### EC2 Instance Cost by Pricing Model
The latest generation of instances are more performant and cheaper to operate.  Identifying which accounts are using [pervious generation](https://aws.amazon.com/ec2/previous-generation/) instances and determining if those instances are running on-demand or covered by a commitment based pricing model (On-Demand, Reserved Instance or Savings Plan) is challenging.   This query may be used to group instance usage by account in a given time period and filter by pricing model.  It will help customers find old generation instances running on-demand which may be candidates for an upgrade.

#### Copy Query
{{%expand "Click here - to expand the query" %}}
Copy the query below or click to [Download SQL File](/Cost/300_CUR_Queries/Code/Cost_Optimization/ec2-instance-cost-by-pricing-term.sql) 

```tsql
SELECT
  line_item_usage_account_id, 
  CASE 
    WHEN reservation_reservation_a_r_n <> '' THEN split_part(reservation_reservation_a_r_n,':',5)
    WHEN savings_plan_savings_plan_a_r_n <> '' THEN split_part(savings_plan_savings_plan_a_r_n,':',5)
    ELSE 'NA'
  END AS ri_sp_owner_id,
	(CASE 
		WHEN (line_item_usage_type LIKE '%SpotUsage%') THEN 'Spot' 
		WHEN 
			(((product_usagetype LIKE '%BoxUsage%') 
			OR (product_usagetype LIKE '%DedicatedUsage:%')) 
			AND ("line_item_line_item_type" LIKE 'SavingsPlanCoveredUsage')) 
			OR (line_item_line_item_type = 'SavingsPlanNegation') 
		THEN 'SavingsPlan' 
		WHEN 
			(("product_usagetype" LIKE '%BoxUsage%') 
			AND ("line_item_line_item_type" LIKE 'DiscountedUsage')) 
		THEN 'ReservedInstance' 
		WHEN 
			((("product_usagetype" LIKE '%BoxUsage%') 
			OR ("product_usagetype" LIKE '%DedicatedUsage:%')) 
			AND ("line_item_line_item_type" LIKE 'Usage')) 
		THEN 'OnDemand' 
		ELSE 'Other' END) pricing_model, 
	CASE 
		WHEN 
			line_item_usage_type like '%BoxUsage' 
			OR line_item_usage_type LIKE '%DedicatedUsage' 
		THEN product_instance_type 
		ELSE SPLIT_PART (line_item_usage_type, ':', 2) END instance_type, 
	ROUND(SUM (line_item_unblended_cost),2) sum_line_item_unblended_cost, 
	ROUND (
		SUM((
			CASE 
				WHEN line_item_usage_type LIKE '%SpotUsage%' 
				THEN line_item_unblended_cost  
				WHEN 
					((product_usagetype LIKE '%BoxUsage%') 
					OR (product_usagetype LIKE '%DedicatedUsage:%')) 
					AND (line_item_line_item_type LIKE 'Usage') 
				THEN line_item_unblended_cost 
				WHEN 
					((line_item_line_item_type LIKE 'SavingsPlanCoveredUsage')) 
				THEN TRY_CAST(savings_plan_savings_plan_effective_cost AS double) 
				WHEN ((line_item_line_item_type LIKE 'DiscountedUsage')) 
				THEN reservation_effective_cost
				WHEN (line_item_line_item_type = 'SavingsPlanNegation') 
				THEN 0
				ELSE line_item_unblended_cost END)), 2) amortized_cost  
FROM 
	${table_name}    
WHERE
	${date_filter}
	AND line_item_operation LIKE '%RunInstance%' AND line_item_product_code = 'AmazonEC2' 
	AND (product_instance_type <> '' OR (line_item_usage_type  LIKE '%SpotUsage%' AND line_item_line_item_type = 'Usage'))  
GROUP BY 
1, -- account id
3, -- pricing model
4, -- instance type
2  -- ri_sp_owner_id
ORDER BY
pricing_model,
sum_line_item_unblended_cost DESC
;
```
{{% /expand%}}

#### Helpful Links
* [AWS Previous Generation Instances](https://aws.amazon.com/ec2/previous-generation/)

{{< email_button category_text="Cost Optimization" service_text="EC2 Instance Cost By Pricing Term" query_text="EC2 Instance Cost By Pricing Term" button_text="Help & Feedback" >}}


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
	  ${table_name}
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
Copy the query below or click to [Download SQL File](/Cost/300_CUR_Queries/Code/Cost_Optimization/natgateway_idle_wrid.sql) 

```tsql
SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  SPLIT_PART(line_item_resource_id, ':', 6) AS split_line_item_resource_id,
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
      line_item_product_code = 'AmazonEC2'
      AND line_item_usage_type LIKE '%Nat%'
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
[Data Transfer Costs Explained](https://github.com/open-guides/og-aws#aws-data-transfer-costs)

{{< email_button category_text="Cost Optimization" service_text="NAT Gateway - Idle NATGW" query_text="NAT Gateway - Idle NATGW" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


### Amazon EBS Volumes Modernize gp2 to gp3

#### Cost Optimization Technique
This query will display cost and usage of general purpose Elastic Block Storage Volumes and provide the estimated cost savings for modernizing a gp2 volume to gp3  These resources returned by this query could be considered for upgrade to gp3 as with up to 20% cost savings, gp3 volumes help you achieve more control over your provisioned IOPS, giving the ability to provision storage with your unique applications in mind. This query assumes you would provision the max iops and throughput based on the volume size, but not all resources will require the max amount and should be validated by the resource owner. 

{{% notice tip %}}
If you are running this for all accounts in a large organization we recommend running the query below first to confirm export size is not over ~1M rows. If the count shown in the query is greater than 1M you will want to filter to groupings of accounts or feed this query into a BI tool such as QuickSight 
{{% /notice %}}

{{%expand "Click here - to expand the query" %}}
```tsql
SELECT 
  COUNT(DISTINCT(line_item_resource_id))
FROM 
  ${table_name}
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
-- NOTE: If running this at a payer account level with millions of volumes we recommend filtering to specific accounts in line 20. You can also remove line 21 to view all EC2 EBS volumes.   
-- Step 1: Filter CUR to return all gp EC2 EBS storage usage  
WITH ebs_all AS (
  SELECT
    bill_billing_period_start_date,
	line_item_usage_start_date,
	bill_payer_account_id,
	line_item_usage_account_id,
	line_item_resource_id ,
	product_volume_api_name,
	line_item_usage_type,
	pricing_unit,
	line_item_unblended_cost,
	line_item_usage_amount
  FROM
	${table_name}
  WHERE 
    (line_item_product_code = 'AmazonEC2') 
	AND (line_item_line_item_type = 'Usage') 
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
    bill_billing_period_start_date AS billing_period,
	date_trunc('month',line_item_usage_start_date) AS usage_date,
	bill_payer_account_id AS payer_account_id,
	line_item_usage_account_id AS linked_account_id,
	line_item_resource_id AS resource_id,
	product_volume_api_name AS volume_api_name,
	SUM(CASE
	  WHEN (((pricing_unit = 'GB-Mo' or pricing_unit = 'GB-month') or pricing_unit = 'GB-month') AND  line_item_usage_type LIKE '%EBS:VolumeUsage%') THEN line_item_usage_amount ELSE 0 
	END) AS usage_storage_gb_mo,
	SUM(CASE
	  WHEN (pricing_unit = 'IOPS-Mo' AND line_item_usage_type LIKE '%IOPS%') THEN line_item_usage_amount 
	  ELSE 0 
	END) AS usage_iops_mo,
	SUM(CASE 
	  WHEN (pricing_unit = 'GiBps-mo' AND line_item_usage_type LIKE '%Throughput%') THEN  line_item_usage_amount 
	  ELSE 0 
	END) AS usage_throughput_gibps_mo,
	SUM(CASE 
	  WHEN ((pricing_unit = 'GB-Mo' or pricing_unit = 'GB-month') AND line_item_usage_type LIKE '%EBS:VolumeUsage%') THEN (line_item_unblended_cost) 
	  ELSE 0 
	END) AS cost_storage_gb_mo,
	SUM(CASE 
	  WHEN (pricing_unit = 'IOPS-Mo' AND  line_item_usage_type LIKE '%IOPS%') THEN  (line_item_unblended_cost) 
	  ELSE 0 
	END) AS cost_iops_mo,
	SUM(CASE 
	  WHEN (pricing_unit = 'GiBps-mo' AND  line_item_usage_type LIKE '%Throughput%') THEN  (line_item_unblended_cost) 
	  ELSE 0 
	END) AS cost_throughput_gibps_mo
	FROM
	  ebs_all
	GROUP BY 
	  1, 2, 3, 4, 5,6
),
ebs_spend_with_unit_cost AS (
  SELECT 
    *,
	cost_storage_gb_mo/usage_storage_gb_mo AS current_unit_cost,
	CASE
	  WHEN usage_storage_gb_mo <= 150 THEN 'under 150GB-Mo'
	  WHEN usage_storage_gb_mo > 150 AND usage_storage_gb_mo <= 1000 THEN 'between 150-1000GB-Mo' 
	  ELSE 'over 1000GB-Mo' 
	END AS storage_summary,
	CASE
	  WHEN volume_api_name <> 'gp2' THEN 0
	  WHEN usage_storage_gb_mo*3 < 3000 THEN 3000 - 3000
	  WHEN usage_storage_gb_mo*3 > 16000 THEN 16000 - 3000
	  ELSE usage_storage_gb_mo*3 - 3000
	END AS gp2_usage_added_iops_mo,
	CASE
	  WHEN volume_api_name <> 'gp2' THEN 0
	  WHEN usage_storage_gb_mo <= 150 THEN 0 
	  ELSE 125
	END AS gp2_usage_added_throughput_gibps_mo,
	cost_storage_gb_mo + cost_iops_mo + cost_throughput_gibps_mo AS ebs_all_cost,
	CASE
	  WHEN volume_api_name = 'sc1' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
	  ELSE 0
	END AS ebs_sc1_cost,
	CASE
	  WHEN volume_api_name = 'st1' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
	  ELSE 0
	END AS ebs_st1_cost,
	CASE
	  WHEN volume_api_name = 'standard' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
	  ELSE 0
	END AS ebs_standard_cost,
	CASE
	  WHEN volume_api_name = 'io1' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
	  ELSE 0
	END AS ebs_io1_cost,
	CASE
	  WHEN volume_api_name = 'io2' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
	  ELSE 0
	END AS ebs_io2_cost,
	CASE
	  WHEN volume_api_name = 'gp2' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
	  ELSE 0
	END AS ebs_gp2_cost,
	CASE
	  WHEN volume_api_name = 'gp3' THEN  (cost_iops_mo + cost_throughput_gibps_mo + cost_storage_gb_mo)
	  ELSE 0
	END AS ebs_gp3_cost,
	CASE
	  WHEN volume_api_name = 'gp2' THEN cost_storage_gb_mo*0.8/usage_storage_gb_mo
	  ELSE 0
	END AS estimated_gp3_unit_cost
  FROM
    ebs_spend
),
ebs_before_map AS ( 
  SELECT DISTINCT
    billing_period,
	payer_account_id,
	linked_account_id,
	resource_id,
	volume_api_name,
	storage_summary,
	SUM(usage_storage_gb_mo) AS usage_storage_gb_mo,
	SUM(usage_iops_mo) AS usage_iops_mo,
	SUM(usage_throughput_gibps_mo) AS usage_throughput_gibps_mo,
	SUM(gp2_usage_added_iops_mo) gp2_usage_added_iops_mo,
	SUM(gp2_usage_added_throughput_gibps_mo) AS gp2_usage_added_throughput_gibps_mo,
	SUM(ebs_all_cost) AS ebs_all_cost,
	SUM(ebs_sc1_cost) AS ebs_sc1_cost,
	SUM(ebs_st1_cost) AS ebs_st1_cost ,
	SUM(ebs_standard_cost) AS ebs_standard_cost,
	SUM(ebs_io1_cost) AS ebs_io1_cost,
	SUM(ebs_io2_cost) AS ebs_io2_cost,
	SUM(ebs_gp2_cost) AS ebs_gp2_cost,
	SUM(ebs_gp3_cost) AS ebs_gp3_cost,
	/* Calculate cost for gp2 gp3 estimate using the following
	- Storage always 20% cheaper
	- Additional iops per iops-mo is 6% of the cost of 1 gp3 GB-mo
	- Additional throughput per gibps-mo is 50% of the cost of 1 gp3 GB-mo */
	SUM(CASE 
	/*ignore non gp2' */
	  WHEN volume_api_name = 'gp2' THEN ebs_gp2_cost 
	        - (cost_storage_gb_mo*0.8 
			+ estimated_gp3_unit_cost * 0.5 * gp2_usage_added_throughput_gibps_mo
			+ estimated_gp3_unit_cost * 0.06 * gp2_usage_added_iops_mo)
	  ELSE 0
	END) AS ebs_gp3_potential_savings
  FROM 
    ebs_spend_with_unit_cost 
  GROUP BY 
    1, 2, 3, 4, 5, 6)
SELECT DISTINCT
  billing_period,
  payer_account_id,
  linked_account_id,
  resource_id,
  volume_api_name,
  usage_storage_gb_mo,
  usage_iops_mo,
  usage_throughput_gibps_mo,
  storage_summary,
  gp2_usage_added_iops_mo,
  gp2_usage_added_throughput_gibps_mo,
  ebs_all_cost,
  ebs_sc1_cost,
  ebs_st1_cost ,
  ebs_standard_cost,
  ebs_io1_cost,
  ebs_io2_cost,
  ebs_gp2_cost,
  ebs_gp3_cost,
  ebs_gp3_potential_savings
FROM 
  ebs_before_map;
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
    year,
	month,
	bill_billing_period_start_date billing_period,
	line_item_usage_start_date usage_start_date,
	bill_payer_account_id payer_account_id,
	line_item_usage_account_id linked_account_id,
	line_item_resource_id resource_id,
	(CASE 
	  WHEN (line_item_usage_type LIKE '%EBS:SnapshotArchive%') THEN 'Snapshot_Archive' 
	  WHEN (line_item_usage_type LIKE '%EBS:Snapshot%') THEN 'Snapshot' 
	  ELSE "line_item_operation" 
	END) AS snapshot_type,
	line_item_usage_amount,
	line_item_unblended_cost,
	pricing_public_on_demand_cost
  FROM
    ${table_name}
  WHERE 
    (((((bill_payer_account_id <> '') 
	AND (line_item_resource_id <> '')) 
	AND (line_item_line_item_type LIKE '%Usage%')) 
	AND (line_item_product_code = 'AmazonEC2')) 
	AND (line_item_usage_type LIKE '%EBS:Snapshot%'))
),	
-- Step 2: Return most recent billing_period and the first billing_period
request_dates AS (
  SELECT DISTINCT
    resource_id AS request_dates_resource_id, 
	MIN(usage_start_date) AS start_date
  FROM
    snapshot_usage_all_time
  WHERE
    (snapshot_type = 'Snapshot')
  GROUP BY 
    1
), 
-- Step 3: Pivot table so looking at previous month filtered for only snapshots still available in the current month
snapshot_usage_all_time_before_map AS (
  SELECT DISTINCT
    billing_period,
	request_dates.start_date,
	payer_account_id,
	linked_account_id,
	snapshot_type,
	resource_id,
	SUM(line_item_usage_amount) usage_quantity,
	SUM(line_item_unblended_cost) ebs_snapshot_cost,
	SUM(pricing_public_on_demand_cost) public_cost,
	SUM((CASE 
	  WHEN ((request_dates.start_date > (billing_period - INTERVAL  '12' MONTH)) AND (snapshot_type = 'Snapshot')) THEN line_item_unblended_cost 
	  ELSE 0 
	END)) AS ebs_snapshots_under_1yr_cost,  
	/*No savings estimate since it uses uses 100% of snapshot cost for snapshots over 6mos as savings estimate*/ 
	SUM((CASE 
	  WHEN ((request_dates.start_date <= (billing_period - INTERVAL  '12' MONTH)) AND (snapshot_type = 'Snapshot')) THEN line_item_unblended_cost 
	  ELSE 0 
	END)) AS ebs_snapshots_over_1yr_cost
  FROM
    (snapshot_usage_all_time snapshot
	LEFT JOIN request_dates ON (request_dates.request_dates_resource_id = snapshot.resource_id))
      WHERE (CAST("concat"(snapshot.year, '-', snapshot.month, '-01') AS date) = ("date_trunc"('month', current_date) - INTERVAL  '1' MONTH))
  GROUP BY 
    1, 2, 3, 4, 5, 6
)

-- Step 4: Add all data
SELECT
  billing_period,
  start_date,
  payer_account_id,
  linked_account_id,
  resource_id,
  snapshot_type,
  usage_quantity,
  ebs_snapshot_cost,
  public_cost,
  ebs_snapshots_under_1yr_cost,
  ebs_snapshots_over_1yr_cost
FROM
  snapshot_usage_all_time_before_map;
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
  SELECT 
    * 
  FROM 
    (
    VALUES (0.3,.68,2,10,3)
	) 
	t(s3_standard_savings,
	  sia_to_glacier_instant_retrieval_storage_savings,
	  sia_to_glacier_instant_retrieval_tier1_increase,
	  sia_to_glacier_instant_retrieval_tier2_increase,
	  sia_to_glacier_instant_retrieval_retriveal_increase
    )
),

-- Step 2: Filter CUR to return all storage usage data and update ${table_name} with your CUR table table  
s3_usage_all_time AS (
  SELECT
    year,
	month,
	bill_billing_period_start_date AS billing_period,
	line_item_usage_start_date AS usage_start_date,
	bill_payer_account_id AS payer_account_id,
	line_item_usage_account_id AS linked_account_id,
	line_item_resource_id AS resource_id,
	s3_standard_savings,
	sia_to_glacier_instant_retrieval_storage_savings,
	sia_to_glacier_instant_retrieval_tier1_increase,
	sia_to_glacier_instant_retrieval_tier2_increase,
	sia_to_glacier_instant_retrieval_retriveal_increase,
	line_item_operation AS operation,
	line_item_usage_type AS usage_type,
	CASE 
	  WHEN line_item_usage_type LIKE '%EarlyDelete%' THEN 'EarlyDelete' 
	  ELSE line_item_operation 
	END AS early_delete_adjusted_operation,
	CASE
	  WHEN line_item_product_code = 'AmazonGlacier' AND line_item_operation = 'Storage' THEN 'Amazon Glacier'
	  WHEN line_item_product_code = 'AmazonS3' AND product_volume_type LIKE '%Intelligent%' AND line_item_operation LIKE '%IntelligentTiering%' THEN 'Intelligent-Tiering'	  
	  ELSE product_volume_type
	END AS storage_class_type,
	pricing_unit,
	SUM(line_item_usage_amount) AS usage_quantity,
	SUM(line_item_unblended_cost) AS unblended_cost,
	SUM(CASE
	  WHEN (pricing_unit = 'GB-Mo' AND line_item_operation like '%Storage%' AND product_volume_type LIKE '%Glacier Deep Archive%') THEN line_item_unblended_cost
	  WHEN (pricing_unit = 'GB-Mo' AND line_item_operation like '%Storage%') THEN line_item_unblended_cost 
	  ELSE 0
	END) AS s3_all_storage_cost, 
	SUM(CASE 
	  WHEN (pricing_unit = 'GB-Mo' AND line_item_operation like '%Storage%') THEN line_item_usage_amount 
	  ELSE 0 
	END) AS s3_all_storage_usage_quantity
  FROM 
	${table_name}, 
	inputs
  WHERE 
    bill_payer_account_id <> ''
	AND line_item_resource_id <> ''
	AND line_item_line_item_type LIKE '%Usage%'
	AND (line_item_product_code LIKE '%AmazonGlacier%' 
	  OR line_item_product_code LIKE '%AmazonS3%')
  GROUP BY 
    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
),

-- Step 3: Return most recent request date to understand if bucket is in active use
most_recent_request AS (
  SELECT DISTINCT
    resource_id,
	MAX(usage_start_date) AS last_request_date
  FROM 
    s3_usage_all_time
  WHERE 
    usage_quantity > 0
	AND operation IN ('PutObject', 'PutObjectForRepl', 'GetObject', 'CopyObject') 
	AND pricing_unit = 'Requests'
  GROUP BY 
    1
),

-- Step 4: Pivot table so storage classes into separate columns and filter for current month
month_usage AS (
  SELECT DISTINCT
    billing_period,
	date_trunc('month', usage_start_date) AS "usage_date",
	payer_account_id,
	linked_account_id,
	s3.resource_id,
	most_recent_request.last_request_date AS "last_requests",
	s3_standard_savings,
	sia_to_glacier_instant_retrieval_storage_savings,
	sia_to_glacier_instant_retrieval_tier1_increase,
	sia_to_glacier_instant_retrieval_tier2_increase,
	sia_to_glacier_instant_retrieval_retriveal_increase,
	SUM(unblended_cost) AS s3_all_cost,
	-- All Storage
    SUM(s3_all_storage_cost) AS s3_all_storage_cost,
    SUM(s3_all_storage_usage_quantity) AS s3_all_storage_usage_quantity,
	-- S3 Standard
	SUM(CASE 
	  WHEN storage_class_type = 'Standard' THEN s3_all_storage_cost 
	  ELSE 0 
	END) AS s3_standard_storage_cost, 
	SUM(CASE 
	  WHEN storage_class_type = 'Standard' THEN s3_all_storage_usage_quantity 
	  ELSE 0 
	END) AS s3_standard_storage_usage_quantity,
	-- S3 Standard Infrequent Access
	SUM(CASE 
	  WHEN storage_class_type = 'Standard - Infrequent Access' THEN s3_all_storage_cost 
	  ELSE 0 
	END) AS s3_standard_ia_storage_cost,
	SUM(CASE 
	  WHEN storage_class_type = 'Standard - Infrequent Access' THEN s3_all_storage_usage_quantity 
	  ELSE 0 
	END) AS s3_standard_ia_storage_usage_quantity,
	SUM(CASE 
	  WHEN usage_type LIKE '%Requests-SIA-Tier1%' THEN unblended_cost 
	  ELSE 0 
	END) AS s3_standard_ia_tier1_cost,
	SUM(CASE 
	  WHEN usage_type LIKE '%Requests-SIA-Tier2%' THEN unblended_cost 
	  ELSE 0 
	END) AS s3_standard_ia_tier2_cost,	
	SUM(CASE 
	  WHEN usage_type LIKE '%Retrieval-SIA%' THEN unblended_cost 
	  ELSE 0 
	END) AS s3_standard_ia_retrieval_cost,
	-- S3 One Zone Infrequent Access
	SUM(CASE 
	  WHEN storage_class_type = 'One Zone - Infrequent Access' THEN s3_all_storage_cost 
	  ELSE 0 
	END) AS s3_onezone_ia_storage_cost,
	SUM(CASE 
	  WHEN storage_class_type = 'One Zone - Infrequent Access' THEN s3_all_storage_usage_quantity 
	  ELSE 0 
	END) AS s3_onezone_ia_storage_usage_quantity,
	-- S3 Reduced Redundancy
	SUM(CASE 
	  WHEN storage_class_type = 'Reduced Redundancy' THEN s3_all_storage_cost 
	  ELSE 0 
	END) AS s3_reduced_redundancy_storage_cost,
	SUM(CASE 
	  WHEN storage_class_type = 'Reduced Redundancy' THEN s3_all_storage_usage_quantity 
	  ELSE 0 
	END) AS s3_reduced_redundancy_storage_usage_quantity,
	-- S3 Intelligent-Tiering
	SUM(CASE 
	  WHEN storage_class_type LIKE '%Intelligent%' THEN s3_all_storage_cost 
	  ELSE 0 
	END) AS s3_intelligent_tiering_storage_cost,
	SUM(CASE 
	  WHEN storage_class_type LIKE '%Intelligent%' THEN s3_all_storage_usage_quantity 
	  ELSE 0 
    END) AS s3_intelligent_tiering_storage_usage_quantity,
	-- S3 Glacier Instant Retrieval   
	SUM(CASE 
	  WHEN storage_class_type LIKE '%Instant%' AND storage_class_type NOT LIKE '%Intelligent%' THEN s3_all_storage_cost 
	  ELSE 0 
	END) AS s3_glacier_instant_retrieval_storage_cost,
	SUM(CASE 
	  WHEN storage_class_type LIKE '%Instant%' AND storage_class_type NOT LIKE '%Intelligent%' THEN s3_all_storage_usage_quantity 
	  ELSE 0 
	END) AS s3_glacier_instant_retrieval_storage_usage_quantity,
	SUM(CASE 
	  WHEN usage_type LIKE '%Requests-GIR-Tier1%' THEN unblended_cost 
	  ELSE 0 
	END) AS s3_glacier_instant_retrieval_tier1_cost,
	SUM(CASE 
	  WHEN usage_type LIKE '%Requests-GIR-Tier2%' THEN unblended_cost 
	  ELSE 0 
	END) AS s3_glacier_instant_retrieval_tier2_cost,
	SUM(CASE 
	  WHEN usage_type LIKE '%Retrieval-SIA-GIR%' THEN unblended_cost 
	  ELSE 0 
	END) AS s3_glacier_instant_retrieval_retrieval_cost,
	-- S3 Glacier Flexible Retrieval
	SUM(CASE 
	  WHEN storage_class_type = 'Amazon Glacier' THEN s3_all_storage_cost 
	  ELSE 0 
	END) AS s3_glacier_flexible_retrieval_storage_cost,
	SUM(CASE 
	  WHEN storage_class_type = 'Amazon Glacier' THEN s3_all_storage_usage_quantity 
	  ELSE 0 
	END) AS s3_glacier_flexible_retrieval_storage_usage_quantity,
	-- Glacier Deep Archive
	SUM(CASE 
	  WHEN storage_class_type = 'Glacier Deep Archive' THEN s3_all_storage_cost 
	  ELSE 0 
	END) AS s3_glacier_deep_archive_storage_storage_cost,
	SUM(CASE 
	  WHEN storage_class_type = 'Glacier Deep Archive' THEN s3_all_storage_usage_quantity 
	  ELSE 0 
	END) AS s3_glacier_deep_archive_storage_usage_quantity,
	-- Operations
	SUM(CASE 
	  WHEN operation = 'PutObject' AND pricing_unit = 'Requests' THEN usage_quantity 
	  ELSE 0 
	END) AS s3_put_object_usage_quantity,
	SUM(CASE 
	  WHEN operation = 'PutObjectForRepl' AND pricing_unit = 'Requests' THEN usage_quantity 
	  ELSE 0 
	END) AS s3_put_object_replication_usage_quantity,
	SUM(CASE 
	  WHEN operation = 'GetObject' AND pricing_unit = 'Requests' THEN usage_quantity 
	  ELSE 0 
	END) AS s3_get_object_usage_quantity,
	SUM(CASE 
	  WHEN operation = 'CopyObject' AND pricing_unit = 'Requests' THEN usage_quantity 
	  ELSE 0 
	END) AS s3_copy_object_usage_quantity,
	SUM(CASE 
	  WHEN operation = 'Inventory' THEN usage_quantity 
	  ELSE 0 
	END) AS s3_inventory_usage_quantity,
	SUM(CASE 
	  WHEN operation = 'S3.STORAGE_CLASS_ANALYSIS.OBJECT' THEN usage_quantity 
	  ELSE 0 
	END) AS s3_analytics_usage_quantity,
	SUM(CASE 
	  WHEN operation like '%Transition%' THEN usage_quantity 
	  ELSE 0 
	END) AS s3_transition_usage_quantity,
	SUM(CASE 
	  WHEN early_delete_adjusted_operation = 'EarlyDelete' THEN unblended_cost
	  ELSE 0 
	END) AS s3_early_delete_cost	
  FROM s3_usage_all_time s3
    LEFT JOIN most_recent_request ON most_recent_request.resource_id = s3.resource_id
  WHERE 
    CAST(concat(s3.year, '-', s3.month, '-01') AS date) = (date_trunc('month', current_date) - INTERVAL '1' MONTH)
  GROUP BY 
    1,2,3,4,5,6,7,8,9,10,11
)

-- Step 6: Apply KPI logic - Add or Adjust bucket name keywords based on your requirements 
SELECT DISTINCT
  billing_period,
  usage_date,
  payer_account_id,
  linked_account_id,
  resource_id,
  CASE 
    WHEN resource_id LIKE '%backup%' THEN 'backup'
	WHEN resource_id LIKE '%archive%' THEN 'archive'
	WHEN resource_id LIKE '%historical%' THEN 'historical'	
	WHEN resource_id LIKE '%log%' THEN 'log' 
	WHEN resource_id LIKE '%compliance%' THEN 'compliance'
	ELSE 'Other'
  END AS bucket_name_keywords, 
  last_requests,
  CASE
    WHEN last_requests >= (usage_date - INTERVAL  '2' MONTH) THEN 'No Action'
	WHEN s3_all_storage_cost = s3_standard_storage_cost THEN 'Potential Action'
	ELSE 'No Action'
  END AS s3_standard_underutilized_optimization,
  CASE
    WHEN ((s3_transition_usage_quantity)> 0  AND (last_requests >= (usage_date - INTERVAL  '1' MONTH)))  THEN 'No Action'
	WHEN s3_put_object_replication_usage_quantity > 0 THEN 'Potential Action'
	ELSE 'No Action' 
  END AS s3_replication_bucket_optimization,
  CASE
    WHEN s3_all_storage_cost = s3_standard_storage_cost THEN 'Yes'
	ELSE 'No' 
  END AS s3_standard_only_bucket,
  CASE
    WHEN s3_glacier_deep_archive_storage_storage_cost > 0 THEN 'in use'
    WHEN s3_glacier_flexible_retrieval_storage_cost > 0 THEN 'in use'
    WHEN s3_glacier_instant_retrieval_storage_cost > 0 THEN 'in use'
    ELSE 'not in use' 
  END AS s3_archive_in_use,
  CASE 
    WHEN s3_inventory_usage_quantity > 0 THEN 'in use' 
    ELSE 'not in use' 
  END AS s3_inventory_in_use,
  CASE 
    WHEN s3_analytics_usage_quantity > 0 THEN 'in use' 
	ELSE 'not in use' 
  END AS s3_analytics_in_use,
  CASE 
    WHEN s3_intelligent_tiering_storage_usage_quantity > 0 THEN 'in use' 
	ELSE 'not in use' 
  END AS s3_int_in_use,
  s3_standard_storage_cost * s3_standard_savings AS s3_standard_storage_potential_savings, 
  (s3_standard_ia_retrieval_cost + s3_standard_ia_tier1_cost + s3_standard_ia_tier2_cost + s3_standard_ia_storage_cost) 
    -((sia_to_glacier_instant_retrieval_storage_savings * s3_standard_ia_storage_cost)
	+(sia_to_glacier_instant_retrieval_tier1_increase * s3_standard_ia_tier1_cost)
	+(sia_to_glacier_instant_retrieval_tier2_increase * s3_standard_ia_tier2_cost)
	+(sia_to_glacier_instant_retrieval_retriveal_increase * s3_standard_ia_retrieval_cost)
  ) AS s3_glacier_instant_retrieval_potential_savings,
  s3_all_cost,
  (s3_all_cost/s3_all_storage_usage_quantity) AS s3_all_unit_cost,
  s3_all_storage_cost,
  s3_all_storage_usage_quantity,
  (s3_all_storage_cost/s3_all_storage_usage_quantity) AS s3_all_storage_unit_cost,
  s3_standard_storage_cost,
  s3_standard_storage_usage_quantity,
  (s3_standard_storage_cost/s3_standard_storage_usage_quantity) AS s3_standard_storage_unit_cost,
  s3_intelligent_tiering_storage_cost,
  s3_intelligent_tiering_storage_usage_quantity,
  (s3_intelligent_tiering_storage_cost/s3_intelligent_tiering_storage_usage_quantity) AS s3_intelligent_tiering_storage_unit_cost,
  s3_standard_ia_storage_cost,
  s3_standard_ia_storage_usage_quantity,
  (s3_standard_ia_storage_cost/s3_standard_ia_storage_usage_quantity) AS s3_standard_ia_storage_unit_cost,
  s3_onezone_ia_storage_cost,
  s3_onezone_ia_storage_usage_quantity,
  (s3_onezone_ia_storage_cost/s3_onezone_ia_storage_usage_quantity) AS s3_onezone_ia_storage_unit_cost,
  s3_reduced_redundancy_storage_cost,
  s3_reduced_redundancy_storage_usage_quantity,
  (s3_reduced_redundancy_storage_cost/s3_reduced_redundancy_storage_usage_quantity) AS s3_reduced_redundancy_storage_unit_cost,
  s3_glacier_instant_retrieval_storage_cost,
  s3_glacier_instant_retrieval_storage_usage_quantity,
  (s3_glacier_instant_retrieval_storage_cost/s3_glacier_instant_retrieval_storage_usage_quantity) AS s3_glacier_instant_retrieval_storage_unit_cost,
  s3_glacier_flexible_retrieval_storage_cost,
  s3_glacier_flexible_retrieval_storage_usage_quantity,
  (s3_glacier_flexible_retrieval_storage_cost/s3_glacier_flexible_retrieval_storage_usage_quantity) AS s3_glacier_flexible_retrieval_storage_unit_cost,
  s3_glacier_deep_archive_storage_storage_cost,
  s3_glacier_deep_archive_storage_usage_quantity,
  (s3_glacier_deep_archive_storage_storage_cost/s3_glacier_deep_archive_storage_usage_quantity)	AS s3_glacier_deep_archive_storage_unit_cost,
  s3_early_delete_cost,
  s3_transition_usage_quantity,
  s3_put_object_usage_quantity,
  s3_put_object_replication_usage_quantity,
  s3_get_object_usage_quantity,
  s3_copy_object_usage_quantity,
  s3_standard_ia_tier1_cost,
  s3_standard_ia_tier2_cost,
  s3_standard_ia_retrieval_cost,
  s3_glacier_instant_retrieval_tier1_cost,
  s3_glacier_instant_retrieval_tier2_cost,
  s3_glacier_instant_retrieval_retrieval_cost		
FROM 
  month_usage;
```

{{% /expand%}}


#### Helpful Links
* [5 Ways to reduce data storage costs using Amazon S3 Storage Lens](https://aws.amazon.com/blogs/storage/5-ways-to-reduce-costs-using-amazon-s3-storage-lens/)
* [Amazon S3 cost optimization for predictable and dynamic access patterns](https://aws.amazon.com/blogs/storage/amazon-s3-cost-optimization-for-predictable-and-dynamic-access-patterns/)
* [Simplify your data lifecycle by using object tags with Amazon S3 Lifecycle](https://aws.amazon.com/blogs/storage/simplify-your-data-lifecycle-by-using-object-tags-with-amazon-s3-lifecycle/)


{{< email_button category_text="Cost Optimization" service_text="Amazon S3 Bucket Trends" query_text="Amazon S3 Bucket Trends" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}

