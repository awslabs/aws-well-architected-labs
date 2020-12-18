SELECT 
    DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') AS month_line_item_usage_start_date,
    bill_bill_type,
    CASE
        WHEN ("product_product_family" = 'Data Transfer') THEN 'Data Transfer' ELSE replace(replace(replace("product_product_name", 'Amazon '),'Amazon'),'AWS ') END "product_product_name",
    product_location,
    line_item_line_item_description,
    sum(line_item_unblended_cost) AS round_sum_line_item_unblended_cost,
    sum(line_item_usage_amount) AS sum_line_item_usage_amount
FROM 
      ${table_name}
WHERE
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
GROUP BY 1,
         bill_bill_type,
         3,
         product_location,
         line_item_line_item_description
HAVING sum(line_item_usage_amount) > 0
ORDER BY month_line_item_usage_start_date,
         bill_bill_type,
         product_product_name,
         product_location,
         line_item_line_item_description;
