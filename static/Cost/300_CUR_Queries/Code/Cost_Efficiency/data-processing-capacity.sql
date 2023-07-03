-- modified: 2023-04-09
-- query_id: data-processing-capacity.sql
-- query_description: Display the usage hours of service(s) using compute and order by largest to smallest number of hours. This query is useful for identifying the largest compute resources in use. The query can be modified to include additional resource granularity by uncommenting the line_item_usage_type and product_vcpu columns. 
SELECT 
    product_product_name as ProductName,
    product_product_family as ProductFamily,
    -- uncomment line_item_usage_type, product_vcpu and commas below for additional resource granularity
    -- line_item_usage_type,
    -- product_vcpu,
    ROUND(SUM(CAST(line_item_usage_amount AS double)),0) as sum_line_item_usage_amount_hours
FROM 
  ${table_name}
WHERE 
  -- optionally define data range (see query help section)
  ${date_filter}
  AND product_vcpu <> ''
  AND line_item_line_item_type like '%Usage%'
GROUP BY
    product_product_name,
    product_product_family
    -- ,
    -- product_vcpu,
    -- line_item_usage_type
ORDER BY
sum_line_item_usage_amount_hours DESC
-- ,
-- product_vcpu DESC
;
