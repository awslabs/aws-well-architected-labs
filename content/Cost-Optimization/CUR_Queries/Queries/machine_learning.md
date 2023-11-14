---
title: "Machine Learning"
weight: 9
---

These are queries for AWS Services under the [Machine Learning product family](https://aws.amazon.com/machine-learning/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [Amazon Rekognition](#amazon-rekognition)
  * [Amazon SageMaker](#amazon-sagemaker)
  * [Amazon Textract](#amazon-textract)

### Amazon Rekognition

#### Query Description
This query will provide daily unblended and usage information per linked account for Amazon Rekognition. The output will include detailed information about the usage type and usage region. The cost will be summed by day, account, and usage type, and displayed in descending order.

#### Pricing
Please refer to the [Rekognition pricing page](https://aws.amazon.com/rekognition/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Machine_Learning/rekognition.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      line_item_usage_type,
      product_region,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM
      {$table_name}
    WHERE
      ${date_filter}
      AND line_item_product_code = 'AmazonRekognition'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_usage_type,
      product_region
    ORDER BY
      sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="MachineLearning" service_text="Rekognition" query_text="Rekognition Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon SageMaker

#### Query Description
This query will provide daily unblended cost and usage information per resource ID for Amazon SageMaker. The output will include detailed information about associated usage types. The cost and usage will be summed by day, account, resource ID, and usage type, and displayed in descending order.

#### Pricing
Please refer to the [SageMaker pricing page](https://aws.amazon.com/sagemaker/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Machine_Learning/sagemakerwrid.sql)

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
    FROM 
      {$table_name}
    WHERE
      ${date_filter}
      AND line_item_product_code = 'AmazonSageMaker'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_resource_id,
      line_item_usage_type
    ORDER BY
      sum_line_item_unblended_cost DESC;
```
      
  

{{< email_button category_text="MachineLearning" service_text="SageMaker" query_text="SageMaker Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon Textract

#### Query Description
This query will provide daily unblended and usage information per linked account for Amazon Textract. The output will include detailed information about the usage type and usage region. The cost and usage will be summed by day, account, and usage type, and displayed in descending order.

#### Pricing
Please refer to the [Textract pricing page](https://aws.amazon.com/textract/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Machine_Learning/textract.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      line_item_usage_type,
      product_region,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM
      {$table_name}
    WHERE
      ${date_filter}
      AND line_item_product_code = 'AmazonTextract'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_usage_type,
      product_region
    ORDER BY
      sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="MachineLearning" service_text="Textract" query_text="Textract Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}






