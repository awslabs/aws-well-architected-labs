SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  IF(line_item_usage_start_date IS NULL, 
       DATE_FORMAT(DATE_PARSE(CONCAT(SPLIT_PART('${table_name}','_',5),'01'),'%Y%m%d'),'%Y-%m-01'),
       DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') 
      ) AS month_line_item_usage_start_time,
  bill_billing_entity,
  product_product_name,
SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name}
WHERE 
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND bill_billing_entity = 'AWS Marketplace'
GROUP BY
  1,2,3,4,5
ORDER BY
  month_line_item_usage_start_time ASC,
  sum_line_item_unblended_cost DESC;