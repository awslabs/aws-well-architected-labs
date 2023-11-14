---
title: "Storage"
weight: 13
---

These are queries for AWS Services under the [Storage product family](https://aws.amazon.com/products/storage/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [Amazon S3](#amazon-s3)
  * [Amazon EBS](#amazon-ebs)
  * [Amazon EBS Snapshots](#amazon-ebs-snapshots)
  * [Amazon EBS Snapshots Copy](#amazon-ebs-snapshots-copy)
  * [Amazon EBS Volumes vs Snapshots ratio](#amazon-ebs-volumes-vs-snapshots-ratio)
  * [Amazon EFS](#amazon-efs)
  * [Amazon FSx](#amazon-fsx)
  * [AWS Backup](#aws-backup)
  * [Amazon EBS Volumes Upgrade gp2 to gp3](#amazon-ebs-volumes-upgrade-gp2-to-gp3)

### Amazon S3

#### Query Description
This query provides daily unblended cost and usage information for Amazon S3.  The output will include detailed information about the resource id (bucket name), operation, and usage type.  The usage amount and cost will be summed, and rows will be sorted by cost (descending). 

#### Pricing
Please refer to the [S3 pricing page](https://aws.amazon.com/s3/pricing/).  Please refer to [understanding your AWS billing and usage reports for Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/dev/aws-usage-report-understand.html) to understand of of the usage types populated for S3 use. 

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/s3costusagetypewrid.sql)

#### Copy Query
```tsql
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
```

{{< email_button category_text="Storage" service_text="Amazon S3" query_text="Amazon S3 Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon EBS

#### Query Description
This query provides an overview of cost and usage for Amazon EC2 EBS. Output includes daily unblended cost and usage quantity by payer account, linked account, usage type, and resource ID. The usage amount and cost will be summed, and rows will be sorted by day (ascending), then cost (descending).

#### Pricing
Please refer to the [Amazon EBS pricing page](https://aws.amazon.com/ebs/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/ebswrid.sql)

#### Copy Query
```tsql
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
```

{{< email_button category_text="Storage" service_text="Amazon EBS" query_text="AWS EBS" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon EBS Snapshots

#### Query Description
This query provides daily unblended cost and usage information about Amazon EBS Snapshot Usage per account including region. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon EBS pricing page](https://aws.amazon.com/ebs/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/ebssnapshot-spend.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS date_line_item_usage_start_date,
      product_region,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM
      ${tableName}
    WHERE
      ${date_filter}
      AND product_product_name = 'Amazon Elastic Compute Cloud'
      AND line_item_usage_type LIKE '%%EBS%%Snapshot%%'
      AND product_product_family LIKE 'Storage Snapshot'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d'),
      product_region
    ORDER BY
      sum_line_item_unblended_cost DESC, 
      sum_line_item_usage_amount DESC,
      date_line_item_usage_start_date ASC; 
```

{{< email_button category_text="Storage" service_text="Amazon EBS" query_text="AWS EBS Snapshot Spend" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon EBS Snapshots Copy

#### Query Description
This query helps correlate cross-region data transfer cost and usage with EBS Snapshot Copy operations for specific EBS snapshots. Understanding the amount of data transfer associated with specific snapshots, and tangentially how much data change is happening on the associated volume, can be used to inform changes to snapshotting strategy. The query provides total unblended cost and usage information grouped by snapshot, usage type, and line item description. Output is sorted by cost in descending order. 

#### Pricing
EBS Snapshot Copy is charged according to data transferred across regions. Please refer to the [data transfer section of the Amazon EC2 pricing page](https://aws.amazon.com/ec2/pricing/on-demand/#Data_Transfer).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/ebssnapshotscopy.sql)

#### Copy Query
```tsql
    SELECT
      line_item_resource_id,
      line_item_usage_type,
      line_item_line_item_description,
      SUM(line_item_usage_amount) as sum_line_item_usage_amount,
      SUM(line_item_unblended_cost) as sum_line_item_unblended_cost
    FROM
      ${table_name}    
    WHERE
      ${date_filter}
      AND line_item_operation = 'EBS Snapshot Copy'
    GROUP BY
      line_item_resource_id,
      line_item_usage_type,
      line_item_line_item_description
    ORDER BY
      SUM(line_item_unblended_cost) DESC; 
```

{{< email_button category_text="Storage" service_text="Amazon EBS Snapshots Copy" query_text="AWS EBS Snapshots Copy" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)
### Amazon EBS Volumes

#### Query Description
This query provides daily unblended cost and usage information about Amazon EBS Volume Usage per account. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon EBS pricing page](https://aws.amazon.com/ebs/pricing/).  Please refer to the [Amazon EBS Volume Charges](https://aws.amazon.com/premiumsupport/knowledge-center/ebs-volume-charges/) page for more info on the calculations used on your bill. 

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/ebsusagespend.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
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
    END AS line_item_usage_type,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM
      ${tableName}
    WHERE
      ${date_filter}
      AND product_product_name = 'Amazon Elastic Compute Cloud'
      AND line_item_usage_type LIKE '%%EBS%%Volume%%'
      AND product_product_family  IN ('Storage','System Operation')
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
      line_item_usage_type
    ORDER BY
      sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Storage" service_text="Amazon EBS" query_text="AWS EBS Usage Spend" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon EBS Volumes vs Snapshots ratio

#### Query Description
This query provides monthly ratio of unblended cost and usage information between Amazon EBS Volume vs Amazon EBS Snapshots Usage per account and region. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon EBS pricing page](https://aws.amazon.com/ebs/pricing/).  Please refer to the [Amazon EBS Volume Charges](https://aws.amazon.com/premiumsupport/knowledge-center/ebs-volume-charges/) page for more info on the calculations used on your bill. 

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/ebssnapshotratio.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id ,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
      CASE 
        WHEN product_product_family = 'Storage' THEN 'EBS Volume'
        WHEN product_product_family = 'Storage Snapshot' THEN 'EBS Snapshot'
      END AS usage_type_product_product_family,
      product_region,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM
      ${tableName}
    WHERE
      ${date_filter}
      AND product_product_name = 'Amazon Elastic Compute Cloud'
      AND (product_product_family = 'Storage Snapshot' OR product_product_family = 'Storage')
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m'),
      CASE 
      WHEN product_product_family = 'Storage' THEN 'EBS Volume'
      WHEN product_product_family = 'Storage Snapshot' THEN 'EBS Snapshot'
      END,
      product_region
    ORDER BY
      month_line_item_usage_start_date ASC, 
      sum_line_item_unblended_cost DESC,
      sum_line_item_usage_amount DESC;
```

{{< email_button category_text="Storage" service_text="Amazon EBS" query_text="AWS EBS Volume vs Snapshot Ratio, Usage Spend" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon EFS

#### Query Description
This query will provide daily unblended cost and usage information per linked account for Amazon EFS.  The output will include detailed information about the resource id (File System), usage type, and API operation.  The usage amount and cost will be summed and the cost will be in descending order. 

#### Pricing
Please refer to the [Amazon EFS pricing page](https://aws.amazon.com/efs/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/efswrid.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      SPLIT_PART(line_item_resource_id, 'file-system/', 2) AS split_line_item_resource_id,
      line_item_usage_type,
      product_product_family,
      product_storage_class,
      pricing_unit,
      line_item_operation,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM
      ${table_name}
    WHERE
      ${date_filter}
      AND product_product_name = 'Amazon Elastic File System'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_usage_type,
      pricing_unit,
      product_product_family,
      product_storage_class,
      line_item_resource_id,
      line_item_operation
    ORDER BY
      day_line_item_usage_start_date,
      sum_line_item_usage_amount,
      sum_line_item_unblended_cost DESC,
      line_item_usage_type;
```

{{< email_button category_text="Storage" service_text="Amazon EFS" query_text="Amazon EFS Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon FSx

#### Query Description
This query will provide daily unblended cost and usage information per linked account for Amazon FSx.  The output will include detailed information about the resource id (FSx file system), usage type, and Storage type. The usage amount and cost will be summed and the cost will be in descending order. 

#### Pricing
Please refer to the [Amazon FSx pricing page](https://aws.amazon.com/fsx/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/fsxwrid.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      SPLIT_PART(line_item_resource_id, ':', 6) AS split_line_item_resource_id,
      product_deployment_option,
      line_item_usage_type,
      product_product_family,
      pricing_unit,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM
      ${table_name}
    WHERE
      ${date_filter}
      AND product_product_name = 'Amazon FSx'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      SPLIT_PART(line_item_resource_id, ':', 6),
      product_deployment_option,
      line_item_usage_type,
      product_product_family,
      pricing_unit
    ORDER BY
      day_line_item_usage_start_date,
      sum_line_item_usage_amount,
      sum_line_item_unblended_cost;
```

{{< email_button category_text="Storage" service_text="Amazon FSx" query_text="Amazon FSx Query" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### AWS Backup

#### Query Description
This query will provide daily unblended cost and usage information per linked account for AWS Backup.  The output will include detailed information about the usage type, product family, pricing unit and others. The usage amount and cost will be summed and the cost will be in descending order. 

#### Pricing
Please refer to the [AWS Backup pricing page](https://aws.amazon.com/backup/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/backup_spend.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date), '%Y-%m-%d') AS day_line_item_usage_start_date,
      pricing_unit,
      product_product_family,
      line_item_usage_type,
      line_item_operation,
      SPLIT_PART(line_item_usage_type, '-', 4) AS split_line_item_usage_type,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM
      ${table_name}
    WHERE
      ${date_filter}
      AND product_product_name LIKE '%Backup%'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_usage_type,
      product_product_family,
      pricing_unit,
      line_item_operation
    ORDER BY
      day_line_item_usage_start_date,
      sum_line_item_usage_amount,
      sum_line_item_unblended_cost,
      line_item_usage_type;
```

{{< email_button category_text="Storage" service_text="AWS Backup" query_text="AWS Backup Query" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon EBS Volumes Upgrade gp2 to gp3

#### Query Description
This query will display cost and usage of Elastic Block Storage Volumes that are type gp3. These resources returned by this query could be considered for upgrade to gp3 as with up to 20% cost savings, gp3 volumes help you achieve more control over your provisioned IOPS, giving the ability to provision storage with your unique applications in mind. This query uses 0.088 gp3 pricing please check the pricing page to confirm you are using the correct pricing for your applicable region. For Additional information checkout this [AWS Blog Post.](https://aws.amazon.com/blogs/aws-cost-management/finding-savings-from-2020-reinvent-announcements/)

#### Pricing
Please refer to the [Elastic Block Storage pricing page](https://aws.amazon.com/ebs/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/ebs_gp2_to_gp3.sql)

#### Copy Query
```tsql
    SELECT * FROM 
        (SELECT bill_payer_account_id,
        line_item_usage_account_id,
        product_location,
        product_region,
        month,
        pricing_public_on_demand_rate,
        line_item_resource_id,
        line_item_usage_type,
        SPLIT_PART(SPLIT_PART(line_item_usage_type ,
        ':',2),'.',2) AS ebs_type,

        SUM(line_item_usage_amount) AS gb_charged,
        SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost,
        SUM(line_item_usage_amount)*.088 AS gp3_price -- 0.088 eu-west-1 pricing
        , (SUM(line_item_unblended_cost)-(SUM(line_item_usage_amount)*.088)) AS gp3_savings -- 0.088 eu-west-1 pricing

        FROM ${table}
        WHERE ${date_filter}
        AND product_product_name = 'Amazon Elastic Compute Cloud'
        AND line_item_usage_type LIKE '%%EBS%%Volume%%'
        AND product_product_family IN ('Storage','System Operation')
        AND line_item_line_item_type = ('Usage')
        AND product_region = 'eu-west-1'
        AND SPLIT_PART(SPLIT_PART(line_item_usage_type,':',2),'.',2) = 'gp2'

        GROUP BY bill_payer_account_id, line_item_usage_account_id, month, line_item_usage_type, product_location, product_region, line_item_resource_id, pricing_public_on_demand_rate, month
        ORDER BY sum_line_item_unblended_cost DESC)
        WHERE gb_charged < 1000;
```

{{< email_button category_text="Compute" service_text="ELB" query_text="Elastic Block Storage gp2 upgrade to gp3" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}
