-- modified: 2021-04-25
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  line_item_product_code,
  CASE
    --DynamoDB Usage Types
      --DynamoDB Data Restore
    WHEN line_item_product_code = 'AmazonDynamoDB' AND line_item_usage_type LIKE '%ExportDataSize%' THEN 'Data Export'
    WHEN line_item_product_code = 'AmazonDynamoDB' AND line_item_usage_type LIKE '%RestoreDataSize%' THEN 'Data Restore'
    
      --DynamoDB Storage
    WHEN line_item_product_code = 'AmazonDynamoDB' AND line_item_usage_type LIKE '%TimedBackupStorage%' THEN 'On Demand Backup Storage'
    WHEN line_item_product_code = 'AmazonDynamoDB' AND line_item_usage_type LIKE '%TimedPITRStorage%' THEN 'Continuous/PITR Backup Storage'
    WHEN line_item_product_code = 'AmazonDynamoDB' AND line_item_usage_type LIKE '%TimedStorage%' THEN 'Standard Storage'
      --DynamoDB IO
    WHEN line_item_product_code = 'AmazonDynamoDB' AND line_item_usage_type LIKE '%ReplWriteRequestUnits' THEN 'On Demand Replicated Write RUs'    
    WHEN line_item_product_code = 'AmazonDynamoDB' AND line_item_usage_type LIKE '%WriteRequestUnits' THEN 'On Demand Write RUs'
    WHEN line_item_product_code = 'AmazonDynamoDB' AND line_item_usage_type LIKE '%ReadRequestUnits' THEN 'On Demand Read RUs'
    WHEN line_item_product_code = 'AmazonDynamoDB' AND line_item_usage_type LIKE '%ReplWriteCapacityUnit%' THEN 'Provisioned Replicated Write CUs'
    WHEN line_item_product_code = 'AmazonDynamoDB' AND line_item_usage_type LIKE '%WriteCapacityUnit%' THEN 'Provisioned Write CUs'
    WHEN line_item_product_code = 'AmazonDynamoDB' AND line_item_usage_type LIKE '%ReadCapacityUnit%' THEN 'Provisioned Read CUs'
      --DynamoDB API Requests
    WHEN line_item_product_code = 'AmazonDynamoDB' AND line_item_usage_type LIKE '%Streams-Requests%' THEN 'Streams API Requests'

    --FSx Usage Types
    WHEN line_item_product_code = 'AmazonFSx' AND product_product_family = 'Storage' AND line_item_operation LIKE '%Lustre' THEN 'Lustre ' || SPLIT_PART(line_item_usage_type,'-',2)
    WHEN line_item_product_code = 'AmazonFSx' AND product_product_family IN ('Storage','Provisioned Throughput') AND line_item_operation LIKE '%Windows' THEN 'Windows ' || SPLIT_PART(line_item_usage_type,'-',2)
    
    --S3 Usage Types
      --S3 Early Delete
    WHEN line_item_product_code = 'AmazonS3' AND line_item_usage_type LIKE '%EarlyDelete-ByteHrs' THEN 'Early Delete Glacier'
    WHEN line_item_product_code = 'AmazonS3' AND line_item_usage_type LIKE '%EarlyDelete%' THEN 'Early Delete ' || SPLIT_PART(line_item_usage_type,'EarlyDelete-',2)
    
      --S3 Requests
    WHEN line_item_product_code = 'AmazonS3' AND line_item_usage_type LIKE '%Requests-INT%' THEN 'Requests INT'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%Requests-Tier1' OR line_item_usage_type LIKE '%Requests-Tier2') THEN 'Requests Standard'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%Requests-GLACIER%' OR line_item_usage_type LIKE '%Requests-Tier3' OR line_item_usage_type LIKE '%Requests-Tier5' OR line_item_usage_type LIKE '%Requests-Tier6') THEN 'Requests Glacier'
    WHEN line_item_product_code = 'AmazonS3' AND line_item_usage_type LIKE '%Requests-GDA%' THEN 'Requests GDA'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%Requests-Tier4' OR line_item_usage_type LIKE '%Requests-SIA%') THEN 'Requests SIA'
    WHEN line_item_product_code = 'AmazonS3' AND line_item_usage_type LIKE '%Requests-ZIA%' THEN 'Requests ZIA'
    
      --S3 Retrieval
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%Retrieval-Bytes' AND line_item_operation = 'RestoreObject') THEN 'Retrieval Glacier'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%Retrieval-Bytes' AND line_item_operation = 'DeepArchiveRestoreObject') THEN 'Retrieval GDA'
    WHEN line_item_product_code = 'AmazonS3' AND line_item_usage_type LIKE '%Retrieval%' THEN 'Retrieval ' || SPLIT_PART(line_item_usage_type,'Retrieval-',2)
 
      --S3 Storage
    WHEN line_item_product_code = 'AmazonS3' AND line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'StandardStorage' THEN 'Storage Standard'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'StandardIAStorage') THEN 'Storage SIA'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'StandardIASizeOverhead') THEN 'Storage SIA-Overhead'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'OneZoneIAStorage') THEN 'Storage ZIA'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'OneZoneIASizeOverhead') THEN 'Storage ZIA-Overhead'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'GlacierStorage') THEN 'Storage Glacier'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'GlacierStagingStorage') THEN 'Storage Glacier-Staging'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND (line_item_operation = 'GlacierObjectOverhead' or line_item_operation = 'GlacierS3ObjectOverhead')) THEN 'Storage Glacier-Overhead'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'RestoreObject') THEN 'Storage Glacier-Restored'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'DeepArchiveStorage') THEN 'Storage GDA'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'DeepArchiveStagingStorage') THEN 'Storage GDA-Staging'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND (line_item_operation = 'DeepArchiveObjectOverhead' or line_item_operation = 'DeepArchiveS3ObjectOverhead')) THEN 'Storage GDA-Overhead'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'DeepArchiveRestoreObject') THEN 'Storage GDA-Restored'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation = 'ReducedRedundancyStorage') THEN 'Storage RRS'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation LIKE 'IntelligentTieringFA%') THEN 'Storage INT-FA'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%TimedStorage%' AND line_item_operation LIKE 'IntelligentTieringIA%') THEN 'Storage INT-IA'
      --S3 Fees & Misc
    WHEN line_item_product_code = 'AmazonS3' AND line_item_usage_type LIKE '%Monitoring-Automation-INT' THEN 'S3 INT Monitoring Fee'
    WHEN line_item_product_code = 'AmazonS3' AND line_item_usage_type LIKE '%StorageAnalytics%' THEN 'S3 Storage Analytics'
    WHEN line_item_product_code = 'AmazonS3' AND line_item_usage_type LIKE '%BatchOperations-Jobs%' THEN 'S3 Batch Operations-Jobs'
    WHEN line_item_product_code = 'AmazonS3' AND line_item_usage_type LIKE '%BatchOperations-Objects%' THEN 'S3 Batch Operations-Objects'
    WHEN line_item_product_code = 'AmazonS3' AND line_item_usage_type LIKE '%TagStorage%' THEN 'S3 Tag Storage'
    WHEN line_item_product_code = 'AmazonS3' AND (line_item_usage_type LIKE '%Select-Returned%' OR line_item_usage_type LIKE '%Select-Scanned%') THEN 'S3 Select'
    WHEN line_item_product_code = 'AmazonS3' AND line_item_usage_type LIKE '%Inventory%' THEN 'S3 Inventory'
    WHEN line_item_product_code = 'AmazonS3' AND line_item_operation LIKE '%StorageLens%' THEN 'Storage Lens'
    --RDS Usage Types
    WHEN line_item_product_code = 'AmazonRDS' AND product_product_family = 'Aurora Global Database' THEN 'Aurora Replicated Write IO'
    WHEN line_item_product_code = 'AmazonRDS' AND product_product_family IN ('Database Storage','Provisioned IOPS','Storage Snapshot') AND line_item_usage_type LIKE '%RDS:%' THEN 'RDS ' || SPLIT_PART(line_item_usage_type,':',2)
    WHEN line_item_product_code = 'AmazonRDS' AND product_product_family IN ('Database Storage','System Operation','Storage Snapshot') AND line_item_usage_type LIKE '%Aurora:%' THEN 'Aurora ' || SPLIT_PART(line_item_usage_type,':',2)
    
    --EBS Usage Types
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%SnapshotUsage%' THEN 'EBS Snapshots'
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%VolumeIOUsage%' THEN 'EBS Magnetic IO'
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%VolumeUsage' THEN 'EBS Magnetic'  
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%VolumeUsage.gp2' THEN 'EBS GP2'
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%VolumeUsage.gp3' THEN 'EBS GP3'
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%VolumeP-IOPS.gp3' THEN 'EBS GP3 IOPS'
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%VolumeP-Throughput.gp3' THEN 'EBS GP3 Throughput'
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%VolumeUsage.piops' THEN 'EBS io1'
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%VolumeP-IOPS.piops' THEN 'EBS io1 IOPS'
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%VolumeUsage.io2%' THEN 'EBS io2'
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%VolumeP-IOPS.io2%' THEN 'EBS io2 IOPS'
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%VolumeUsage.st1' THEN 'EBS st1'
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%VolumeUsage.sc1' THEN 'EBS sc1'
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%directAPI%' THEN 'EBS Direct API Requests'
    WHEN (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') AND line_item_usage_type LIKE '%FastSnapshotRestore' THEN 'EBS Fast Snapshot Restore'
   
    --EFS Usage Types
    WHEN line_item_product_code = 'AmazonEFS' AND line_item_usage_type LIKE '%-TimedStorage-%' THEN 'EFS Standard'
    WHEN line_item_product_code = 'AmazonEFS' AND line_item_usage_type LIKE '%-IATimedStorage-%' THEN 'EFS IA'
    WHEN line_item_product_code = 'AmazonEFS' AND line_item_usage_type LIKE '%-IADataAccess-%' THEN 'EFS IA Data Access'
    WHEN line_item_product_code = 'AmazonEFS' AND line_item_usage_type LIKE '%-IncludedTP-%' THEN 'EFS Throughput (Included)'
    WHEN line_item_product_code = 'AmazonEFS' AND line_item_usage_type LIKE '%-ProvisionedTP-%' THEN 'EFS Throughput'
  ELSE SPLIT_PART(line_item_usage_type,':',2)
  END AS case_line_item_usage_type,
  SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost
FROM 
  ${tableName}
WHERE
  ${date_filter}
  AND ((line_item_product_code in ('AmazonFSx','AmazonEFS','AmazonS3','AmazonDynamoDB'))
    OR (line_item_product_code = 'AmazonEC2' AND line_item_usage_type LIKE '%EBS:%') 
    OR (line_item_product_code = 'AmazonRDS' AND product_product_family in ('Aurora Global Database','Database Storage','Provisioned IOPS','Storage Snapshot','System Operation')))
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
  AND (line_item_usage_type not LIKE '%DataTransfer%' 
        AND line_item_usage_type not LIKE '%DataXfer%'
        AND line_item_usage_type not LIKE '%In-Bytes%'
        AND line_item_usage_type not LIKE '%In-ABytes%'
        AND line_item_usage_type not LIKE '%Out-Bytes%'
        AND line_item_usage_type not LIKE '%Out-ABytes%')
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  line_item_product_code,
  5 --refers to case_line_item_usage_type
ORDER BY 
  day_line_item_usage_start_date ASC, 
  sum_line_item_unblended_cost DESC;
