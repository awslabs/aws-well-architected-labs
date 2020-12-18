SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS day_line_item_usage_start_date,
  SPLIT_PART(SPLIT_PART(line_item_resource_id,'/',2),'+',1) AS split_webaclid_line_item_resource_id,
  SPLIT_PART(SPLIT_PART(line_item_resource_id,'/',2),'+',2) AS split_ruleid_line_item_resource_id,
  line_item_usage_type,
  product_group,
  product_group_description,
  product_location,
  product_location_type,
  line_item_line_item_description,
  pricing_unit,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${tableName}
WHERE
  (year = '2020' AND month IN ('1','01') OR year = '2020' AND month IN ('2','02'))
  AND product_product_name = 'AWS WAF'
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d'),
  line_item_resource_id,
  line_item_usage_type,
  product_group,
  product_group_description,
  product_location,
  product_location_type,
  line_item_line_item_description,
  pricing_unit
ORDER BY
  day_line_item_usage_start_date,
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost,
  product_group;
  