SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  line_item_resource_id,
  line_item_operation,
  CASE
    --S3 Early Delete
    WHEN line_item_usage_type LIKE '%EarlyDelete-ByteHrs' THEN 'Early Delete Glacier'
    WHEN line_item_usage_type LIKE '%EarlyDelete%' THEN 'Early Delete ' || SPLIT_PART(line_item_usage_type,'EarlyDelete-',2)
    --S3 Requests
    WHEN line_item_usage_type LIKE '%Requests-INT%' THEN 'Requests INT'
    WHEN (line_item_usage_type LIKE '%Requests-Tier1' OR line_item_usage_type LIKE '%Requests-Tier2') THEN 'Requests Standard'
    WHEN (line_item_usage_type LIKE '%Requests-GLACIER%' OR line_item_usage_type LIKE '%Requests-Tier3' OR line_item_usage_type LIKE '%Requests-Tier5' OR line_item_usage_type LIKE '%Requests-Tier6') THEN 'Requests Glacier'
    WHEN line_item_usage_type LIKE '%Requests-GDA%' THEN 'Requests GDA'
    WHEN line_item_usage_type LIKE '%Requests-GIR%' THEN 'Requests GIR'
    WHEN (line_item_usage_type LIKE '%Requests-Tier4' OR line_item_usage_type LIKE '%Requests-SIA%') THEN 'Requests SIA'
    WHEN line_item_usage_type LIKE '%Requests-ZIA%' THEN 'Requests ZIA'
    --S3 Retrieval
    WHEN (line_item_usage_type LIKE '%Retrieval-Bytes' AND line_item_operation = 'RestoreObject') THEN 'Retrieval Glacier'
    WHEN (line_item_usage_type LIKE '%Retrieval-Bytes' AND line_item_operation = 'DeepArchiveRestoreObject') THEN 'Retrieval GDA'
    WHEN line_item_usage_type LIKE '%Retrieval%' THEN 'Retrieval ' || SPLIT_PART(line_item_usage_type,'Retrieval-',2)
    --S3 Storage
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'StandardStorage') THEN 'Storage Standard'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'StandardIAStorage') THEN 'Storage SIA'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'StandardIASizeOverhead') THEN 'Storage SIA-Overhead'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'OneZoneIAStorage') THEN 'Storage ZIA'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'OneZoneIASizeOverhead') THEN 'Storage ZIA-Overhead'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'GlacierInstantRetrievalStorage') THEN 'Storage GIR'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'GlacierIRSizeOverhead') THEN 'Storage GIR-Overhead'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'GlacierStorage') THEN 'Storage Glacier'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'GlacierStagingStorage') THEN 'Storage Glacier-Staging'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND (line_item_operation = 'GlacierObjectOverhead' or line_item_operation = 'GlacierS3ObjectOverhead')) THEN 'Storage Glacier-Overhead'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'RestoreObject') THEN 'Storage Glacier-Restored'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'DeepArchiveStorage') THEN 'Storage GDA'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'DeepArchiveStagingStorage') THEN 'Storage GDA-Staging'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND (line_item_operation = 'DeepArchiveObjectOverhead' or line_item_operation = 'DeepArchiveS3ObjectOverhead')) THEN 'Storage GDA-Overhead'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'DeepArchiveRestoreObject') THEN 'Storage GDA-Restored'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'ReducedRedundancyStorage') THEN 'Storage RRS'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation LIKE 'IntelligentTieringAA%') THEN 'Storage INT-AA'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND (line_item_operation = 'IntAAObjectOverhead' or line_item_operation = 'IntAAS3ObjectOverhead')) THEN 'Storage INT-AA-Overhead'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation LIKE 'IntelligentTieringDAA%') THEN 'Storage INT-DAA'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND (line_item_operation = 'IntDAAObjectOverhead' or line_item_operation = 'IntDAAS3ObjectOverhead')) THEN 'Storage INT-DAA-Overhead'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation LIKE 'IntelligentTieringFA%') THEN 'Storage INT-FA'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation LIKE 'IntelligentTieringIA%') THEN 'Storage INT-IA'
    WHEN (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation LIKE 'IntelligentTieringAIA%') THEN 'Storage INT-AIA'
    --Data Transfer
    WHEN line_item_usage_type LIKE '%AWS-In-Bytes%' THEN 'Data Transfer Region to Region (In)'
    WHEN line_item_usage_type LIKE '%AWS-In-ABytes%'THEN 'Data Transfer Accelerated Region to Region (In)'
    WHEN line_item_usage_type LIKE '%AWS-Out-Bytes%' THEN 'Data Transfer Region to Region (Out)'
    WHEN line_item_usage_type LIKE '%AWS-Out-ABytes%' THEN 'Data Transfer Accelerated Region to Region (Out)'
    WHEN line_item_usage_type LIKE '%CloudFront-In-Bytes%' THEN 'Data Transfer CloudFront (In)'
    WHEN line_item_usage_type LIKE '%CloudFront-Out-Bytes%' THEN 'Data Transfer CloudFront (Out)'
    WHEN line_item_usage_type LIKE '%DataTransfer-Regional-Bytes%' THEN 'Data Transfer Inter AZ'
    WHEN line_item_usage_type LIKE '%DataTransfer-In-Bytes%' THEN 'Data Transfer Internet (In)'
    WHEN line_item_usage_type LIKE '%DataTransfer-Out-Bytes%' THEN 'Data Transfer Internet (Out)'
    WHEN line_item_usage_type LIKE '%DataTransfer-In-ABytes%' THEN 'Data Transfer Accelerated Internet (In)'
    WHEN line_item_usage_type LIKE '%DataTransfer-Out-ABytes%' THEN 'Data Transfer Accelerated Internet (Out)'
    WHEN line_item_usage_type LIKE '%S3RTC-In-Bytes%' THEN 'Data Transfer Replication Time Control (In)'
    WHEN line_item_usage_type LIKE '%S3RTC-Out-Bytes%' THEN 'Data Transfer Replication Time Control (Out)'
    --S3 Fees & Misc
    WHEN line_item_usage_type LIKE '%Monitoring-Automation-INT' THEN 'S3 INT Monitoring Fee'
    WHEN line_item_usage_type LIKE '%StorageAnalytics%' THEN 'S3 Storage Analytics'
    WHEN line_item_usage_type LIKE '%BatchOperations-Jobs%' THEN 'S3 Batch Operations-Jobs'
    WHEN line_item_usage_type LIKE '%BatchOperations-Objects%' THEN 'S3 Batch Operations-Objects'
    WHEN line_item_usage_type LIKE '%TagStorage%' THEN 'S3 Tag Storage'
    WHEN (line_item_usage_type LIKE '%Select-Returned%' OR line_item_usage_type LIKE '%Select-Scanned%') THEN 'S3 Select'
    WHEN line_item_usage_type LIKE '%Inventory%' THEN 'S3 Inventory'
    WHEN line_item_operation LIKE '%StorageLens%' THEN 'Storage Lens'
    ELSE 'Other ' || line_item_usage_type
  END as case_line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM
  ${table_name}
WHERE
  ${date_filter} 
  AND line_item_product_code = 'AmazonS3'
  AND line_item_line_item_type  in ('DiscountedUsage','Usage', 'SavingsPlanCoveredUsage')
  AND product_product_family != 'Data Transfer'
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  line_item_resource_id,
  line_item_operation,
  6 --refers to case_line_item_usage_type
ORDER BY
  sum_line_item_unblended_cost DESC;
