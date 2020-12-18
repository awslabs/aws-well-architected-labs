SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, 
  product_product_name, 
  SPLIT_PART(line_item_usage_type,'-',2) as split_line_item_usage_type, 
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount, 
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM ${table_name}
WHERE 
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND product_product_name = 'AWS CloudTrail'
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY  
  bill_payer_account_id, 
  line_item_usage_account_id, 
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'), 
  SPLIT_PART(line_item_usage_type,'-',2), 
  product_product_name
ORDER BY  
  sum_line_item_unblended_cost desc, 
  month_line_item_usage_start_date, 
  sum_line_item_usage_amount;