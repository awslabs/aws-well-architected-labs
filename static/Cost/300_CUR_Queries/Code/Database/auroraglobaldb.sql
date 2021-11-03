SELECT 
  DATE_TRUNC('day',line_item_usage_start_date) AS day_line_item_usage_start_date, 
  line_item_usage_account_id,
  line_item_line_item_type,
  line_item_usage_type,
  line_item_operation,
  line_item_line_item_description,
  line_item_resource_id,
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost,
  SUM(line_item_usage_amount) AS sum_line_item_usage_amount
FROM 
  ${table_name}
WHERE 
  ${date_filter}
  AND (line_item_resource_id LIKE '%${primary_cluster_id}%' -- primary region cluster id in format 'cluster-xxxxxxxxxxxxxxxxxxxxxxxx'
    OR line_item_resource_id LIKE '%${secondary_cluster_id_1}%' -- secondary region cluster id in format 'cluster-xxxxxxxxxxxxxxxxxxxxxxxx'
    OR line_item_resource_id LIKE '%${secondary_cluster_id_n}%' -- additional secondary region cluster id. copy and paste this line once per additional region/cluster
    OR line_item_resource_id LIKE '%${primary_cluster_db_instance_name_1}%' -- primary region database instance name. user defined string, e.g 'team-a-mysql-db-1'
    OR line_item_resource_id LIKE '%${primary_cluster_db_instance_name_n}%' -- additional primary region database instance name. copy and paste this line once per additional instance
    OR line_item_resource_id LIKE '%${secondary_cluster_db_instance_name_1}%' -- secondary region database instance name. user defined string, e.g 'team-a-mysql-db-2'. optional if running headless.
    OR line_item_resource_id LIKE '%${secondary_cluster_db_instance_name_n}%' -- additional secondary region database instance name. copy and paste this line once per additional instance
  )
  AND line_item_usage_type NOT LIKE '%BackupUsage%'
GROUP BY 
  DATE_TRUNC('day', line_item_usage_start_date), 
  line_item_usage_account_id,
  line_item_line_item_type,
  line_item_usage_type,
  line_item_operation,
  line_item_line_item_description,
  line_item_resource_id
ORDER BY
  day_line_item_usage_start_date, 
  sum_line_item_unblended_cost DESC
  ;
  