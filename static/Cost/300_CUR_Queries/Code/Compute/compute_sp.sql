-- modified: 2021-04-25
-- query_id: compute_sp
-- query_description: This query will provide details about Compute usage that is covered by Savings Plans. The output will include detailed information about the usage type, usage amount, Savings Plans ARN, line item description, and Savings Plans effective savings as compared to On-Demand pricing. The public pricing on-demand cost will be summed and in descending order.
-- query_columns: bill_billing_period_start_date,bill_payer_account_id,line_item_line_item_description,line_item_product_code,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,line_item_usage_type,pricing_public_on_demand_cost,pricing_public_on_demand_rate,savings_plan_savings_plan_a_r_n,savings_plan_savings_plan_effective_cost,savings_plan_savings_plan_rate

SELECT -- automation_select_stmt
  bill_payer_account_id,
  bill_billing_period_start_date,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, -- automation_timerange_dateformat
  savings_plan_savings_plan_a_r_n,
  line_item_product_code,
  line_item_usage_type,
  SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
  line_item_line_item_description,
  pricing_public_on_demand_rate,
  SUM(pricing_public_on_demand_cost) AS sum_pricing_public_on_demand_cost,
  savings_plan_savings_plan_rate,
  SUM(savings_plan_savings_plan_effective_cost) AS sum_savings_plan_savings_plan_effective_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND line_item_line_item_type LIKE 'SavingsPlanCoveredUsage'
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id, 
  bill_billing_period_start_date, 
  line_item_usage_account_id, 
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'), -- automation_timerange_dateformat
  savings_plan_savings_plan_a_r_n, 
  line_item_product_code, 
  line_item_usage_type, 
  line_item_unblended_rate, 
  line_item_line_item_description, 
  pricing_public_on_demand_rate, 
  savings_plan_savings_plan_rate
ORDER BY -- automation_order_stmt
  sum_pricing_public_on_demand_cost DESC
;
