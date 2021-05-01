-- modified: 2021-04-25

select -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(("line_item_usage_start_date"),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  SPLIT_PART(savings_plan_savings_plan_a_r_n, '/', 2) AS savings_plan_savings_plan_a_r_n,
  CASE
    savings_plan_offering_type
    WHEN 'EC2InstanceSavingsPlans' THEN 'EC2 Instance Savings Plans'
    WHEN 'ComputeSavingsPlans' THEN 'Compute Savings Plans'
    ELSE savings_plan_offering_type
  END AS "Type",
  savings_plan_region,
  CASE 
  	WHEN product_product_name = 'Amazon EC2 Container Service' THEN 'Fargate'
  	WHEN product_product_name = 'AWS Lambda' THEN 'Lambda'
  	ELSE product_instance_type_family 
  END AS "Instance Type Family",
  SUM (TRY_CAST(line_item_unblended_cost as decimal(16, 8))) as "On Demand Cost",
  SUM(TRY_CAST(savings_plan_savings_plan_effective_cost AS decimal(16, 8))) as "Effective Cost",
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost, 
  savings_plan_end_time
  FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND savings_plan_savings_plan_a_r_n <> ''
  AND line_item_line_item_type = 'SavingsPlanCoveredUsage'
GROUP by -- automation_groupby_stmt
	      bill_payer_account_id,
      line_item_usage_account_id,
       DATE_FORMAT(("line_item_usage_start_date"),'%Y-%m-%d'), -- automation_timerange_dateformat
  savings_plan_savings_plan_a_r_n,
  savings_plan_offering_type,
  savings_plan_region,
  product_instance_type_family,
  product_product_name, 
  savings_plan_end_time
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date;
