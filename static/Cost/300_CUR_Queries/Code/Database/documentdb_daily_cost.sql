-- modified: 2021-07-15
-- query_id: documentdb
-- query_description: This query will output the total daily cost per DocumentDB cluster. The output will include detailed information about the resource id (cluster name) and usage type.  The unblended cost will be summed and in descending order. 
-- query_columns: bill_payer_account_id,line_item_unblended_cost,line_item_resource_id,line_item_usage_account_id,line_item_usage_amount,line_item_usage_type, product_region
-- query_link: /cost/300_labs/300_cur_queries/queries/database/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(("line_item_usage_start_date"),'%Y-%m-%d') AS day_line_item_usage_start_date,
  SPLIT_PART(line_item_resource_id,':',7) AS line_item_resource_id,
  line_item_usage_type,
  product_region,
  line_item_product_code,
  sum(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  sum(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_Name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter}
  AND line_item_product_code = 'AmazonDocDB'
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','Fee','RIFee')
GROUP BY  -- automation_groupby_stmt
  1, -- bill_payer_account_id
  2, -- line_item_usage_account_id
  3, -- day_line_item_usage_start_date
  4, -- line_item_resource_id
  5, -- line_item_usage_type
  6, -- product_region
  7 -- line_item_product_code
ORDER BY -- automation_order_stmt
  sum_line_item_unblended_cost DESC
;