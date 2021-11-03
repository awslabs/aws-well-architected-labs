-- modified: 2021-04-25
SELECT bill_payer_account_id,
        line_item_usage_account_id,
        SUM(line_item_unblended_cost) sum_line_item_unblended_cost,
        ROUND(total_support_cost *((SUM(line_item_unblended_cost)/total_cost)),
        2) AS support_cost,
        ROUND(SUM(line_item_unblended_cost)/total_cost*100,
        2) AS percentage_of_total_cost,
        ${table_name}.year,
        ${table_name}.month
FROM ${table_name}

RIGHT JOIN -- Total AWS bill without support    
    (SELECT SUM(line_item_unblended_cost) AS total_cost,
            year,
            month
    FROM ${table_name}
    WHERE line_item_line_item_type <> 'Tax'
          AND line_item_product_code <> 'OCBPremiumSupport'
    GROUP BY  year, month ) AS aws_total_without_support
    ON (${table_name}.year = aws_total_without_support.year
        AND ${table_name}.month = aws_total_without_support.month)

RIGHT JOIN -- Total support    
    (SELECT SUM(line_item_unblended_cost) AS total_support_cost,
            year,
            month
    FROM ${table_name}
    WHERE line_item_product_code = 'OCBPremiumSupport'
          AND line_item_line_item_type <> 'Tax'
    GROUP BY  year, month ) AS aws_support
    ON (${table_name}.year=aws_support.year
        AND ${table_name}.month = aws_support.month)
        
WHERE line_item_line_item_type <> 'Tax'
      AND line_item_product_code <> 'OCBPremiumSupport'
      AND ${table_name}.year = '2020' AND (${table_name}.month BETWEEN '7' AND '9' OR ${table_name}.month BETWEEN '07' AND '09') 
GROUP BY  bill_payer_account_id, total_support_cost, total_cost, ${table_name}.year, ${table_name}.month, line_item_usage_account_id
ORDER BY  support_cost DESC;