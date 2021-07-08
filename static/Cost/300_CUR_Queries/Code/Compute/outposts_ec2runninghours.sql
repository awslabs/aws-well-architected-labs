-- modified: 2021-07-07
-- query_id: outposts_ec2runninghours
-- query_description: This query will provide the Amazon EC2 software costs (like Windows, RHEL or others) on AWS Outposts. These software fees are not included with the cost of the AWS Outposts racks and are billed separately here. The output will include detailed information about the instance type, pre-installed softwares, operating system, description, amortized cost, and usage quantity. The output will be ordered by amortized cost in descending order.
-- query_columns: day_line_item_usage_start_date, bill_payer_account_id, line_item_usage_account_id, line_item_resource_id, product_instance_type, product_operating_system, product_pre_installed_sw, line_item_line_item_description, sum_line_item_usage_amount, sum_amortized_cost
--query_link: /cost/300_labs/300_cur_queries/queries/compute/

SELECT  -- automation_select_stmt
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  bill_payer_account_id, 
  line_item_usage_account_id,  
  line_item_resource_id,
  product_instance_type,
  product_operating_system,
  product_pre_installed_sw,
  line_item_line_item_description, 
  SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
  SUM(CASE
    WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN savings_plan_savings_plan_effective_cost
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
    WHEN line_item_line_item_type = 'Usage' THEN line_item_unblended_cost
    ELSE 0 
  END) AS sum_amortized_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND line_item_product_code = 'AWSOutposts'
  AND line_item_operation LIKE '%%RunInstance%%'
  AND (line_item_line_item_type = 'Usage'
    OR (line_item_line_item_type = 'SavingsPlanCoveredUsage')
    OR (line_item_line_item_type = 'DiscountedUsage')
  )
GROUP BY -- automation_groupby_stmt
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), -- automation_timerange_dateformat
  bill_payer_account_id, 
  line_item_usage_account_id,  
  line_item_resource_id,
  product_instance_type,
  product_operating_system,
  product_pre_installed_sw,
  line_item_line_item_description
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date ASC,
  sum_amortized_cost DESC
  ;