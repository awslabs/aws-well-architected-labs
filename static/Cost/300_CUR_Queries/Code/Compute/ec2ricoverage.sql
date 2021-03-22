-- query_id: ec2-ri-coverage
-- query_description: The Reserved Instance Utilization and Coverage reports are available out-of-the-box in AWS Cost Explorer. This query provides coverage for EC2 Reserved Instances. It shows useful information about the Reserved Instances purchased including Lease ID, instance type and family, used and unused amounts, and On-Demand usage that could be covered by additional Savings Plans if this is your preferred savings method.
-- query_columns: bill_payer_account_id,line_item_usage_account_id,day_line_item_usage_start_date,ReservationType,LeaseID,InstanceType,InstanceFamily,Region,UsageType,sum_line_item_usage_amount,sum_reservation_unused_quantity,sum_line_item_normalized_usage_amount,sum_reservation_unused_normalized_unit_quantity,sum_line_item_blended_cost,sum_line_item_unblended_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/compute/

    SELECT -- automation_select_stmt
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
      CASE 
        WHEN line_item_line_item_type IN ('Usage') THEN 'OnDemand'
        WHEN line_item_line_item_type IN ('Fee','RIFee','DiscountedUsage') THEN 'ReservedInstance' 
      END AS ReservationType,
      SPLIT_PART(SPLIT_PART(reservation_reservation_a_r_n,':',6),'/',2) AS LeaseID,
      SPLIT_PART(line_item_usage_type ,':',2) AS InstanceType,
      SPLIT_PART(SPLIT_PART(line_item_usage_type ,':',2), '.', 1) AS InstanceFamily,
      CASE product_region
        WHEN NULL THEN 'Global'
        WHEN '' THEN 'Global'
        ELSE product_region
      END as Region,
      line_item_line_item_type as UsageType,
      SUM(TRY_CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(TRY_CAST(reservation_unused_quantity AS double)) AS sum_reservation_unused_quantity,
      SUM(TRY_CAST(line_item_normalized_usage_amount AS double)) AS sum_line_item_normalized_usage_amount,
      SUM(TRY_CAST(reservation_unused_normalized_unit_quantity AS double)) AS sum_reservation_unused_normalized_unit_quantity,
      SUM(CAST(reservation_effective_cost AS decimal(16,8))) AS sum_line_item_blended_cost,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM -- automation_from_stmt
      ${table_name} -- automation_tablename
    WHERE -- automation_where_stmt
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09') -- automation_timerange_year_month
      AND product_product_name = 'Amazon Elastic Compute Cloud'
      AND line_item_operation LIKE '%%RunInstance%%'
      AND line_item_line_item_type IN ('Usage','Fee','RIFee','DiscountedUsage')
      AND product_product_family NOT IN ('Data Transfer')
    GROUP BY -- automation_groupby_stmt
      bill_payer_account_id,
      line_item_usage_account_id,
      3,
      5,
      6,
      product_region,
      line_item_line_item_type
    ORDER BY -- automation_order_stmt
      day_line_item_usage_start_date,
      InstanceType,
      sum_line_item_unblended_cost DESC;
