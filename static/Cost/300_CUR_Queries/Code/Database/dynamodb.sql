-- modified: 2021-04-25
-- query_id: dynamodb
-- query_description: This query will output the total monthly sum per resource for all DynamoDB purchase options (including reserved capacity) across all DynamoDB usage types (including data transfer and storage costs). 
-- query_columns: bill_payer_account_id,line_item_blended_cost,line_item_line_item_type,line_item_resource_id,line_item_usage_account_id,line_item_usage_amount,line_item_usage_type,product_location,product_product_family,reservation_reservation_a_r_n,reservation_unused_quantity,reservation_unused_recurring_fee
-- query_link: /cost/300_labs/300_cur_queries/queries/database/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  month,
  product_location,
  SPLIT_PART(line_item_resource_id, 'table/', 2) as line_item_resource_id,
  (CASE
    WHEN line_item_usage_type LIKE '%CapacityUnit%' THEN 'DynamoDB Provisioned Capacity'
    WHEN line_item_usage_type LIKE '%HeavyUsage%' THEN 'DynamoDB Provisioned Capacity'
    WHEN line_item_usage_type LIKE '%RequestUnit%' THEN 'DynamoDB On-Demand Capacity'
    ELSE 'DynamoDB Usage'
  END) as capacity_mode_line_item_line_item_type,
 (CASE
    WHEN line_item_line_item_type LIKE '%Fee' THEN 'DynamoDB Reserved Capacity'
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN 'DynamoDB Reserved Capacity'
    ELSE 'DynamoDB Usage' 
  END) as purchase_option_line_item_line_item_type,
  (CASE
    WHEN product_product_family = 'Data Transfer' THEN 'DynamoDB Data Transfer'
    WHEN product_product_family LIKE '%Storage' THEN 'DynamoDB Storage'
    ELSE 'DynamoDB Usage' 
  END) as usage_type_product_product_family,   
  SUM(CAST(line_item_usage_amount AS double)) as sum_line_item_usage_amount,
  SUM(CAST(line_item_blended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost,
  SUM(CAST(reservation_unused_quantity AS double)) as sum_reservation_unused_quantity,
  SUM(CAST(reservation_unused_recurring_fee as decimal(16,8))) as sum_reservation_unused_recurring_fee,
  reservation_reservation_a_r_n
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
  WHERE -- automation_where_stmt
  year = '2020' AND (month BETWEEN '07' AND '10' OR month BETWEEN '7' AND '10') -- automation_timerange_year_month
  AND line_item_product_code = 'AmazonDynamoDB'
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  month,
  product_location,
  5,
  6,
  7,
  8,
  reservation_reservation_a_r_n
ORDER BY -- automation_order_stmt
  sum_line_item_unblended_cost DESC;
