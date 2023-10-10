---
title: "Customer Engagement"
weight: 5
---

These are queries for AWS Services under the [Customer Engagement product family](https://aws.amazon.com/products/customer-engagement/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [Amazon Connect](#amazon-connect)
  
### Amazon Connect

#### Query Description
This query will provide daily unblended cost and usage information per linked account for Amazon Connect. The output will include specific details about the usage type, usage description, and product usage region.  The cost will be summed and in descending order.

#### Pricing
Please refer to the [Connect pricing page](https://aws.amazon.com/connect/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Customer_Engagement/connect.sql)

#### Copy Query
```tsql
SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  product_region,
  CASE
    WHEN line_item_usage_type LIKE '%end-customer-mins' THEN 'End customer minutes'
    WHEN line_item_usage_type LIKE '%chat-message' THEN 'Chat messages'
    WHEN line_item_usage_type LIKE '%did-numbers' THEN 'DID days of use'
    WHEN line_item_usage_type LIKE '%tollfree-numbers' THEN 'Toll free days of use'
    WHEN line_item_usage_type LIKE '%did-inbound-mins' THEN 'Inbound DID minutes'
    WHEN line_item_usage_type LIKE '%outbound-mins' THEN 'Outbound minutes'
    WHEN line_item_usage_type LIKE '%tollfree-inbound-mins' THEN 'Inbound Toll Free minutes'
    ELSE 'Others'
  END AS case_line_item_usage_type,
  line_item_line_item_description,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name}
WHERE
  ${date_filter}
  AND line_item_product_code IN ('AmazonConnect', 'ContactCenterTelecomm')
  AND line_item_line_item_type = 'Usage'
GROUP BY
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  product_region,
  line_item_usage_type,
  line_item_line_item_description
ORDER BY
  day_line_item_usage_start_date ASC,
  sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Customer Engagement" service_text="Amazon Connect" query_text="Amazon Connect Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}





