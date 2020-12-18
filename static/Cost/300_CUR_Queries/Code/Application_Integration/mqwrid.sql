SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  product_broker_engine,
  line_item_usage_type,
  product_product_family,
  pricing_unit,
  pricing_term,
  SPLIT_PART(line_item_usage_type, ':', 2) AS split_line_item_usage_type,
  SPLIT_PART(line_item_resource_id, ':', 7) AS split_line_item_resource_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  line_item_operation,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM
  ${table_Name}
WHERE
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND product_product_name = 'Amazon MQ'
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  product_broker_engine,
  product_product_family,
  pricing_unit,
  pricing_term,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  line_item_usage_type,
  line_item_resource_id,
  line_item_operation
ORDER BY
  day_line_item_usage_start_date,
  sum_line_item_unblended_cost DESC,
  split_line_item_usage_type;