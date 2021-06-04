-- modified: 2021-04-25

SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  product_region,
  CASE
    WHEN line_item_usage_type LIKE '%end-customer-mins' THEN 'End customer minutes'
    WHEN line_item_usage_type LIKE '%chat-message' THEN 'Chat messages'
    WHEN line_item_usage_type LIKE '%did-numbers' THEN 'DID days of use'
    WHEN line_item_usage_type LIKE '%tollfree-numbers' THEN 'Toll free days of use'
    WHEN line_item_usage_type LIKE '%did-inbound-mins' THEN 'Inbound DID minutes'
    WHEN line_item_usage_type LIKE '%outbound-mins' THEN 'Outbound minutes'
    WHEN line_item_usage_type LIKE '%tollfree-inbound-mins' THEN 'Inbound Toll Free minutes'
    ELSE 'Others'
  END AS case_line_item_usage_type,
  line_item_line_item_description,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name}
WHERE
  ${date_filter}
  AND line_item_product_code IN ('AmazonConnect', 'ContactCenterTelecomm')
  AND line_item_line_item_type = 'Usage'
GROUP BY
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  product_region,
  line_item_usage_type,
  line_item_line_item_description
ORDER BY
  day_line_item_usage_start_date ASC,
  sum_line_item_unblended_cost DESC
;
