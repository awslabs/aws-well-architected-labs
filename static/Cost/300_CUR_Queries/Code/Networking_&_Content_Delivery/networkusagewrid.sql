SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  line_item_operation,
  line_item_resource_id,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name}
WHERE
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND line_item_operation IN (
    'LoadBalancing-PublicIP-In',
    'LoadBalancing-PublicIP-Out',
    'InterZone-In',
    'InterZone-Out',
    'PublicIP-In',
    'PublicIP-Out',
    'VPCPeering-In',
    'VPCPeering-Out'
  )
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount')
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  line_item_operation,
  line_item_resource_id
ORDER BY
  day_line_item_usage_start_date ASC,
  sum_line_item_usage_amount DESC,
  sum_line_item_unblended_cost DESC;