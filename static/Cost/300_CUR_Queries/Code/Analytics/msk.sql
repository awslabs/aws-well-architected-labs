SELECT 
 line_item_product_code, 
 line_item_line_item_description, 
 line_item_operation,
 SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost 
FROM 
 ${table_name}  
WHERE
 ${date_filter} 
 AND line_item_product_code = 'AmazonMSK'
 AND line_item_line_item_type NOT IN ('Tax','Refund','Credit')
GROUP BY
 line_item_product_code, 
 line_item_line_item_description, 
 line_item_operation
ORDER BY 
 sum_line_item_unblended_cost DESC;