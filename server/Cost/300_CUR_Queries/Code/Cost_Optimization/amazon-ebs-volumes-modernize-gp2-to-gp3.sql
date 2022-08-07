/*
-- modified: 2022-02-08
-- query_id: amazon-ebs-volumes-modernize-gp2-to-gp3
-- query_description: This query will display cost and usage of general purpose Elastic Block Storage Volumes and provide the estimated cost savings for modernizing a gp2 volume to gp3  These resources returned by this query could be considered for upgrade to gp3 as with up to 20% cost savings, gp3 volumes help you achieve more control over your provisioned IOPS, giving the ability to provision storage with your unique applications in mind. This query assumes you would provision the max iops and throughput based on the volume size, but not all resources will require the max amount and should be validated by the resource owner. You can remove the volume filter to view all EC2 EBS volume data. 
-- query_columns: billing_period,payer_account_id,linked_account_id,resource_id,volume_api_name,usage_storage_gb_mo,usage_iops_mo,usage_throughput_gibps_mo,storage_summary,gp2_usage_added_iops_mo,gp2_usage_added_throughput_gibps_mo,ebs_all_cost,ebs_sc1_cost,ebs_st1_cost,ebs_standard_cost,ebs_io1_cost,ebs_io2_cost,ebs_gp2_cost,ebs_gp3_cost,ebs_gp3_potential_savings
-- query_link: /cost/300_labs/300_cur_queries/queries/cost_optimization
*/

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
  ebs_before_map
;
