SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  line_item_resource_id,
  product_product_name,
  line_item_usage_type,
  CASE
    WHEN line_item_usage_type LIKE '%%EarlyDelete-ByteHrs' THEN 'S3: Early Delete - Glacier'
    WHEN line_item_usage_type LIKE '%%EarlyDelete-SIA' THEN 'S3: Early Delete - Standard Infrequent Access'
    WHEN line_item_usage_type LIKE '%%Requests-Tier3' THEN 'S3: API Requests - Glacier'
    WHEN (line_item_usage_type LIKE '%%Requests-Tier4' OR line_item_usage_type LIKE '%%Requests-SIA') THEN 'S3: API Requests - Standard Infrequent Access'
    WHEN (line_item_usage_type LIKE '%%Requests-Tier1' OR line_item_usage_type LIKE '%%Requests-Tier2') THEN 'S3: API Requests - Standard'
    WHEN line_item_usage_type LIKE '%%Retrieval-SIA' THEN 'S3: Data Retrieval - Standard Infrequent Access'
    WHEN line_item_usage_type LIKE '%%Peak-Restore-Bytes-Delta' THEN 'S3: Data Retrieval - Glacier'
    WHEN (line_item_usage_type LIKE '%%AWS-In-Bytes' OR line_item_usage_type LIKE '%%AWS-In-ABytes') THEN 'S3: Data Transfer - Region to Region (In)'
    WHEN (line_item_usage_type LIKE '%%AWS-Out-Bytes' OR line_item_usage_type LIKE '%%AWS-Out-ABytes') THEN 'S3: Data Transfer - Region to Region (Out)'
    WHEN line_item_usage_type LIKE '%%CloudFront-In-Bytes' THEN 'S3: Data Transfer - CloudFront (In)'
    WHEN line_item_usage_type LIKE '%%CloudFront-Out-Bytes' THEN 'S3: Data Transfer - CloudFront (Out)'
    WHEN line_item_usage_type LIKE '%%DataTransfer-Regional-Bytes' THEN 'S3: Data Transfer - Inter AZ'
    WHEN (line_item_usage_type LIKE '%%DataTransfer-In-aBytes' OR line_item_usage_type LIKE '%%DataTransfer-In-Bytes') THEN 'S3: Data Transfer - Internet (In)'
    WHEN (line_item_usage_type LIKE '%%DataTransfer-Out-aBytes' OR line_item_usage_type LIKE '%%DataTransfer-Out-Bytes') THEN 'S3: Data Transfer - Internet (Out)'
    WHEN line_item_usage_type LIKE '%%TimedStorage-GlacierByteHrs' THEN 'S3: Storage - Glacier'
    WHEN line_item_usage_type LIKE '%%TimedStorage-RRS-ByteHrs' THEN 'S3: Storage - Reduced Redundancy'
    WHEN (line_item_usage_type LIKE '%%TimedStorage-SIA-ByteHrs' OR line_item_usage_type LIKE '%%TimedStorage-SIA-SmObjects') THEN 'S3: Storage - Standard Infrequent Access'
    WHEN line_item_usage_type LIKE '%%TimedStorage-ByteHrs' THEN 'S3: Storage - Standard'
    ELSE 'Other Requests'
  END as line_item_usage_type_group,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name}
WHERE
  (year = '2020' AND month IN ('7','9') OR year = '2020' AND month IN ('07','09'))
  AND (("product_product_name" LIKE '%Amazon Glacier%') OR ("product_product_name" LIKE '%Amazon Simple Storage Service%'))
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY
  1,2,3,4,5,6
ORDER By
  day_line_item_usage_start_date ASC,
  line_item_usage_account_id,
  line_item_usage_type_group DESC,
  sum_line_item_unblended_cost DESC;
