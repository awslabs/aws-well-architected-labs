SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  product_product_family,
  CASE
    WHEN line_item_usage_type LIKE '%%DataTransfer-In-Bytes%%' THEN 'Data Transfer GB (IN) '
    WHEN line_item_usage_type LIKE '%%DataTransfer-Out-Bytes%%' THEN 'Data Transfer GB (Out)'
    WHEN line_item_usage_type LIKE '%%AttachmentsSize-Bytes%%' THEN 'Attachments GB'
    WHEN line_item_usage_type LIKE '%%Recipients' THEN 'Recipients'
    WHEN line_item_usage_type LIKE '%%Recipients-EC2' THEN 'Recipients'
    WHEN line_item_usage_type LIKE '%%Recipients-MailboxSim' THEN 'Recipients (MailboxSimulator)'
    WHEN line_item_usage_type LIKE '%%Message%%' THEN 'Messages'
    WHEN line_item_usage_type LIKE '%%ReceivedChunk%%' THEN 'Received Chunk'
    ELSE 'Others'
  END as case_line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_Name}
WHERE
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND product_product_name = 'Amazon Simple Email Service'
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  product_product_family,
  line_item_usage_type
ORDER BY
  day_line_item_usage_start_date,
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost DESC;
