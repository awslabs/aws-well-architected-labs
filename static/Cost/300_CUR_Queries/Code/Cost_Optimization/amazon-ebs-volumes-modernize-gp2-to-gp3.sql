/*
-- modified: 2021-08-24
-- query_id: amazon-ebs-volumes-modernize-gp2-to-gp3
-- query_description: This query will display cost and usage of general purpose Elastic Block Storage Volumes and provide the estimated cost savings for modernizing a gp2 volume to gp3  These resources returned by this query could be considered for upgrade to gp3 as with up to 20% cost savings, gp3 volumes help you achieve more control over your provisioned IOPS, giving the ability to provision storage with your unique applications in mind. This query assumes you would provision the max iops and throughput based on the volume size, but not all resources will require the max amount and should be validated by the resource owner. 
-- query_columns: billing_period,payer_account_id,linked_account_id,resource_id,volume_api_name,usage_storage_gb_mo,usage_iops_mo,usage_throughput_gibps_mo,storage_summary,usage_added_iops_mo,usage_added_throughput_gibps_mo,ebs_gp_all_cost,ebs_gp2_cost,ebs_gp3_cost,ebs_gp3_potential_savings,daily_volumes,total_resource_count
-- query_link: /cost/300_labs/300_cur_queries/queries/cost_optimization
*/

		-- NOTE: If running this at a payer account level with millions of volumes we recommend filtering to specific accounts in line 21
		WITH 
		-- Step 1: Filter CUR to return all gp EC2 EBS storage usage data
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
				  ${table_name}
			 WHERE (line_item_product_code = 'AmazonEC2') AND (line_item_line_item_type = 'Usage') 
			   AND bill_payer_account_id <> ''
			   AND line_item_usage_account_id <> ''	   
			   AND (CAST("concat"("year", '-', "month", '-01') AS date) = ("date_trunc"('month', current_date) - INTERVAL  '1' MONTH))
			   AND line_item_usage_type LIKE '%gp%'
			   AND line_item_usage_type LIKE '%EBS%' 

		),

		-- Step 2: Pivot table so gp cost and usage into separate columns
			
		ebs_spend AS (
			 SELECT
			   bill_billing_period_start_date AS billing_period
			 , date_trunc('day',line_item_usage_start_date) AS usage_date
			 , bill_payer_account_id AS payer_account_id
			 , line_item_usage_account_id AS linked_account_id
			 , line_item_resource_id AS resource_id
			 , product_volume_api_name AS volume_api_name
			 , SUM (CASE
					   WHEN (pricing_unit = 'GB-Mo' AND  line_item_usage_type LIKE '%EBS:VolumeUsage%')
					   THEN  line_item_usage_amount ELSE 0 END) "usage_storage_gb_mo"
			 , SUM (CASE
				  WHEN (pricing_unit = 'IOPS-Mo' AND  line_item_usage_type LIKE '%IOPS%') THEN line_item_usage_amount 
				  ELSE 0 END) "usage_iops_mo"
			 , SUM (CASE WHEN (pricing_unit = 'GiBps-mo' AND  line_item_usage_type LIKE '%Throughput%') THEN  line_item_usage_amount ELSE 0 END) "usage_throughput_gibps_mo"
			 , SUM (CASE WHEN (pricing_unit = 'GB-Mo' AND  line_item_usage_type LIKE '%EBS:VolumeUsage%') THEN  (line_item_unblended_cost) ELSE 0 END) "cost_storage_gb_mo"
			 , SUM (CASE WHEN (pricing_unit = 'IOPS-Mo' AND  line_item_usage_type LIKE '%IOPS%') THEN  (line_item_unblended_cost) ELSE 0 END) "cost_iops_mo"
			 , SUM (CASE WHEN (pricing_unit = 'GiBps-mo' AND  line_item_usage_type LIKE '%Throughput%') THEN  (line_item_unblended_cost) ELSE 0 END) "cost_throughput_gibps_mo"
			 FROM
				  ebs_all
			 GROUP BY 1, 2, 3, 4, 5,6
		),

		-- Step 3: Return avg daily volumes
		volume_average AS (
			SELECT 
			 bill_billing_period_start_date
			,date_trunc('day',line_item_usage_start_date) AS usage_date
			, line_item_usage_account_id
			, count(distinct line_item_resource_id) "daily_resource_count"
			FROM ebs_all
			GROUP BY 1,2,3 
		),
		volume_count AS (
			SELECT 
			 bill_billing_period_start_date
			, line_item_usage_account_id
			, count(distinct line_item_resource_id) "total_resource_count"
			FROM ebs_all
			GROUP BY 1,2	
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
			   END AS usage_added_iops_mo
			 , CASE
				  WHEN volume_api_name <> 'gp2' THEN 0
				  WHEN usage_storage_gb_mo <= 150 THEN 0 
				  ELSE 125
			   END AS usage_added_throughput_gibps_mo
			 , cost_storage_gb_mo + cost_iops_mo + cost_throughput_gibps_mo AS ebs_gp_all_cost
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
			LEFT JOIN volume_average ON volume_average.line_item_usage_account_id = linked_account_id and volume_average.bill_billing_period_start_date = billing_period
		  
		)

		SELECT
		  billing_period
		, payer_account_id
		, linked_account_id
		, resource_id
		, volume_api_name
		, usage_storage_gb_mo
		, usage_iops_mo
		, usage_throughput_gibps_mo
		, storage_summary
		, usage_added_iops_mo
		, usage_added_throughput_gibps_mo
		, ebs_gp_all_cost
		, ebs_gp2_cost
		, ebs_gp3_cost
		/* Calculate cost for gp2 gp3 estimate using the following
			  - Storage always 20% cheaper
			  - Additional iops per iops-mo is 6% of the cost of 1 gp3 GB-mo
			  - Additional throughput per gibps-mo is 50% of the cost of 1 gp3 GB-mo */
		, CASE 
			 /*ignore non gp2' */
			 WHEN volume_api_name = 'gp2' THEN ebs_gp2_cost
				  - (cost_storage_gb_mo*0.8 
					   + estimated_gp3_unit_cost * 0.5 * usage_added_throughput_gibps_mo
					   + estimated_gp3_unit_cost * 0.06 * usage_added_iops_mo)
			 ELSE 0
			 END AS ebs_gp3_potential_savings
		, avg(volume_average.daily_resource_count) daily_volumes
		, max(volume_count.total_resource_count) total_resource_count
		FROM 
		  ebs_spend_with_unit_cost 
			LEFT JOIN volume_average ON volume_average.line_item_usage_account_id = linked_account_id and volume_average.bill_billing_period_start_date = billing_period
				LEFT JOIN volume_count ON volume_count.line_item_usage_account_id = linked_account_id and volume_count.bill_billing_period_start_date = billing_period
		GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15