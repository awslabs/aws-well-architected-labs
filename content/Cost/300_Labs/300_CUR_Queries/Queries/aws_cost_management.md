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
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost/300_labs/300_CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [AWS Marketplace](#aws-marketplace)
  
### AWS Marketplace

#### Query Description
This query provides AWS Marketplace subscription costs including subscription product name, associated linked account, and monthly total unblended cost.  This query includes tax, however this can be filtered out in the WHERE clause.  Please refer to the [CUR Query Library Helpers section](/cost/300_labs/300_cur_queries/query_help/) for assistance.  

#### Pricing
Please refer to the [AWS Marketplace FAQ](https://aws.amazon.com/marketplace/help/).

#### Sample Output
![Images/subscriptions-output.png](/Cost/300_CUR_Queries/Images/AWS_Cost_Management/marketplacespend.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/AWS_Cost_Management/marketplacespend.sql)

#### Copy Query
```tsql
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
      ${date_filter}
      AND bill_billing_entity = 'AWS Marketplace'
    GROUP BY
      1,2,3,4,5
    ORDER BY
      month_line_item_usage_start_time ASC,
      sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="AWS Cost Management" service_text="AWS Marketplace" query_text="AWS Marketplace Total Monthly Spend Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}






