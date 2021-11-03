-- modified: 2021-04-25
SELECT *
FROM
(
  (  
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id, 
      line_item_line_item_type,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      product_region,
      CASE
        WHEN line_item_usage_type LIKE '%Lambda-Edge-GB-Second%' THEN 'Lambda EDGE GB x Sec.'
        WHEN line_item_usage_type LIKE '%Lambda-Edge-Request%' THEN 'Lambda EDGE Requests'
        WHEN line_item_usage_type LIKE '%Lambda-GB-Second%' THEN 'Lambda GB x Sec.'
        WHEN line_item_usage_type LIKE '%Request%' THEN 'Lambda Requests'
        WHEN line_item_usage_type LIKE '%In-Bytes%' THEN 'Data Transfer (IN)'
        WHEN line_item_usage_type LIKE '%Out-Bytes%' THEN 'Data Transfer (Out)'
        WHEN line_item_usage_type LIKE '%Regional-Bytes%' THEN 'Data Transfer (Regional)'
        ELSE 'Other'
      END AS case_line_item_usage_type,
      line_item_resource_id,
      pricing_term,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost, 
      SUM(CASE
        WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN savings_plan_savings_plan_effective_cost
        WHEN line_item_line_item_type = 'SavingsPlanRecurringFee' THEN savings_plan_total_commitment_to_date - savings_plan_used_commitment
        WHEN line_item_line_item_type = 'SavingsPlanNegation' THEN 0 
        WHEN line_item_line_item_type = 'SavingsPlanUpfrontFee' THEN 0
        WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
        WHEN line_item_line_item_type = 'RIFee' THEN reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee
        WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN 0
        ELSE line_item_unblended_cost 
      END) AS sum_amortized_cost
    FROM ${table_name}
      WHERE ${date_filter}
      AND product_product_name = 'AWS Lambda'
      AND line_item_line_item_type LIKE '%Usage%'
      AND product_product_family IN ('Data Transfer', 'Serverless')
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      line_item_line_item_type,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      product_region,
      6, -- refers to case_line_item_usage_type
      line_item_resource_id,
      pricing_term
  )

  UNION

  (
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      line_item_line_item_type,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      product_region,
      CASE
        WHEN line_item_usage_type LIKE '%Lambda-Edge-GB-Second%' THEN 'Lambda EDGE GB x Sec.'
        WHEN line_item_usage_type LIKE '%Lambda-Edge-Request%' THEN 'Lambda EDGE Requests'
        WHEN line_item_usage_type LIKE '%Lambda-GB-Second%' THEN 'Lambda GB x Sec.'
        WHEN line_item_usage_type LIKE '%Request%' THEN 'Lambda Requests'
        WHEN line_item_usage_type LIKE '%In-Bytes%' THEN 'Data Transfer (IN)'
        WHEN line_item_usage_type LIKE '%Out-Bytes%' THEN 'Data Transfer (Out)'
        WHEN line_item_usage_type LIKE '%Regional-Bytes%' THEN 'Data Transfer (Regional)'
        ELSE 'Other'
      END AS case_line_item_usage_type,
      line_item_resource_id,
      savings_plan_offering_type,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(savings_plan_savings_plan_effective_cost AS DECIMAL(16,8))) AS sum_savings_plan_savings_plan_effective_cost,
      SUM(CASE
        WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN savings_plan_savings_plan_effective_cost
        WHEN line_item_line_item_type = 'SavingsPlanRecurringFee' THEN savings_plan_total_commitment_to_date - savings_plan_used_commitment
        WHEN line_item_line_item_type = 'SavingsPlanNegation' THEN 0
        WHEN line_item_line_item_type = 'SavingsPlanUpfrontFee' THEN 0
        WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
        WHEN line_item_line_item_type = 'RIFee' THEN reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee
        WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN 0
        ELSE line_item_unblended_cost 
      END) AS sum_amortized_cost
    FROM 
      ${table_name}
    WHERE 
      ${date_filter}
      AND product_product_name = 'AWS Lambda'
      AND product_product_family IN ('Data Transfer', 'Serverless')
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      line_item_line_item_type,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      product_region,
      6, --refers to case_line_item_usage_type
      line_item_resource_id,
      savings_plan_offering_type
  )
) AS aggregatedTable

ORDER BY
  day_line_item_usage_start_date,
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost
;
