SELECT 
  line_item_product_code,
  line_item_usage_account_id  ,
  date_format(line_item_usage_start_date,'%Y-%m-%d') AS date_line_item_usage_start_date, 
  line_item_usage_type, 
  product_from_location, 
  product_to_location, 
  product_product_family, 
  line_item_resource_id, 
  SUM(CAST(line_item_usage_amount AS double)) as sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) as sum_line_item_unblended_cost
FROM ${tableName}
WHERE 
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND product_product_family = 'Data Transfer'
  AND line_item_line_item_type = 'Usage'
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY 
  line_item_product_code,
  line_item_usage_account_id,
  date_format(line_item_usage_start_date, '%Y-%m-%d'),
  line_item_resource_id,
  line_item_usage_type,
  product_from_location,
  product_to_location,
  product_product_family
ORDER BY 
  sum_line_item_unblended_cost DESC;