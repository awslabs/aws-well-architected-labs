-- modified: 2021-06-16
-- query_id: data-transfer-regional
-- query_description: This query provides daily unblended cost and usage information about Data Transfer Regional (Inter-AZ) usage including resource id that sourced the traffic, the product code corresponding to the source traffic.
-- query_columns: 
-- query_link: /cost/300_labs/300_cur_queries/queries/networking__content_delivery/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  line_item_product_code,
  product_product_family,
  product_region,
  line_item_line_item_description,
  line_item_resource_id,
  sum(line_item_unblended_cost) AS sum_line_item_unblended_cost
FROM 
  ${table_name} -- automation_tablename
WHERE -- automation_tablename
  ${date_filter} -- automation_timerange_year_month
  AND line_item_line_item_description LIKE '%regional data transfer%'
GROUP BY  -- automation_groupby_stmt
  bill_payer_account_id, 
  line_item_usage_account_id, 
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m'), -- automation_timerange_dateformat
  line_item_product_code,
  product_product_family,
  product_region,
  line_item_line_item_description,
  line_item_resource_id
ORDER BY -- automation_order_stmt
  sum_line_item_unblended_cost DESC
;