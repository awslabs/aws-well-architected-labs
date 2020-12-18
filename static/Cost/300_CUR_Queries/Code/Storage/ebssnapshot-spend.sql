SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS date_line_item_usage_start_date,
  product_region,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM
  ${tableName}
WHERE
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND product_product_name = 'Amazon Elastic Compute Cloud'
  AND line_item_usage_type LIKE '%%EBS%%Snapshot%%'
  AND product_product_family LIKE 'Storage Snapshot'
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d'),
  product_region
ORDER BY
  sum_line_item_unblended_cost DESC, 
  sum_line_item_usage_amount DESC,
  date_line_item_usage_start_date ASC; 