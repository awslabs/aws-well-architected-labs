---
date: 2022-01-16T11:16:08-04:00
chapter: false
weight: 999
hidden: FALSE
---



## KPI EBS Storage All View

This view will be used to create the **KPI EBS Storage All view** that is used to analyze EBS storage metrics and potential savings opportunities. There is only one version of this view and it is not dependent on if you have or do not have Reserved Instances or Savings Plans.      


### Create View
- {{%expand "Click here to expand the view" %}}

Modify the following SQL query for the KPI EBS Storage All view: 
 - Update line 21, replace (database).(tablename) with your CUR database and table name 


		CREATE OR REPLACE VIEW kpi_ebs_storage_all AS 
		WITH 
		-- Step 1: Add mapping view
		map AS(SELECT *
		FROM account_map),
		-- Step 2: Filter CUR to return all EC2 EBS storage usage data
		ebs_all AS (
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
		(database).(tablename)
		WHERE (line_item_product_code = 'AmazonEC2') AND (line_item_line_item_type = 'Usage') 
		AND bill_payer_account_id <> ''
		AND line_item_usage_account_id <> ''	   
		AND (CAST("concat"("year", '-', "month", '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '3' MONTH))
		AND product_volume_api_name <> ''
		AND line_item_usage_type NOT LIKE '%Snap%'
		AND line_item_usage_type LIKE '%EBS%' 
		),
		-- Step 3: Pivot table so storage types cost and usage into separate columns
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
		, map.*
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
		LEFT JOIN map ON map.account_id = linked_account_id 

{{% /expand%}}


### Adding Cost Allocation Tags
{{% notice tip %}}
Cost Allocation tags can be added to any views. We recommend adding while creating the dashboard to eliminate rework. 
{{% /notice %}}

{{%expand "Click here - for an example with a cost allocation tags" %}}
Example uses the tag **resource_tags_user_project**

		 CREATE OR REPLACE VIEW kpi_ebs_storage_all AS 
		 WITH 
		 -- Step 1: Add mapping view
		 map AS(SELECT *
		 FROM account_map),
		 -- Step 2: Filter CUR to return all EC2 EBS storage usage data
		 ebs_all AS (
		 SELECT
		 bill_billing_period_start_date
		 , line_item_usage_start_date
		 , bill_payer_account_id
		 , line_item_usage_account_id
		 , resource_tags_user_project
		 , line_item_resource_id 
		 , product_volume_api_name
		 , line_item_usage_type
		 , pricing_unit
		 , line_item_unblended_cost
		 , line_item_usage_amount
		 FROM
		 (database).(tablename)
		 WHERE (line_item_product_code = 'AmazonEC2') AND (line_item_line_item_type = 'Usage') 
		 AND bill_payer_account_id <> ''
		 AND line_item_usage_account_id <> ''	   
		 AND (CAST("concat"("year", '-', "month", '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '3' MONTH))
		 AND product_volume_api_name <> ''
		 AND line_item_usage_type NOT LIKE '%Snap%'
		 AND line_item_usage_type LIKE '%EBS%' 
		 ),
		 -- Step 3: Pivot table so storage types cost and usage into separate columns
		 ebs_spend AS (
		 SELECT DISTINCT
		 bill_billing_period_start_date AS billing_period
		 , date_trunc('month',line_item_usage_start_date) AS usage_date
		 , bill_payer_account_id AS payer_account_id
		 , line_item_usage_account_id AS linked_account_id
		 , resource_tags_user_project
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
		 GROUP BY 1, 2, 3, 4, 5,6,7
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
		 , resource_tags_user_project
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
		 GROUP BY 1, 2, 3, 4, 5, 6,7)
		 SELECT DISTINCT
		 billing_period
		 , payer_account_id
		 , linked_account_id
		 , resource_tags_user_project
		 , map.*
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
		 LEFT JOIN map ON map.account_id = linked_account_id 


{{% /expand%}}


### Validate View 
- Confirm the view is working, run the following Athena query and you should receive 10 rows of data:

        select * from kpi_ebs_storage_all
        limit 10
