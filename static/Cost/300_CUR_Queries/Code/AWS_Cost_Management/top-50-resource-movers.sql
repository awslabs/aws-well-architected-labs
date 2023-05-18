-- modified: 2023-04-28
-- query_id: top-50-resource-movers
-- query_description: This query produces the top 50 moving resources by 1/ cost delta and 2/ change in percentage.  The parameters have been adjusted for comparison of resources from three days prior and two days prior as CUR can take up to 48 hours to update all estimated charges.  Additionally, this query only pulls resources with greater than $5 in unblended cost in order to reduce noise from resources which did not exist in one of the look back periods or spun up at the end of one of the look back periods.  These parameters may be adjusted as needed.  
-- query_columns: 
-- query_link: /cost/300_labs/300_cur_queries/queries/aws_cost_management/


SELECT
    a.line_item_usage_account_id AS "line_item_usage_account_id",
    old_line_item_resource_id,
    old_line_item_unblended_cost AS "cost_three_days_prior",
    new_line_item_unblended_cost AS "cost_two_days_prior",
    (new_line_item_unblended_cost - old_line_item_unblended_cost) AS "cost_delta",
    (((new_line_item_unblended_cost - old_line_item_unblended_cost)/old_line_item_unblended_cost)*100) AS "change_percentage",
    a.usage_date AS "date_three_days_prior",
    b.usage_date AS "date_two_days_prior",
    a.product_product_name AS "product_product_name"
FROM
(
    (
        SELECT
            distinct "line_item_resource_id" as old_line_item_resource_id,
            line_item_usage_account_id,
            product_product_name,
            DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') usage_date,
            sum(line_item_unblended_cost) as old_line_item_unblended_cost
        FROM
            ${table_name}
        WHERE
            "line_item_resource_id" <> ''
            AND line_item_unblended_cost > 5
            AND "line_item_usage_start_date" = current_date - INTERVAL '3' DAY
        GROUP BY
        1, -- resource id three days prior
        2, -- account id
        3, -- product name
        4 -- usage date
    ) a
        
    FULL OUTER JOIN
    ( 
        SELECT 
            distinct "line_item_resource_id" as new_line_item_resource_id,
            line_item_usage_account_id,
            product_product_name,
            DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') usage_date,
            SUM(line_item_unblended_cost) as new_line_item_unblended_cost
        FROM
            ${table_name}
        WHERE
            "line_item_resource_id" <> ''
            AND line_item_unblended_cost > 5
            AND "line_item_usage_start_date" = current_date - INTERVAL '2' DAY
        GROUP BY
        1, -- resource id two days prior
        2, -- account id
        3, -- product name
        4 -- usage date
    ) b ON a.old_line_item_resource_id = b.new_line_item_resource_id
)
ORDER BY
    5 DESC, -- cost delta   
    6 DESC -- change percentage
LIMIT 50