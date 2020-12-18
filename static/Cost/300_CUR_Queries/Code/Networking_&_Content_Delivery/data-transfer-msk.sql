SELECT 
  line_item_product_code,
  line_item_usage_account_id,
  date_format(line_item_usage_start_date,'%Y-%m-%d') AS date_line_item_usage_start_date, 
  line_item_resource_id,
  line_item_usage_type,
  line_item_line_item_description,
  product_product_family,
  sum(line_item_usage_amount)/1024 as sum_line_item_usage_amount,
  round(sum(line_item_unblended_cost),2) as sum_line_item_unblended_cost
FROM ${table_name}
WHERE 
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09') 
  AND line_item_product_code = 'AmazonMSK'
  AND line_item_usage_type LIKE '%DataTransfer%'
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY  
  line_item_product_code,
  line_item_usage_account_id,
  date_format(line_item_usage_start_date, '%Y-%m-%d'),
  line_item_resource_id,
  line_item_usage_type,
  product_product_family, 
  line_item_line_item_description
ORDER BY  
  sum_line_item_unblended_cost desc
