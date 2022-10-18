/* 
-- modified: 2022-02-08
-- query_id: s3-bucket-trends-and-optimizations
--  query_description: This query breaks out the previous month's costs and usage of each S3 bucket by storage class and includes and separates out identifiers that can be used to identify trends or potential areas to look into for optimization across Lifecycle Policies or Intelligent Tiering. The query uses this information to provide a variety of checks for each S3 bucket including:
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
-- query_columns: billing_period,usage_date,payer_account_id,linked_account_id,resource_id,bucket_name_keywords,last_requests,s3_standard_underutilized_optimization,s3_replication_bucket_optimization,s3_standard_only_bucket,s3_archive_in_use,s3_inventory_in_use,s3_analytics_in_use,s3_int_in_use,s3_standard_storage_potential_savings,s3_glacier_instant_retrieval_potential_savings,s3_all_cost,s3_all_unit_cost,s3_all_storage_cost,s3_all_storage_usage_quantity,s3_all_storage_unit_cost,s3_standard_storage_cost,s3_standard_storage_usage_quantity,s3_standard_storage_unit_cost,s3_intelligent-tiering_storage_cost,s3_intelligent-tiering_storage_usage_quantity,s3_intelligent-tiering_storage_unit_cost,s3_standard-ia_storage_cost,s3_standard-ia_storage_usage_quantity,s3_standard-ia_storage_unit_cost,s3_onezone-ia_storage_cost,s3_onezone-ia_storage_usage_quantity,s3_onezone-ia_storage_unit_cost,s3_reduced_redundancy_storage_cost,s3_reduced_redundancy_storage_usage_quantity,s3_reduced_redundancy_storage_unit_cost,s3_glacier_instant_retrieval_storage_cost,s3_glacier_instant_retrieval_storage_usage_quantity,s3_glacier_instant_retrieval_storage_unit_cost,s3_glacier_flexible_retrieval_storage_cost,s3_glacier_flexible_retrieval_storage_usage_quantity,s3_glacier_flexible_retrieval_storage_unit_cost,s3_glacier_deep_archive_storage_storage_cost,s3_glacier_deep_archive_storage_usage_quantity,s3_glacier_deep_archive_storage_unit_cost,s3_early_delete_cost,s3_transition_usage_quantity,s3_put_object_usage_quantity,s3_put_object_replication_usage_quantity,s3_get_object_usage_quantity,s3_copy_object_usage_quantity,s3_standard-ia_tier1_cost,s3_standard-ia_tier2_cost,s3_standard-ia_retrieval_cost,s3_glacier_instant_retrieval_tier1_cost,s3_glacier_instant_retrieval_tier2_cost,s3_glacier_instant_retrieval_retrieval_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/cost_optimization
*/
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
  month_usage
;
