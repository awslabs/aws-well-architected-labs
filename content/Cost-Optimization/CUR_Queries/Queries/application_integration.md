---
title: "Application Integration"
weight: 2
---

These are queries for AWS Services under the [Application Integration product family](https://aws.amazon.com/products/application-integration).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [Amazon MQ](#amazon-mq)
  * [Amazon SES](#amazon-ses)
  * [Amazon SNS](#amazon-sns)
  * [Amazon SQS Top 20 Daily Unblended Costs](#amazon-sqs-top-20-daily-unblended-costs)
  * [Amazon SQS By Product Family](#amazon-sqs-by-product-family)
  
### Amazon MQ

#### Query Description
This query will provide daily unblended and amortized cost as well as usage information per linked account for Amazon MQ.  The output will include detailed information about the resource id (broker), usage type, and API operation.  The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon MQ pricing page](https://aws.amazon.com/amazon-mq/pricing/).

{{% notice note %}}
This query will **not** run against CUR data that does not have any Amazon MQ usage.  
{{% /notice%}}

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Application_Integration/mqwrid.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  product_broker_engine,
  line_item_usage_type,
  product_product_family,
  pricing_unit,
  pricing_term,
  SPLIT_PART(line_item_usage_type, ':', 2) AS split_line_item_usage_type,
  SPLIT_PART(line_item_resource_id, ':', 7) AS split_line_item_resource_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  line_item_operation,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND product_product_name = 'Amazon MQ'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  product_broker_engine,
  product_product_family,
  pricing_unit,
  pricing_term,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), 
  line_item_usage_type,
  line_item_resource_id,
  line_item_operation
ORDER BY 
  day_line_item_usage_start_date,
  sum_line_item_unblended_cost DESC,
  split_line_item_usage_type;
```

{{< email_button category_text="Application Integration" service_text="Amazon MQ" query_text="Amazon MQ Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon SES

#### Query Description
This query will provide daily unblended and usage information per linked account for Amazon SES.  The output will include detailed information about the product family (Sending Attachments, Data Transfer, etc...) and usage type.  The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon SES pricing page](https://aws.amazon.com/ses/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Application_Integration/ses.sql)

#### Copy Query
```tsql
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
  END AS case_line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_Name} 
WHERE 
  ${date_filter} 
  AND product_product_name = 'Amazon Simple Email Service'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY 
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), 
  product_product_family,
  5 --refers to case_line_item_usage_type
ORDER BY 
  day_line_item_usage_start_date,
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Application Integration" service_text="Amazon SES" query_text="Amazon SES Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon SNS

#### Query Description
This query will provide daily unblended cost and usage information per linked account for Amazon SNS.  The output will include detailed information about the product family, API Operation, and usage type.  The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon SNS pricing page](https://aws.amazon.com/sns/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Application_Integration/sns.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  CONCAT(product_product_family,' - ',line_item_operation) AS concat_product_product_family,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_Name} 
WHERE 
  ${date_filter} 
  AND product_product_name = 'Amazon Simple Notification Service'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY 
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), 
  CONCAT(product_product_family,' - ',line_item_operation)
ORDER BY 
  day_line_item_usage_start_date,
  sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Application Integration" service_text="Amazon SNS" query_text="Amazon SNS Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon SQS Top 20 Daily Unblended Costs

#### Query Description
This query will provide the top 20 daily unblended costs as well as usage information for a specified linked account for Amazon SQS.  The output will include detailed information about the resource id (queue), usage type, and API operation.  The cost will be summed and in descending order.  This is helpful for tracking down spikes in cost for SQS usage.  Cost Explorer will provide you all of this information except the resource ID.  This allows your investigation to be targeted to a time range, linked account, API operation, and resource that is generating the usage.

#### Pricing
Please refer to the [Amazon SQS pricing page](https://aws.amazon.com/sqs/pricing/).  Please refer to the [Reducing Amazon SQS costs page](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/reducing-costs.html) and [Enabling client-side buffering and request batching](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-client-side-buffering-request-batching.html) for Cost Optimization suggestions.

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Application_Integration/sqs.sql)

#### Copy Query
```tsql
SELECT 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  line_item_usage_type,
  line_item_operation,
  line_item_resource_id,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_Name} 
WHERE 
  ${date_filter} 
  AND line_item_product_code = 'AWSQueueService'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  line_item_usage_type,
  line_item_operation,
  line_item_resource_id
ORDER BY 
  sum_line_item_unblended_cost DESC
LIMIT 20; 
```

{{< email_button category_text="Application Integration" service_text="Amazon SQS" query_text="Amazon SQS Top 20 Daily Unblended Costs" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)
### Amazon SQS By Product Family

#### Query Description
This query will provide daily unblended cost and usage information for Amazon SQS, grouped by account and operation. The operation is also grouped using product_product_family, which results in values such as "Data Transfer - Receive" and "API Request - SendMessageBatch". Output is ordered by date, then by cost (descending). This can be used to identify specific API operations driving the most daily cost, which allows for targeted investigation into optimization opportunities.

#### Pricing
Please refer to the [Amazon SQS pricing page](https://aws.amazon.com/sqs/pricing/).  Please refer to the [Reducing Amazon SQS costs page](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/reducing-costs.html) and [Enabling client-side buffering and request batching](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-client-side-buffering-request-batching.html) for Cost Optimization suggestions.

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Application_Integration/sqs-by-product-family.sql)

#### Copy Query
```tsql
SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  CONCAT(product_product_family,' - ',line_item_operation) AS concat_product_product_family,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM
    ${table_name}
WHERE
    ${date_filter}}
    AND line_item_product_code = 'AWSQueueService'
    AND line_item_line_item_type IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  CONCAT(product_product_family,' - ',line_item_operation)
ORDER BY
  day_line_item_usage_start_date,
  sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Application Integration" service_text="Amazon SQS" query_text="Amazon SQS By Product Family" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}





