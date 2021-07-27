SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  CASE 
    WHEN line_item_usage_type LIKE '%SnapshotUsage%' THEN 'Snapshots'
    WHEN line_item_usage_type LIKE '%VolumeIOUsage%' THEN 'Magnetic IO'
    WHEN line_item_usage_type LIKE '%VolumeUsage' THEN 'Magnetic'  
    WHEN line_item_usage_type LIKE '%VolumeUsage.gp2' THEN 'GP2'
    WHEN line_item_usage_type LIKE '%VolumeUsage.gp3' THEN 'GP3'
    WHEN line_item_usage_type LIKE '%VolumeP-IOPS.gp3' THEN 'GP3 IOPS'
    WHEN line_item_usage_type LIKE '%VolumeP-Throughput.gp3' THEN 'GP3 Throughput'
    WHEN line_item_usage_type LIKE '%VolumeUsage.piops' THEN 'io1'
    WHEN line_item_usage_type LIKE '%VolumeP-IOPS.piops' THEN 'io1 IOPS'
    WHEN line_item_usage_type LIKE '%VolumeUsage.io2%' THEN 'io2'
    WHEN line_item_usage_type LIKE '%VolumeP-IOPS.io2%' THEN 'io2 IOPS'
    WHEN line_item_usage_type LIKE '%VolumeUsage.st1' THEN 'st1'
    WHEN line_item_usage_type LIKE '%VolumeUsage.sc1' THEN 'sc1'
    WHEN line_item_usage_type LIKE '%directAPI%' THEN 'Direct API Requests'
    WHEN line_item_usage_type LIKE '%FastSnapshotRestore' THEN 'Fast Snapshot Restore'
    ELSE SPLIT_PART(line_item_usage_type,':',2)
  END AS case_line_item_usage_type,
  CASE 
    WHEN line_item_resource_id LIKE '%snap%' THEN SPLIT_PART(line_item_resource_id,'/',2)
    ELSE line_item_resource_id
  END AS case_line_item_resource_id,
  SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost
FROM 
  {$tableName}
WHERE
  {$date_filter}
  AND line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%'
  AND line_item_line_item_type  = 'Usage'
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  4, --refers to case_line_item_usage_type
  5  --refers to case_line_item_resource_id
ORDER BY 
  day_line_item_usage_start_date ASC, 
  sum_line_item_unblended_cost DESC;
  