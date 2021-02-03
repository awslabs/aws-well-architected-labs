 SELECT 
    bill_payer_account_id,
    line_item_usage_account_id,
    DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
    CASE 
        WHEN LOWER(line_item_usage_type) LIKE 'qs-user-enterprise%' THEN 'Users - Enterprise'
        WHEN LOWER(line_item_usage_type) LIKE 'qs-user-standard%' THEN 'Users - Standard'
        WHEN LOWER(line_item_usage_type) LIKE 'qs-reader-usage%' THEN 'Reader Usage'
        WHEN LOWER(line_item_usage_type) LIKE '%spice' THEN 'SPICE'  
        ELSE line_item_usage_type
    END as purchase_type_line_item_usage_type,
    SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
    SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM 
     ${table_name}
WHERE 
   year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
   AND product_product_name = 'Amazon QuickSight'
   AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY
   bill_payer_account_id,
   line_item_usage_account_id,
   DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
   CASE 
      WHEN LOWER(line_item_usage_type) LIKE 'qs-user-enterprise%' THEN 'Users - Enterprise'
      WHEN LOWER(line_item_usage_type) LIKE 'qs-user-standard%' THEN 'Users - Standard'
      WHEN LOWER(line_item_usage_type) LIKE 'qs-reader-usage%' THEN 'Reader Usage'
      WHEN LOWER(line_item_usage_type) LIKE '%spice' THEN 'SPICE'  
      ELSE line_item_usage_type
   END
ORDER BY
   month_line_item_usage_start_date,
   sum_line_item_unblended_cost DESC