-- modified: 2021-04-25
-- query_id: cloudtrail
-- query_description: This query will provide monthly unblended and usage information per linked account for AWS CloudTrail. 
-- query_columns: bill_payer_account_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,line_item_usage_type,product_product_name
-- query_link: /cost/300_labs/300_cur_queries/queries/management__governance/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, -- automation_timerange_dateformat
  product_product_name, 
  SPLIT_PART(line_item_usage_type,'-',2) AS split_line_item_usage_type, 
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount, 
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name}  -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND product_product_name = 'AWS CloudTrail'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id, 
  line_item_usage_account_id, 
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'), -- automation_timerange_dateformat
  SPLIT_PART(line_item_usage_type,'-',2), 
  product_product_name
ORDER BY -- automation_order_stmt
  sum_line_item_unblended_cost DESC, 
  month_line_item_usage_start_date, 
  sum_line_item_usage_amount
;