-- modified: 2023-3-24
-- query_id: ec2cpuspend
-- query_description: This query will provide the EC2 spend for CPU architectures (AMD, Intel, Graviton, Mac) by account.  The spend covers on-demand, savings plan, reserved instances, and spot.
-- query_columns: bill_billing_period_start_date,line_item_usage_account_id,product_physical_processor,product_usagetype,line_item_line_item_type,line_item_unblended_cost,savings_plan_savings_plan_effective_cost,reservation_effective_cost

SELECT
  DATE_FORMAT(bill_billing_period_start_date,'%Y-%m') as "billing_period"
, line_item_usage_account_id as "account_id"
, round 
    (sum 
      (IF ((product_physical_processor LIKE '%AMD%'), 
        (CASE 
            WHEN (product_usagetype LIKE '%SpotUsage%') THEN line_item_unblended_cost 
            WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost 
            WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost 
            WHEN (line_item_line_item_type LIKE 'Usage') THEN line_item_unblended_cost ELSE 0E0 END
        ), 
      0)
    ), 
  2) "amd_cost"
, round 
    (sum
      (IF (((product_physical_processor LIKE '%Intel%') OR (product_physical_processor LIKE '%Variable%')), 
        (CASE 
           WHEN (product_usagetype LIKE '%SpotUsage%') THEN line_item_unblended_cost 
           WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost 
           WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost 
           WHEN (line_item_line_item_type LIKE 'Usage') THEN line_item_unblended_cost ELSE 0E0 END
        ),
      0)
    ),
  2) "intel_cost"
, round 
    (sum
      (IF ((product_physical_processor LIKE '%Graviton%'), 
        (CASE 
           WHEN (product_usagetype LIKE '%SpotUsage%') THEN line_item_unblended_cost 
           WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost 
           WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost 
           WHEN (line_item_line_item_type LIKE 'Usage') THEN line_item_unblended_cost ELSE 0E0 END
        ),
      0)
    ),
  2) "graviton_cost"
, round 
    (sum
      (IF ((product_physical_processor LIKE 'Apple%'), 
        (CASE 
          WHEN (product_usagetype LIKE '%SpotUsage%') THEN line_item_unblended_cost 
          WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost 
          WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost 
          WHEN (line_item_line_item_type LIKE 'Usage') THEN line_item_unblended_cost ELSE 0E0 END
        ),
      0)
    ),
  2) "mac_cost" 
, round 
    (sum
      (CASE 
         WHEN (product_usagetype LIKE '%SpotUsage%') THEN line_item_unblended_cost 
         WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost 
         WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost 
         WHEN (line_item_line_item_type LIKE 'Usage') THEN line_item_unblended_cost ELSE 0E0 END
    ),
  2) "total_cost"
FROM
  ${table_name}
WHERE
  ${date_filter} 
  AND (product_product_name = 'Amazon Elastic Compute Cloud') 
  AND ((product_usagetype LIKE '%SpotUsage%') 
    OR (product_usagetype LIKE '%BoxUsage%') 
    OR (product_usagetype LIKE '%HostUsage%') 
    OR (product_usagetype LIKE '%DedicatedUsage%')
  ) 
  AND ((line_item_line_item_type = 'Usage')
    OR (line_item_line_item_type = 'SavingsPlanCoveredUsage')
    OR (line_item_line_item_type = 'DiscountedUsage')
  )
GROUP BY 
  bill_billing_period_start_date, 
  line_item_usage_account_id
ORDER BY total_cost DESC;
