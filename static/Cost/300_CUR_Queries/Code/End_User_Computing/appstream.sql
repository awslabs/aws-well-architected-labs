-- query_id: appstream
-- query_description: This query will provide unblended cost and usage information per linked account for Amazon AppStream 2.0.
-- query_columns: bill_payer_account_id,line_item_usage_account_id,month_line_item_usage_start_date,product_product_family,product_instance_type,pricing_unit,product_region,sum_line_item_usage_amount,sum_line_item_unblended_cost_reservation_effective_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/end_user_computing/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, -- automation_timerange_dateformat
  product_product_family, -- Stopped Instance, Streaming Instance, User Fees
  product_instance_type,  -- stream.TYPE.SIZE
  pricing_unit, -- Hrs, Users
  product_region, 
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  CASE line_item_line_item_type
    WHEN 'DiscountedUsage' THEN SUM(CAST(reservation_effective_cost AS decimal(16,8)))
    WHEN 'Usage' THEN SUM(CAST(line_item_unblended_cost AS decimal(16,8)))
    ELSE SUM(CAST(line_item_unblended_cost AS decimal(16,8)))
  END AS sum_line_item_unblended_cost_reservation_effective_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09') -- automation_timerange_year_month
  AND product_product_name = 'Amazon AppStream'
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
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
  sum_line_item_usage_amount desc,
  sum_line_item_unblended_cost_reservation_effective_cost,
  product_product_family;