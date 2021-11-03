CREATE OR REPLACE VIEW ec2_cluster_costs_view AS 
SELECT
  "line_item_product_code"
, "line_item_usage_account_id"
, "line_item_resource_id"
, "line_item_usage_type"
, "sum"((CASE WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "line_item_usage_amount" WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "line_item_usage_amount" WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_usage_amount" ELSE 0 END)) "sum_line_item_usage_amount"
, "sum"("line_item_unblended_cost") "unblended_cost"
, "sum"((CASE WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "savings_plan_savings_plan_effective_cost" WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment") WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0 WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0 WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "reservation_effective_cost" WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee") ELSE "line_item_unblended_cost" END)) "sum_line_item_amortized_cost"
, "month"
, "year"
FROM
  ${CUR}
WHERE (((product_product_name = 'Amazon Elastic Compute Cloud') AND (("resource_tags_user_name" LIKE '%ECS%') OR ("resource_tags_user_name" LIKE '%ecs%'))) AND ((("line_item_usage_type" LIKE '%BoxUsage%') OR ("line_item_usage_type" LIKE '%Spot%')) OR (line_item_usage_type LIKE '%%EBS%%Volume%%')))
GROUP BY "resource_tags_user_name", "line_item_product_code", "line_item_usage_account_id", "line_item_resource_id", "line_item_usage_type", "month", "year"
