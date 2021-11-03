-- modified: 2021-04-25
-- query_id: mq
-- query_description: This query will provide daily unblended and amortized cost as well as usage information per linked account for Amazon MQ. The output will include detailed information about the resource id (broker), usage type, and API operation. The usage amount and cost will be summed and the cost will be in descending order.
-- query_columns: bill_payer_account_id,line_item_operation,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,line_item_usage_type,pricing_term,pricing_unit,product_broker_engine,product_product_family,line_item_usage_type
-- query_link: /cost/300_labs/300_cur_queries/queries/application_integration/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  product_broker_engine,
  line_item_usage_type,
  product_product_family,
  pricing_unit,
  pricing_term,
  SPLIT_PART(line_item_usage_type, ':', 2) AS split_line_item_usage_type,
  SPLIT_PART(line_item_resource_id, ':', 7) AS split_line_item_resource_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  line_item_operation,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_Name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND product_product_name = 'Amazon MQ'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  product_broker_engine,
  product_product_family,
  pricing_unit,
  pricing_term,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), -- automation_timerange_dateformat
  line_item_usage_type,
  line_item_resource_id,
  line_item_operation
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date,
  sum_line_item_unblended_cost DESC,
  split_line_item_usage_type
;
