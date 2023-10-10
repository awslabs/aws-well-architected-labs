---
title: "Analytics"
weight: 1
---

These are queries for AWS Services under the [Analytics product family](https://aws.amazon.com/big-data/datalakes-and-analytics). 

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [Amazon Athena](#amazon-athena)
  * [AWS Glue](#aws-glue)
  * [Amazon Kinesis](#amazon-kinesis)
  * [Amazon Elasticsearch](#amazon-elasticsearch)
  * [Amazon EMR](#amazon-emr)
  * [Amazon QuickSight](#amazon-quicksight)
  * [Amazon MSK](#amazon-msk)
  
### Amazon Athena

#### Query Description
This query will provide daily unblended and usage information for Amazon Athena.  The output will include detailed information about the resource id.  The cost will be summed and in descending order.

#### Pricing
Please refer to the [Athena pricing page](https://aws.amazon.com/athena/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Analytics/athena.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  line_item_usage_type,
  line_item_resource_id,
  product_region,
  line_item_product_code,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND line_item_product_code = 'AmazonAthena'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  line_item_usage_start_date,
  line_item_usage_type,
  line_item_resource_id,
  product_region,
  line_item_product_code
ORDER BY 
  sum_line_item_unblended_cost DESC
LIMIT 20; 
```

{{< email_button category_text="Analytics" service_text="Athena" query_text="Athena Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### AWS Glue

#### Query Description
This query will provide daily unblended and usage information per linked account for AWS Glue.  The output will include detailed information about the resource id (Glue Crawler) and API operation.  The cost will be summed and in descending order.

#### Pricing
Please refer to the [Glue pricing page](https://aws.amazon.com/glue/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Analytics/gluewrid.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,  
  line_item_operation,
  CASE
    WHEN LOWER(line_item_operation) = 'jobrun' THEN SPLIT_PART(line_item_resource_id, 'job/', 2)
    WHEN LOWER(line_item_operation) = 'crawlerrun' THEN SPLIT_PART(line_item_resource_id, 'crawler/', 2)
    ELSE 'N/A'
  END AS case_line_item_resource_id,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16, 8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND product_product_name = ('AWS Glue')
  AND line_item_line_item_type IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), 
  line_item_operation,
  line_item_resource_id
ORDER BY 
  day_line_item_usage_start_date,
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost;
```

{{< email_button category_text="Analytics" service_text="Glue" query_text="Glue Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)



### Amazon Kinesis

#### Query Description
This query will provide daily unblended and usage information per linked account for each Kinesis product (Amazon Kinesis, Amazon Kinesis Firehose, and Amazon Kinesis Analytics).  The output will include detailed information about the resource id (Stream, Delivery Stream, etc...) and API operation.  The cost will be summed and in descending order.

#### Pricing
Please refer to the Kinesis pricing pages:

[Amazon Kinesis Data Streams Pricing](https://aws.amazon.com/kinesis/data-streams/pricing/)

[Amazon Kinesis Data Firehose Pricing](https://aws.amazon.com/kinesis/data-analytics/pricing/)

[Amazon Kinesis Data Analytics Pricing](https://aws.amazon.com/kinesis/data-analytics/pricing/)

[Amazon Kinesis Video Streams pricing](https://aws.amazon.com/kinesis/video-streams/pricing)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Analytics/kinesis.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  SPLIT_PART(line_item_resource_id,':',6) AS split_line_item_resource_id,
  product_product_name,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16, 8))) AS sum_line_item_unblended_cost
FROM 
  ${table_Name} 
WHERE 
  ${date_filter} 
  AND line_item_product_code LIKE '%Kinesis%'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), 
  line_item_resource_id,
  product_product_name
ORDER BY 
  day_line_item_usage_start_date,
  sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Analytics" service_text="Kinesis" query_text="Kinesis Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon Elasticsearch

#### Query Description
This query will provide daily unblended and amortized cost as well as usage information per linked account for Amazon Elasticsearch.  The output will include detailed information about the resource id (ES Domain), usage type, and API operation.  The usage amount and cost will be summed and the cost will be in descending order. This query includes RI and SP true up which will show any upfront fees to the account that purchased the pricing model.

#### Pricing
Please refer to the [Elasticsearch pricing page](https://aws.amazon.com/elasticsearch-service/pricing/).  Please refer to this blog for [Cost Optimization techniques](https://aws.amazon.com/blogs/database/reducing-cost-for-small-amazon-elasticsearch-service-domains/). 

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Analytics/elasticsearch.sql)

#### Copy Query
```tsql
SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  SPLIT_PART(line_item_resource_id,':',6) AS split_line_item_resource_id,
  product_product_family,
  product_instance_family,
  product_instance_type,
  pricing_term,
  product_storage_media,
  product_transfer_type,
  SUM(CASE 
    WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN line_item_usage_amount 
    WHEN (line_item_line_item_type = 'DiscountedUsage') THEN line_item_usage_amount 
    WHEN (line_item_line_item_type = 'Usage') THEN line_item_usage_amount 
    ELSE 0 
  END) AS sum_line_item_usage_amount,
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost,
  SUM(CASE
    WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost 
    WHEN (line_item_line_item_type = 'SavingsPlanRecurringFee') THEN (savings_plan_total_commitment_to_date - savings_plan_used_commitment) 
    WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN 0
    WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN 0
    WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost  
    WHEN (line_item_line_item_type = 'RIFee') THEN (reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee)
    WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN 0 
    ELSE line_item_unblended_cost 
  END) AS sum_amortized_cost,
  SUM(CASE
    WHEN (line_item_line_item_type = 'SavingsPlanRecurringFee') THEN (-savings_plan_amortized_upfront_commitment_for_billing_period) 
    WHEN (line_item_line_item_type = 'RIFee') THEN (-reservation_amortized_upfront_fee_for_billing_period) 
    ELSE 0 
  END) AS sum_ri_sp_trueup,
  SUM(CASE
    WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN line_item_unblended_cost
    WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN line_item_unblended_cost 
    ELSE 0 
  END) AS sum_ri_sp_upfront_fees
FROM
  ${table_name}
WHERE
  ${date_filter}
  AND product_product_name in ('Amazon Elasticsearch Service' ,'Amazon OpenSearch Service')
  AND line_item_product_code = 'AmazonES'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  SPLIT_PART(line_item_resource_id,':',6),
  product_product_family,
  product_instance_family,
  product_instance_type,
  pricing_term,
  product_storage_media,
  product_transfer_type
ORDER BY
  day_line_item_usage_start_date,
  product_product_family,
  sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Analytics" service_text="Elasticsearch" query_text="Elasticsearch Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


### Amazon EMR

#### Query Description
This query will provide daily unblended cost and usage information per linked account for Amazon EMR.  The cost will be summed and the cost will be in descending order. 

#### Pricing 
Please refer to the [EMR pricing page](https://aws.amazon.com/emr/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Analytics/emr.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  SPLIT_PART(line_item_usage_type ,':',2) AS split_line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND product_product_name = 'Amazon Elastic MapReduce'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY 
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), 
  line_item_usage_type,
  line_item_line_item_type
ORDER BY 
  day_line_item_usage_start_date,
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost DESC,
  split_line_item_usage_type;
```

{{< email_button category_text="Analytics" service_text="EMR" query_text="EMR Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon QuickSight

#### Query Description
This query will provide monthly unblended and usage information per linked account for Amazon QuickSight.  The output will include detailed information about the usage type and its usage amount. The cost will be summed and in descending order.

#### Pricing
Please refer to the [Amazon QuickSight pricing page](https://aws.amazon.com/quicksight/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Analytics/quicksight.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, 
  CASE
    WHEN LOWER(line_item_usage_type) LIKE 'qs-user-enterprise%' THEN 'Users - Enterprise'
    WHEN LOWER(line_item_usage_type) LIKE 'qs-user-standard%' THEN 'Users - Standard'
    WHEN LOWER(line_item_usage_type) LIKE 'qs-reader%' THEN 'Reader Usage'
    WHEN LOWER(line_item_usage_type) LIKE '%spice' THEN 'SPICE' 
    WHEN LOWER(line_item_usage_type) LIKE '%alerts%' THEN 'Alerts'
    ELSE line_item_usage_type
  END AS case_line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND product_product_name = 'Amazon QuickSight'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage')
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'), 
  4 -- refers to case_line_item_usage_type
ORDER BY 
  month_line_item_usage_start_date,
  sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Analytics" service_text="Amazon QuickSight" query_text="QuickSight Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)




### Amazon MSK

#### Query Description
This query will provide monthly unblended and usage information per linked account for all types of Amazon MSK, including OD and Serverless.  The output will include detailed information about the usage type and its usage amount. The cost will be summed and in descending order.

#### Pricing
Please refer to the [Amazon MSK pricing page](https://aws.amazon.com/msk/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Analytics/msk.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id, 
  line_item_product_code, 
  line_item_line_item_description, 
  line_item_operation,
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost 
FROM 
  ${table_name}  
WHERE
  ${date_filter} 
  AND line_item_product_code = 'AmazonMSK'
  AND line_item_line_item_type NOT IN ('Tax','Refund','Credit')
GROUP BY 1,2,3,4,5
  ORDER BY 
  sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Analytics" service_text="Amazon MSK" query_text="MSK Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: <a href="mailto:curquery@amazon.com?subject=Cur Query Library Request - Analytics">curquery@amazon.com</a>
{{% /notice %}}
