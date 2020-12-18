SELECT bill_payer_account_id,
         line_item_usage_account_id,
         DATE_FORMAT(("line_item_usage_start_date"),
         '%Y-%m-%d') AS day_line_item_usage_start_date, product_instance_type, line_item_operation, line_item_usage_type, line_item_line_item_type, pricing_term, product_product_family , SPLIT_PART(line_item_resource_id,':',7) AS line_item_resource_id,
    CASE product_database_engine
    WHEN '' THEN
    'Not Applicable'
    ELSE product_database_engine
    END AS OS , sum(CASE
    WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN
    "line_item_usage_amount"
    WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN
    "line_item_usage_amount"
    WHEN ("line_item_line_item_type" = 'Usage') THEN
    "line_item_usage_amount"
    ELSE 0 END) "usage_quantity", sum ("line_item_unblended_cost") "unblended_cost", sum(CASE
    WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN
    "savings_plan_savings_plan_effective_cost"
    WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN
    ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment")
    WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN
    0
    WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN
    0
    WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN
    "reservation_effective_cost"
    WHEN ("line_item_line_item_type" = 'RIFee') THEN
    ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
    WHEN (("line_item_line_item_type" = 'Fee')
        AND ("reservation_reservation_a_r_n" <> '')) THEN
    0
    ELSE "line_item_unblended_cost" END) "amortized_cost", sum(CASE
    WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN
    (-"savings_plan_amortized_upfront_commitment_for_billing_period")
    WHEN ("line_item_line_item_type" = 'RIFee') THEN
    (-"reservation_amortized_upfront_fee_for_billing_period")
    ELSE 0 END) "ri_sp_trueup", sum(CASE
    WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN
    "line_item_unblended_cost"
    WHEN (("line_item_line_item_type" = 'Fee')
        AND ("reservation_reservation_a_r_n" <> '')) THEN
    "line_item_unblended_cost"ELSE 0 END) "ri_sp_upfront_fees"
FROM ${table_name}
WHERE year = '2020'
        AND (month
    BETWEEN '7'
        AND '9'
        OR month
    BETWEEN '07'
        AND '09')
        AND product_product_name = 'Amazon Relational Database Service'
        AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY  bill_payer_account_id, line_item_usage_account_id, DATE_FORMAT(("line_item_usage_start_date"),'%Y-%m-%d'), product_instance_type, line_item_operation, line_item_usage_type, line_item_line_item_type, pricing_term, product_product_family, product_database_engine, line_item_line_item_type, line_item_resource_id
ORDER BY  day_line_item_usage_start_date, usage_quantity, unblended_cost; 