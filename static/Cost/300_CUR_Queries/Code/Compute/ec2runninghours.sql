-- modified: 2021-04-25
-- query_id: ec2-running-hours
-- query_description: This query will provide the EC2 usage quantity measured in hours for each purchase option and each instance type. The output will include detailed information about the instance type, amortized cost, purchase option, and usage quantity. The output will be ordered by usage quantity in descending order.
-- query_columns: bill_billing_period_start_date,bill_payer_account_id,line_item_line_item_type,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,line_item_usage_type,product_instance_type,reservation_effective_cost,reservation_reservation_a_r_n,savings_plan_savings_plan_a_r_n,savings_plan_savings_plan_effective_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/compute/

SELECT -- automation_select_stmt
  year,
  month,
  bill_billing_period_start_date,
  date_trunc('hour', line_item_usage_start_date) as hour_line_item_usage_start_date, 
  bill_payer_account_id, 
  line_item_usage_account_id,
  (CASE 
    WHEN (line_item_usage_type LIKE '%SpotUsage%') THEN
      SPLIT_PART(line_item_usage_type, ':', 2)
    ELSE product_instance_type
    END) AS product_instance_type,
  (CASE
    WHEN (savings_plan_savings_plan_a_r_n <> '') THEN
      'SavingsPlan'
    WHEN (reservation_reservation_a_r_n <> '') THEN
      'Reserved'
    WHEN (line_item_usage_type LIKE '%Spot%') THEN
      'Spot'
    ELSE 'OnDemand' END) as purchase_option, 
    sum(CASE
      WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN
        savings_plan_savings_plan_effective_cost
      WHEN line_item_line_item_type = 'DiscountedUsage' THEN
        reservation_effective_cost
      WHEN line_item_line_item_type = 'Usage' THEN
        line_item_unblended_cost
      ELSE 0 END) as amortized_cost, 
  round(sum(line_item_usage_amount), 2) usage_quantity
FROM ${table_name} -- automation_from_stmt -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND ( (line_item_product_code = 'AmazonEC2')
        AND (product_servicecode <> 'AWSDataTransfer')
        AND (line_item_operation LIKE '%RunInstances%')
        AND (line_item_usage_type NOT LIKE '%DataXfer%') 
      )
  AND (
        (line_item_line_item_type = 'Usage')
        OR (line_item_line_item_type = 'SavingsPlanCoveredUsage')
        OR (line_item_line_item_type = 'DiscountedUsage')
      )
GROUP BY -- automation_groupby_stmt
  year, 
  month,
  bill_billing_period_start_date,  
  product_instance_type,
  date_trunc('hour', line_item_usage_start_date),
  bill_payer_account_id,
  line_item_usage_account_id,
  7,
  8
ORDER BY -- automation_order_stmt
  usage_quantity DESC;
