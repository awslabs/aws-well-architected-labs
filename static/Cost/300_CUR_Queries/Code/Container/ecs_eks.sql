SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  SPLIT_PART(line_item_resource_id,':',6) as split_line_item_resource_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  line_item_operation,
  line_item_product_code,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(line_item_unblended_cost) "sum_line_item_unblended_cost"
, sum(CASE
    WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "savings_plan_savings_plan_effective_cost"
    WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment")
    WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
    WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
    WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "reservation_effective_cost"
      ELSE "line_item_unblended_cost" END) "amortized_cost"
FROM
  ${table_name}
WHERE
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  and line_item_product_code in ('AmazonECS','AmazonEKS')
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount')
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  3,
  4,
  line_item_operation,
  line_item_product_code
ORDER BY
  day_line_item_usage_start_date,
  sum_line_item_unblended_cost,
  sum_line_item_usage_amount,
  line_item_operation;
