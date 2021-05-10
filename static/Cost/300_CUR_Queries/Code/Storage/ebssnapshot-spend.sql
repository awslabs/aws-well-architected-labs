-- modified: 2021-04-25
-- query_id: ebssnapshot-spend
-- query_description: This query provides daily unblended cost and usage information about Amazon EBS Snapshot Usage per account including region.
-- query_columns: bill_payer_account_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,product_region
-- query_link: /cost/300_labs/300_cur_queries/queries/storage/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS date_line_item_usage_start_date, -- automation_timerange_dateformat
  product_region,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND product_product_name = 'Amazon Elastic Compute Cloud'
  AND line_item_usage_type LIKE '%%EBS%%Snapshot%%'
  AND product_product_family LIKE 'Storage Snapshot'
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d'), -- automation_timerange_dateformat
  product_region
ORDER BY -- automation_order_stmt
  sum_line_item_unblended_cost DESC, 
  sum_line_item_usage_amount DESC,
  date_line_item_usage_start_date ASC; 