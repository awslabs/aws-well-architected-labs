-- modified: 2021-04-25
-- query_id: kinesis
-- query_description: This query will provide daily unblended and usage information per linked account for each Kinesis product (Amazon Kinesis, Amazon Kinesis Firehose, and Amazon Kinesis Analytics).
-- query_columns: bill_payer_account_id,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,product_product_name
-- query_link: /cost/300_labs/300_cur_queries/queries/analytics/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  SPLIT_PART(line_item_resource_id,':',6) as split_line_item_resource_id,
  product_product_name,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16, 8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_Name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND product_product_name IN ('Amazon Kinesis','Amazon Kinesis Firehose','Amazon Kinesis Analytics','Amazon Kinesis Video')
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), -- automation_timerange_dateformat
  line_item_resource_id,
  product_product_name
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date,
  sum_line_item_unblended_cost DESC;
