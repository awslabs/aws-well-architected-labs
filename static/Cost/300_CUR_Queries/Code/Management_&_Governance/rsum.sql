-- modified: 2021-04-25
-- query_id: region_usage
-- query_description: Query transforms your billing data into a summarized view of your usage of AWS services by region and availability zone.
-- query_columns: bill_billing_entity,line_item_availability_zone,line_item_unblended_cost,product_product_name,product_region
-- query_link: /cost/300_labs/300_cur_queries/queries/management__governance/#regional-service-usage-mapping

SELECT -- automation_select_stmt
  CASE
    WHEN ("bill_billing_entity" = 'AWS Marketplace' AND "line_item_line_item_type" NOT LIKE '%Discount%') THEN "product_product_name"
    WHEN ("product_product_name" = '') THEN "line_item_product_code" ELSE "product_product_name" END "product_name",
    CASE product_region
      WHEN NULL THEN 'Global'
      WHEN '' THEN 'Global'
      WHEN 'global' THEN 'Global'
      ELSE product_region
    END AS product_region,
    line_item_availability_zone, 
    sum(line_item_unblended_cost) sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
line_item_usage_start_date >= now() - interval '30' day 
AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  1, 
  line_item_product_code, 
  line_item_availability_zone, 
  product_region
HAVING sum(line_item_unblended_cost) > 0
ORDER BY -- automation_order_stmt
  product_region, 
  sum_line_item_unblended_cost DESC
;
