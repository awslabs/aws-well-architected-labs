SELECT 
 bill_payer_account_id,
 line_item_usage_account_id,
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
 1,2,3,4,5
ORDER BY 
 sum_line_item_unblended_cost DESC;