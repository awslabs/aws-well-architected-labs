-- modified: 2021-04-25
SELECT
    product_product_name,
    product_product_family,
    line_item_operation,
    pricing_unit,
    product_description,
    product_usage_family
FROM
    ${tableName}
WHERE
    line_item_line_item_type = 'Usage'
GROUP BY
    product_product_name,
    product_product_family,
    line_item_operation,
    pricing_unit,
    product_description,
    product_usage_family
ORDER BY
    product_product_name,
    product_product_family,
    line_item_operation,
    pricing_unit,
    product_description,
    product_usage_family;
