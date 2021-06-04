-- modified: 2021-05-04
-- query_id: unblended_cost_by_charge_type
-- query_description: Display all charge types unblended cost, includes ssavings plans cost, reservation cost, support costs, refunds, credits and tax.
-- query_columns: bill_payer_account_id,line_item_line_item_type,line_item_unblended_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/gobal/#cost-by-charge-type

SELECT bill_payer_account_id, -- automation_select_stmt
    CASE 
      WHEN (line_item_line_item_type = 'Fee' AND product_product_name = 'AWS Premium Support') THEN 'Support fee'
      WHEN (line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '') THEN 'Upfront reservation fee'
      ELSE line_item_line_item_type 
    END charge_type,
    line_item_line_item_description,
    round(sum(line_item_unblended_cost),2) sum_unblended_cost
FROM -- automation_from_stmt
  ${table_name}
WHERE -- automation_where_stmt
 ${date_filter}
GROUP BY -- automation_groupby_stmt
bill_payer_account_id,
2,  -- reference to charge_type case statement
line_item_line_item_description
ORDER BY -- automation_order_stmt
sum_unblended_cost DESC
;
