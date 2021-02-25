SELECT line_item_product_code, 
line_item_line_item_description, 
round(sum(line_item_unblended_cost),2) as sum_line_item_unblended_cost 
FROM ${table_name}
WHERE
year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
AND line_item_product_code like '%AmazonEC2%'
AND line_item_line_item_type NOT IN ('Tax','Refund')
AND line_item_product_code like '%AmazonEC2%'
GROUP BY line_item_product_code, 
line_item_line_item_description
ORDER BY sum_line_item_unblended_cost desc

