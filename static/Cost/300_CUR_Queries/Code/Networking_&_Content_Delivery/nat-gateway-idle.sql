-- modified: 2021-07-08
-- query_id: nat-gateway-idle
-- query_description: This query shows cost and usage of NAT Gateways which didn't receive any traffic last month and ran for more than 336 hrs. Resources returned by this query could be considered for deletion.
-- query_columns: bill_payer_account_id,line_item_operation,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,pricing_unit
-- query_link: /cost/300_labs/300_cur_queries/queries/networking__content_delivery/

SELECT  -- automation_select_stmt
    bill_payer_account_id,
    line_item_usage_account_id,
    SPLIT_PART(line_item_resource_id, ':', 6) split_line_item_resource_id,
    product_region,
    pricing_unit,
    sum_line_item_usage_amount,
    CAST(cost_per_resource AS DECIMAL(16, 8)) AS sum_line_item_unblended_cost
FROM  -- automation_from_stmt
    (
        SELECT  -- automation_select_stmt
            line_item_resource_id,
            product_region,
            pricing_unit,
            line_item_usage_account_id,
            bill_payer_account_id,
            SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
            SUM(SUM(line_item_unblended_cost)) OVER (PARTITION BY line_item_resource_id) AS cost_per_resource,
            SUM(SUM(line_item_usage_amount)) OVER (PARTITION BY line_item_resource_id, pricing_unit) AS usage_per_resource_and_pricing_unit,
            COUNT(pricing_unit) OVER (PARTITION BY line_item_resource_id) AS pricing_unit_per_resource
        FROM  -- automation_from_stmt
            ${table_name}
        WHERE -- automation_where_stmt
            line_item_product_code = 'AmazonEC2'
            AND line_item_usage_type LIKE '%Nat%'
            -- get previous month
            AND CAST(month AS INT) = CAST(month(current_timestamp + -1 * INTERVAL '1' MONTH) AS INT)
            -- get year for previous month
            AND CAST(year AS INT) = CAST(year(current_timestamp + -1 * INTERVAL '1' MONTH) AS INT)
            AND line_item_line_item_type = 'Usage'
        GROUP BY -- automation_groupby_stmt
            line_item_resource_id,
            product_region,
            pricing_unit,
            line_item_usage_account_id,
            bill_payer_account_id
    )
WHERE -- automation_where_stmt
    -- filter only resources which ran more than half month (336 hrs)
    usage_per_resource_and_pricing_unit > 336
    AND pricing_unit_per_resource = 1
ORDER BY -- automation_order_stmt
    cost_per_resource DESC;