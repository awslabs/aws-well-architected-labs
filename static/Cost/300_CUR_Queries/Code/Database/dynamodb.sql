-- modified: 2022-12-13
-- query_id: dynamodb
-- query_description: This query will output the total monthly sum per resource for all DynamoDB purchase options (including reserved capacity) across all DynamoDB usage types (including data transfer and storage costs). 
-- query_columns: bill_payer_account_id,line_item_blended_cost,line_item_line_item_type,line_item_resource_id,line_item_usage_account_id,line_item_usage_amount,line_item_usage_type,product_location,product_product_family,reservation_reservation_a_r_n,reservation_unused_quantity,reservation_unused_recurring_fee
-- query_link: /cost/300_labs/300_cur_queries/queries/database/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
  product_location,
  SPLIT_PART(line_item_resource_id, 'table/', 2) AS line_item_resource_id,
  CASE
    WHEN line_item_usage_type LIKE '%CapacityUnit%' THEN 'DynamoDB Provisioned Capacity'
    WHEN line_item_usage_type LIKE '%HeavyUsage%' THEN 'DynamoDB Provisioned Capacity'
    WHEN line_item_usage_type LIKE '%RequestUnit%' THEN 'DynamoDB On-Demand Capacity'
    WHEN line_item_usage_type LIKE '%TimedStorage%' THEN 'DynamoDB Storage'
    WHEN line_item_usage_type LIKE '%TimedBackup%' THEN 'DynamoDB Backups'
    WHEN line_item_usage_type LIKE '%TimedPITR%' THEN 'DynamoDB Backups'
    WHEN line_item_usage_type like '%DataTransfer%'THEN 'DynamoDB Data Transfer'
    ELSE 'DynamoDB Other Usage'
  END AS case_line_item_usage_type,
  CASE
    WHEN line_item_line_item_type LIKE '%Fee' THEN 'DynamoDB Reserved Capacity'
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN 'DynamoDB Reserved Capacity'
    ELSE 'DynamoDB Usage' 
  END AS case_purchase_option,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_blended_cost AS DECIMAL(16,8))) AS sum_line_item_blended_cost,
  SUM(CAST(reservation_unused_quantity AS DOUBLE)) AS sum_reservation_unused_quantity,
  SUM(CAST(reservation_unused_recurring_fee AS DECIMAL(16,8))) AS sum_reservation_unused_recurring_fee,
  reservation_reservation_a_r_n
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  {$date_filter}
  AND line_item_product_code = 'AmazonDynamoDB'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
  product_location,
  SPLIT_PART(line_item_resource_id, 'table/', 2),
  6, -- refers to case_line_item_usage_type
  7, -- refers to case_purchase_option
  reservation_reservation_a_r_n
ORDER BY -- automation_order_stmt
  sum_line_item_blended_cost DESC
;
