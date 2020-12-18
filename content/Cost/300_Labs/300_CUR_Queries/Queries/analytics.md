---
title: "Analytics"
date: 2020-08-28T11:16:09-04:00
chapter: false
weight: 1
pre: "<b> </b>"
---

These are queries for AWS Services under the [Analytics product family](https://aws.amazon.com/big-data/datalakes-and-analytics). 

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
You may need to change variables used as placeholders in your query. **${table_Name}** is a common variable which needs to be replaced. **Example: cur_db.cur_table**
{{% /notice %}}

### Table of Contents

{{< expand "AWS Glue" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide daily unblended and usage information per linked account for AWS Glue.  The output will include detailed information about the resource id (Glue Crawler) and API operation.  The cost will be summed and in descending order.

#### Pricing
Please refer to the [Glue pricing page](https://aws.amazon.com/glue/pricing/).

#### Sample Output
![Images/gluewrid.png](/Cost/300_CUR_Queries/Images/Analytics/gluewrid.png)


#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Analytics/gluewrid.sql)

#### Copy Query
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      line_item_operation,
      SPLIT_PART(line_item_resource_id, 'crawler/', 2) AS split_line_item_resource_id,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16, 8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_product_name = ('AWS Glue')
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_operation,
      line_item_resource_id
    ORDER BY
      day_line_item_usage_start_date,
      sum_line_item_unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="Analytics" service_text="Glue" query_text="Glue Query1" button_text="Help & Feedback" %}}

{{< /expand >}}



{{< expand "Amazon Kinesis" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide daily unblended and usage information per linked account for each Kinesis product (Amazon Kinesis, Amazon Kinesis Firehose, and Amazon Kinesis Analytics).  The output will include detailed information about the resource id (Stream, Delivery Stream, etc...) and API operation.  The cost will be summed and in descending order.

#### Pricing
Please refer to the Kinesis pricing pages:

[Amazon Kinesis Data Streams Pricing](https://aws.amazon.com/kinesis/data-streams/pricing/)

[Amazon Kinesis Data Firehose Pricing](https://aws.amazon.com/kinesis/data-analytics/pricing/)

[Amazon Kinesis Data Analytics Pricing](https://aws.amazon.com/kinesis/data-analytics/pricing/)

[Amazon Kinesis Video Streams pricing](https://aws.amazon.com/kinesis/video-streams/pricing)

#### Sample Output
![Images/kinesis-output.png](/Cost/300_CUR_Queries/Images/Analytics/kinesis.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Analytics/kinesis.sql)

#### Copy Query
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      SPLIT_PART(line_item_resource_id,':',6) as split_line_item_resource_id,
      product_product_name,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16, 8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_Name} 
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_product_name IN ('Amazon Kinesis','Amazon Kinesis Firehose','Amazon Kinesis Analytics','Amazon Kinesis Video')
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_resource_id,
      product_product_name
    ORDER BY
      day_line_item_usage_start_date,
      sum_line_item_unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="Analytics" service_text="Kinesis" query_text="Kinesis Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{< expand "Amazon Elasticsearch" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide daily unblended and amortized cost as well as usage information per linked account for Amazon Elasticsearch.  The output will include detailed information about the resource id (ES Domain), usage type, and API operation.  The usage amount and cost will be summed and the cost will be in descending order. This query includes RI and SP true up which will show any upfront fees to the account that purchased the pricing model.

#### Pricing
Please refer to the [Elasticsearch pricing page](https://aws.amazon.com/elasticsearch-service/pricing/).  Please refer to this blog for [Cost Optimization techniques](https://aws.amazon.com/blogs/database/reducing-cost-for-small-amazon-elasticsearch-service-domains/). 

#### Sample Output
![Images/elasticsearch-output.png](/Cost/300_CUR_Queries/Images/Analytics/elasticsearch.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Analytics/elasticsearch.sql)

#### Copy Query
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      SPLIT_PART(line_item_resource_id,':',6) as split_line_item_resource_id,
      product_product_family,
      product_instance_family,
      product_instance_type,
      pricing_term,
      product_storage_media,
      product_transfer_type,
      sum(CASE 
      WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "line_item_usage_amount" 
      WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "line_item_usage_amount" 
      WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_usage_amount" ELSE 0 END) "usage_quantity",
      sum ("line_item_unblended_cost") "unblended_cost",
      sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "savings_plan_savings_plan_effective_cost" 
          WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment") 
          WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
          WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
          WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "reservation_effective_cost"  
          WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
          WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE "line_item_unblended_cost" END) "amortized_cost",
    sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN (-"savings_plan_amortized_upfront_commitment_for_billing_period") 
          WHEN ("line_item_line_item_type" = 'RIFee') THEN (-"reservation_amortized_upfront_fee_for_billing_period") ELSE 0 END) "ri_sp_trueup",
    sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN "line_item_unblended_cost"
          WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN "line_item_unblended_cost"ELSE 0 END) "ri_sp_upfront_fees"
    FROM
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_product_name = 'Amazon Elasticsearch Service'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount') 
    GROUP BY
      1,2,3,4,5,6,7,8,9,10
    ORDER BY
      day_line_item_usage_start_date,
      product_product_family,
      unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="Analytics" service_text="Elasticsearch" query_text="Elasticsearch Query1" button_text="Help & Feedback" %}}

{{< /expand >}}


{{< expand "Amazon EMR" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide daily unblended cost and usage information per linked account for Amazon EMR.  The cost will be summed and the cost will be in descending order. 

#### Pricing 
Please refer to the [EMR pricing page](https://aws.amazon.com/emr/pricing/).

#### Sample Output
![Images/emr.png](/Cost/300_CUR_Queries/Images/Analytics/emr.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Analytics/emr.sql)

#### Copy Query
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      SPLIT_PART(line_item_usage_type ,':',2) AS split_line_item_usage_type,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_product_name = 'Amazon Elastic MapReduce'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_usage_type,
      line_item_line_item_type
    ORDER BY
      day_line_item_usage_start_date,
      sum_line_item_usage_amount,
      sum_line_item_unblended_cost,
      split_line_item_usage_type;

{{% /markdown_wrapper %}}

{{% email_button category_text="Analytics" service_text="EMR" query_text="EMR Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: <a href="mailto:curquery@amazon.com?subject=Cur Query Library Request - Analytics">curquery@amazon.com</a>
{{% /notice %}}