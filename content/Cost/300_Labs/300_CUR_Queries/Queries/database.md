---
title: "Database"
date: 2020-08-28T11:16:09-04:00
chapter: false
weight: 6
pre: "<b> </b>"
---

These are queries for AWS Services under the [Database product family](https://aws.amazon.com/products/databases/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
You may need to change variables used as placeholders in your query. **${table_Name}** is a common variable which needs to be replaced. **Example: cur_db.cur_table**
{{% /notice %}}

### Table of Contents

{{< expand "Amazon RDS" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will output the daily sum per resource for all RDS purchase options across all RDS usage types. 

#### Pricing
Please refer to the [Amazon RDS pricing page](https://aws.amazon.com/rds/pricing/).

#### Sample Output
![Images/rds-w-rid.png](/Cost/300_CUR_Queries/Images/Database/rds-w-rid.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Database/rds-w-id.sql)

#### Copy Query
      SELECT bill_payer_account_id,
         line_item_usage_account_id,
         DATE_FORMAT(("line_item_usage_start_date"),
         '%Y-%m-%d') AS day_line_item_usage_start_date, product_instance_type, line_item_operation, line_item_usage_type, line_item_line_item_type, pricing_term, product_product_family , SPLIT_PART(line_item_resource_id,':',7) AS line_item_resource_id,
          CASE product_database_engine
          WHEN '' THEN
          'Not Applicable'
          ELSE product_database_engine
          END AS OS , sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN
          "line_item_usage_amount"
          WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN
          "line_item_usage_amount"
          WHEN ("line_item_line_item_type" = 'Usage') THEN
          "line_item_usage_amount"
          ELSE 0 END) "usage_quantity", sum ("line_item_unblended_cost") "unblended_cost", sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN
          "savings_plan_savings_plan_effective_cost"
          WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN
          ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment")
          WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN
          0
          WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN
          0
          WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN
          "reservation_effective_cost"
          WHEN ("line_item_line_item_type" = 'RIFee') THEN
          ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
          WHEN (("line_item_line_item_type" = 'Fee')
              AND ("reservation_reservation_a_r_n" <> '')) THEN
          0
          ELSE "line_item_unblended_cost" END) "amortized_cost", sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN
          (-"savings_plan_amortized_upfront_commitment_for_billing_period")
          WHEN ("line_item_line_item_type" = 'RIFee') THEN
          (-"reservation_amortized_upfront_fee_for_billing_period")
          ELSE 0 END) "ri_sp_trueup", sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN
          "line_item_unblended_cost"
          WHEN (("line_item_line_item_type" = 'Fee')
              AND ("reservation_reservation_a_r_n" <> '')) THEN
          "line_item_unblended_cost"ELSE 0 END) "ri_sp_upfront_fees"
      FROM ${table_name}
      WHERE year = '2020'
              AND (month
          BETWEEN '7'
              AND '9'
              OR month
          BETWEEN '07'
              AND '09')
              AND product_product_name = 'Amazon Relational Database Service'
              AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
      GROUP BY  bill_payer_account_id, line_item_usage_account_id, DATE_FORMAT(("line_item_usage_start_date"),'%Y-%m-%d'), product_instance_type, line_item_operation, line_item_usage_type, line_item_line_item_type, pricing_term, product_product_family, product_database_engine, line_item_line_item_type, line_item_resource_id
      ORDER BY  day_line_item_usage_start_date, usage_quantity, unblended_cost; 

{{% /markdown_wrapper %}}

{{% email_button category_text="Database" service_text="Amazon RDS" query_text="Amazon RDS Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{< expand "Amazon DynamoDB" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will output the total monthly sum per resource for all DynamoDB purchase options (including reserved capacity) across all DynamoDB usage types (including data transfer and storage costs). The unblended cost will be summed and in descending order. 

#### Pricing
Please refer to the [DynamoDB pricing page](https://aws.amazon.com/dynamodb/pricing/).

#### Sample Output
![Images/dynamodb.png](/Cost/300_CUR_Queries/Images/Database/dynamodb.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Database/dynamodb.sql)

#### Copy Query

    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      month,
      product_location,
      SPLIT_PART(line_item_resource_id, 'table/', 2) as line_item_resource_id,
      (CASE
        WHEN line_item_line_item_type LIKE '%Fee' THEN 'DynamoDB Reserved Capacity'
        WHEN line_item_line_item_type = 'DiscountedUsage' THEN 'DynamoDB Reserved Capacity'
        ELSE 'DynamoDB Usage' 
      END) as purchase_option_line_item_line_item_type,
      (CASE
        WHEN product_product_family = 'Data Transfer' THEN 'DynamoDB Data Transfer'
        WHEN product_product_family LIKE '%Storage' THEN 'DynamoDB Storage'
        ELSE 'DynamoDB Usage' 
      END) as usage_type_product_product_family,   
      SUM(CAST(line_item_usage_amount AS double)) as sum_line_item_usage_amount,
      SUM(CAST(line_item_blended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost,
      reservation_reservation_a_r_n
    FROM 
      ${table_name}
      WHERE year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND line_item_product_code = 'AmazonDynamoDB'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      month,
      product_location,
      line_item_resource_id,
      line_item_line_item_type,
      product_product_family,
      reservation_reservation_a_r_n
    ORDER BY
      sum_line_item_unblended_cost DESC

{{% /markdown_wrapper %}}

{{% email_button category_text="Database" service_text="Amazon DynamoDB" query_text="Amazon DynamoDB Query1" button_text="Help & Feedback" %}}

{{< /expand >}}


{{< expand "Amazon Redshift" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide daily unblended and amortized cost as well as usage information per linked account for Amazon Redshift.  The output will include detailed information about the resource id (cluster name), usage type, and API operation.  The usage amount and cost will be summed and the cost will be in descending order. This query includes RI and SP true up which will show any upfront fees to the account that purchased the pricing model.

#### Pricing
Please refer to the [Redshift pricing page](https://aws.amazon.com/redshift/pricing/). Please refer to the [Redshift Cost Optimization Whitepaper](https://d1.awsstatic.com/whitepapers/amazon-redshift-cost-optimization.pdf) for Cost Optimization techniques. 

#### Sample Output
![Images/redshiftwrid.png](/Cost/300_CUR_Queries/Images/Database/redshiftwrid.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Database/redshiftwrid.sql)

#### Copy Query
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      product_instance_type,
      SPLIT_PART(line_item_resource_id,':',7) as split_line_item_resource_id,
      line_item_operation,
      line_item_usage_type,
      line_item_line_item_type,
      pricing_term,
      product_usage_family,
      product_product_family,
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
      AND product_product_name = 'Amazon Redshift'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount')
    GROUP BY
      1,2,3,4,5,6,7,8,9,10,11
    ORDER BY
      day_line_item_usage_start_date,
      product_product_family,
      unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="Database" service_text="Amazon Redshift" query_text="Amazon Redshift Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}






