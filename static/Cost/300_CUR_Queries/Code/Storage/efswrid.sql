-- query_id: efs
-- query_description: This query will provide daily unblended cost and usage information per linked account for Amazon EFS.
-- query_columns: bill_payer_account_id,line_item_usage_account_id,day_line_item_usage_start_date,split_line_item_resource_id,line_item_usage_type,product_product_family,product_storage_class,pricing_unit,line_item_operation,sum_line_item_usage_amount,sum_line_item_unblended_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/storage/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  SPLIT_PART(line_item_resource_id, 'file-system/', 2) AS split_line_item_resource_id,
  line_item_usage_type,
  product_product_family,
  product_storage_class,
  pricing_unit,
  line_item_operation,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09') -- automation_timerange_year_month
  AND product_product_name = 'Amazon Elastic File System'
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), -- automation_timerange_dateformat
  line_item_usage_type,
  pricing_unit,
  product_product_family,
  product_storage_class,
  line_item_resource_id,
  line_item_operation
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date,
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost,
  line_item_usage_type;