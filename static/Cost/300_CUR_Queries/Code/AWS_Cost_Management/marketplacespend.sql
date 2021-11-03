-- modified: 2021-04-25
-- query_id: marketplace-spend
-- query_description: This query provides AWS Marketplace subscription costs including subscription product name, associated linked account, and monthly total unblended cost. This query includes tax, however this can be filtered out in the WHERE clause. Please refer to the CUR Query Library Helpers section for assistance.
-- query_columns: bill_billing_entity,bill_payer_account_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_start_date,line_item_usage_start_time,product_product_name
-- query_link: /cost/300_labs/300_cur_queries/queries/aws_cost_management/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  CASE line_item_usage_start_date
    WHEN NULL THEN DATE_FORMAT(DATE_PARSE(CONCAT(SPLIT_PART('${table_name}','_',5),'01'),'%Y%m%d'),'%Y-%m-01') -- automation_timerange_dateformat
    ELSE DATE_FORMAT(line_item_usage_start_date,'%Y-%m-01') -- automation_timerange_dateformat
  END AS case_line_item_usage_start_time,
  bill_billing_entity,
  product_product_name,
SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND bill_billing_entity = 'AWS Marketplace'
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  3, --refers to case_line_item_usage_start_time,
  bill_billing_entity,
  product_product_name
ORDER BY -- automation_order_stmt
  case_line_item_usage_start_time ASC,
  sum_line_item_unblended_cost DESC
  ;
