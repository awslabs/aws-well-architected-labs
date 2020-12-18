SELECT *
FROM 
( 
  (
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      product_region,
      CASE
        WHEN line_item_usage_type LIKE '%%end-customer-mins' THEN 'End customer minutes'
        WHEN line_item_usage_type LIKE '%%chat-message' THEN 'Chat messages'
        ELSE 'Others'
      END AS UsageType,
      line_item_line_item_description,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND line_item_product_code = 'AmazonConnect'
      AND line_item_line_item_type = 'Usage'
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      product_region,
      line_item_usage_type,
      line_item_line_item_description
  )

  UNION ALL

  (
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      product_region,
      CASE
        WHEN line_item_usage_type LIKE '%%did-numbers' THEN 'DID days of use'
        WHEN line_item_usage_type LIKE '%%tollfree-numbers' THEN 'Toll free days of use'
        WHEN line_item_usage_type LIKE '%%did-inbound-mins' THEN 'Inbound DID minutes'
        WHEN line_item_usage_type LIKE '%%outbound-mins' THEN 'Outbound minutes'
        WHEN line_item_usage_type LIKE '%%tollfree-inbound-mins' THEN 'Inbound Toll Free minutes'
        ELSE 'Other'
      END AS UsageType,
      line_item_line_item_description,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND line_item_product_code = 'ContactCenterTelecomm'
      AND line_item_line_item_type = 'Usage'
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      product_region,
      line_item_usage_type,
      line_item_line_item_description
  )
) AS aggregatedTable

ORDER BY
  day_line_item_usage_start_date ASC,
  sum_line_item_unblended_cost DESC;