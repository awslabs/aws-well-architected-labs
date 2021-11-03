-- modified: 2021-04-25
SELECT
  line_item_usage_type,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
  resource_tags_user_environment,
  SUM(CAST(line_item_blended_cost AS DECIMAL(16,8))) AS sum_line_item_blended_cost
FROM 
  ${table_name}
WHERE 
  ${date_filter}
  AND line_item_product_code='AmazonRDS'
  AND resource_tags_user_environment = 'dev'
GROUP BY  
  line_item_usage_type,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
  resource_tags_user_environment
HAVING 
  SUM(line_item_blended_cost) > 0
ORDER BY 
  line_item_usage_type,
  month_line_item_usage_start_date,
  resource_tags_user_environment
;
