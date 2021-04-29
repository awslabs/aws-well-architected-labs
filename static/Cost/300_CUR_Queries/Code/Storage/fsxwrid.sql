-- modified: 2021-04-25
-- query_id: fsx
-- query_description: This query will provide daily unblended cost and usage information per linked account for Amazon FSx.
-- query_columns: bill_payer_account_id,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,line_item_usage_type,pricing_unit,product_deployment_option,product_product_family
-- query_link: /cost/300_labs/300_cur_queries/queries/storage/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  SPLIT_PART(line_item_resource_id, ':', 6) as split_line_item_resource_id,
  product_deployment_option,
  line_item_usage_type,
  product_product_family,
  pricing_unit,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND product_product_name = 'Amazon FSx'
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), -- automation_timerange_dateformat
  SPLIT_PART(line_item_resource_id, ':', 6),
  product_deployment_option,
  line_item_usage_type,
  product_product_family,
  pricing_unit
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date,
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost;