-- modified: 2021-04-25
-- query_id: elasticcache
-- query_description: This query will output the total monthly sum per resource for all Amazon ElastiCache purchase options (including reserved instances) across all ElastiCache instances types.
-- query_columns: bill_payer_account_id,line_item_line_item_type,line_item_resource_id,line_item_usage_account_id,line_item_usage_start_date,line_item_usage_type
-- query_link: /cost/300_labs/300_cur_queries/queries/database/

select -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id, 
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') AS month_line_item_usage_start_date, -- automation_timerange_dateformat
  SPLIT_PART(line_item_resource_id,':',7) as split_line_item_resource_id,
  SPLIT_PART(line_item_usage_type ,':',2) AS split_line_item_usage_type,
 (CASE 
  WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN 'Reserved Instance'
  WHEN ("line_item_line_item_type" = 'Usage') THEN 'OnDemand' ELSE 'Others' END) purchase_option_line_item_line_item_type,
 sum(CASE 
  WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "line_item_usage_amount" 
  WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "line_item_usage_amount" 
  WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_usage_amount" ELSE 0 END) sum_line_item_usage_amount,
  sum(CASE
    WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0 ELSE "line_item_unblended_cost" END) sum_line_item_unblended_cost,
  sum(CASE
    WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "savings_plan_savings_plan_effective_cost"
    WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment")
    WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
    WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
    WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "reservation_effective_cost"
    WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
    WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE "line_item_unblended_cost" END) "amortized_cost",
  sum(CASE
    WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN (-"savings_plan_amortized_upfront_commitment_for_billing_period")
    WHEN ("line_item_line_item_type" = 'RIFee') THEN (-"reservation_amortized_upfront_fee_for_billing_period")
    WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN (-"line_item_unblended_cost" ) ELSE 0 END) "ri_sp_trueup",
  sum(CASE
    WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN "line_item_unblended_cost"
    WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN "line_item_unblended_cost"ELSE 0 END) "ri_sp_upfront_fees"      
FROM -- automation_from_stmt
     ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
    ${date_filter} -- automation_timerange_year_month
    AND product_product_name = 'Amazon ElastiCache'
    AND product_product_family = 'Cache Instance'
    AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
    DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01'), -- automation_timerange_dateformat
    bill_payer_account_id, 
    line_item_usage_account_id, 
    line_item_line_item_type, 
    line_item_resource_id, 
    line_item_usage_type
ORDER BY -- automation_order_stmt
    month_line_item_usage_start_date,
    sum_line_item_usage_amount desc, 
    sum_line_item_unblended_cost 