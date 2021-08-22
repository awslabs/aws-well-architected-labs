
WITH allresources AS (
    SELECT
    line_item_usage_account_id
    , line_item_product_code
    , count(DISTINCT line_item_resource_id) AS count_resource
    , CASE
        WHEN resource_tags_user_name = '' THEN 'NoTag'
        ELSE 'Tag'
        END AS Tag_Status
    FROM mybillingreport
    WHERE  ${date_filter}
    GROUP BY line_item_usage_account_id, line_item_product_code, 4 -- 4 represents the Tag_Status column
)
SELECT
        line_item_usage_account_id
    , line_item_product_code
    , sum(count_resource) AS "resources"
    , sum(CASE WHEN Tag_Status = 'Tag' THEN count_resource ELSE 0 END) AS "tagged_resources"
    , round(sum(CASE WHEN Tag_Status = 'Tag' THEN CAST(count_resource AS double) ELSE 0. END)/ sum(count_resource) * 100., 1) AS "percentage_tagged"
FROM allresources
GROUP BY 1,2