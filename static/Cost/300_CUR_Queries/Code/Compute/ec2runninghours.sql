SELECT 
  year,
  month,
  bill_billing_period_start_date,
  product_instance_type,
  date_trunc('hour', line_item_usage_start_date) as hour_line_item_usage_start_date, 
  bill_payer_account_id, 
  line_item_usage_account_id, 
  (CASE
    WHEN (savings_plan_savings_plan_a_r_n <> '') THEN
      'SavingsPlan'
    WHEN (reservation_reservation_a_r_n <> '') THEN
      'Reserved'
    WHEN (line_item_usage_type LIKE '%Spot%') THEN
      'Spot'
    ELSE 'OnDemand' END) as purchase_option, 
    sum(CASE
      WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN
        savings_plan_savings_plan_effective_cost
      WHEN line_item_line_item_type = 'DiscountedUsage' THEN
        reservation_effective_cost
      WHEN line_item_line_item_type = 'Usage' THEN
        line_item_unblended_cost
      ELSE 0 END) as amortized_cost, 
  round(sum(line_item_usage_amount), 2) usage_quantity
FROM ${table_name}
WHERE 
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND ( (line_item_product_code = 'AmazonEC2')
        AND (product_servicecode <> 'AWSDataTransfer')
        AND (line_item_operation LIKE '%RunInstances%')
        AND (line_item_usage_type NOT LIKE '%DataXfer%') 
      )
  AND (
        (line_item_line_item_type = 'Usage')
        OR (line_item_line_item_type = 'SavingsPlanCoveredUsage')
        OR (line_item_line_item_type = 'DiscountedUsage')
      )
GROUP BY  
  year, 
  month, 
  bill_billing_period_start_date,  
  product_instance_type,
  date_trunc('hour', line_item_usage_start_date),
  bill_payer_account_id,
  7,
  8
ORDER BY 
  usage_quantity DESC