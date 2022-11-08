-- modified: 2022-03-31
-- query_id: imbalance-interaz-transfer
-- query_description: This query shows cost and usage of inbalance inter-az data transfer last month.  Resources returned by this query could be considered for rearchitecture to eliminate inter-az data transfers.
-- query_columns: bill_billing_period_start_date, line_item_usage_account_id, product_region, line_item_resource_id, line_item_usage_type, line_item_unblended_cost, line_item_product_code
-- query_link: /cost/300_labs/300_cur_queries/queries/networking__content_delivery/

SELECT
    line_item_usage_account_id as "account"
  , product_region as "region"
  , line_item_resource_id as "resource"
  , round (sum (IF ((line_item_operation = 'InterZone-In'), line_item_unblended_cost, 0)), 2) as "interaz_in_cost"
  , round (sum (IF ((line_item_operation = 'InterZone-Out'), line_item_unblended_cost, 0)), 2) as "interaz_out_cost"
FROM $(table_name)
WHERE (line_item_usage_type LIKE '%DataTransfer-Regional-Bytes%') 
  and (line_item_line_item_type = 'Usage')
  and ((line_item_operation = 'InterZone-In') or (line_item_operation = 'InterZone-Out')) 
  and (month(bill_billing_period_start_date) = month((current_date) - INTERVAL '1' month))
  and (year(bill_billing_period_start_date) = year((current_date) - INTERVAL '1' month))
GROUP BY line_item_usage_account_id, product_region, line_item_resource_id
HAVING  ((round (sum (IF ((line_item_operation LIKE 'InterZone-In'), line_item_unblended_cost, 0)), 2) / (round (sum (IF ((line_item_operation LIKE 'InterZone-Out'), line_item_unblended_cost, 0)), 2))) > 20)
    and ((round (sum (IF ((line_item_operation LIKE 'InterZone-In'), line_item_unblended_cost, 0)), 2)) > 1000)
ORDER BY "interaz_in_cost" DESC, "interaz_out_cost" DESC, account ASC, region ASC, resource ASC