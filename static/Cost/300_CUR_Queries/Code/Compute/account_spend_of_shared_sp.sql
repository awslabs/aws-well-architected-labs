-- modified: 2021-04-25
-- query_id: account_spend_of_shared_sp
-- query_description: This query focuses on surfacing accounts which have utilized AWS Savings Plans for which they are not a buyer.
-- query_columns: bill_payer_account_id,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_start_date,savings_plan_offering_type,savings_plan_savings_plan_effective_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/compute/
SELECT -- automation_select_stmt
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
  bill_payer_account_id,
  line_item_usage_account_id,
  savings_plan_offering_type,
  line_item_resource_id,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16, 8))) AS sum_line_item_unblended_cost,
  SUM(CAST(savings_plan_savings_plan_effective_cost AS DECIMAL(16, 8))) AS sum_savings_plan_savings_plan_effective_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND (bill_payer_account_id = '111122223333' -- automation_payer_account
  AND line_item_usage_account_id = '444455556666' -- automation_linked_account
  AND line_item_line_item_type = 'SavingsPlanCoveredUsage'
  AND savings_plan_savings_plan_a_r_n NOT LIKE '%444455556666%')
GROUP BY -- automation_groupby_stmt
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
  line_item_resource_id,
  line_item_usage_account_id,
  bill_payer_account_id,
  savings_plan_offering_type
ORDER BY -- automation_order_stmt
sum_savings_plan_savings_plan_effective_cost DESC
;
