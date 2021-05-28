-- modified: 2021-04-25
-- query_id: workspaces
-- query_description: This query will provide unblended cost and usage information per linked account for Amazon WorkSpaces.
-- query_columns: bill_payer_account_id,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,pricing_unit,product_bundle,product_license,product_memory,product_operating_system,product_running_mode,product_software_included,product_storage,product_vcpu
-- query_link: /cost/300_labs/300_cur_queries/queries/end_user_computing/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  SPLIT_PART(line_item_resource_id,'/',2) AS split_line_item_resource_id,
  SPLIT_PART(product_bundle,'-',1) AS split_product_bundle,
  product_operating_system,
  product_memory,
  product_storage,
  product_vcpu,
  product_running_mode,
  product_license,
  product_software_included,
  pricing_unit,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost 
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND product_product_name = 'Amazon WorkSpaces'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), -- automation_timerange_dateformat
  line_item_resource_id,
  product_bundle,
  product_operating_system,
  product_memory,
  product_storage,
  product_vcpu,
  product_running_mode,
  product_license,
  product_software_included,
  pricing_unit
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date,
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost
;