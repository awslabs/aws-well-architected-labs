-- modified: 2021-04-25
SELECT
  SPLIT_PART(savings_plan_savings_plan_a_r_n, '/', 2) AS split_savings_plan_savings_plan_a_r_n,
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m') AS month_line_item_usage_start_date,
  savings_plan_offering_type,
  savings_plan_region,
  DATE_FORMAT(FROM_ISO8601_TIMESTAMP(savings_plan_start_time),'%Y-%m-%d') AS day_savings_plan_start_time,
  DATE_FORMAT(FROM_ISO8601_TIMESTAMP(savings_plan_end_time),'%Y-%m-%d') AS day_savings_plan_end_time,
  savings_plan_payment_option,
  savings_plan_purchase_term,
  SUM(TRY_CAST(savings_plan_recurring_commitment_for_billing_period AS DECIMAL(16, 8))) AS sum_savings_plan_recurring_committment_for_billing_period,
  SUM(TRY_CAST(savings_plan_total_commitment_to_date AS DECIMAL(16, 8))) AS sum_savings_plan_total_commitment_to_date, 
  SUM(TRY_CAST(savings_plan_used_commitment AS DECIMAL(16, 8))) AS sum_savings_plan_used_commitment,
  AVG(CASE
    WHEN line_item_line_item_type = 'SavingsPlanRecurringFee' THEN TRY_CAST(savings_plan_total_commitment_to_date AS DECIMAL(8, 2))
  END) AS "Hourly Commitment",
  -- (used commitment / total commitment) * 100 = utilization %
  TRY_CAST(((SUM(TRY_CAST(savings_plan_used_commitment AS DECIMAL(16, 8))) / SUM(TRY_CAST(savings_plan_total_commitment_to_date AS DECIMAL(16, 8)))) * 100) AS DECIMAL(3, 0)) AS calc_savings_plan_utilization_percent
FROM
  ${table_name}
WHERE 
  ${date_filter}
  AND savings_plan_savings_plan_a_r_n <> ''
  AND line_item_line_item_type = 'SavingsPlanRecurringFee'
GROUP BY
  SPLIT_PART(savings_plan_savings_plan_a_r_n, '/', 2),
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m'),
  savings_plan_offering_type,
  savings_plan_region,
  DATE_FORMAT(FROM_ISO8601_TIMESTAMP(savings_plan_start_time),'%Y-%m-%d'),
  DATE_FORMAT(FROM_ISO8601_TIMESTAMP(savings_plan_end_time),'%Y-%m-%d'),
  savings_plan_payment_option,
  savings_plan_purchase_term
ORDER BY
  split_savings_plan_savings_plan_a_r_n,
  month_line_item_usage_start_date
  ;