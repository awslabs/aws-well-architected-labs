-- modified: 2021-04-25
-- query_id: network-usage
-- query_description: This query provides daily unblended cost and usage information about AWS Network Usage including VPCPeering, PublicIP, InterZone, LoadBalancing, and resource id. 
-- query_columns: bill_payer_account_id,line_item_operation,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date
-- query_link: /cost/300_labs/300_cur_queries/queries/networking__content_delivery/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  line_item_operation,
  line_item_resource_id,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND line_item_operation IN (
    'LoadBalancing-PublicIP-In',
    'LoadBalancing-PublicIP-Out',
    'InterZone-In',
    'InterZone-Out',
    'PublicIP-In',
    'PublicIP-Out',
    'VPCPeering-In',
    'VPCPeering-Out'
  )
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), -- automation_timerange_dateformat
  line_item_operation,
  line_item_resource_id
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date ASC,
  sum_line_item_usage_amount DESC,
  sum_line_item_unblended_cost DESC;