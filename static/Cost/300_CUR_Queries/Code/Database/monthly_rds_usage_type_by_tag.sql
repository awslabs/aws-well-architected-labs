SELECT
    line_item_usage_type,
    month,
    resource_tags_user_environment,
    SUM(CAST(line_item_blended_cost AS decimal(16,8))) AS sum_line_item_blended_cost
FROM 
    customer_all
WHERE year = '2020' AND (month BETWEEN '1' AND '12' OR month BETWEEN '01' AND '12')
AND line_item_product_code='AmazonRDS'
AND resource_tags_user_environment = 'dev'
GROUP BY  
    1,2,3
HAVING sum(line_item_blended_cost) > 0
ORDER BY 
    line_item_usage_type,
    month,
    resource_tags_user_environment;