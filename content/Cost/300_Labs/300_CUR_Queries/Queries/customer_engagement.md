---
title: "Customer Engagement"
date: 2020-08-28T11:16:09-04:00
chapter: false
weight: 5
pre: "<b> </b>"
---

These are queries for AWS Services under the [Customer Engagement product family](https://aws.amazon.com/products/customer-engagement/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
You may need to change variables used as placeholders in your query. **${table_Name}** is a common variable which needs to be replaced. **Example: cur_db.cur_table**
{{% /notice %}}

### Table of Contents

{{< expand "Amazon Connect" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide daily unblended cost and usage information per linked account for Amazon Connect. The output will include specific details about the usage type, usage description, and product usage region.  The cost will be summed and in descending order.

#### Pricing
Please refer to the [Connect pricing page](https://aws.amazon.com/connect/pricing/).

#### Sample Output
![Images/connect.png](/Cost/300_CUR_Queries/Images/Customer_Engagement/connect.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Customer_Engagement/connect.sql)

#### Copy Query
    SELECT *
    FROM 
    ( 
      (
        SELECT
          bill_payer_account_id,
          line_item_usage_account_id,
          DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
          product_region,
          CASE
            WHEN line_item_usage_type LIKE '%%end-customer-mins' THEN 'End customer minutes'
            WHEN line_item_usage_type LIKE '%%chat-message' THEN 'Chat messages'
            ELSE 'Others'
          END AS UsageType,
          line_item_line_item_description,
          SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
          SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
        FROM 
          ${table_name}
        WHERE
          year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
          AND line_item_product_code = 'AmazonConnect'
          AND line_item_line_item_type = 'Usage'
        GROUP BY
          bill_payer_account_id, 
          line_item_usage_account_id,
          DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
          product_region,
          line_item_usage_type,
          line_item_line_item_description
      )

      UNION ALL

      (
        SELECT
          bill_payer_account_id,
          line_item_usage_account_id,
          DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
          product_region,
          CASE
            WHEN line_item_usage_type LIKE '%%did-numbers' THEN 'DID days of use'
            WHEN line_item_usage_type LIKE '%%tollfree-numbers' THEN 'Toll free days of use'
            WHEN line_item_usage_type LIKE '%%did-inbound-mins' THEN 'Inbound DID minutes'
            WHEN line_item_usage_type LIKE '%%outbound-mins' THEN 'Outbound minutes'
            WHEN line_item_usage_type LIKE '%%tollfree-inbound-mins' THEN 'Inbound Toll Free minutes'
            ELSE 'Other'
          END AS UsageType,
          line_item_line_item_description,
          SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
          SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
        FROM 
          ${table_name}
        WHERE
          year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
          AND line_item_product_code = 'ContactCenterTelecomm'
          AND line_item_line_item_type = 'Usage'
        GROUP BY
          bill_payer_account_id, 
          line_item_usage_account_id,
          DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
          product_region,
          line_item_usage_type,
          line_item_line_item_description
      )
    ) AS aggregatedTable
    ORDER BY
      day_line_item_usage_start_date ASC,
      sum_line_item_unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="Customer Engagement" service_text="Amazon Connect" query_text="Amazon Connect Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}





