SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  line_item_resource_id,
  line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM ${table_name}
WHERE ${date_filter}
  AND line_item_product_code = 'CodeBuild'
GROUP BY
  1, 2, 3, 4, 5
ORDER BY
  sum_line_item_unblended_cost DESC;