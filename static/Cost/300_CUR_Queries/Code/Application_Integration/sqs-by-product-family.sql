SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  CONCAT(product_product_family,' - ',line_item_operation) AS concat_product_product_family,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM
    ${table_name}
WHERE
    ${date_filter}}
    AND line_item_product_code = 'AWSQueueService'
    AND line_item_line_item_type IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  CONCAT(product_product_family,' - ',line_item_operation)
ORDER BY
  day_line_item_usage_start_date,
  sum_line_item_unblended_cost DESC;