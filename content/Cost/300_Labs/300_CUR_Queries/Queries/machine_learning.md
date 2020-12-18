---
title: "Machine Learning"
date: 2020-08-28T11:16:09-04:00
chapter: false
weight: 9
pre: "<b> </b>"
---

These are queries for AWS Services under the [Machine Learning product family](https://aws.amazon.com/machine-learning/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
You may need to change variables used as placeholders in your query. **${table_Name}** is a common variable which needs to be replaced. **Example: cur_db.cur_table**
{{% /notice %}}

### Table of Contents

{{< expand "Amazon Rekognition" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide daily unblended and usage information per linked account for Amazon Rekognition. The output will include detailed information about the usage type and usage region. The cost will be summed by day, account, and usage type, and displayed in descending order.

#### Pricing
Please refer to the [Rekognition pricing page](https://aws.amazon.com/rekognition/pricing/).

#### Sample Output
![Images/rekognition.png](/Cost/300_CUR_Queries/Images/Machine_Learning/rekognition.png)


#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Machine_Learning/rekognition.sql)

#### Copy Query
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      line_item_usage_type,
      product_region,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM
      {$table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND line_item_product_code = 'AmazonRekognition'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_usage_type,
      product_region
    ORDER BY
      sum_line_item_unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="MachineLearning" service_text="Rekognition" query_text="Rekognition Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{< expand "Amazon SageMaker" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide daily unblended cost and usage information per resource ID for Amazon SageMaker. The output will include detailed information about associated usage types. The cost and usage will be summed by day, account, resource ID, and usage type, and displayed in descending order.

#### Pricing
Please refer to the [SageMaker pricing page](https://aws.amazon.com/sagemaker/pricing/).

#### Sample Output
![Images/sagemakerwrid.png](/Cost/300_CUR_Queries/Images/Machine_Learning/sagemakerwrid.png)


#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Machine_Learning/sagemakerwrid.sql)

#### Copy Query
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') as day_line_item_usage_start_date,
      line_item_resource_id,
      line_item_usage_type,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      {$table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND line_item_product_code = 'AmazonSageMaker'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_resource_id,
      line_item_usage_type
    ORDER by
      sum_line_item_unblended_cost DESC;
      
  

{{% /markdown_wrapper %}}

{{% email_button category_text="MachineLearning" service_text="SageMaker" query_text="SageMaker Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{< expand "Amazon Textract" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide daily unblended and usage information per linked account for Amazon Textract. The output will include detailed information about the usage type and usage region. The cost and usage will be summed by day, account, and usage type, and displayed in descending order.

#### Pricing
Please refer to the [Textract pricing page](https://aws.amazon.com/textract/pricing/).

#### Sample Output
![Images/textract.png](/Cost/300_CUR_Queries/Images/Machine_Learning/textract.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Machine_Learning/textract.sql)

#### Copy Query
    SELECT
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      line_item_usage_type,
      product_region,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM
      {$table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND line_item_product_code = 'AmazonTextract'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_usage_type,
      product_region
    ORDER BY
      sum_line_item_unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="MachineLearning" service_text="Textract" query_text="Textract Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}






