---
title: "Developer Tools"
weight: 12
---

These are queries for AWS Services under the [Developer Tools family](https://aws.amazon.com/products/developer-tools/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [AWS CodeBuild](#aws-codebuild)


### AWS CodeBuild

#### Query Description
This query provides daily unblended cost and usage information about AWS CodeBuild Usage. The usage amount and cost will be summed.

#### Pricing
Please refer to the [AWS CodeBuild pricing page](https://aws.amazon.com/codebuild/pricing/?nc=sn&loc=3) for more details.

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Developer_Tools/codebuild.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      line_item_resource_id,
      line_item_usage_type,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM ${table_name}
    WHERE ${date_filter}
      AND line_item_product_code = 'CodeBuild'
    GROUP BY
      1, 2, 3, 4, 5
    ORDER BY
      sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Developer Tools" service_text="AWS CodeBuild" query_text="AWS CodeBuild Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}




