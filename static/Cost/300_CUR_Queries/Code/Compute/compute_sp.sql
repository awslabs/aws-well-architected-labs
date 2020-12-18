SELECT  
  bill_payer_account_id,
  bill_billing_period_start_date,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
  savings_plan_savings_plan_a_r_n,
  line_item_product_code,
  line_item_usage_type,
  sum(line_item_usage_amount) sum_line_item_usage_amount,
  line_item_line_item_description,
  pricing_public_on_demand_rate,
  sum(pricing_public_on_demand_cost) AS sum_pricing_public_on_demand_cost,
  savings_plan_savings_plan_rate,
  sum(savings_plan_savings_plan_effective_cost) AS sum_savings_plan_savings_plan_effective_cost
FROM ${table_name}
WHERE
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND line_item_line_item_type LIKE 'SavingsPlanCoveredUsage'
GROUP BY  
  bill_payer_account_id, 
  bill_billing_period_start_date, 
  line_item_usage_account_id, 
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
  savings_plan_savings_plan_a_r_n, 
  line_item_product_code, 
  line_item_usage_type, 
  line_item_unblended_rate, 
  line_item_line_item_description, 
  pricing_public_on_demand_rate, 
  savings_plan_savings_plan_rate
ORDER BY
  sum_pricing_public_on_demand_cost DESC