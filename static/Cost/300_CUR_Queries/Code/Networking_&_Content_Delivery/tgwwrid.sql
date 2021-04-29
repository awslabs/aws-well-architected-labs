-- modified: 2021-04-25
-- query_id: transit-gateway
-- query_description: This query provides monthly unblended cost and usage information about AWS Transit Gateway Usage including attachment type, and resource id.
-- query_columns: bill_payer_account_id,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,pricing_unit,product_attachment_type,product_location
-- query_link: /cost/300_labs/300_cur_queries/queries/networking__content_delivery/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, -- automation_timerange_dateformat
  CASE
    WHEN line_item_resource_id like 'arn%' THEN CONCAT(SPLIT_PART(line_item_resource_id,'/',2),' - ',product_location)
    ELSE CONCAT(line_item_resource_id,' - ',product_location)
  END AS line_item_resource_id,
  product_location,
  product_attachment_type,
  pricing_unit,
  CASE
    WHEN pricing_unit = 'hour' THEN 'Hourly charges'
    WHEN pricing_unit = 'GigaBytes' THEN 'Data processing charges'
  END AS pricing_unit,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND product_group = 'AWSTransitGateway' 
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'), -- automation_timerange_dateformat
  line_item_resource_id,
  product_location,
  product_attachment_type,
  pricing_unit
ORDER BY -- automation_order_stmt
  sum_line_item_unblended_cost DESC,
  month_line_item_usage_start_date,
  sum_line_item_usage_amount,
  product_attachment_type;