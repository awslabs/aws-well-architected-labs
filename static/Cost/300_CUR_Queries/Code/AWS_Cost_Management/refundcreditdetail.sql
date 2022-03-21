SELECT
  bill_payer_account_id,
  line_item_usage_account_id, 
  DATE_FORMAT(line_item_usage_start_date, '%Y-%m') as month_line_item_usage_start_date,
  line_item_line_item_type,
  line_item_product_code,
  line_item_line_item_description,
  sum(line_item_unblended_cost) AS sum_line_item_unblended_cost
FROM
  ${tableName}
WHERE
  ${date_filter}
  AND line_item_unblended_cost < 0
  AND line_item_line_item_type <> 'SavingsPlanNegation'
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id, 
  DATE_TRUNC('month',line_item_usage_start_date),
  line_item_line_item_type,
  line_item_product_code,
  line_item_line_item_description
ORDER BY
  month_line_item_usage_start_date ASC,
  sum_line_item_unblended_cost ASC;