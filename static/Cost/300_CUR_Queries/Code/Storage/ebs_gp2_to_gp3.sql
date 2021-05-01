-- modified: 2021-04-25
SELECT * FROM 
        (SELECT bill_payer_account_id,
        line_item_usage_account_id,
        product_location,
        product_region,
        month,
        year,
        pricing_public_on_demand_rate,
        line_item_resource_id,
        line_item_usage_type,
        product_volume_api_name AS ebs_type,

        sum(line_item_usage_amount) AS gb_charged,
        sum(line_item_unblended_cost) AS sum_line_item_unblended_cost,
        sum(line_item_usage_amount)*.088 AS gp3_price -- 0.088 eu-west-1 pricing
        , (sum(line_item_unblended_cost)-(sum(line_item_usage_amount)*.088)) AS gp3_savings -- 0.088 eu-west-1 pricing

        FROM ${table}
        WHERE ${date_filter}
        AND product_product_name = 'Amazon Elastic Compute Cloud'
        AND line_item_usage_type LIKE '%%EBS%%Volume%%'
        AND product_product_family IN ('Storage','System Operation')
        AND line_item_line_item_type = ('Usage')
        AND product_region = 'eu-west-1'
        AND product_volume_api_name = 'gp2'

        GROUP BY bill_payer_account_id, line_item_usage_account_id, month, line_item_usage_type, product_location, product_region, line_item_resource_id, pricing_public_on_demand_rate,product_volume_api_name, month, year
        ORDER BY sum_line_item_unblended_cost DESC)
        WHERE gb_charged < 1000;