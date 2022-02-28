-- modified: 2022-02-08
-- query_id: reservation_savings
-- query_description: This query provides an aggregated report of savings from purchased reservations across multiple services - EC2, Elasticache, OpenSearch (formerly Amazon ElasticSearch), and RDS. This is similar to what can be found in Cost Explorer Reservation Utilization reports, except aggregated across all services offering reservations, allowing for easier organizational reporting on total savings. Output can be used to identify savings per specific reservation ARN, as well as savings per service, savings per linked account, savings per region, and savings per specific instance/node type.
-- query_columns: bill_payer_account_id,line_item_usage_account_id,line_item_usage_start_date,line_item_line_item_type,line_item_product_code,reservation_reservation_a_r_n,line_item_usage_type,pricing_public_on_demand_cost,reservation_effective_cost,reservation_unused_amortized_upfront_fee_for_billing_period,reservation_unused_recurring_fee

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, -- automation_timerange_dateformat
  line_item_product_code,
  reservation_reservation_a_r_n,
  SPLIT_PART(line_item_usage_type,':', 2) AS split_line_item_usage_type,
  SPLIT_PART(reservation_reservation_a_r_n,':', 4) AS split_product_region, -- split ARN for region due to product_region inconsistencies
  SUM(CAST(pricing_public_on_demand_cost AS DECIMAL (16,8))) AS sum_pricing_public_on_demand_cost,
  SUM(CASE
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
    WHEN line_item_line_item_type = 'RIFee' THEN reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee
    WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN 0
  END) AS sum_case_reservation_effective_cost,
  SUM(TRY_CAST(pricing_public_on_demand_cost AS DECIMAL(16, 8))) 
    - SUM(CASE
        WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
        WHEN line_item_line_item_type = 'RIFee' THEN reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee
        WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN 0
      END) AS sum_case_reservation_net_savings
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter}
  AND line_item_product_code IN ('AmazonEC2','AmazonRedshift','AmazonRDS','AmazonES','AmazonElastiCache')  
  AND line_item_line_item_type IN ('Fee','RIFee','DiscountedUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
  line_item_product_code,
  reservation_reservation_a_r_n,
  SPLIT_PART(line_item_usage_type,':', 2),
  SPLIT_PART(reservation_reservation_a_r_n,':', 4)
ORDER BY -- automation_order_stmt
  month_line_item_usage_start_date,
  line_item_product_code,
  split_line_item_usage_type
  ;