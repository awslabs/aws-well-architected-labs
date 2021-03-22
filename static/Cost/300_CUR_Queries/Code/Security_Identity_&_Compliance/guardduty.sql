-- query_id: guardduty
-- query_description: This query provides daily unblended cost and usage information about Amazon GuardDuty Usage.
-- query_columns: bill_payer_account_id,line_item_usage_account_id,day_line_item_usage_start_date,line_item_usage_type,trim_product_group,pricing_unit,sum_line_item_usage_amount,sum_line_item_unblended_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/security_identity__compliance/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  line_item_usage_type,
  TRIM(REPLACE(product_group, 'Security Services - Amazon GuardDuty ', '')) AS trim_product_group,   
  pricing_unit, 
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
      (year = '2020' AND month IN ('1','01') OR year = '2020' AND month IN ('2','02'))
  AND product_product_name = 'Amazon GuardDuty'
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), -- automation_timerange_dateformat
  line_item_usage_type,
  product_group,
  pricing_unit
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date,
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost,
  trim_product_group;
  