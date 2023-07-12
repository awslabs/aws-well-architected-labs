-- modified: 2023-07-03
-- query_id: shield
-- query_description: This query provides daily unblended cost and usage information about resources protected by AWS Shield advanced. 
-- query_columns: bill_payer_account_id,line_item_usage_account_id,line_item_resource_id,line_item_operation,sum_line_item_unblended_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/security_identity__compliance/


SELECT
    bill_payer_account_id,
    line_item_usage_account_id,
    line_item_resource_id, 
    line_item_operation,
    SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM
    ${table_name}
WHERE
    line_item_product_code = 'AWSShield'
    AND product_product_family IN ('Shield-DataTransfer', 'Shield Advanced Monthly Fee')
    AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    ${date_filter}
GROUP BY
    bill_payer_account_id,
    line_item_usage_account_id,
    line_item_resource_id,
    line_item_operation
ORDER BY
    sum_line_item_unblended_cost DESC,
    line_item_resource_id