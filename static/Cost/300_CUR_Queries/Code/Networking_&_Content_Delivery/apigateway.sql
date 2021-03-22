-- query_id: apigateway
-- query_description: This query provides daily unblended cost and usage information about Amazon API Gateway usage including the resource id.
-- query_columns: bill_payer_account_id,line_item_usage_account_id,split_line_item_resource_id,day_line_item_usage_start_date,case_line_item_usage_type,sum_line_item_usage_amount,sum_line_item_unblended_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/networking__content_delivery/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  SPLIT_PART(line_item_resource_id, 'apis/', 2) as split_line_item_resource_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  CASE  
    WHEN line_item_usage_type LIKE '%%ApiGatewayRequest%%' OR line_item_usage_type LIKE '%%ApiGatewayHttpRequest%%' THEN 'Requests' 
    WHEN line_item_usage_type LIKE '%%DataTransfer%%' THEN 'Data Transfer'
    WHEN line_item_usage_type LIKE '%%Message%%' THEN 'Messages'
    WHEN line_item_usage_type LIKE '%%Minute%%' THEN 'Minutes'
    WHEN line_item_usage_type LIKE '%%CacheUsage%%' THEN 'Cache Usage'
    ELSE 'Other'
  END AS case_line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09') -- automation_timerange_year_month
  AND product_product_name = 'Amazon API Gateway'
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d'), -- automation_timerange_dateformat
  line_item_resource_id,
  line_item_usage_type
ORDER BY -- automation_order_stmt
  sum_line_item_unblended_cost DESC;
