SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
CASE SPLIT_PART(line_item_usage_type,':',2)
    WHEN 'VolumeUsage' THEN 'EBS - Magnetic'
    WHEN 'VolumeUsage.gp2' THEN 'EBS - SSD(gp2)'
    WHEN 'VolumeUsage.gp3' THEN 'EBS - SSD(gp3)'
    WHEN 'VolumeUsage.piops' THEN 'EBS - SSD(io1)'
    WHEN 'VolumeUsage.st1' THEN 'EBS - HDD(st1)'
    WHEN 'VolumeUsage.sc1' THEN 'EBS - HDD(sc1)'
    WHEN 'VolumeIOUsage' THEN 'EBS - I/O Requests'
    WHEN 'VolumeP-IOPS.piops' THEN 'EBS - Provisioned IOPS'
    ELSE SPLIT_PART(line_item_usage_type,':',2)
END as line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM
  ${tableName}
WHERE
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND product_product_name = 'Amazon Elastic Compute Cloud'
  AND line_item_usage_type LIKE '%%EBS%%Volume%%'
  AND product_product_family  IN ('Storage','System Operation')
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
  line_item_usage_type
ORDER BY
  sum_line_item_unblended_cost DESC;