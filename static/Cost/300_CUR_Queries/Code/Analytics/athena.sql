-- query_id: athena
-- query_description: This query will provide the top 20 Amazon Athena workgroups driving cost within an Organization.
-- query_columns: bill_payer_account_id,line_item_usage_account_id,day_line_item_usage_start_date,line_item_usage_type,line_item_resource_id,product_region,line_item_product_code,sum_line_item_usage_amount,sum_line_item_unblended_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/analytics/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  line_item_usage_type,
  line_item_resource_id,
  product_region,
  line_item_product_code,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09') -- automation_timerange_year_month
  AND line_item_product_code = 'AmazonAthena'
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  1,2,3,4,5,6,7
ORDER BY -- automation_order_stmt
  sum_line_item_unblended_cost DESC
LIMIT 20 -- automation_limit_stmt
; 
