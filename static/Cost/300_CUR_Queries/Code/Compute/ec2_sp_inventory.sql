-- modified: 2021-04-25
SELECT
  SPLIT_PART(savings_plan_savings_plan_a_r_n, '/', 2) AS split_savings_plan_savings_plan_a_r_n,
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m') AS month_line_item_usage_start_date,
  CASE
    savings_plan_offering_type
    WHEN 'EC2InstanceSavingsPlans' THEN 'EC2 Instance Savings Plans'
    WHEN 'ComputeSavingsPlans' THEN 'Compute Savings Plans'
    ELSE savings_plan_offering_type
  END AS "Type",
  savings_plan_region,
  DATE_FORMAT(
    from_iso8601_timestamp(savings_plan_start_time),
    '%Y-%m-%d'
  ) AS "Start Date",
  DATE_FORMAT(
    from_iso8601_timestamp(savings_plan_end_time),
    '%Y-%m-%d'
  ) AS "End Date",
  savings_plan_payment_option AS "savings_plan_payment_option",
  savings_plan_purchase_term AS "savings_plan_purchase_term",
  SUM(
    TRY_CAST(
      savings_plan_recurring_commitment_for_billing_period AS decimal(16, 8)
    )
  ) AS "Recurring commitment for billing period / Monthly Fee",
  SUM(
    TRY_CAST(
      savings_plan_total_commitment_to_date AS decimal(16, 8)
    )
  ) AS "Total Commit to Date",
  SUM(
    TRY_CAST(
      savings_plan_used_commitment AS decimal(16, 8)
    )
  ) AS "Used Commitment",
  avg(
    case
      when line_item_line_item_type = 'SavingsPlanRecurringFee' then TRY_CAST(
        savings_plan_total_commitment_to_date as decimal(8, 2)
      )
    end
  ) as "Hourly Commitment",
  TRY_CAST(
    (
      (
        SUM(
          TRY_CAST(
            savings_plan_used_commitment AS decimal(16, 8)
          )
        ) / SUM(
          TRY_CAST(
            savings_plan_total_commitment_to_date AS decimal(16, 8)
          )
        )
      ) * 100
    ) AS decimal(3, 0)
  ) AS "Utilization (%)"
FROM
  ${table_name}
WHERE 
  ${date_filter}
  AND savings_plan_savings_plan_a_r_n <> ''
  AND line_item_line_item_type = 'SavingsPlanRecurringFee'
GROUP BY
  savings_plan_savings_plan_a_r_n,
  bill_payer_account_id,
  line_item_usage_account_id,
  4,
  savings_plan_offering_type,
  savings_plan_region,
  savings_plan_start_time,
  savings_plan_end_time,
  savings_plan_payment_option,
  savings_plan_purchase_term
ORDER BY
  split_savings_plan_savings_plan_a_r_n,
  month_line_item_usage_start_date;