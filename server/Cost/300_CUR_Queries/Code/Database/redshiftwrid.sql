-- modified: 2021-04-25
-- query_id: redshift
-- query_description: This query will provide daily unblended and amortized cost as well as usage information per linked account for Amazon Redshift. 
-- query_columns: bill_payer_account_id,line_item_line_item_type,line_item_operation,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_start_date,line_item_usage_type,pricing_term,product_instance_type,product_product_family,product_usage_family
-- query_link: /cost/300_labs/300_cur_queries/queries/database/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  product_instance_type,
  SPLIT_PART(line_item_resource_id,':',7) AS split_line_item_resource_id,
  line_item_operation,
  line_item_usage_type,
  line_item_line_item_type,
  pricing_term,
  product_usage_family,
  product_product_family,
  SUM(CASE 
    WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN line_item_usage_amount 
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN line_item_usage_amount 
    WHEN line_item_line_item_type = 'Usage' THEN line_item_usage_amount 
    ELSE 0 
  END) AS sum_line_item_usage_amount,
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost,
  SUM(CASE
    WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN savings_plan_savings_plan_effective_cost 
    WHEN line_item_line_item_type = 'SavingsPlanRecurringFee' THEN savings_plan_total_commitment_to_date - savings_plan_used_commitment 
    WHEN line_item_line_item_type = 'SavingsPlanNegation' THEN 0
    WHEN line_item_line_item_type = 'SavingsPlanUpfrontFee' THEN 0
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost  
    WHEN line_item_line_item_type = 'RIFee' THEN reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee
    WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN 0 
    ELSE line_item_unblended_cost 
  END) AS sum_amortized_cost,
  SUM(CASE
    WHEN line_item_line_item_type = 'SavingsPlanRecurringFee' THEN -savings_plan_amortized_upfront_commitment_for_billing_period
    WHEN line_item_line_item_type = 'RIFee' THEN -reservation_amortized_upfront_fee_for_billing_period 
    ELSE 0 
  END) AS sum_ri_sp_trueup,
  SUM(CASE
    WHEN line_item_line_item_type = 'SavingsPlanUpfrontFee' THEN line_item_unblended_cost
    WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN line_item_unblended_cost
    ELSE 0 
  END) AS ri_sp_upfront_fees
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND product_product_name = 'Amazon Redshift'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  product_instance_type,
  SPLIT_PART(line_item_resource_id,':',7),
  line_item_operation,
  line_item_usage_type,
  line_item_line_item_type,
  pricing_term,
  product_usage_family,
  product_product_family
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date,
  product_product_family,
  sum_line_item_unblended_cost DESC
;
