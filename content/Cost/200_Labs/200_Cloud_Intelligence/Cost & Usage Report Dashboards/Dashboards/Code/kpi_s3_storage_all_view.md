---
date: 2022-01-16T11:16:08-04:00
chapter: false
weight: 999
hidden: FALSE
---



## KPI S3 Storage All View

This view will be used to create the **KPI S3 Storage All view** that is used to analyze S3 storage metrics and potential savings opportunities. There is only one version of this view and it is not dependent on if you have or do not have Reserved Instances or Savings Plans.      


### Create View
- {{%expand "Click here to expand the view" %}}

Modify the following SQL query for the KPI S3 Storage All view: 
 - Update line 42, replace (database).(tablename) with your CUR database and table name 

		CREATE OR REPLACE VIEW kpi_s3_storage_all AS 
		-- Step 1: Enter S3 standard savings savings assumption. Default is set to 0.3 for 30% savings 
		WITH inputs AS (
			SELECT * FROM (VALUES (0.3)) t(s3_standard_savings)),
			
		-- Step: 2  Add mapping view
		map AS(SELECT 
		* 
		FROM account_map),

		-- Step 3: Filter CUR to return all storage usage data
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
			(database).(tablename)
				, inputs
			WHERE bill_payer_account_id <> ''
			  AND line_item_resource_id <> ''
			  AND line_item_line_item_type LIKE '%Usage%'
			  AND (line_item_product_code LIKE '%AmazonGlacier%' OR line_item_product_code LIKE '%AmazonS3%')
			GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12,13
		),

		-- Step 4: Return most recent request date to understand if bucket is in active use
		most_recent_request AS (
			SELECT DISTINCT
			  resource_id
			, max(usage_start_date) AS last_request_date
			FROM s3_usage_all_time
			WHERE usage_quantity > 0
			  AND operation IN ('PutObject', 'PutObjectForRepl', 'GetObject', 'CopyObject') AND pricing_unit = 'Requests'
			GROUP BY 1
		),

		-- Step 5: Pivot table so storage classes into separate columns and filter for current month
		month_usage AS (

			SELECT DISTINCT
			  billing_period
			, date_trunc('month', usage_start_date) AS "usage_date"
			, payer_account_id
			, linked_account_id
			, s3.resource_id
			, most_recent_request.last_request_date AS "last_requests"
			,s3_standard_savings
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
			WHERE CAST(concat(s3.year, '-', s3.month, '-01') AS date) >= (date_trunc('month', current_date) - INTERVAL '3' MONTH)
			GROUP BY 1, 2, 3, 4, 5, 6,7
		)


		-- Step 6: Add account mapping & apply KPI logic - Add or Adjust bucket name keywords based on your requirements 
		SELECT DISTINCT
		  billing_period
		, usage_date
		, payer_account_id
		, linked_account_id
		, map.*
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
		, s3_all_cost
		, s3_all_storage_cost
		, s3_all_storage_usage_quantity
		, s3_standard_storage_cost
		, s3_standard_storage_usage_quantity
		, "s3_intelligent-tiering_storage_cost"
		, "s3_intelligent-tiering_storage_usage_quantity"		
		, "s3_standard-ia_storage_cost"
		, "s3_standard-ia_storage_usage_quantity"
		, "s3_standard-ia_tier1_cost"
		, "s3_standard-ia_tier2_cost"
		, "s3_standard-ia_retrieval_cost"
		, "s3_onezone-ia_storage_cost"
		, "s3_onezone-ia_storage_usage_quantity"
		, s3_reduced_redundancy_storage_cost
		, s3_reduced_redundancy_storage_usage_quantity
		, s3_glacier_instant_retrieval_storage_cost
		, s3_glacier_instant_retrieval_storage_usage_quantity
		, s3_glacier_instant_retrieval_tier1_cost
		, s3_glacier_instant_retrieval_tier2_cost
		, s3_glacier_instant_retrieval_retrieval_cost
		, s3_glacier_flexible_retrieval_storage_cost
		, s3_glacier_flexible_retrieval_storage_usage_quantity
		, s3_glacier_deep_archive_storage_storage_cost
		, s3_glacier_deep_archive_storage_usage_quantity		
		, s3_early_delete_cost  
		, s3_transition_usage_quantity
		, s3_put_object_usage_quantity
		, s3_put_object_replication_usage_quantity
		, s3_get_object_usage_quantity
		, s3_copy_object_usage_quantity
		FROM month_usage
		LEFT JOIN map ON map.account_id = linked_account_id 


{{% /expand%}}

### Adding Cost Allocation Tags
{{% notice tip %}}
Cost Allocation tags can be added to any views. We recommend adding while creating the dashboard to eliminate rework. 
{{% /notice %}}

