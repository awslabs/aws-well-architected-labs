SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
  product_port_speed,
  product_product_family,
  product_transfer_type,
  product_from_location,
  product_to_location,
  product_direct_connect_location,
  pricing_unit,
  line_item_operation,
  line_item_resource_id,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name}
WHERE
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09' )
  AND product_product_name = 'AWS Direct Connect' 
  AND product_transfer_type NOT IN ('IntraRegion Inbound','InterRegion Inbound')
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount')
GROUP BY
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
  line_item_resource_id,
  line_item_operation,
  product_port_speed,
  product_product_family,
  product_transfer_type,
  product_from_location,
  product_to_location,
  product_direct_connect_location,
  pricing_unit
ORDER BY
  sum_line_item_unblended_cost Desc