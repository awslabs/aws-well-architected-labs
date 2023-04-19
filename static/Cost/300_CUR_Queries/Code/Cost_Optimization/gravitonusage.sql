-- modified: 2023-01-31
-- query_id: gravitonusage
-- query_description: AWS Graviton processors are designed by AWS to deliver the best price performance ratio for cloud workloads, delivering up to 40% improvement over comparable current gen x86 processors. Due to the improved price performance, many organizations track Graviton usage as a KPI to drive cost-savings for their cloud workloads. Graviton-based EC2 instances are available, and many other AWS services such as Amazon Relational Database Service, Amazon ElastiCache, Amazon EMR, and Amazon OpenSearch also support Graviton-based instance types. This query provides detail on Graviton-based usage. Amortized cost, usage hours, and a count of unique resources are summed. Output is grouped by day, payer account ID, linked account ID, service, instance type, and region. Output is sorted by day (descending) and amortized cost (descending).

SELECT 
  DATE_TRUNC('day',line_item_usage_start_date) AS day_line_item_usage_start_date,
  bill_payer_account_id,
  line_item_usage_account_id,
  line_item_product_code,
  product_instance_type,
  product_region,
  SUM(CASE
    WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN savings_plan_savings_plan_effective_cost
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
    WHEN line_item_line_item_type = 'Usage' THEN line_item_unblended_cost
    ELSE 0 
  END) AS sum_amortized_cost, 
  SUM(line_item_usage_amount) as sum_line_item_usage_amount, 
  COUNT(DISTINCT(line_item_resource_id)) AS count_line_item_resource_id
FROM 
  ${table_name}
WHERE 
  ${date_filter}
  AND REGEXP_LIKE(line_item_usage_type, '.?[a-z]([1-9]|[1-9][0-9]).?.?[g][a-zA-Z]?\.')
  AND line_item_usage_type NOT LIKE '%EBSOptimized%' 
  AND (line_item_line_item_type = 'Usage'
    OR line_item_line_item_type = 'SavingsPlanCoveredUsage'
    OR line_item_line_item_type = 'DiscountedUsage'
  )
GROUP BY
  DATE_TRUNC('day',line_item_usage_start_date),
  bill_payer_account_id,
  line_item_usage_account_id,
  line_item_product_code,
  line_item_usage_type,
  product_instance_type,
  product_region
ORDER BY 
  day_line_item_usage_start_date DESC,
  sum_amortized_cost DESC
;
