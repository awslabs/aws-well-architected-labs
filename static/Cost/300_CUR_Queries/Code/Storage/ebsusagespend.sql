-- query_id: ebs-usage-spend
-- query_description: This query provides daily unblended cost and usage information about Amazon EBS Volume Usage per account.
-- query_columns: bill_payer_account_id,line_item_usage_account_id,month_line_item_usage_start_date,line_item_usage_type,sum_line_item_usage_amount,sum_line_item_unblended_cost
-- query_link: /cost/300_labs/300_cur_queries/queries/storage/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, -- automation_timerange_dateformat
CASE SPLIT_PART(line_item_usage_type,':',2)
    WHEN 'VolumeUsage' THEN 'EBS - Magnetic'
    WHEN 'VolumeIOUsage' THEN 'EBS Magnetic IO'
    WHEN 'VolumeUsage.gp2' THEN 'EBS GP2'
    WHEN 'VolumeUsage.gp3' THEN 'EBS GP3'
    WHEN 'VolumeP-IOPS.gp3' THEN 'EBS GP3 IOPS'
    WHEN 'VolumeP-Throughput.gp3' THEN 'EBS GP3 Throughput'
    WHEN 'VolumeUsage.piops' THEN 'EBS io1'
    WHEN 'VolumeP-IOPS.piops' THEN 'EBS io1 IOPS'
    WHEN 'VolumeUsage.io2' THEN 'EBS io2'
    WHEN 'VolumeP-IOPS.io2' THEN 'EBS io2 IOPS'
    WHEN 'VolumeUsage.st1' THEN 'EBS st1'
    WHEN 'VolumeUsage.sc1' THEN 'EBS sc1'
    WHEN 'directAPI' THEN 'EBS Direct API Requests'
    WHEN 'FastSnapshotRestore' THEN 'EBS Fast Snapshot Restore'  
    ELSE SPLIT_PART(line_item_usage_type,':',2)
END as line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
WHERE -- automation_where_stmt
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09') -- automation_timerange_year_month
  AND product_product_name = 'Amazon Elastic Compute Cloud'
  AND line_item_usage_type LIKE '%%EBS%%Volume%%'
  AND product_product_family  IN ('Storage','System Operation')
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'), -- automation_timerange_dateformat
  line_item_usage_type
ORDER BY -- automation_order_stmt
  sum_line_item_unblended_cost DESC;