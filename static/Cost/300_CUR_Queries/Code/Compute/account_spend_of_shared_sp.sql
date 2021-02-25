SELECT year,
month,
bill_payer_account_id,
line_item_usage_account_id,
savings_plan_offering_type,
line_item_resource_id,
SUM(CAST(line_item_unblended_cost AS decimal(16, 8))) AS sum_line_item_unblended_cost,
SUM(CAST(savings_plan_savings_plan_effective_cost AS decimal(16, 8))) AS sum_savings_plan_savings_plan_effective_cost
FROM ${table_name}
WHERE
year = '2020'
AND (month BETWEEN '9' AND '12' OR month BETWEEN '09' AND '12')
AND (bill_payer_account_id = '111122223333'
AND line_item_usage_account_id = '444455556666'
AND line_item_line_item_type = 'SavingsPlanCoveredUsage'
AND savings_plan_savings_plan_a_r_n NOT LIKE '%444455556666%')
GROUP BY
year,
month,
line_item_resource_id,
line_item_usage_account_id,
bill_payer_account_id,
savings_plan_offering_type
ORDER BY sum_savings_plan_savings_plan_effective_cost DESC;