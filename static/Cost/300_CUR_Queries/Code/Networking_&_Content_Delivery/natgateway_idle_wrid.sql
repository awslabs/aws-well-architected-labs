SELECT
    bill_payer_account_id,
    line_item_usage_account_id,
    SPLIT_PART(line_item_resource_id, ':', 6) split_line_item_resource_id,
    product_region,
    pricing_unit,
    sum_line_item_usage_amount,
    CAST(cost_per_resource AS decimal(16, 8)) AS "sum_line_item_unblended_cost"
FROM
    (
        SELECT
            line_item_resource_id,
            product_region,
            pricing_unit,
            line_item_usage_account_id,
            bill_payer_account_id,
            SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
            SUM(SUM(line_item_unblended_cost)) OVER (PARTITION BY line_item_resource_id) AS cost_per_resource,
            SUM(SUM(line_item_usage_amount)) OVER (PARTITION BY line_item_resource_id, pricing_unit) AS usage_per_resource_and_pricing_unit,
            COUNT(pricing_unit) OVER (PARTITION BY line_item_resource_id) AS pricing_unit_per_resource
        FROM
            ${table_name}
        WHERE
            line_item_product_code = 'AmazonEC2'
            AND line_item_usage_type like '%Nat%'
            -- get previous month
            AND month = cast(month(current_timestamp + -1 * interval '1' MONTH) AS VARCHAR)
            -- get year for previous month
            AND year = cast(year(current_timestamp + -1 * interval '1' MONTH) AS VARCHAR)
            AND line_item_line_item_type = 'Usage'
        GROUP BY
            line_item_resource_id,
            product_region,
            pricing_unit,
            line_item_usage_account_id,
            bill_payer_account_id
    )
WHERE
    -- filter only resources which ran more than half month (336 hrs)
    usage_per_resource_and_pricing_unit > 336
    AND pricing_unit_per_resource = 1
ORDER BY
    cost_per_resource DESC