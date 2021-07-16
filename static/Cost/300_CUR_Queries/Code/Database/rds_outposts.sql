-- modified: 2021-07-15
-- query_id: outposts_rdsrunninghours
-- query_description: This query will provide the daily cost and usage for Amazon RDS on AWS Outposts. The output will include detailed information about the instance type, DB engine, deployment option, database ID, amortized cost, and usage quantity. The output will be ordered by month, usage amount, and unblended cost.
-- query_columns: day_line_item_usage_start_date, bill_payer_account_id, line_item_usage_account_id, split_line_item_resource_id, product_instance_type, product_database_engine, product_deployment_option, sum_line_item_usage_amount, sum_line_item_unblended_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/database/


SELECT  -- automation_select_stmt
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  bill_payer_account_id,
  line_item_usage_account_id,
  SPLIT_PART(line_item_resource_id,':',7) AS split_line_item_resource_id,
  product_instance_type,
  product_database_engine,
  product_deployment_option,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost 
FROM  -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE
  ${date_filter} -- automation_timerange_year_month
  AND product_location_type='AWS Outposts'
  AND product_product_family='Database Instance'
  AND line_item_product_code = 'AmazonRDS'
  AND (line_item_line_item_type = 'Usage'
    OR (line_item_line_item_type = 'SavingsPlanCoveredUsage')
    OR (line_item_line_item_type = 'DiscountedUsage')
  )
GROUP BY
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), -- automation_timerange_dateformat
  bill_payer_account_id, 
  line_item_usage_account_id,
  line_item_resource_id,
  product_instance_type,
  product_database_engine,
  product_deployment_option
ORDER BY
  day_line_item_usage_start_date ASC,
  sum_line_item_usage_amount DESC,
  sum_line_item_unblended_cost DESC;