{{%expand "Click here - for an example with a cost allocation tags" %}}
Example uses the tag **resource_tags_user_project**

		 CREATE OR REPLACE VIEW kpi_s3_storage_all AS 
		 -- Step 1: Enter S3 standard savings savings assumption. Default is set to 0.3 for 30% savings 
		 WITH inputs AS (
			 SELECT * FROM (VALUES (0.3)) t(s3_standard_savings)),

		 -- Step: 2  Add mapping view
		 map AS(SELECT 
		 * 
		 FROM account_map),

		 -- Step 3: Filter CUR to return all storage usage data
		 s3_usage_all_time AS (
			 SELECT
			   year
			 , month
			 , bill_billing_period_start_date AS billing_period
			 , line_item_usage_start_date AS usage_start_date
			 , bill_payer_account_id AS payer_account_id
			 , line_item_usage_account_id AS linked_account_id
			 , resource_tags_user_project
			 , line_item_resource_id AS resource_id
			 , s3_standard_savings
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
			 (database).(tablename)
				 , inputs
			 WHERE bill_payer_account_id <> ''
			   AND line_item_resource_id <> ''
			   AND line_item_line_item_type LIKE '%Usage%'
			   AND (line_item_product_code LIKE '%AmazonGlacier%' OR line_item_product_code LIKE '%AmazonS3%')
			 GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12,13,14
		 ),

		 -- Step 4: Return most recent request date to understand if bucket is in active use
		 most_recent_request AS (
			 SELECT DISTINCT
			   resource_id
			 , max(usage_start_date) AS last_request_date
			 FROM s3_usage_all_time
			 WHERE usage_quantity > 0
			   AND operation IN ('PutObject', 'PutObjectForRepl', 'GetObject', 'CopyObject') AND pricing_unit = 'Requests'
			 GROUP BY 1
		 ),

		 -- Step 5: Pivot table so storage classes into separate columns and filter for current month
		 month_usage AS (

			 SELECT DISTINCT
			   billing_period
			 , date_trunc('month', usage_start_date) AS "usage_date"
			 , payer_account_id
			 , linked_account_id
			 , resource_tags_user_project
			 , s3.resource_id
			 , most_recent_request.last_request_date AS "last_requests"
			 ,s3_standard_savings
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
			 WHERE CAST(concat(s3.year, '-', s3.month, '-01') AS date) >= (date_trunc('month', current_date) - INTERVAL '3' MONTH)
			 GROUP BY 1, 2, 3, 4, 5, 6,7,8
		 )


		 -- Step 6: Add account mapping & apply KPI logic - Add or Adjust bucket name keywords based on your requirements 
		 SELECT DISTINCT
		   billing_period
		 , usage_date
		 , payer_account_id
		 , linked_account_id
		 , resource_tags_user_project
		 , map.*
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
		 , s3_all_cost
		 , s3_all_storage_cost
		 , s3_all_storage_usage_quantity
		 , s3_standard_storage_cost
		 , s3_standard_storage_usage_quantity
		 , "s3_intelligent-tiering_storage_cost"
		 , "s3_intelligent-tiering_storage_usage_quantity"		
		 , "s3_standard-ia_storage_cost"
		 , "s3_standard-ia_storage_usage_quantity"
		 , "s3_standard-ia_tier1_cost"
		 , "s3_standard-ia_tier2_cost"
		 , "s3_standard-ia_retrieval_cost"
		 , "s3_onezone-ia_storage_cost"
		 , "s3_onezone-ia_storage_usage_quantity"
		 , s3_reduced_redundancy_storage_cost
		 , s3_reduced_redundancy_storage_usage_quantity
		 , s3_glacier_instant_retrieval_storage_cost
		 , s3_glacier_instant_retrieval_storage_usage_quantity
		 , s3_glacier_instant_retrieval_tier1_cost
		 , s3_glacier_instant_retrieval_tier2_cost
		 , s3_glacier_instant_retrieval_retrieval_cost
		 , s3_glacier_flexible_retrieval_storage_cost
		 , s3_glacier_flexible_retrieval_storage_usage_quantity
		 , s3_glacier_deep_archive_storage_storage_cost
		 , s3_glacier_deep_archive_storage_usage_quantity		
		 , s3_early_delete_cost  
		 , s3_transition_usage_quantity
		 , s3_put_object_usage_quantity
		 , s3_put_object_replication_usage_quantity
		 , s3_get_object_usage_quantity
		 , s3_copy_object_usage_quantity
		 FROM month_usage
		 LEFT JOIN map ON map.account_id = linked_account_id


{{% /expand%}}


### Validate View 
- Confirm the view is working, run the following Athena query and you should receive 10 rows of data:

        select * from kpi_s3_storage_all
        limit 10
