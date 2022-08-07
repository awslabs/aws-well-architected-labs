-- modified: 2021-04-25
-- query_id: config
-- query_description: This query will provide daily unblended and usage information per linked account for AWS Config.
-- query_columns: bill_payer_account_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,line_item_usage_type,product_region
-- query_link: /cost/300_labs/300_cur_queries/queries/management__governance/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  product_region,
  CASE
    WHEN line_item_usage_type LIKE '%%ConfigurationItemRecorded%%' THEN 'ConfigurationItemRecorded'
    WHEN line_item_usage_type LIKE '%%ActiveConfigRules%%' THEN 'ActiveConfigRules'
    WHEN line_item_usage_type LIKE '%%SecurityHubConfigRules%%' THEN 'SecurityHubConfigRules'
    WHEN line_item_usage_type LIKE '%%ConfigRuleEvaluations%%' THEN 'ConfigRuleEvaluations'      
    ELSE 'Others'
  END AS case_line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${tableName} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND product_product_name = 'AWS Config'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage') 
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), -- automation_timerange_dateformat
  product_region,
  line_item_usage_type
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date,
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost,
  case_line_item_usage_type
;
      