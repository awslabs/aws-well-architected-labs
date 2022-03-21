-- modified: 2022-03-21
-- query_id: refund-credit-detail
-- query_description: This query provides a list of refunds and credits issued. Output is grouped by payer, linked account, month, line item type, service, and line item description. This allows for analysis of refunds and credits along any of these grouped dimensions. For example, "what refunds or credits were issued to account 111122223333 for service ABC in January 2022?" or "what was the total refund issued across all accounts for payer 444455556666 with line item description XYZ?" 

SELECT
  bill_payer_account_id,
  line_item_usage_account_id, 
  DATE_TRUNC('month',line_item_usage_start_date) as month_line_item_usage_start_date,
  line_item_line_item_type,
   CASE
    WHEN (bill_billing_entity = 'AWS Marketplace' AND line_item_line_item_type NOT LIKE '%Discount%') THEN product_product_name
    WHEN (product_servicecode = '') THEN line_item_product_code
    ELSE product_servicecode
  END case_service,
  line_item_line_item_description,
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost
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
  5, --refers to case_service
  line_item_line_item_description
ORDER BY
  month_line_item_usage_start_date ASC,
  sum_line_item_unblended_cost ASC;