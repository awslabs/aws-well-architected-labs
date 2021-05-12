-- modified: 2021-04-25
-- query_id: cloudfront
-- query_description: This query provides daily unblended cost and usage information about Amazon CloudFront usage including the distribution name, region, and operation.
-- query_columns: bill_payer_account_id,line_item_operation,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,product_product_family,product_region
-- query_link: /cost/300_labs/300_cur_queries/queries/networking__content_delivery/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  product_region,
  product_product_family, -- NOTE: product_product_family used in place of large line_item_usage_type CASE
  line_item_operation,
  SPLIT_PART(line_item_resource_id, 'distribution/', 2) as split_line_item_resource_id,
  SUM(CAST(line_item_usage_amount AS double)) as sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) as sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND line_item_product_code = 'AmazonCloudFront'
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d'), -- automation_timerange_dateformat
  product_region,
  product_product_family,
  line_item_operation,
  line_item_resource_id
ORDER BY -- automation_order_stmt
  sum_line_item_unblended_cost DESC;
      