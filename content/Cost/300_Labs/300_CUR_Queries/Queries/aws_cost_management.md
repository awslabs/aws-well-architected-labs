---
title: "AWS Cost Management"
date: 2020-08-28T11:16:09-04:00
chapter: false
weight: 3
pre: "<b> </b>"
---

These are queries for AWS Services under the [AWS Cost Management product family](https://aws.amazon.com/aws-cost-management/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
You may need to change variables used as placeholders in your query. **${table_Name}** is a common variable which needs to be replaced. **Example: cur_db.cur_table**
{{% /notice %}}

### Table of Contents

{{< expand "AWS Marketplace" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides AWS Marketplace subscription costs including subscription product name, associated linked account, and monthly total unblended cost.  This query includes tax, however this can be filtered out in the WHERE clause.  Please refer to the [CUR Query Library Helpers section](/cost/300_labs/300_cur_queries/query_help/) for assistance.  

#### Pricing
Please refer to the [AWS Marketplace FAQ](https://aws.amazon.com/marketplace/help/).

#### Sample Output
![Images/subscriptions-output.png](/Cost/300_CUR_Queries/Images/AWS_Cost_Management/marketplacespend.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/AWS_Cost_Management/marketplacespend.sql)

#### Copy Query
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      IF(line_item_usage_start_date IS NULL, 
          DATE_FORMAT(DATE_PARSE(CONCAT(SPLIT_PART('${table_name}','_',5),'01'),'%Y%m%d'),'%Y-%m-01'),
          DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') 
          ) AS month_line_item_usage_start_time,
      bill_billing_entity,
      product_product_name,
    SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE 
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND bill_billing_entity = 'AWS Marketplace'
    GROUP BY
      1,2,3,4,5
    ORDER BY
      month_line_item_usage_start_time ASC,
      sum_line_item_unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="AWS Cost Management" service_text="AWS Marketplace" query_text="AWS Marketplace Total Monthly Spend Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}






