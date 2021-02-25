SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  SPLIT_PART(SPLIT_PART(line_item_resource_id,':',6),'/',2) AS split_line_item_resource_id,
  CASE
    WHEN line_item_usage_type LIKE '%%Fargate-GB%%' THEN 'GB per hour'
    WHEN line_item_usage_type LIKE '%%Fargate-vCPU%%' THEN 'vCPU per hour'
  END AS case_line_item_usage_type,
  CASE line_item_line_item_type
    WHEN 'SavingsPlanCoveredUsage' THEN
      CASE savings_plan_offering_type
        WHEN 'ComputeSavingsPlans' THEN 'Compute Savings Plans'
        ELSE savings_plan_offering_type
      END
    WHEN 'SavingsPlanNegation' THEN
      CASE savings_plan_offering_type
        WHEN 'ComputeSavingsPlans' THEN 'Compute Savings Plans'
        ELSE savings_plan_offering_type
      END
    ELSE 
      CASE pricing_term
        WHEN 'OnDemand' THEN 'OnDemand'
        WHEN '' THEN 'Spot Instance'
        ELSE pricing_term
      END
  END AS case_pricing_term,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CASE pricing_term
    WHEN 'OnDemand' THEN line_item_unblended_cost
    WHEN '' THEN line_item_unblended_cost
    END) AS sum_line_item_unblended_cost,
  SUM(CASE
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
    AND line_item_product_code in ('AmazonECS')
    AND line_item_operation != 'ECSTask-EC2'
    AND product_product_family != 'Data Transfer'
    AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount')
  GROUP BY
    bill_payer_account_id,
    line_item_usage_account_id,
    3,
    4,
    5,
    6
  ORDER BY
    day_line_item_usage_start_date ASC,
    case_pricing_term,
    sum_line_item_usage_amount DESC;

