-- modified: 2021-04-25
-- query_id: sns
-- query_description: This query will provide daily unblended cost and usage information per linked account for Amazon SNS. The output will include detailed information about the product family, API Operation, and usage type. The usage amount and cost will be summed and the cost will be in descending order.
-- query_columns: bill_payer_account_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,product_product_family

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  CONCAT(product_product_family,' - ',line_item_operation) AS concat_product_product_family,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_Name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND product_product_name = 'Amazon Simple Notification Service'
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), -- automation_timerange_dateformat
  CONCAT(product_product_family,' - ',line_item_operation)
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date,
  sum_line_item_unblended_cost DESC;
