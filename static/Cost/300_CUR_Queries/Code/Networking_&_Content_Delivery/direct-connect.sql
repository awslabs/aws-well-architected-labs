-- query_id: direct-connect
-- query_description: The query will output AWS Direct Connect charges split by Direct Connect port charges and Data Transfer charges for a specific resource using Direct Connect. 
-- query_columns: bill_payer_account_id,line_item_usage_account_id,month_line_item_usage_start_date,product_port_speed,product_product_family,product_transfer_type,product_from_location,product_to_location,product_direct_connect_location,pricing_unit,line_item_operation,line_item_resource_id,sum_line_item_usage_amount,sum_line_item_unblended_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/networking__content_delivery/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, -- automation_timerange_dateformat
  product_port_speed,
  product_product_family,
  product_transfer_type,
  product_from_location,
  product_to_location,
  product_direct_connect_location,
  pricing_unit,
  line_item_operation,
  line_item_resource_id,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09' ) -- automation_timerange_year_month
  AND product_product_name = 'AWS Direct Connect' 
  AND product_transfer_type NOT IN ('IntraRegion Inbound','InterRegion Inbound')
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'), -- automation_timerange_dateformat
  line_item_resource_id,
  line_item_operation,
  product_port_speed,
  product_product_family,
  product_transfer_type,
  product_from_location,
  product_to_location,
  product_direct_connect_location,
  pricing_unit
ORDER BY -- automation_order_stmt
  sum_line_item_unblended_cost Desc