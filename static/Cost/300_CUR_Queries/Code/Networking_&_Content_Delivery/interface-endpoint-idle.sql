-- modified: 2022-03-31
-- query_id: interface-endpoint-idle
-- query_description: This query shows cost and usage of Interface Endpoints which didn't receive significant traffic last month.  Resources returned by this query could be considered for deletion or rearchitecture for centralized deployment.
-- query_columns: bill_billing_period_start_date, line_item_usage_account_id, product_region, line_item_resource_id, line_item_usage_type, line_item_unblended_cost, line_item_blended_cost, line_item_product_code
-- query_link: /cost/300_labs/300_cur_queries/queries/networking__content_delivery/

SELECT
    line_item_usage_account_id as "account"
  , product_region as "region"
  , split_part(line_item_resource_id, ':', 6) as "resource"
  , round (sum (IF ((line_item_usage_type LIKE '%Endpoint-Hour%'), line_item_unblended_cost, 0)), 2) as "hourly_cost"
  , round (sum (IF ((line_item_usage_type LIKE '%Endpoint-Bytes%'), line_item_blended_cost, 0)), 2) as "traffic_cost"
FROM ${table_name}
WHERE (line_item_product_code = 'AmazonVPC') 
  and (line_item_line_item_type = 'Usage')
  and ((line_item_usage_type LIKE '%Endpoint-Hour%') or (line_item_usage_type LIKE '%Endpoint-Byte%'))
  and (month(bill_billing_period_start_date) = month((current_date) - INTERVAL '1' month))
  and (year(bill_billing_period_start_date) = year((current_date) - INTERVAL '1' month))
GROUP BY line_item_usage_account_id, product_region, line_item_resource_id
HAVING ((round (sum (IF ((line_item_usage_type LIKE '%Endpoint-Hour%'), line_item_unblended_cost, 0)), 2) / (round (sum (IF   ((line_item_usage_type LIKE '%Endpoint-Bytes%'), line_item_blended_cost, 0)), 2))) > 20)
ORDER BY "hourly_cost" DESC, "traffic_cost" DESC, account ASC, region ASC, resource ASC