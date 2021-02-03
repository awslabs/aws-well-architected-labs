SELECT 
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
FROM 
  ${table_name}
  WHERE year = '2020' AND (month BETWEEN '07' AND '10' OR month BETWEEN '7' AND '10')
  AND line_item_product_code = 'AmazonDynamoDB'
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount')
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  month,
  product_location,
  5,
  6,
  7,
  8,
  reservation_reservation_a_r_n
ORDER BY
  sum_line_item_unblended_cost DESC;
