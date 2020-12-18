SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  line_item_resource_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
  CASE  
    WHEN line_item_usage_type LIKE '%%NatGateway-Bytes' THEN 'NAT Gateway Data Processing Charge' -- Charge for per GB data processed by NatGateways
    WHEN line_item_usage_type LIKE '%%NatGateway-Hours' THEN 'NAT Gateway Hourly Charge'          -- Hourly charge for NAT Gateways
    ELSE line_item_usage_type
  END AS line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name}
WHERE
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND product_product_family = 'NAT Gateway'
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
  line_item_resource_id,
  line_item_usage_type
ORDER BY
  sum_line_item_unblended_cost DESC,
  sum_line_item_usage_amount;