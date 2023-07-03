-- modified: 2023-04-10
-- query_id: ec2-reservation-utilization
-- query_description:  This query will give you a very granular look at which Reserved Instance purchases were not being utilized to their full extent last month.  This query is written for Amazon EC2, however, commenting the line_item_product_code line in the WHERE clause will output all Reserved Instances. 
-- query_columns: 
-- query_link: /cost/300_labs/300_cur_queries/queries/aws_cost_management/

-- EC2 Reservations active in current month ordered by expiration first
SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
DATE_FORMAT((line_item_usage_start_date),'%Y-%m') AS month_line_item_usage_start_date,
  bill_bill_type,
  line_item_product_code,
  line_item_usage_type,
  product_region,
  reservation_subscription_id,
  reservation_reservation_a_r_n,
  pricing_purchase_option,
  pricing_offering_class,
  pricing_lease_contract_length,
  reservation_number_of_reservations,
  reservation_start_time,
  reservation_end_time,
  reservation_modification_status,
  reservation_total_reserved_units,
  reservation_unused_quantity,
  TRY_CAST(1 - (TRY_CAST(reservation_unused_quantity AS Decimal(16,8)) / TRY_CAST(reservation_total_reserved_units AS Decimal(16,8))) as Decimal(16,8)) AS calc_percentage_utilized
FROM
  ${table_name}
WHERE 
    CAST("concat"("year", '-', "month", '-01') AS date) = "date_trunc"('month', current_date) - INTERVAL  '1' MONTH --last month
    AND pricing_term = 'Reserved'
    AND line_item_line_item_type IN ('Fee','RIFee')
    AND line_item_product_code = 'AmazonEC2' --EC2 only, comment out for all reservation types
    AND bill_bill_type = 'Anniversary' --identify 
    AND try_cast(date_parse(SPLIT_PART(reservation_end_time, 'T', 1), '%Y-%m-%d') as date) > cast(current_date as date) --res exp time after today's date
GROUP BY 
  bill_bill_type,
  bill_payer_account_id,
  line_item_usage_account_id,
  reservation_reservation_a_r_n,
  reservation_subscription_id,
DATE_FORMAT((line_item_usage_start_date),'%Y-%m'),
  line_item_product_code,
  line_item_usage_type,
  product_region,
  pricing_purchase_option,
  pricing_offering_class,
  pricing_lease_contract_length,
  reservation_number_of_reservations,
  reservation_start_time,
  reservation_end_time,
  reservation_modification_status,
  reservation_total_reserved_units,
  reservation_unused_quantity
ORDER BY 
  reservation_unused_quantity DESC,
  reservation_end_time ASC,
  calc_percentage_utilized ASC