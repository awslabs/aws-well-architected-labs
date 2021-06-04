-- modified: 2021-04-25

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  SPLIT_PART(savings_plan_savings_plan_a_r_n, '/', 2) AS savings_plan_savings_plan_a_r_n,
  savings_plan_offering_type,
  savings_plan_region,
  CASE 
  	WHEN line_item_product_code = 'AmazonECS' THEN 'Fargate'
  	WHEN line_item_product_code = 'AWSLambda' THEN 'Lambda'
  	ELSE product_instance_type_family 
  END AS case_instance_type_family,
  savings_plan_end_time,
  SUM(TRY_CAST(line_item_unblended_cost AS DECIMAL(16, 8))) AS sum_line_item_unblended_cost,
  SUM(TRY_CAST(savings_plan_savings_plan_effective_cost AS DECIMAL(16, 8))) AS sum_savings_plan_savings_plan_effective_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND savings_plan_savings_plan_a_r_n <> ''
  AND line_item_line_item_type = 'SavingsPlanCoveredUsage'
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  SPLIT_PART(savings_plan_savings_plan_a_r_n, '/', 2),
  savings_plan_offering_type,
  savings_plan_region,
  7, -- refers to case_instance_type_family
  savings_plan_end_time
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date
;
