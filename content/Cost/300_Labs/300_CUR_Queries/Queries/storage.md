---
title: "Storage"
date: 2020-08-28T11:16:09-04:00
chapter: false
weight: 13
pre: "<b> </b>"
---

These are queries for AWS Services under the [Storage product family](https://aws.amazon.com/products/storage/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
You may need to change variables used as placeholders in your query. **${table_Name}** is a common variable which needs to be replaced. **Example: cur_db.cur_table**
{{% /notice %}}

### Table of Contents

{{< expand "Amazon S3" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides daily unblended cost and usage information for Amazon S3.  The output will include detailed information about the resource id (bucket name) and usage type.  The usage amount and cost will be summed and the cost will be in descending order. 

#### Pricing
Please refer to the [S3 pricing page](https://aws.amazon.com/s3/pricing/).  Please refer to [understanding your AWS billing and usage reports for Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/dev/aws-usage-report-understand.html) to understand of of the usage types populated for S3 use. 

#### Sample Output
![Images/s3costusagetypegroupwrid.png](/Cost/300_CUR_Queries/Images/Storage/s3costusagetypegroupwrid.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/s3costusagetypegroupwrid.sql)

#### Copy Query
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
      AND (("line_item_product_code" LIKE '%AmazonGlacier%') OR ("line_item_product_code" LIKE '%AmazonS3%'))
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      1,2,3,4,5,6
    ORDER By
      day_line_item_usage_start_date ASC,
      line_item_usage_account_id,
      line_item_usage_type_group DESC,
      sum_line_item_unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="Storage" service_text="Amazon S3" query_text="Amazon S3 Query1" button_text="Help & Feedback" %}}

{{< /expand >}}



{{< expand "Amazon EBS Snapshots" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides daily unblended cost and usage information about Amazon EBS Snapshot Usage per account including region. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon EBS pricing page](https://aws.amazon.com/ebs/pricing/).

#### Sample Output
![Images/ebssnapshot-spend.png](/Cost/300_CUR_Queries/Images/Storage/ebssnapshot-spend.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/ebssnapshot-spend.sql)

#### Copy Query
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS date_line_item_usage_start_date,
      product_region,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM
      ${tableName}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_product_name = 'Amazon Elastic Compute Cloud'
      AND line_item_usage_type LIKE '%%EBS%%Snapshot%%'
      AND product_product_family LIKE 'Storage Snapshot'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d'),
      product_region
    ORDER BY
      sum_line_item_unblended_cost DESC, 
      sum_line_item_usage_amount DESC,
      date_line_item_usage_start_date ASC; 

{{% /markdown_wrapper %}}

{{% email_button category_text="Storage" service_text="Amazon EBS" query_text="AWS EBS Snapshot Spend" button_text="Help & Feedback" %}}

{{< /expand >}}



{{< expand "Amazon EBS Volumes" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides daily unblended cost and usage information about Amazon EBS Volume Usage per account. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon EBS pricing page](https://aws.amazon.com/ebs/pricing/).  Please refer to the [Amazon EBS Volume Charges](https://aws.amazon.com/premiumsupport/knowledge-center/ebs-volume-charges/) page for more info on the calculations used on your bill. 

#### Sample Output
![Images/ebssnapshot-spend.png](/Cost/300_CUR_Queries/Images/Storage/ebsusagespend.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/ebsusagespend.sql)

#### Copy Query
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
    CASE SPLIT_PART(line_item_usage_type,':',2)
        WHEN 'VolumeUsage' THEN 'EBS - Magnetic'
        WHEN 'VolumeUsage.gp2' THEN 'EBS - SSD(gp2)'
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

{{% /markdown_wrapper %}}

{{% email_button category_text="Storage" service_text="Amazon EBS" query_text="AWS EBS Usage Spend" button_text="Help & Feedback" %}}

{{< /expand >}}



{{< expand "AWS EFS" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide daily unblended cost and usage information per linked account for AWS EFS.  The output will include detailed information about the resource id (File System), usage type, and API operation.  The usage amount and cost will be summed and the cost will be in descending order. 

#### Pricing
Please refer to the [EFS pricing page](https://aws.amazon.com/efs/pricing/).

#### Sample Output
![Images/efswrid.png](/Cost/300_CUR_Queries/Images/Storage/efswrid.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Storage/efswrid.sql)

#### Copy Query
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
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_product_name = 'Amazon Elastic File System'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
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

{{% /markdown_wrapper %}}

{{% email_button category_text="Storage" service_text="Amazon EFS" query_text="AWS EFS Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}






