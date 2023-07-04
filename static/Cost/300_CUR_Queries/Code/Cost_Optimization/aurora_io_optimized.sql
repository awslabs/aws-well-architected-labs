with rds_aurora_io_optimized_data as (
-- io_usage
SELECT
    (compute_usage.compute_amortized_cost + storage_usage.storage_usage_unblended_cost + SUM(line_item_unblended_cost)) - (1.3 * compute_usage.compute_amortized_cost + 2.25 * storage_usage.storage_usage_unblended_cost) as savings,
    io_usage.line_item_usage_account_id as accounts,
    SUM(line_item_unblended_cost) as io_usage_unblended_cost,
    compute_usage.compute_amortized_cost as compute_usage_amortized_cost,
    storage_usage.storage_usage_unblended_cost as storage_usage_unblended_cost,
    io_usage.month,
    io_usage.year
FROM 
    ${table_name}
    io_usage,

    -- storage_usage
    (SELECT 
        line_item_usage_account_id,
        SUM(line_item_unblended_cost) as storage_usage_unblended_cost, 
        month, 
        year
    FROM 
         ${table_name}
    WHERE 
        line_item_usage_type LIKE '%Aurora:StorageUsage'
        AND line_item_usage_amount != 0.0
        ${date_filter} -- use partitions to optimize query
    GROUP BY 
        line_item_usage_account_id,
        month, 
        year
    ) storage_usage,

    -- compute_usage
    (SELECT 
        line_item_usage_account_id,
        SUM(line_item_usage_amount) AS compute_usage_usage_amount, 
        SUM(line_item_blended_cost) as compute_usage_blended_cost, 
        "sum"((CASE 
        WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "reservation_effective_cost" 
        WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee") 
        WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE "line_item_unblended_cost" 
        END)) "compute_amortized_cost", 
        month, 
        year
    FROM 
        ${table_name}
    WHERE 
        (line_item_resource_id LIKE '%cluster:cluster-%' OR line_item_resource_id LIKE '%db:%')
        AND product_database_engine IN ('Aurora MySQL','Aurora PostgreSQL')
        AND line_item_usage_amount != 0.0
        ${date_filter}  -- use partitions to optimize query
    GROUP BY 
        line_item_usage_account_id,
        month, 
        year
    ) compute_usage

-- io_usage continued
WHERE 
    line_item_usage_type LIKE '%Aurora:StorageIOUsage'
    AND storage_usage.line_item_usage_account_id = compute_usage.line_item_usage_account_id
    AND storage_usage.line_item_usage_account_id = io_usage.line_item_usage_account_id
    AND storage_usage.month = compute_usage.month
    AND storage_usage.year = compute_usage.year
    AND storage_usage.month = io_usage.month
    AND storage_usage.year = io_usage.year
    AND line_item_line_item_type IN ('DiscountedUsage', 'Usage')
    ${date_filter} -- use partitions to optimize query
GROUP BY 
    io_usage.line_item_usage_account_id,
    storage_usage.storage_usage_unblended_cost,
    compute_usage.compute_amortized_cost,
    storage_usage.storage_usage_unblended_cost,
    io_usage.month,
    io_usage.year
ORDER BY 
    savings DESC
)

SELECT 
    SUM(savings) as potential_savings, 
    accounts,
    io_usage_unblended_cost,
    compute_usage_amortized_cost,
    storage_usage_unblended_cost,
    month,
    year
FROM 
    rds_aurora_io_optimized_data
WHERE
    savings > 0  -- display only positive savings
    -- add additional account filtering here
GROUP BY 
    accounts,
    io_usage_unblended_cost,
    compute_usage_amortized_cost,
    storage_usage_unblended_cost,
    month,
    year
ORDER BY
    potential_savings DESC