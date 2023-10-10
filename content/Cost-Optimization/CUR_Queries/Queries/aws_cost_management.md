---
title: "AWS Cost Management"
weight: 3
---

These are queries for AWS Services under the [AWS Cost Management product family](https://aws.amazon.com/aws-cost-management/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [AWS Marketplace](#aws-marketplace)
  * [Refund and Credit Detail](#refund-and-credit-detail)
  * [Reservation Savings](#reservation-savings)
  * [Migration Acceleration Program (MAP) Credits](#migration-acceleration-program-credits)
  * [EC2 Reservation Utilization](#ec2-reservation-utilization)
  * [Savings Plans Utilization](#savings-plans-utilization)
  * [Top 50 Resource Movers](#top-50-resource-movers)

  
### AWS Marketplace

#### Query Description
This query provides AWS Marketplace subscription costs including subscription product name, associated linked account, and monthly total unblended cost.  This query includes tax, however this can be filtered out in the WHERE clause.  Please refer to the [CUR Query Library Helpers section](/cost/300_labs/300_cur_queries/query_help/) for assistance.  

#### Pricing
Please refer to the [AWS Marketplace FAQ](https://aws.amazon.com/marketplace/help/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/AWS_Cost_Management/marketplacespend.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  CASE line_item_usage_start_date
    WHEN NULL THEN DATE_FORMAT(DATE_PARSE(CONCAT(SPLIT_PART('${table_name}','_',5),'01'),'%Y%m%d'),'%Y-%m-01') 
    ELSE DATE_FORMAT(line_item_usage_start_date,'%Y-%m-01') 
  END AS case_line_item_usage_start_time,
  bill_billing_entity,
  product_product_name,
SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND bill_billing_entity = 'AWS Marketplace'
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  3, --refers to case_line_item_usage_start_time,
  bill_billing_entity,
  product_product_name
ORDER BY 
  case_line_item_usage_start_time ASC,
  sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="AWS Cost Management" service_text="AWS Marketplace" query_text="AWS Marketplace Total Monthly Spend Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Refund and Credit Detail

#### Query Description
This query provides a list of refunds and credits issued. Output is grouped by payer, linked account, month, line item type, service, and line item description. This allows for analysis of refunds and credits along any of these grouped dimensions. For example, "what refunds or credits were issued to account 111122223333 for service ABC in January 2022?" or "what was the total refund issued across all accounts for payer 444455556666 with line item description XYZ?" 

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/AWS_Cost_Management/refundcreditdetail.sql)

#### Copy Query
```tsql
SELECT
  bill_payer_account_id,
  line_item_usage_account_id, 
  DATE_TRUNC('month',line_item_usage_start_date) as month_line_item_usage_start_date,
  line_item_line_item_type,
   CASE
    WHEN (bill_billing_entity = 'AWS Marketplace' AND line_item_line_item_type NOT LIKE '%Discount%') THEN product_product_name
    WHEN (product_servicecode = '') THEN line_item_product_code
    ELSE product_servicecode
  END case_service,
  line_item_line_item_description,
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost
FROM
  ${tableName}
WHERE
  ${date_filter}
  AND line_item_unblended_cost < 0
  AND line_item_line_item_type <> 'SavingsPlanNegation'
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id, 
  DATE_TRUNC('month',line_item_usage_start_date),
  line_item_line_item_type,
  5, --refers to case_service
  line_item_line_item_description
ORDER BY
  month_line_item_usage_start_date ASC,
  sum_line_item_unblended_cost ASC;
```

{{< email_button category_text="AWS Cost Management" service_text="AWS Marketplace" query_text="AWS Marketplace Total Monthly Spend Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Reservation Savings

#### Query Description
This query provides an aggregated report of savings from purchased reservations across multiple services - EC2, Elasticache, OpenSearch (formerly Amazon ElasticSearch), and RDS. This is similar to what can be found in Cost Explorer Reservation Utilization reports, except aggregated across all services offering reservations, allowing for easier organizational reporting on total savings. Output can be used to identify savings per specific reservation ARN, as well as savings per service, savings per linked account, savings per region, and savings per specific instance/node type.

#### Pricing
Please refer to the relevant service reservation pricing page. 
* [EC2](https://aws.amazon.com/ec2/pricing/reserved-instances/pricing/)
* [ElastiCache](https://aws.amazon.com/elasticache/pricing/?nc=sn&loc=5#Reserved_Nodes)
* [OpenSearch (formerly Amazon ElasticSearch)](https://aws.amazon.com/opensearch-service/pricing/#Reserved_Instance_pricing)
* [Redshift](https://aws.amazon.com/redshift/pricing/#Reserved_Instance_pricing)
* [RDS](https://aws.amazon.com/rds/pricing/)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/AWS_Cost_Management/reservation-savings.sql)

#### Copy Query
```tsql
SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
  line_item_product_code,
  reservation_reservation_a_r_n,
  SPLIT_PART(line_item_usage_type,':', 2) AS split_line_item_usage_type,
  SPLIT_PART(reservation_reservation_a_r_n,':', 4) AS split_product_region, -- split ARN for region due to product_region inconsistencies
  SUM(CAST(pricing_public_on_demand_cost AS DECIMAL (16,8))) AS sum_pricing_public_on_demand_cost,
  SUM(CASE
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
    WHEN line_item_line_item_type = 'RIFee' THEN reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee
    WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN 0
  END) AS sum_case_reservation_effective_cost,
  SUM(TRY_CAST(pricing_public_on_demand_cost AS DECIMAL(16, 8))) 
    - SUM(CASE
        WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
        WHEN line_item_line_item_type = 'RIFee' THEN reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee
        WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN 0
      END) AS sum_case_reservation_net_savings
FROM
  ${table_name}
WHERE
  ${date_filter}
  AND line_item_product_code IN ('AmazonEC2','AmazonRedshift','AmazonRDS','AmazonES','AmazonElastiCache')  
  AND line_item_line_item_type IN ('Fee','RIFee','DiscountedUsage')
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
  line_item_product_code,
  reservation_reservation_a_r_n,
  SPLIT_PART(line_item_usage_type,':', 2),
  SPLIT_PART(reservation_reservation_a_r_n,':', 4)
ORDER BY
  month_line_item_usage_start_date,
  line_item_product_code,
  split_line_item_usage_type;
  ```

### Migration Acceleration Program Credits

#### Query Description
This query provides all rewarded [Migration Acceleration Program](https://aws.amazon.com/migration-acceleration-program/) (MAP) credits grouped by month, year, product credit source and account id.  Default is for all time. A line is included as an example if a date filter is desired. Please refer to the [CUR Query Library Helpers section](/cost/300_labs/300_cur_queries/query_help/) for assistance.  

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/AWS_Cost_Management/MAPCredits.sql)

#### Copy Query
```tsql
select
  month,
  year,
  line_item_line_item_type,
  line_item_line_item_description,
  line_item_usage_account_id,
  sum(line_item_unblended_cost) sum_line_item_unblended_cost
from ${tableName}
where
  line_item_line_item_type in ('Refund','Credit') and
  line_item_line_item_description like '%_MPE%'
-- default is all MAP credits for the entire account for all time, add next line to filter
-- and ${date_filter}
group by 1,2,3,4,5;
```

{{< email_button category_text="AWS Cost Management" service_text="AWS Marketplace" query_text="Enterprise Discount Plan (EDP) Credits" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### EC2 Reservation Utilization

#### Query Description
This query pulls all ACTIVE Reserved Instance ARNs for Amazon EC2 and produces their utilization for last month.  This query will give you a very granular look at which Reserved Instance purchases were not being utilized to their full extent last month.  This query is written for Amazon EC2, however, commenting the line_item_product_code line in the WHERE clause will output all Reserved Instances.


#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/AWS_Cost_Management/ec2-reservation-utilization.sql)

#### Copy Query
```tsql
-- EC2 Reservations active in current month ordered by expiration first
SELECT
bill_payer_account_id,
line_item_usage_account_id,
DATE_FORMAT((line_item_usage_start_date),'%Y-%m') AS month_line_item_usage_start_date,
bill_bill_type,
line_item_product_code,
line_item_usage_type,
product_region,
reservation_subscription_id,
reservation_reservation_a_r_n,
pricing_purchase_option,
pricing_offering_class,
pricing_lease_contract_length,
reservation_number_of_reservations,
reservation_start_time,
reservation_end_time,
reservation_modification_status,
reservation_total_reserved_units,
reservation_unused_quantity,
TRY_CAST(1 - (TRY_CAST(reservation_unused_quantity AS Decimal(16,8)) / TRY_CAST(reservation_total_reserved_units AS Decimal(16,8))) as Decimal(16,8)) AS calc_percentage_utilized
FROM
  ${table_name}
WHERE 
  CAST("concat"("year", '-', "month", '-01') AS date) = "date_trunc"('month', current_date) - INTERVAL  '1' MONTH --last month
  AND pricing_term = 'Reserved'
  AND line_item_line_item_type IN ('Fee','RIFee')
  AND line_item_product_code = 'AmazonEC2' --EC2 only, comment out for all reservation types
  AND bill_bill_type = 'Anniversary' --identify 
  AND try_cast(date_parse(SPLIT_PART(reservation_end_time, 'T', 1), '%Y-%m-%d') as date) > cast(current_date as date) --res exp time after today's date
GROUP BY 
bill_bill_type,
bill_payer_account_id,
line_item_usage_account_id,
reservation_reservation_a_r_n,
reservation_subscription_id,
DATE_FORMAT((line_item_usage_start_date),'%Y-%m'),
line_item_product_code,
line_item_usage_type,
product_region,
pricing_purchase_option,
pricing_offering_class,
pricing_lease_contract_length,
reservation_number_of_reservations,
reservation_start_time,
reservation_end_time,
reservation_modification_status,
reservation_total_reserved_units,
reservation_unused_quantity
ORDER BY 
reservation_unused_quantity DESC,
reservation_end_time ASC,
calc_percentage_utilized ASC
  ```

[Back to Table of Contents](#table-of-contents)

{{< email_button category_text="AWS Cost Management" service_text="EC2 Reservation Utilization" query_text="EC2 Reservation Utilization" button_text="Help & Feedback" >}}

### Savings Plans Utilization

#### Query Description
This query pulls all ACTIVE Savings Plan ARNs and produces their utilization for last month.  This query will give you a very granular look at which Savings Plan purchases were not being utilized to their full extent last month.

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/AWS_Cost_Management/savings-plans-utilization.sql)

#### Copy Query
```tsql
SELECT
  SPLIT_PART(savings_plan_savings_plan_a_r_n, '/', 2) AS split_savings_plan_savings_plan_a_r_n,
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m') AS month_line_item_usage_start_date,
  savings_plan_offering_type,
  savings_plan_region,
  DATE_FORMAT(FROM_ISO8601_TIMESTAMP(savings_plan_start_time),'%Y-%m-%d') AS day_savings_plan_start_time,
  DATE_FORMAT(FROM_ISO8601_TIMESTAMP(savings_plan_end_time),'%Y-%m-%d') AS day_savings_plan_end_time,
  savings_plan_payment_option,
  savings_plan_purchase_term,
  SUM(TRY_CAST(savings_plan_recurring_commitment_for_billing_period AS DECIMAL(16, 8))) AS sum_savings_plan_recurring_committment_for_billing_period,
  SUM(TRY_CAST(savings_plan_total_commitment_to_date AS DECIMAL(16, 8))) AS sum_savings_plan_total_commitment_to_date, 
  SUM(TRY_CAST(savings_plan_used_commitment AS DECIMAL(16, 8))) AS sum_savings_plan_used_commitment,
  AVG(CASE
    WHEN line_item_line_item_type = 'SavingsPlanRecurringFee' THEN TRY_CAST(savings_plan_total_commitment_to_date AS DECIMAL(8, 2))
  END) AS "Hourly Commitment",
  -- (used commitment / total commitment) * 100 = utilization %
  TRY_CAST(((SUM(TRY_CAST(savings_plan_used_commitment AS DECIMAL(16, 8))) / SUM(TRY_CAST(savings_plan_total_commitment_to_date AS DECIMAL(16, 8))))) AS DECIMAL(16, 8)) AS calc_savings_plan_utilization_percent
FROM
  ${table_name}
WHERE 
  CAST("concat"("year", '-', "month", '-01') AS date) = "date_trunc"('month', current_date) - INTERVAL  '1' MONTH --last month
  AND savings_plan_savings_plan_a_r_n <> ''
  AND line_item_line_item_type = 'SavingsPlanRecurringFee'
  AND try_cast(date_parse(SPLIT_PART(savings_plan_end_time, 'T', 1), '%Y-%m-%d') as date) > cast(current_date as date) --res exp time after today's date
GROUP BY
  SPLIT_PART(savings_plan_savings_plan_a_r_n, '/', 2),
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m'),
  savings_plan_offering_type,
  savings_plan_region,
  DATE_FORMAT(FROM_ISO8601_TIMESTAMP(savings_plan_start_time),'%Y-%m-%d'),
  DATE_FORMAT(FROM_ISO8601_TIMESTAMP(savings_plan_end_time),'%Y-%m-%d'),
  savings_plan_payment_option,
  savings_plan_purchase_term
ORDER BY
  calc_savings_plan_utilization_percent DESC,
  day_savings_plan_end_time,
  split_savings_plan_savings_plan_a_r_n,
  month_line_item_usage_start_date;
  ```

[Back to Table of Contents](#table-of-contents)

{{< email_button category_text="AWS Cost Management" service_text="Savings Plans Utilization" query_text="Savings Plans Utilization" button_text="Help & Feedback" >}}

### Top 50 Resource Movers

#### Query Description
This query produces the top 50 moving resources by 1/ cost delta and 2/ change in percentage.  The parameters have been adjusted for comparison of resources from three days prior and two days prior as CUR may take up to 48 hours to update all estimated charges.  Additionally, this query only pulls resources with greater than $5 in unblended cost in order to reduce noise from resources which did not exist in one of the look back periods or spun up at the end of one of the look back periods.  These parameters may be adjusted as needed.  

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/AWS_Cost_Management/top-50-resource-movers.sql)

#### Copy Query
```tsql
SELECT
    a.line_item_usage_account_id AS "line_item_usage_account_id",
    old_line_item_resource_id,
    old_line_item_unblended_cost AS "cost_three_days_prior",
    new_line_item_unblended_cost AS "cost_two_days_prior",
    (new_line_item_unblended_cost - old_line_item_unblended_cost) AS "cost_delta",
    (((new_line_item_unblended_cost - old_line_item_unblended_cost)/old_line_item_unblended_cost)*100) AS "change_percentage",
    a.usage_date AS "date_three_days_prior",
    b.usage_date AS "date_two_days_prior",
    a.product_product_name AS "product_product_name"
FROM
(
    (
        SELECT
            distinct "line_item_resource_id" as old_line_item_resource_id,
            line_item_usage_account_id,
            product_product_name,
            DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') usage_date,
            sum(line_item_unblended_cost) as old_line_item_unblended_cost
        FROM
            ${table_name}
        WHERE
            "line_item_resource_id" <> ''
            AND line_item_unblended_cost > 5
            AND "line_item_usage_start_date" = current_date - INTERVAL '3' DAY
        GROUP BY
        1, -- resource id three days prior
        2, -- account id
        3, -- product name
        4 -- usage date
    ) a
        
    FULL OUTER JOIN
    ( 
        SELECT 
            distinct "line_item_resource_id" as new_line_item_resource_id,
            line_item_usage_account_id,
            product_product_name,
            DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') usage_date,
            SUM(line_item_unblended_cost) as new_line_item_unblended_cost
        FROM
            ${table_name}
        WHERE
            "line_item_resource_id" <> ''
            AND line_item_unblended_cost > 5
            AND "line_item_usage_start_date" = current_date - INTERVAL '2' DAY
        GROUP BY
        1, -- resource id two days prior
        2, -- account id
        3, -- product name
        4 -- usage date
    ) b ON a.old_line_item_resource_id = b.new_line_item_resource_id
)
ORDER BY
    5 DESC, -- cost delta   
    6 DESC -- change percentage
LIMIT 50
  ```

[Back to Table of Contents](#table-of-contents)

{{< email_button category_text="AWS Cost Management" service_text="Savings Plans Utilization" query_text="Savings Plans Utilization" button_text="Help & Feedback" >}}

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}






