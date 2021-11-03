-- modified: 2021-04-25
-- query_id: data-transfer-msk
-- query_description: This query provides monthly unblended cost and usage information about Data Transfer related to Amazon MSK including resource id.
-- query_columns: line_item_line_item_description,line_item_product_code,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,line_item_usage_type,product_product_family
-- query_link: /cost/300_labs/300_cur_queries/queries/networking__content_delivery/

SELECT -- automation_select_stmt
  line_item_product_code,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS date_line_item_usage_start_date, -- automation_timerange_dateformat
  line_item_resource_id,
  line_item_usage_type,
  line_item_line_item_description,
  product_product_family,
  SUM(line_item_usage_amount)/1024 AS sum_line_item_usage_amount,
  ROUND(SUM(line_item_unblended_cost),2) AS sum_line_item_unblended_cost
FROM  -- automation_from_stmt 
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND line_item_product_code = 'AmazonMSK'
  AND line_item_usage_type LIKE '%DataTransfer%'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  line_item_product_code,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date, '%Y-%m-%d'), -- automation_timerange_dateformat
  line_item_resource_id,
  line_item_usage_type,
  product_product_family, 
  line_item_line_item_description
ORDER BY -- automation_order_stmt
  sum_line_item_unblended_cost desc
;
