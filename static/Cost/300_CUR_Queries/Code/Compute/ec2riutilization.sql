-- modified: 2021-04-25
-- query_id: ec2-ri-utilization
-- query_description: The Reserved Instance Utilization and Coverage reports are available out-of-the-box in AWS Cost Explorer. This query provides utilization for EC2 Reserved Instances. It shows useful information about the Reserved Instances purchased including Lease ID, instance type and family, used and unused amounts.
-- query_columns: bill_payer_account_id,line_item_blended_cost,line_item_line_item_type,line_item_normalized_usage_amount,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,line_item_usage_type,product_region,reservation_reservation_a_r_n,reservation_unused_normalized_unit_quantity,reservation_unused_quantity
-- query_link: /cost/300_labs/300_cur_queries/queries/compute/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  SPLIT_PART(SPLIT_PART(reservation_reservation_a_r_n,':',6),'/',2) AS LeaseID,
  SPLIT_PART(line_item_usage_type ,':',2) AS InstanceType,
  SPLIT_PART(SPLIT_PART(line_item_usage_type ,':',2), '.', 1) AS InstanceFamily,
  CASE product_region
    WHEN NULL THEN 'Global'
    WHEN '' THEN 'Global'
    ELSE product_region
  END AS Region,
  line_item_line_item_type,
  SUM(TRY_CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(TRY_CAST(reservation_unused_quantity AS DOUBLE)) AS sum_reservation_unused_quantity,
  SUM(TRY_CAST(line_item_normalized_usage_amount AS DOUBLE)) AS sum_line_item_normalized_usage_amount,
  SUM(TRY_CAST(reservation_unused_normalized_unit_quantity AS DOUBLE)) AS sum_reservation_unused_normalized_unit_quantity,
  SUM(CAST(line_item_blended_cost AS DECIMAL(16,8))) AS sum_line_item_blended_cost,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${tableName} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND product_product_name = 'Amazon Elastic Compute Cloud'
  AND line_item_operation LIKE '%%RunInstance%%'
  AND line_item_line_item_type IN ('Fee','RIFee','DiscountedUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), -- automation_timerange_dateformat
  4,
  line_item_usage_type,
  product_region,
  line_item_line_item_type
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date,
  InstanceType,
  sum_line_item_unblended_cost DESC
;
