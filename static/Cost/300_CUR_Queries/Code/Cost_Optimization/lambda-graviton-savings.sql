/* 
-- modified: 2022-11-17
-- query_id: lambda-graviton-savings
--  query_description: This query identifies savings for X86 lambda functions if they were to be migrated into ARM64
-- query_columns: 
-- query_link: 
*/
WITH x86_v_arm_spend AS (
SELECT
   line_item_resource_id      AS line_item_resource_id,
   bill_payer_account_id      AS bill_payer_account_id,
   line_item_usage_account_id AS line_item_usage_account_id,
   line_item_line_item_type AS line_item_line_item_type,
   CASE SUBSTR(line_item_usage_type, length(line_item_usage_type)-2)
      WHEN 'ARM' THEN 'arm64'
      ELSE 'x86_64'
   END AS "processor",
   CASE SUBSTR(line_item_usage_type, length(line_item_usage_type)-2)
      WHEN 'ARM' THEN 0
      ELSE line_item_unblended_cost * .2
   END AS "potential_arm_savings",
   SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost
FROM 
${table_name}
WHERE 
   line_item_product_code  = 'AWSLambda'
   AND line_item_operation = 'Invoke'
   AND ( 
      line_item_usage_type    LIKE '%Request%'
      OR line_item_usage_type LIKE '%Lambda-GB-Second%'
   )
   AND line_item_usage_start_date > CURRENT_DATE - INTERVAL '1' MONTH
   AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY 1,2,3,5,6,4
)
SELECT 
line_item_resource_id,
bill_payer_account_id,
line_item_usage_account_id,
line_item_line_item_type,
processor,
sum(sum_line_item_unblended_cost)           AS sum_line_item_unblended_cost,
sum(potential_arm_savings) AS "potential_arm_savings"
FROM 
x86_v_arm_spend
GROUP BY 2,3,1,5,4
