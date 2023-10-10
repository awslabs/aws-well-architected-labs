-- modified: 2023-04-10
-- query_id: savings-plans-utilization
-- query_description: This query pulls all ACTIVE Savings Plan ARNs and produces their utilization for last month.  This query will give you a very granular look at which Savings Plan purchases were not being utilized to their full extent last month. 
-- query_columns: 
-- query_link: /cost/300_labs/300_cur_queries/queries/aws_cost_management/

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
  TRY_CAST(((SUM(TRY_CAST(savings_plan_used_commitment AS DECIMAL(16, 8))) / SUM(TRY_CAST(savings_plan_total_commitment_to_date AS DECIMAL(16, 8))))) AS DECIMAL(16, 8)) AS calc_savings_plan_utilization_percent
FROM
  ${table_name}
WHERE 
  CAST("concat"("year", '-', "month", '-01') AS date) = "date_trunc"('month', current_date) - INTERVAL  '1' MONTH --last month
  AND savings_plan_savings_plan_a_r_n <> ''
  AND line_item_line_item_type = 'SavingsPlanRecurringFee'
  AND try_cast(date_parse(SPLIT_PART(savings_plan_end_time, 'T', 1), '%Y-%m-%d') as date) > cast(current_date as date) --res exp time after today's date
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
  calc_savings_plan_utilization_percent DESC,
  day_savings_plan_end_time,
  split_savings_plan_savings_plan_a_r_n,
  month_line_item_usage_start_date;