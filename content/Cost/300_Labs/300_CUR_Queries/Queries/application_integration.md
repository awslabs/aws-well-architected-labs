---
title: "Application Integration"
date: 2020-08-28T11:16:09-04:00
chapter: false
weight: 2
pre: "<b> </b>"
---

These are queries for AWS Services under the [Application Integration product family](https://aws.amazon.com/products/application-integration).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
You may need to change variables used as placeholders in your query. **${table_Name}** is a common variable which needs to be replaced. **Example: cur_db.cur_table**
{{% /notice %}}

### Table of Contents
  * [Amazon MQ](#amazon-mq)
  * [Amazon SES](#amazon-ses)
  * [Amazon SNS](#amazon-sns)
  * [Amazon SQS](#amazon-sqs)
  
### Amazon MQ

#### Query Description
This query will provide daily unblended and amortized cost as well as usage information per linked account for Amazon MQ.  The output will include detailed information about the resource id (broker), usage type, and API operation.  The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon MQ pricing page](https://aws.amazon.com/amazon-mq/pricing/).

{{% notice note %}}
This query will **not** run against CUR data that does not have any Amazon MQ usage.  
{{% /notice%}}

#### Sample Output
![Images/mq-w-rid-output.png](/Cost/300_CUR_Queries/Images/Application_Integration/mqwrid.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Application_Integration/mqwrid.sql)

#### Copy Query
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
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM
      ${table_Name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_product_name = 'Amazon MQ'
      AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
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

{{% email_button category_text="Application Integration" service_text="Amazon MQ" query_text="Amazon MQ Query1" button_text="Help & Feedback" %}}

[Back to Table of Contents](#table-of-contents)

### Amazon SES

#### Query Description
This query will provide daily unblended and usage information per linked account for Amazon SES.  The output will include detailed information about the product family (Sending Attachments, Data Transfer, etc...) and usage type.  The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon SES pricing page](https://aws.amazon.com/ses/pricing/).

#### Sample Output
![Images/ses-output.png](/Cost/300_CUR_Queries/Images/Application_Integration/ses.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Application_Integration/ses.sql)

#### Copy Query
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
      AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
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

{{% email_button category_text="Application Integration" service_text="Amazon SES" query_text="Amazon SES Query1" button_text="Help & Feedback" %}}

[Back to Table of Contents](#table-of-contents)

### Amazon SNS

#### Query Description
This query will provide daily unblended cost and usage information per linked account for Amazon SNS.  The output will include detailed information about the product family, API Operation, and usage type.  The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [Amazon SNS pricing page](https://aws.amazon.com/sns/pricing/).

#### Sample Output
![Images/sns-output.png](/Cost/300_CUR_Queries/Images/Application_Integration/sns.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Application_Integration/sns.sql)

#### Copy Query
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      CONCAT(product_product_family,' - ',line_item_operation) AS concat_product_product_family,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_Name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_product_name = 'Amazon Simple Notification Service'
      AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      CONCAT(product_product_family,' - ',line_item_operation)
    ORDER BY
      day_line_item_usage_start_date,
      sum_line_item_unblended_cost DESC;

{{% email_button category_text="Application Integration" service_text="Amazon SNS" query_text="Amazon SNS Query1" button_text="Help & Feedback" %}}

[Back to Table of Contents](#table-of-contents)

### Amazon SQS

#### Query Description
This query will provide the top 20 daily unblended costs as well as usage information for a specified linked account for Amazon SQS.  The output will include detailed information about the resource id (queue), usage type, and API operation.  The cost will be summed and in descending order.  This is helpful for tracking down spikes in cost for SQS usage.  Cost Explorer will provide you all of this information except the resource ID.  This allows your investigation to be targeted to a time range, linked account, API operation, and resource that is generating the usage.

#### Pricing
Please refer to the [Amazon SQS pricing page](https://aws.amazon.com/sqs/pricing/).  Please refer to the [Reducing Amazon SQS costs page](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/reducing-costs.html) and [Enabling client-side buffering and request batching](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-client-side-buffering-request-batching.html) for Cost Optimization suggestions.

#### Sample Output
![Images/sqs.png](/Cost/300_CUR_Queries/Images/Application_Integration/sqs.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Application_Integration/sqs.sql)

#### Copy Query
    SELECT 
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      line_item_usage_type,
      line_item_operation,
      line_item_resource_id,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_Name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND line_item_usage_account_id = '444455556666'
      AND line_item_product_code = 'AWSQueueService'
      AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      1,2,3,4,5
    ORDER BY
      sum_line_item_unblended_cost DESC
    LIMIT 20;

{{% email_button category_text="Application Integration" service_text="Amazon SQS" query_text="Amazon SQS Query1" button_text="Help & Feedback" %}}

[Back to Table of Contents](#table-of-contents)

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}





