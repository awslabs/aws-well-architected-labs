-- modified: 2021-07-08
-- query_id: nat-gateway-idle
-- query_description: This query shows cost and usage of NAT Gateways which didn't receive any traffic last month and ran for more than 336 hrs. Resources returned by this query could be considered for deletion.
-- query_columns: bill_payer_account_id,line_item_operation,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,pricing_unit
-- query_link: /cost/300_labs/300_cur_queries/queries/networking__content_delivery/

SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
  CASE
	WHEN line_item_resource_id LIKE 'arn%' THEN CONCAT(SPLIT_PART(line_item_resource_id,'/',2),' - ',product_location)
	ELSE CONCAT(line_item_resource_id,' - ',product_location)
  END AS line_item_resource_id,
  product_location,
  product_attachment_type,
  pricing_unit,
  CASE
	WHEN pricing_unit = 'hour' THEN 'Hourly charges'
	WHEN pricing_unit = 'GigaBytes' THEN 'Data processing charges'
  END AS pricing_unit,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name}
WHERE
  ${date_filter}
  AND product_group = 'AWSTransitGateway' 
  AND line_item_line_item_type IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
  line_item_resource_id,
  product_location,
  product_attachment_type,
  pricing_unit
ORDER BY
  sum_line_item_unblended_cost DESC,
  month_line_item_usage_start_date,
  sum_line_item_usage_amount,
  product_attachment_type
;
