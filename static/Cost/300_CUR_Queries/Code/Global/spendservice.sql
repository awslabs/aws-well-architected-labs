SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') AS month_line_item_usage_start_date,
  CASE 
    WHEN ("line_item_line_item_type" = 'Usage' AND "product_product_family" = 'Data Transfer') THEN CONCAT('DataTransfer-',"line_item_product_code") ELSE "line_item_product_code" END "service_line_item_product_code"
  , sum(CASE
      WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0 ELSE "line_item_unblended_cost" END) "sum_line_item_unblended_cost"
  , sum(CASE
      WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "savings_plan_savings_plan_effective_cost" 
      WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment") 
      WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
      WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
      WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "reservation_effective_cost"  
      WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
      WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE "line_item_unblended_cost" END) "amortized_cost"
  , sum(CASE
      WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN (-"savings_plan_amortized_upfront_commitment_for_billing_period") 
      WHEN ("line_item_line_item_type" = 'RIFee') THEN (-"reservation_amortized_upfront_fee_for_billing_period")
      WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN (-"line_item_unblended_cost" ) ELSE 0 END) "ri_sp_trueup"
  , sum(CASE
      WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN "line_item_unblended_cost"
      WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN "line_item_unblended_cost"ELSE 0 END) "ri_sp_upfront_fees"
      
FROM
  ${table_name}
WHERE
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND line_item_usage_type != 'Route53-Domains' 
  AND line_item_line_item_type != 'Tax'
  AND line_item_line_item_type != 'EdpDiscount' 
  AND line_item_line_item_type != 'Credit' 
  AND line_item_line_item_type != 'Refund'
  AND line_item_line_item_type != 'BundledDiscount'
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  3,
  4
ORDER BY
  month_line_item_usage_start_date ASC,
  sum_line_item_unblended_cost DESC;

