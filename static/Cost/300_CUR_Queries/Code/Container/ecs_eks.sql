-- modified: 2022-12-13
-- query_id: ecs-eks
-- query_description: This query will output the daily cost and usage per resource, by operation and service, for Elastic Consainer Services, ECS and EKS, both unblended and amortized costs are shown.
-- query_columns: bill_payer_account_id,line_item_line_item_type,line_item_operation,line_item_product_code,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date
-- query_link: /cost/300_labs/300_cur_queries/queries/container/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  SPLIT_PART(line_item_resource_id,':',6) AS split_line_item_resource_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  line_item_operation,
  line_item_product_code,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(line_item_unblended_cost) sum_line_item_unblended_cost,
  SUM(CASE
    WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN savings_plan_savings_plan_effective_cost
    WHEN line_item_line_item_type = 'SavingsPlanRecurringFee' THEN (savings_plan_total_commitment_to_date - savings_plan_used_commitment)
    WHEN line_item_line_item_type = 'SavingsPlanNegation' THEN 0
    WHEN line_item_line_item_type = 'SavingsPlanUpfrontFee' THEN 0
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
    ELSE ine_item_unblended_cost 
  END) AS sum_amortized_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  and line_item_product_code IN ('AmazonECS','AmazonEKS')
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage','SavingsPlanRecurringFee','SavingsPlanNegation','SavingsPlanUpfrontFee')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  SPLIT_PART(line_item_resource_id,':',6),
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  line_item_operation,
  line_item_product_code
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date,
  sum_line_item_unblended_cost,
  sum_line_item_usage_amount,
  line_item_operation
;
