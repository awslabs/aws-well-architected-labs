-- modified: 2021-10-07
-- query_id: amortized_cost_by_charge_type
-- query_description: This query provides amortized cost by charge type for a given month. The output includes payer account ID, the month, charge types and the amortized cost for the charge type. It closely matches Cost Explorer result when "show costs as" amortized cost is selected under the advanced options and grouped by charge type.
-- query_columns: bill_payer_account_id, charge_type, line_item_usage_start_date, amortized_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/global/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  CASE 
      WHEN (line_item_line_item_type = 'Fee' AND product_product_name = 'AWS Premium Support') THEN 'Support fee'
      WHEN (line_item_line_item_type = 'Fee' AND bill_billing_entity <> 'AWS') THEN 'Marketplace fee'
	  WHEN (line_item_line_item_type = 'DiscountedUsage') THEN 'Reservation applied usage'
      ELSE line_item_line_item_type 
    END charge_type,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m') AS month_line_item_usage_start_date
  , 
  round(sum(CASE
      WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost
      WHEN (line_item_line_item_type = 'SavingsPlanRecurringFee') THEN round((savings_plan_total_commitment_to_date - savings_plan_used_commitment),8)
      WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN 0
      WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN 0
      WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost  
      WHEN (line_item_line_item_type = 'RIFee') THEN (reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee)
      WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN 0 ELSE line_item_unblended_cost END),2) sum_amortized_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  2, -- month_line_item_usage_start_date
  3 -- sum_amortized_cost
ORDER BY -- automation_order_stmt
  sum_amortized_cost DESC
  ;