-- modified: 2021-04-25
-- query_id: appstream
-- query_description: This query will provide unblended cost and usage information per linked account for Amazon AppStream 2.0.
-- query_columns: bill_payer_account_id,line_item_line_item_type,line_item_unblended_cost,line_item_unblended_cost_reservation_effective_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,pricing_unit,product_instance_type,product_product_family,product_region,reservation_effective_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/end_user_computing/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, -- automation_timerange_dateformat
  product_product_family, -- Stopped Instance, Streaming Instance, User Fees
  product_instance_type,  -- stream.TYPE.SIZE
  pricing_unit, -- Hrs, Users
  product_region, 
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  CASE line_item_line_item_type
    WHEN 'DiscountedUsage' THEN SUM(CAST(reservation_effective_cost AS DECIMAL(16,8)))
    WHEN 'Usage' THEN SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8)))
    ELSE SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8)))
  END AS sum_line_item_unblended_cost_reservation_effective_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND product_product_name = 'Amazon AppStream'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'), -- automation_timerange_dateformat
  product_product_family,
  product_instance_type,
  pricing_unit,
  product_region,
  line_item_line_item_type
ORDER BY -- automation_order_stmt
  month_line_item_usage_start_date,
  sum_line_item_usage_amount DESC,
  sum_line_item_unblended_cost_reservation_effective_cost,
  product_product_family;